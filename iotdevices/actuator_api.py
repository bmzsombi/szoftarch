#!/usr/bin/env python3

import os
from fastapi import FastAPI, HTTPException
import mysql.connector
from aiocoap import Context, Message, PUT
import json
from typing import Union, Dict
from pydantic import BaseModel
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("ActuatorControlAPI")

# Database configuration
DB_CONFIG = {
    'database': os.getenv('DB_NAME', 'plant_care'),
    'user': os.getenv('DB_USER', 'user'),
    'password': os.getenv('DB_PASSWORD', 'teszt'),
    'host': os.getenv('DB_HOST', 'szoftarch-db'),
    'port': int(os.getenv('DB_PORT', '3306'))
}

class ActuatorCommand(BaseModel):
    action: Union[bool, str]

class ActuatorAPI:
    def __init__(self):
        self.app = FastAPI(title="Actuator Control API")
        self.db_pool = mysql.connector.pooling.MySQLConnectionPool(
            pool_name="api_pool",
            pool_size=5,
            **DB_CONFIG
        )
        self.coap_context = None
        
        # Register routes
        self.app.on_event("startup")(self.startup_event)
        self.app.put("/api/instances/{instance_id}/actuators/{actuator_id}")(self.control_actuator)
        
    async def startup_event(self):
        """Initialize CoAP context on startup."""
        self.coap_context = await Context.create_client_context()
        logger.info("CoAP context initialized")

    def get_actuator_info(self, instance_id: int, actuator_id: int) -> Dict:
        """Get actuator and device information from database."""
        conn = self.db_pool.get_connection()
        try:
            cursor = conn.cursor(dictionary=True)
            query = """
                SELECT 
                    d.port,
                    di.id as instance_id,
                    di.device_id,
                    a.*
                FROM device_instance di
                JOIN device d ON di.device_id = d.id
                JOIN actuator a ON a.device_id = d.id
                WHERE di.id = %s AND a.id = %s
            """
            cursor.execute(query, (instance_id, actuator_id))
            
            result = cursor.fetchone()
            if not result:
                raise HTTPException(
                    status_code=404,
                    detail=f"Actuator {actuator_id} or device instance {instance_id} not found"
                )
            
            logger.info(f"Found actuator info: {result}")
            return result
            
        finally:
            cursor.close()
            conn.close()

    def normalize_action(self, action: Union[bool, str]) -> bool:
        """Normalize various action inputs to boolean."""
        if isinstance(action, bool):
            return action
        
        action_str = str(action).lower()
        if action_str in ('true', 'on', 'up'):
            return True
        elif action_str in ('false', 'off', 'down'):
            return False
        else:
            raise HTTPException(
                status_code=400,
                detail="Invalid action. Allowed values: true, false, on, off, up, down"
            )

    async def send_coap_request(self, instance_id: int, path: str) -> dict:
        """Send CoAP PUT request to device."""
        try:
            container_name = f"device_instance_{instance_id}"
            
            # Make sure path is properly formatted without leading/trailing slashes
            clean_path = path.strip('/')
            uri = f'coap://{container_name}:5683/{clean_path}'
            logger.info(f"Sending CoAP request to: {uri}")
            
            # Create proper CoAP PUT request
            request = Message(code=PUT, uri=uri)
            logger.info(f"Created CoAP request: Code={request.code}, URI={uri}")
            
            response = await self.coap_context.request(request).response
            logger.info(f"CoAP response received: Code={response.code}")
            
            if response.code.is_successful():
                payload = response.payload.decode('utf-8')
                logger.info(f"Successful response payload: {payload}")
                return json.loads(payload)
            else:
                raise HTTPException(
                    status_code=502,
                    detail=f"Device returned error: {response.code} - {response.payload.decode('utf-8')}"
                )
                
        except Exception as e:
            logger.error(f"CoAP request failed: {e}")
            raise HTTPException(
                status_code=502,
                detail=f"Failed to communicate with device: {str(e)}"
            )

    async def control_actuator(
        self,
        instance_id: int,
        actuator_id: int,
        command: ActuatorCommand
    ):
        """Control an actuator on a device instance."""
        try:
            # Get actuator information
            actuator_info = self.get_actuator_info(instance_id, actuator_id)
            
            # Normalize the action to boolean
            action = self.normalize_action(command.action)
            
            # Determine which endpoint to use
            endpoint = actuator_info['on_up_endpoint'] if action else actuator_info['off_down_endpoint']
            logger.info(f"Using endpoint from DB: {endpoint}")
            
            # Send CoAP request
            result = await self.send_coap_request(
                instance_id=instance_id,
                path=endpoint
            )
            
            return {
                "status": "success",
                "instance_id": instance_id,
                "actuator_id": actuator_id,
                "action": command.action,
                "result": result
            }
            
        except HTTPException:
            raise
        except Exception as e:
            logger.error(f"Error controlling actuator: {e}")
            raise HTTPException(status_code=500, detail=str(e))

# Initialize the API
api = ActuatorAPI()
app = api.app

def main():
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=5003)

if __name__ == "__main__":
    main()
