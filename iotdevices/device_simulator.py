#!/usr/bin/env python3

import os
import asyncio
import json
import logging
import mysql.connector
from abc import ABC, abstractmethod
from datetime import datetime
from typing import Optional, Dict, Any 
from aiocoap import resource, Message, CHANGED
import random

# Database configuration
DB_CONFIG = {
    'database': os.getenv('DB_NAME', 'plant_care'),
    'user': os.getenv('DB_USER', 'user'),
    'password': os.getenv('DB_PASSWORD', 'teszt'),
    'host': os.getenv('DB_HOST', 'szoftarch-db'),
    'port': os.getenv('DB_PORT', '3306')
}

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("IoTDeviceSimulator")

class SensorDataSource(ABC):
    @abstractmethod
    def get_value(self, data_type: str, min_val: Optional[float], max_val: Optional[float]) -> float:
        pass

class RandomSensorDataSource(SensorDataSource):
    def get_value(self, data_type: str, min_val: Optional[float], max_val: Optional[float]) -> float:
        if min_val is None:
            min_val = 0
        if max_val is None:
            max_val = 100
            
        if data_type == 'INTEGER':
            return random.randint(int(min_val), int(max_val))
        else:  # FLOAT
            return round(random.uniform(min_val, max_val), 2)

class SensorResource(resource.Resource):
    def __init__(self, sensor_config: Dict[str, Any], data_source: SensorDataSource):
        super().__init__()
        self.config = sensor_config
        self.data_source = data_source
        logger.info(f"Created sensor resource: {self.config['name']}")

    async def render_get(self, request):
        value = self.data_source.get_value(
            self.config['data_type'],
            self.config['min_value'],
            self.config['max_value']
        )

        response_data = {
            self.config['value_key']: value,
            "timestamp": datetime.now().isoformat()
        }
        
        payload = json.dumps(response_data).encode('utf-8')
        logger.info(f"Sensor {self.config['name']} reading: {response_data}")
        return Message(payload=payload)

class ActuatorResource(resource.Resource):
    # Class-level dictionary to store states across all instances of same actuator
    _shared_states = {}
    
    def __init__(self, actuator_config: Dict[str, Any], command_type: str):
        super().__init__()
        self.config = actuator_config
        self.command_type = command_type  # 'status', 'on_up', or 'off_down'
        
        # Use actuator ID as key for shared state
        self.actuator_id = self.config['id']
        if self.actuator_id not in self._shared_states:
            self._shared_states[self.actuator_id] = False
        
        logger.info(f"Created actuator resource: {self.config['name']} for {command_type}")

    @property
    def state(self):
        return self._shared_states[self.actuator_id]
    
    @state.setter
    def state(self, value):
        self._shared_states[self.actuator_id] = value

    def get_state_value(self) -> str:
        """Get the current state value based on actuator configuration."""
        if self.state:
            logger.info(f"Returning state {self.config['on_up_value']}")
            return self.config['on_up_value']
        logger.info(f"Returning state {self.config['off_down_value']}")
        return self.config['off_down_value']

    async def render_get(self, request):
        """Handle status endpoint."""
        if self.command_type != 'status':
            return Message(code=4.05)  # Method not allowed
        
        response_data = {
            self.config['value_key']: self.get_state_value(),
            "timestamp": datetime.now().isoformat()
        }
        
        payload = json.dumps(response_data).encode('utf-8')
        return Message(payload=payload)

    async def render_put(self, request):
        """Handle actuation endpoints."""
        if self.command_type == 'status':
            return Message(code=4.05)  # Method not allowed
            
        if self.command_type == 'on_up':
            self.state = True
            logger.info(f"Actuator {self.config['name']} turned ON/OPENED")
        else:  # off_down
            self.state = False
            logger.info(f"Actuator {self.config['name']} turned OFF/CLOSED")
        
        response_data = {
            "status": "success",
            "device": self.config['name'],
            "state": self.get_state_value()
        }
        
        payload = json.dumps(response_data).encode('utf-8')
        return Message(payload=payload, code=CHANGED)

class IoTDeviceSimulator:
    def __init__(self, device_id: int):
        self.device_id = device_id
        self.device_info = None
        self.sensors = []
        self.actuators = []
        self.data_source = RandomSensorDataSource()
        self.db_pool = self.create_pool()

    def create_pool(self):
        """Create a connection pool for MySQL."""
        return mysql.connector.pooling.MySQLConnectionPool(
            pool_name="simulator_pool",
            pool_size=5,
            **DB_CONFIG
        )

    def load_configuration(self):
        """Load device configuration from database."""
        conn = self.db_pool.get_connection()
        try:
            cursor = conn.cursor(dictionary=True)
            
            # Load device info
            cursor.execute("""
                SELECT * FROM device WHERE id = %s
            """, (self.device_id,))
            self.device_info = cursor.fetchone()

            # Load sensors
            cursor.execute("""
                SELECT * FROM sensor WHERE device_id = %s
            """, (self.device_id,))
            self.sensors = cursor.fetchall()

            # Load actuators
            cursor.execute("""
                SELECT * FROM actuator WHERE device_id = %s
            """, (self.device_id,))
            self.actuators = cursor.fetchall()

            logger.info(f"Loaded configuration for device {self.device_info['model']}")

        finally:
            cursor.close()
            conn.close()

    async def start(self):
        try:
            from aiocoap import resource, Context, Message, CHANGED
            
            self.load_configuration()
            root = resource.Site()

            # Add sensor resources
            for sensor in self.sensors:
                # Remove leading/trailing slashes and split
                path = sensor['read_endpoint'].strip('/')
                path_segments = path.split('/')
                root.add_resource(path_segments, SensorResource(sensor, self.data_source))
                logger.info(f"Added sensor resource at path: /{path}")

            # Add actuator resources
            for actuator in self.actuators:
                # Handle status endpoint
                status_path = actuator['status_endpoint'].strip('/').split('/')
                root.add_resource(status_path, ActuatorResource(actuator, 'status'))
                logger.info(f"Added actuator status at path: /{'/'.join(status_path)}")

                # Handle control endpoints
                on_path = actuator['on_up_endpoint'].strip('/').split('/')
                off_path = actuator['off_down_endpoint'].strip('/').split('/')
                
                root.add_resource(on_path, ActuatorResource(actuator, 'on_up'))
                root.add_resource(off_path, ActuatorResource(actuator, 'off_down'))
                logger.info(f"Added actuator control at paths: /{'/'.join(on_path)} and /{'/'.join(off_path)}")

            self.context = await Context.create_server_context(
                root, 
                bind=('::', self.device_info['port'])
            )

        except Exception as e:
            logger.error(f"Error starting simulator: {e}")
            raise

    def _print_endpoints(self, site, path=""):
        """Recursively print all available endpoints"""
        for name, resource in site._resources.items():
            current_path = f"{path}/{name}" if path else f"/{name}"
            if isinstance(resource, (ActuatorResource, SensorResource)):
                logger.info(f"  Endpoint: {current_path}")
            if hasattr(resource, '_resources'):
                self._print_endpoints(resource, current_path)

async def main():
    import sys
    if len(sys.argv) != 2:
        print("Usage: python simulator.py <device_id>")
        sys.exit(1)

    try:
        device_id = int(sys.argv[1])
    except ValueError:
        print("Error: device_id must be an integer")
        sys.exit(1)

    simulator = IoTDeviceSimulator(device_id)
    await simulator.start()
    
    try:
        while True:
            await asyncio.sleep(1)
    except KeyboardInterrupt:
        logger.info("Shutting down simulator...")

if __name__ == "__main__":
    asyncio.run(main())
