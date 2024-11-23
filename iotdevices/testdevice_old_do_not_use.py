#!/usr/bin/env python3

import yaml
import random
import asyncio
import json
import logging
from aiocoap import resource, Context, Message, CHANGED
from datetime import datetime
from aiocoap.numbers.codes import Code

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("IoTDeviceSimulator")

class SensorResource(resource.Resource):
    def __init__(self, sensor_config):
        super().__init__()
        self.sensor_config = sensor_config
        self.measurement = sensor_config['measurement']
        self.value_key = sensor_config['coap_endpoints']['read'].get('value_key', 'value')
        logger.info(f"Created sensor resource with value_key: {self.value_key}")

    async def render_get(self, request):
        logger.info(f"Received GET request for sensor")
        # Generate random value within the specified range
        min_val = self.measurement['range']['min']
        max_val = self.measurement['range']['max']
        
        if self.measurement['data_type'] == 'INTEGER':
            value = random.randint(min_val, max_val)
        else:  # FLOAT
            value = random.uniform(min_val, max_val)
            value = round(value, 2)

        # Create response with timestamp
        response_data = {
            self.value_key: value,
            "timestamp": datetime.now().isoformat()
        }
        
        payload = json.dumps(response_data).encode('utf-8')
        logger.info(f"Sending sensor response: {response_data}")
        return Message(payload=payload)

class ActuatorResource(resource.Resource):
    def __init__(self, name, actuator_type, command):
        super().__init__()
        self.name = name
        self.actuator_type = actuator_type
        self.command = command  # 'on', 'off', 'open', or 'close'
        self.state = False
        logger.info(f"Created actuator resource: {name} of type {actuator_type} for command {command}")

    async def render_put(self, request):
        logger.info(f"Received PUT request for actuator {self.name} with command {self.command}")
        
        if self.command in ['on', 'open']:
            self.state = True
            logger.info(f"{self.name} turned ON/OPENED")
        elif self.command in ['off', 'close']:
            self.state = False
            logger.info(f"{self.name} turned OFF/CLOSED")
        
        response_data = {
            "status": "success",
            "device": self.name,
            "state": "on" if self.state else "off"
        }
        
        payload = json.dumps(response_data).encode('utf-8')
        return Message(payload=payload, code=Code.CHANGED)

class IoTDeviceSimulator:
    def __init__(self, config_file):
        with open(config_file, 'r') as f:
            self.config = yaml.safe_load(f)
        
        self.name = self.config['device_info']['model']
        self.port = self.config['network']['default_port']
        
    async def start(self):
        # Create root site
        root = resource.Site()
        
        # Add sensor resources
        for sensor in self.config['sensors']:
            path = sensor['coap_endpoints']['read']['path'].lstrip('/')
            path_segments = path.split('/')
            root.add_resource(path_segments, SensorResource(sensor))
            logger.info(f"Added sensor resource at path: /{path}")
            
        # Add actuator resources
        for actuator in self.config['actuators']:
            if actuator['type'] in ['PUMP', 'LIGHT']:
                # Add turn on endpoint
                on_path = actuator['endpoints']['turn_on'].lstrip('/')
                on_segments = on_path.split('/')
                root.add_resource(
                    on_segments, 
                    ActuatorResource(actuator['name'], actuator['type'], 'on')
                )
                
                # Add turn off endpoint
                off_path = actuator['endpoints']['turn_off'].lstrip('/')
                off_segments = off_path.split('/')
                root.add_resource(
                    off_segments,
                    ActuatorResource(actuator['name'], actuator['type'], 'off')
                )
                
            elif actuator['type'] == 'BLIND':
                # Add open endpoint
                open_path = actuator['endpoints']['open'].lstrip('/')
                open_segments = open_path.split('/')
                root.add_resource(
                    open_segments,
                    ActuatorResource(actuator['name'], actuator['type'], 'open')
                )
                
                # Add close endpoint
                close_path = actuator['endpoints']['close'].lstrip('/')
                close_segments = close_path.split('/')
                root.add_resource(
                    close_segments,
                    ActuatorResource(actuator['name'], actuator['type'], 'close')
                )

        # Create context with the site
        self.context = await Context.create_server_context(root, bind=("::", self.port))
        logger.info(f"IoT Device Simulator '{self.name}' started on port {self.port}")
        logger.info("Available endpoints:")
        self._print_endpoints(root)

    def _print_endpoints(self, site, path=""):
        """Recursively print all available endpoints"""
        for name, resource in site._resources.items():
            current_path = f"{path}/{name}" if path else f"/{name}"
            if isinstance(resource, (ActuatorResource, SensorResource)):
                logger.info(f"  {current_path}")
            if hasattr(resource, '_resources'):
                self._print_endpoints(resource, current_path)

async def main():
    import sys
    if len(sys.argv) != 2:
        print("Usage: python simulator.py <config.yaml>")
        sys.exit(1)

    config_file = sys.argv[1]
    simulator = IoTDeviceSimulator(config_file)
    await simulator.start()
    
    # Keep the server running
    try:
        while True:
            await asyncio.sleep(1)
    except KeyboardInterrupt:
        logger.info("Shutting down simulator...")

if __name__ == "__main__":
    asyncio.run(main())
