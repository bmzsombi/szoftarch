#!/usr/bin/env python3

import asyncio
import json
import logging
import mysql.connector
import aiocoap
import os
import time
from typing import List, Dict, Any

time.sleep(30)

# Database configuration
DB_CONFIG = {
    'database': os.getenv('DB_NAME', 'plant_care'),
    'user': os.getenv('DB_USER', 'user'),
    'password': os.getenv('DB_PASSWORD', 'teszt'),
    'host': os.getenv('DB_HOST', 'szoftarch-db'),
    'port': os.getenv('DB_PORT', '3306')
}

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("DeviceMonitor")

class DeviceMonitor:
    def __init__(self):
        self.coap_context = None
        self.active_instances = []
        self.polling_interval = int(os.getenv('POLLING_INTERVAL', '60'))  # seconds
        self.db_pool = self.create_pool()

    def create_pool(self):
        """Create a connection pool for MySQL."""
        return mysql.connector.pooling.MySQLConnectionPool(
            pool_name="mypool",
            pool_size=5,
            **DB_CONFIG
        )

    async def setup(self):
        """Setup CoAP context."""
        self.coap_context = await aiocoap.Context.create_client_context()

    def get_active_instances(self) -> List[Dict[str, Any]]:
        """Get all active device instances from database."""
        conn = self.db_pool.get_connection()
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.execute("""
                SELECT 
                    di.id as instance_id,
                    d.id as device_id,
                    d.model,
                    di.location
                FROM device_instance di
                JOIN device d ON di.device_id = d.id
            """)
            return cursor.fetchall()
        finally:
            cursor.close()
            conn.close()

    def get_instance_endpoints(self, device_id: int) -> Dict[str, List[Dict]]:
        """Get all endpoints for a device."""
        conn = self.db_pool.get_connection()
        try:
            cursor = conn.cursor(dictionary=True)
            # Get sensors
            cursor.execute("""
                SELECT id, name, read_endpoint, value_key 
                FROM sensor 
                WHERE device_id = %s
            """, (device_id,))
            sensors = cursor.fetchall()

            # Get actuators
            cursor.execute("""
                SELECT id, name, status_endpoint, value_key, on_up_value
                FROM actuator 
                WHERE device_id = %s
            """, (device_id,))
            actuators = cursor.fetchall()

            return {'sensors': sensors, 'actuators': actuators}
        finally:
            cursor.close()
            conn.close()

    async def query_endpoint(self, instance_id: str, endpoint: str) -> Dict:
        """Query a CoAP endpoint and return the response."""
        try:
            # Use container name as hostname
            container_name = f"device_instance_{instance_id}"
            clean_path = endpoint.strip('/')
            uri = f'coap://{container_name}:5683/{clean_path}'
            logger.info(f"Querying endpoint: {uri}")
            
            request = aiocoap.Message(
                code=aiocoap.GET,
                uri=uri
            )
            response = await self.coap_context.request(request).response
            return json.loads(response.payload)
        except Exception as e:
            logger.error(f"Failed to query endpoint {endpoint} on container {container_name}: {e}")
            return None

    def store_sensor_measurement(self, instance_id: int, sensor_id: int, value: float):
        """Store sensor measurement in database."""
        conn = self.db_pool.get_connection()
        try:
            cursor = conn.cursor()
            # Explicitly include the timestamp in the INSERT
            cursor.execute("""
                INSERT INTO sensor_measurement 
                (instance_id, sensor_id, value, timestamp) 
                VALUES (%s, %s, %s, NOW())
            """, (instance_id, sensor_id, value))
            conn.commit()
        finally:
            cursor.close()
            conn.close()

    def store_actuator_state(self, instance_id: int, actuator_id: int, state: bool):
        """Store actuator state in database."""
        conn = self.db_pool.get_connection()
        try:
            cursor = conn.cursor()
            cursor.execute("""
                INSERT INTO actuator_state_history 
                (instance_id, actuator_id, state, changed_at) 
                VALUES (%s, %s, %s, NOW())
            """, (instance_id, actuator_id, state))
            conn.commit()
        finally:
            cursor.close()
            conn.close()

    async def monitor_instance(self, instance: Dict):
        """Monitor all endpoints for a single instance."""
        endpoints = self.get_instance_endpoints(instance['device_id'])
        
        # Query sensors
        for sensor in endpoints['sensors']:
            logger.info(f"Monitoring sensor: {sensor['name']} at {sensor['read_endpoint']}")
            response = await self.query_endpoint(
                str(instance['instance_id']), 
                sensor['read_endpoint']
            )
            if response and sensor['value_key'] in response:
                value = response[sensor['value_key']]
                self.store_sensor_measurement(
                    instance['instance_id'],
                    sensor['id'],
                    value
                )
                logger.info(f"Stored sensor reading: {sensor['name']} = {value}")

        # Query actuators
        for actuator in endpoints['actuators']:
            logger.info(f"Monitoring actuator: {actuator['name']} at {actuator['status_endpoint']}")
            response = await self.query_endpoint(
                str(instance['instance_id']), 
                actuator['status_endpoint']
            )
            if response and actuator['value_key'] in response:
                state = response[actuator['value_key']]
                self.store_actuator_state(
                    instance['instance_id'],
                    actuator['id'],
                    state == actuator['on_up_value']  # Assuming boolean state
                )
                logger.info(f"Stored actuator state: {actuator['name']} = {state}")

    async def monitor_loop(self):
        """Main monitoring loop."""
        while True:
            try:
                instances = self.get_active_instances()
                logger.info(f"Found {len(instances)} active instances")
                
                # Monitor all instances concurrently
                tasks = [self.monitor_instance(instance) for instance in instances]
                await asyncio.gather(*tasks)
                
                logger.info(f"Completed monitoring cycle. Waiting {self.polling_interval} seconds...")
                await asyncio.sleep(self.polling_interval)
                
            except Exception as e:
                logger.error(f"Error in monitoring loop: {e}")
                await asyncio.sleep(5)  # Wait before retry

async def main():
    monitor = DeviceMonitor()
    await monitor.setup()
    await monitor.monitor_loop()

if __name__ == "__main__":
    asyncio.run(main())
