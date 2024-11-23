#!/usr/bin/env python3

import asyncio
import json
import logging
import psycopg2
from psycopg2.extras import DictCursor
import aiocoap
from datetime import datetime
import os
import time
from typing import List, Dict, Any

time.sleep(30)

# Database configuration
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'plantmonitor'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', ''),
    'host': os.getenv('DB_HOST', 'postgres_dev'),
    'port': os.getenv('DB_PORT', '5432')
}

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("DeviceMonitor")

class DeviceMonitor:
    def __init__(self):
        self.coap_context = None
        self.active_instances = []
        self.polling_interval = int(os.getenv('POLLING_INTERVAL', '60'))  # seconds

    async def setup(self):
        """Setup CoAP context."""
        self.coap_context = await aiocoap.Context.create_client_context()

    def get_active_instances(self) -> List[Dict[str, Any]]:
        """Get all active device instances from database."""
        with psycopg2.connect(**DB_CONFIG) as conn:
            with conn.cursor(cursor_factory=DictCursor) as cur:
                cur.execute("""
                    SELECT 
                        di.id as instance_id,
                        d.id as device_id,
                        d.model,
                        di.location
                    FROM device_instances di
                    JOIN devices d ON di.device_id = d.id
                """)
                return [dict(row) for row in cur.fetchall()]

    def get_instance_endpoints(self, device_id: int) -> Dict[str, List[Dict]]:
        """Get all endpoints for a device."""
        with psycopg2.connect(**DB_CONFIG) as conn:
            with conn.cursor(cursor_factory=DictCursor) as cur:
                # Get sensors
                cur.execute("""
                    SELECT id, name, read_endpoint, value_key 
                    FROM sensors 
                    WHERE device_id = %s
                """, (device_id,))
                sensors = [dict(row) for row in cur.fetchall()]

                # Get actuators
                cur.execute("""
                    SELECT id, name, status_endpoint, value_key 
                    FROM actuators 
                    WHERE device_id = %s
                """, (device_id,))
                actuators = [dict(row) for row in cur.fetchall()]

                return {'sensors': sensors, 'actuators': actuators}

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
        with psycopg2.connect(**DB_CONFIG) as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    INSERT INTO sensor_measurements 
                    (instance_id, sensor_id, value) 
                    VALUES (%s, %s, %s)
                """, (instance_id, sensor_id, value))
                conn.commit()

    def store_actuator_state(self, instance_id: int, actuator_id: int, state: bool):
        """Store actuator state in database."""
        with psycopg2.connect(**DB_CONFIG) as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    INSERT INTO actuator_state_history 
                    (instance_id, actuator_id, state) 
                    VALUES (%s, %s, %s)
                """, (instance_id, actuator_id, state))
                conn.commit()

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
                    state == 'on'  # Assuming boolean state
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
