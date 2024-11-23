#!/usr/bin/env python3

import os
import asyncio
import json
import logging
import psycopg2
from psycopg2.extras import DictCursor
from aiocoap import resource, Context, Message, CHANGED
from abc import ABC, abstractmethod
from datetime import datetime
from typing import Any, Dict, Optional
import random

# Database configuration
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'plantmonitor'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', ''),
    'host': os.getenv('DB_HOST', 'postgres_dev'),  # Default to container name
    'port': os.getenv('DB_PORT', '5432')
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
    def __init__(self, actuator_config: Dict[str, Any], command_type: str):
        super().__init__()
        self.config = actuator_config
        self.command_type = command_type  # 'status', 'on_up', or 'off_down'
        self.state = False  # Initialize to off/closed state
        logger.info(f"Created actuator resource: {self.config['name']} for {command_type}")

    def get_state_value(self) -> str:
        """Get the current state value based on actuator configuration."""
        if self.state:
            return self.config['on_up_value']
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

    def load_configuration(self):
        """Load device configuration from database."""
        with psycopg2.connect(**DB_CONFIG) as conn:
            with conn.cursor(cursor_factory=DictCursor) as cur:
                # Load device info
                cur.execute("""
                    SELECT * FROM devices WHERE id = %s
                """, (self.device_id,))
                self.device_info = dict(cur.fetchone())

                # Load sensors
                cur.execute("""
                    SELECT * FROM sensors WHERE device_id = %s
                """, (self.device_id,))
                self.sensors = [dict(row) for row in cur.fetchall()]

                # Load actuators
                cur.execute("""
                    SELECT * FROM actuators WHERE device_id = %s
                """, (self.device_id,))
                self.actuators = [dict(row) for row in cur.fetchall()]

        logger.info(f"Loaded configuration for device {self.device_info['model']}")

    async def start(self):
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