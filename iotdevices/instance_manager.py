#!/usr/bin/env python3

import sys
import logging
import mysql.connector
from mysql.connector.cursor import MySQLCursor
import docker
from datetime import datetime
import argparse
from typing import Optional, Tuple

# Database configuration
DB_CONFIG = {
    'database': 'plant_care',
    'user': 'user',
    'password': 'teszt',
    'host': 'localhost',
    'port': '3306'
}

# Docker network name
DOCKER_NETWORK = 'szoftarch-nw'

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("DeviceInstanceManager")

class InstanceManager:
    MONITOR_CONTAINER_NAME = 'device_monitor'

    def __init__(self):
        self.docker_client = docker.from_env()
        self.ensure_network_exists()
        self.ensure_db_in_network()
        self.ensure_monitor_running()

    def ensure_network_exists(self):
        """Ensure the Docker network exists."""
        try:
            self.docker_client.networks.get(DOCKER_NETWORK)
            logger.debug(f"Network {DOCKER_NETWORK} already exists")
        except docker.errors.NotFound:
            self.docker_client.networks.create(
                DOCKER_NETWORK,
                driver="bridge"
            )
            logger.info(f"Created Docker network: {DOCKER_NETWORK}")

    def is_container_in_network(self, container_name: str, network_name: str) -> bool:
        """Check if a container is already in a specific network."""
        try:
            container = self.docker_client.containers.get(container_name)
            networks = container.attrs['NetworkSettings']['Networks']
            return network_name in networks
        except docker.errors.NotFound:
            return False

    def ensure_container_in_network(self, container_name: str) -> None:
        """Ensure a container is in our network, adding it only if necessary."""
        try:
            container = self.docker_client.containers.get(container_name)
            if not self.is_container_in_network(container_name, DOCKER_NETWORK):
                network = self.docker_client.networks.get(DOCKER_NETWORK)
                network.connect(container)
                logger.info(f"Added container {container_name} to network {DOCKER_NETWORK}")
            else:
                logger.debug(f"Container {container_name} already in network {DOCKER_NETWORK}")
        except docker.errors.NotFound as e:
            logger.error(f"Container {container_name} not found!")
            raise

    def ensure_db_in_network(self):
        """Ensure the MySQL container is in our network."""
        try:
            self.ensure_container_in_network('szoftarch-db')
        except docker.errors.NotFound as e:
            logger.error("MySQL container not found. Make sure it's running!")
            raise

    def ensure_monitor_running(self):
        """Ensure the monitor container is running and in the network."""
        try:
            # Try to get existing monitor container
            monitor = self.docker_client.containers.get(self.MONITOR_CONTAINER_NAME)
            
            # Check if it's running
            if monitor.status != 'running':
                monitor.remove()
                raise docker.errors.NotFound("Monitor not running")
                
        except docker.errors.NotFound:
            # Start new monitor container
            monitor = self.docker_client.containers.run(
                "device-monitor:latest",
                name=self.MONITOR_CONTAINER_NAME,
                network=DOCKER_NETWORK,
                detach=True,
                restart_policy={"Name": "unless-stopped"},
                environment={
                    "DB_HOST": "szoftarch-db",
                    "DB_PORT": "3306",
                    "DB_NAME": "plant_care",
                    "DB_USER": "user",
                    "DB_PASSWORD": "teszt",
                    "POLLING_INTERVAL": "60"
                }
            )
            logger.info("Started device monitor container")

    def start_instance(self, device_id: int, location: str, user: str):
        """Start a new device instance."""
        try:
            instance_id = self.create_instance(device_id, location, user)
            container_name = f"device_instance_{instance_id}"
            
            # Create the device container
            container = self.docker_client.containers.run(
                "device-simulator:latest",
                command=str(device_id),
                name=container_name,
                hostname=str(instance_id),
                network=DOCKER_NETWORK,
                detach=True,
                environment={
                    "DEVICE_ID": str(device_id),
                    "INSTANCE_ID": str(instance_id),
                    "DB_HOST": "szoftarch-db",
                    "DB_PORT": "3306",
                    "DB_NAME": "plant_care",
                    "DB_USER": "user",
                    "DB_PASSWORD": "teszt"
                }
            )
            
            logger.info(f"Started device instance {instance_id} in container {container_name}")
            return instance_id
            
        except Exception as e:
            logger.error(f"Failed to start instance: {str(e)}")
            try:
                self.delete_instance(instance_id)
            except:
                pass
            raise

    def create_instance(self, device_id: int, location: str, user: str) -> int:
        """Create a new device instance in the database."""
        conn = mysql.connector.connect(**DB_CONFIG)
        try:
            cursor = conn.cursor(dictionary=True)
            
            # Verify device exists
            cursor.execute("SELECT id FROM device WHERE id = %s", (device_id,))
            if not cursor.fetchone():
                raise ValueError(f"Device ID {device_id} not found")
            
            # Create instance
            cursor.execute("""
                INSERT INTO device_instance 
                (device_id, location, username, installation_date)
                VALUES (%s, %s, %s, %s)
            """, (device_id, location, user, datetime.now()))
            
            instance_id = cursor.lastrowid
            conn.commit()
            logger.info(f"Created device instance with ID: {instance_id}")
            return instance_id
        finally:
            conn.close()

    def delete_instance(self, instance_id: int):
        """Delete a device instance from the database."""
        conn = mysql.connector.connect(**DB_CONFIG)
        try:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM device_instance WHERE id = %s", (instance_id,))
            if cursor.rowcount == 0:
                raise ValueError(f"Instance ID {instance_id} not found")
            conn.commit()
            logger.info(f"Deleted device instance with ID: {instance_id}")
        finally:
            conn.close()

    def get_device_info(self, instance_id: int) -> Tuple[int, str]:
        """Get device ID and model for an instance."""
        conn = mysql.connector.connect(**DB_CONFIG)
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.execute("""
                SELECT d.id, d.model
                FROM device d
                JOIN device_instance di ON d.id = di.device_id
                WHERE di.id = %s
            """, (instance_id,))
            result = cursor.fetchone()
            if not result:
                raise ValueError(f"Instance ID {instance_id} not found")
            return result['id'], result['model']
        finally:
            conn.close()

    def stop_instance(self, instance_id: int):
        """Stop a device instance."""
        try:
            # First verify instance exists and get info
            device_id, model = self.get_device_info(instance_id)
            
            # Stop and remove container
            container_name = f"device_instance_{instance_id}"
            try:
                container = self.docker_client.containers.get(container_name)
                container.stop()
                container.remove()
                logger.info(f"Stopped and removed container {container_name}")
            except docker.errors.NotFound:
                logger.warning(f"Container {container_name} not found")
            
            # Remove database instance
            self.delete_instance(instance_id)
            logger.info(f"Successfully stopped instance {instance_id}")
            
        except Exception as e:
            logger.error(f"Failed to stop instance: {str(e)}")
            raise

def main():
    parser = argparse.ArgumentParser(description='Manage device instances')
    parser.add_argument('action', choices=['start', 'stop'])
    parser.add_argument('--device-id', type=int, help='Device ID (required for start)')
    parser.add_argument('--instance-id', type=int, help='Instance ID (required for stop)')
    parser.add_argument('--location', help='Device location (required for start)')
    parser.add_argument('--user', help='User ID (required for start)')
    
    args = parser.parse_args()
    
    manager = InstanceManager()
    
    try:
        if args.action == 'start':
            if not all([args.device_id, args.location, args.user]):
                parser.error("start requires --device-id, --location, and --user")
            instance_id = manager.start_instance(args.device_id, args.location, args.user)
            print(f"Started instance {instance_id}")
            
        elif args.action == 'stop':
            if not args.instance_id:
                parser.error("stop requires --instance-id")
            manager.stop_instance(args.instance_id)
            print(f"Stopped instance {args.instance_id}")
            
    except Exception as e:
        logger.error(str(e))
        sys.exit(1)

if __name__ == "__main__":
    main()
