#!/usr/bin/env python3

import logging
import mysql.connector
import docker
import os
from datetime import datetime
from flask import Flask, request, jsonify
from typing import Tuple

# Database configuration
DB_CONFIG = {
    'database': os.getenv('DB_NAME', 'plant_care'),
    'user': os.getenv('DB_USER', 'user'),
    'password': os.getenv('DB_PASSWORD', 'teszt'),
    'host': os.getenv('DB_HOST', 'szoftarch-db'),
    'port': os.getenv('DB_PORT', '3306')
}

# Docker network name
DOCKER_NETWORK = 'szoftarch-nw'

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("DeviceInstanceManager")

app = Flask(__name__)

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
            monitor = self.docker_client.containers.get(self.MONITOR_CONTAINER_NAME)
            if monitor.status != 'running':
                monitor.remove()
                raise docker.errors.NotFound("Monitor not running")
        except docker.errors.NotFound:
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

    def start_instance(self, device_id: int, location: str, user: str, name: str):
        """Start a new device instance."""
        try:
            instance_id = self.create_instance(device_id, location, user, name)
            container_name = f"device_instance_{instance_id}"
            
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
            
            # Ensure actuator API is in the network
            try:
                self.ensure_container_in_network('szoftarch-actuator-api')
            except docker.errors.NotFound:
                logger.warning("Actuator API container not found")
            
            logger.info(f"Started device instance {instance_id} in container {container_name}")
            return instance_id
            
        except Exception as e:
            logger.error(f"Failed to start instance: {str(e)}")
            try:
                self.delete_instance(instance_id)
            except:
                pass
            raise

    def create_instance(self, device_id: int, location: str, user: str, name: str) -> int:
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
                (device_id, location, username, installation_date, name)
                VALUES (%s, %s, %s, %s, %s)
            """, (device_id, location, user, datetime.now(), name))
            
            instance_id = cursor.lastrowid
            conn.commit()
            logger.info(f"Created device instance with ID: {instance_id}")
            return instance_id
        finally:
            conn.close()

    def delete_instance(self, instance_id: int):
        """Delete a device instance and all related historical data from the database."""
        conn = mysql.connector.connect(**DB_CONFIG)
        try:
            cursor = conn.cursor()
            
            cursor.execute("DELETE FROM sensor_measurement WHERE instance_id = %s", (instance_id,))
            logger.info(f"Deleted {cursor.rowcount} sensor measurements for instance {instance_id}")
            
            cursor.execute("DELETE FROM actuator_state_history WHERE instance_id = %s", (instance_id,))
            logger.info(f"Deleted {cursor.rowcount} actuator state records for instance {instance_id}")
            
            cursor.execute("DELETE FROM device_instance WHERE id = %s", (instance_id,))
            if cursor.rowcount == 0:
                raise ValueError(f"Instance ID {instance_id} not found")
                
            conn.commit()
            logger.info(f"Deleted device instance with ID: {instance_id}")
            
        except mysql.connector.Error as e:
            conn.rollback()
            logger.error(f"Database error deleting instance: {e}")
            raise
        finally:
            cursor.close()
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
            device_id, model = self.get_device_info(instance_id)
            
            container_name = f"device_instance_{instance_id}"
            try:
                container = self.docker_client.containers.get(container_name)
                container.stop()
                container.remove()
                logger.info(f"Stopped and removed container {container_name}")
            except docker.errors.NotFound:
                logger.warning(f"Container {container_name} not found")
            
            self.delete_instance(instance_id)
            logger.info(f"Successfully stopped instance {instance_id}")
            
        except Exception as e:
            logger.error(f"Failed to stop instance: {str(e)}")
            raise

# Create instance manager
manager = InstanceManager()

@app.route('/api/instances', methods=['POST'])
def start_instance():
    data = request.get_json()
    
    # Validate required fields
    required_fields = ['device_id', 'location', 'user', 'name']
    for field in required_fields:
        if field not in data:
            return jsonify({'error': f'Missing required field: {field}'}), 400
    
    try:
        instance_id = manager.start_instance(
            device_id=int(data['device_id']),
            location=data['location'],
            user=data['user'],
            name=data['name']
        )
        return jsonify({
            'instance_id': instance_id,
            'message': f'Instance started successfully'
        }), 201
    except ValueError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        logger.error(f"Error starting instance: {str(e)}")
        return jsonify({'error': 'Internal server error'}), 500

@app.route('/api/instances/<int:instance_id>', methods=['DELETE'])
def stop_instance(instance_id):
    try:
        manager.stop_instance(instance_id)
        return jsonify({
            'message': f'Instance {instance_id} stopped successfully'
        }), 200
    except ValueError as e:
        return jsonify({'error': str(e)}), 404
    except Exception as e:
        logger.error(f"Error stopping instance: {str(e)}")
        return jsonify({'error': 'Internal server error'}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5002)
