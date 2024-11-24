#!/usr/bin/env python3

from fastapi import FastAPI, UploadFile, BackgroundTasks, HTTPException
from fastapi.responses import JSONResponse
import yaml
import mysql.connector
import logging
import os
import re
from typing import Dict, Tuple, Any, Optional, Set

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'szoftarch-db'),
    'user': os.getenv('DB_USER', 'user'),
    'password': os.getenv('DB_PASSWORD', 'teszt'),
    'database': os.getenv('DB_NAME', 'plant_care'),
    'port': int(os.getenv('DB_PORT', 3306))
}

app = FastAPI()

def get_db_connection():
    """Create and return a database connection."""
    try:
        return mysql.connector.connect(**DB_CONFIG)
    except mysql.connector.Error as e:
        logger.error(f"Failed to connect to database: {e}")
        raise HTTPException(status_code=500, detail="Database connection failed")

class ValidationError(Exception):
    pass

def validate_url_path(path: str) -> bool:
    """Validate if string is a valid URL path."""
    # Basic URL path validation: no spaces, starts with letter/number
    return bool(re.match(r'^[a-zA-Z0-9/][a-zA-Z0-9_/.-]*$', path))

def validate_non_empty_string(value: str, field_name: str) -> None:
    """Validate if a string is non-empty."""
    if not isinstance(value, str) or not value.strip():
        raise ValidationError(f"{field_name} must be a non-empty string")

def validate_device_info(device_info: Dict) -> None:
    """Validate device_info section."""
    if not isinstance(device_info, dict):
        raise ValidationError("device_info must be a dictionary")
    
    # Check required fields
    required_fields = ["manufacturer", "model", "firmware_version"]
    for field in required_fields:
        if field not in device_info:
            raise ValidationError(f"device_info.{field} is required")
        validate_non_empty_string(device_info[field], f"device_info.{field}")

def validate_network(network: Dict) -> None:
    """Validate optional network section."""
    if network is None:
        return
    
    if not isinstance(network, dict):
        raise ValidationError("network must be a dictionary")
    
    if 'default_port' in network:
        if not isinstance(network['default_port'], int):
            raise ValidationError("network.default_port must be an integer")
    
    if 'discovery_enabled' in network:
        if not isinstance(network['discovery_enabled'], bool):
            raise ValidationError("network.discovery_enabled must be a boolean")

def validate_measurement(measurement: Dict, context: str) -> None:
    """Validate measurement section of sensors."""
    if not isinstance(measurement, dict):
        raise ValidationError(f"{context}: measurement must be a dictionary")
    
    # Required fields
    if 'unit' not in measurement:
        raise ValidationError(f"{context}: measurement.unit is required")
    validate_non_empty_string(measurement['unit'], f"{context}: measurement.unit")
    
    if 'data_type' not in measurement:
        raise ValidationError(f"{context}: measurement.data_type is required")
    if measurement['data_type'] not in ['INTEGER', 'FLOAT']:
        raise ValidationError(f"{context}: measurement.data_type must be INTEGER or FLOAT")
    
    # Optional range
    if 'range' in measurement:
        if 'min' not in measurement['range'] or 'max' not in measurement['range']:
            raise ValidationError(f"{context}: both min and max are required in range")
        try:
            min_val = float(measurement['range']['min'])
            max_val = float(measurement['range']['max'])
            if min_val > max_val:
                raise ValidationError(f"{context}: range.min must be less than or equal to range.max")
        except (ValueError, TypeError):
            raise ValidationError(f"{context}: range values must be numbers")

def validate_coap_endpoints_sensor(endpoints: Dict, context: str) -> None:
    """Validate CoAP endpoints for sensors."""
    if not isinstance(endpoints, dict):
        raise ValidationError(f"{context}: coap_endpoints must be a dictionary")
    
    if 'read' not in endpoints:
        raise ValidationError(f"{context}: coap_endpoints.read is required")
    
    read = endpoints['read']
    if not isinstance(read, dict):
        raise ValidationError(f"{context}: coap_endpoints.read must be a dictionary")
    
    if 'path' not in read:
        raise ValidationError(f"{context}: coap_endpoints.read.path is required")
    if not validate_url_path(read['path']):
        raise ValidationError(f"{context}: Invalid URL path format in coap_endpoints.read.path")
    
    if 'value_key' not in read:
        raise ValidationError(f"{context}: coap_endpoints.read.value_key is required")
    validate_non_empty_string(read['value_key'], f"{context}: coap_endpoints.read.value_key")

def validate_sensor(sensor: Dict, index: int) -> None:
    """Validate a single sensor configuration."""
    context = f"sensors[{index}]"
    
    if not isinstance(sensor, dict):
        raise ValidationError(f"{context} must be a dictionary")
    
    # Required fields
    if 'name' not in sensor:
        raise ValidationError(f"{context}: name is required")
    validate_non_empty_string(sensor['name'], f"{context}: name")
    
    if 'measurement' not in sensor:
        raise ValidationError(f"{context}: measurement is required")
    validate_measurement(sensor['measurement'], context)
    
    if 'coap_endpoints' not in sensor:
        raise ValidationError(f"{context}: coap_endpoints is required")
    validate_coap_endpoints_sensor(sensor['coap_endpoints'], context)
    
    # Optional sampling
    if 'sampling' in sensor:
        if not isinstance(sensor['sampling'], dict):
            raise ValidationError(f"{context}: sampling must be a dictionary")
        if 'interval' in sensor['sampling']:
            if not isinstance(sensor['sampling']['interval'], int):
                raise ValidationError(f"{context}: sampling.interval must be an integer")

def validate_actuator_state(state: Dict, actuator_type: str, context: str) -> None:
    """Validate actuator state configuration."""
    if not isinstance(state, dict):
        raise ValidationError(f"{context}: state must be a dictionary")
    
    required_fields = ['data_type', 'possible_values', 'value_key']
    for field in required_fields:
        if field not in state:
            raise ValidationError(f"{context}: state.{field} is required")
    
    if state['data_type'] not in ['BOOLEAN', 'ENUM']:
        raise ValidationError(f"{context}: state.data_type must be BOOLEAN or ENUM")
    
    if not isinstance(state['possible_values'], list):
        raise ValidationError(f"{context}: state.possible_values must be a list")
    
    values = state['possible_values']
    if state['data_type'] == 'BOOLEAN':
        if len(values) != 2:
            raise ValidationError(f"{context}: BOOLEAN state must have exactly 2 possible values")
    else:  # ENUM
        if len(values) < 2:
            raise ValidationError(f"{context}: ENUM state must have at least 2 possible values")
        
        # Check for on_value/off_value for PUMP/LIGHT with ENUM type
        if actuator_type in ['PUMP', 'LIGHT']:
            if ('on_value' in state and 'off_value' not in state) or ('off_value' in state and 'on_value' not in state):
                raise ValidationError(f"{context}: Both on_value and off_value must be defined for {actuator_type} if either is defined")
            if len(values) > 2:
                if 'on_value' not in state or 'off_value' not in state:
                    raise ValidationError(f"{context}: on_value and off_value are required for {actuator_type} with ENUM type having more than 2 values")
                if state['on_value'] not in values or state['off_value'] not in values:
                    raise ValidationError(f"{context}: on_value and off_value must be in possible_values")
        
        # Check for open_value/closed_value for BLIND with ENUM type
        if actuator_type == 'BLIND':
            if ('open_value' in state and 'closed_value' not in state) or ('closed_value' in state and 'open_value' not in state):
                raise ValidationError(f"{context}: Both open_value and closed_value must be defined for BLIND if either is defined")
            if len(values) > 2:
                if 'open_value' not in state or 'closed_value' not in state:
                    raise ValidationError(f"{context}: open_value and closed_value are required for BLIND with ENUM type having more than 2 values")
                if state['open_value'] not in values or state['closed_value'] not in values:
                    raise ValidationError(f"{context}: open_value and closed_value must be in possible_values")

def validate_actuator_endpoints(endpoints: Dict, actuator_type: str, context: str) -> None:
    """Validate actuator endpoints configuration."""
    if not isinstance(endpoints, dict):
        raise ValidationError(f"{context}: endpoints must be a dictionary")
    
    if 'status' not in endpoints:
        raise ValidationError(f"{context}: endpoints.status is required")
    if not validate_url_path(endpoints['status']):
        raise ValidationError(f"{context}: Invalid URL path format in endpoints.status")
    
    if actuator_type in ['PUMP', 'LIGHT']:
        required = ['turn_on', 'turn_off']
    elif actuator_type == 'BLIND':
        required = ['open', 'close']
    else:
        raise ValidationError(f"{context}: Invalid actuator type: {actuator_type}")
    
    for endpoint in required:
        if endpoint not in endpoints:
            raise ValidationError(f"{context}: endpoints.{endpoint} is required for type {actuator_type}")
        if not validate_url_path(endpoints[endpoint]):
            raise ValidationError(f"{context}: Invalid URL path format in endpoints.{endpoint}")

def validate_actuator(actuator: Dict, index: int) -> None:
    """Validate a single actuator configuration."""
    context = f"actuators[{index}]"
    
    if not isinstance(actuator, dict):
        raise ValidationError(f"{context} must be a dictionary")
    
    # Required fields
    required_fields = ['type', 'name', 'state', 'endpoints']
    for field in required_fields:
        if field not in actuator:
            raise ValidationError(f"{context}: {field} is required")
    
    # Validate type
    if actuator['type'] not in ['PUMP', 'LIGHT', 'BLIND']:
        raise ValidationError(f"{context}: type must be one of: PUMP, LIGHT, BLIND")
    
    validate_non_empty_string(actuator['name'], f"{context}: name")
    validate_actuator_state(actuator['state'], actuator['type'], context)
    validate_actuator_endpoints(actuator['endpoints'], actuator['type'], context)

def validate_yaml_config(config: Dict) -> None:
    """Main validation function for the YAML configuration."""
    # Validate device_info (required)
    if 'device_info' not in config:
        raise ValidationError("device_info section is required")
    validate_device_info(config['device_info'])
    
    # Validate network (optional)
    if 'network' in config:
        validate_network(config['network'])
    
    # Validate that at least one sensor or actuator exists
    sensors = config.get('sensors', [])
    actuators = config.get('actuators', [])
    
    if not sensors and not actuators:
        raise ValidationError("At least one sensor or actuator is required")
    
    # Validate sensors
    for i, sensor in enumerate(sensors):
        validate_sensor(sensor, i)
    
    # Validate actuators
    for i, actuator in enumerate(actuators):
        validate_actuator(actuator, i)

def validate_yaml_content(content: str) -> Tuple[bool, str]:
    """Validate YAML content directly from string."""
    try:
        config = yaml.safe_load(content)
        validate_yaml_config(config)
        return True, "Configuration is valid"
    except ValidationError as e:
        return False, str(e)
    except yaml.YAMLError as e:
        return False, f"YAML parsing error: {str(e)}"
    except Exception as e:
        return False, f"Unexpected error: {str(e)}"
    
async def process_yaml_to_db(content: str):
    """Process the YAML content and insert/update data in the database."""
    try:
        config = yaml.safe_load(content)
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        
        try:
            # Get or insert device information
            device_id = get_or_insert_device(cursor, config['device_info'], config.get('network'))
            
            # Keep track of current sensors and actuators
            current_sensors = set()
            current_actuators = set()
            
            # Process sensors if present
            for sensor in config.get('sensors', []):
                sensor_id = get_or_update_sensor(cursor, sensor, device_id)
                current_sensors.add(sensor['name'])
            
            # Process actuators if present
            for actuator in config.get('actuators', []):
                actuator_id = get_or_update_actuator(cursor, actuator, device_id)
                current_actuators.add(actuator['name'])
            
            # Clean up old components
            cleanup_old_components(cursor, device_id, current_sensors, current_actuators)
            
            conn.commit()
            logger.info("Successfully imported/updated all data")
            
        except Exception as e:
            conn.rollback()
            logger.error(f"Error during import: {e}")
            raise
        finally:
            cursor.close()
            conn.close()
            
    except Exception as e:
        logger.error(f"Failed to process YAML content: {e}")
        raise
    

def get_or_insert_device(cursor, device_info: Dict[str, Any], network: Optional[Dict[str, Any]]) -> int:
    """Get existing device ID or insert new device and return the ID."""
    find_sql = """
    SELECT id FROM device
    WHERE manufacturer = %s
    AND model = %s
    AND firmware_version = %s;
    """
    
    cursor.execute(find_sql, (
        device_info['manufacturer'],
        device_info['model'],
        device_info['firmware_version']
    ))
    
    result = cursor.fetchone()
    
    if result:
        device_id = result['id']
        # Update existing device
        update_sql = """
        UPDATE device
        SET description = %s,
            port = %s,
            discovery_enabled = %s
        WHERE id = %s;
        """
        
        port = network.get('default_port', 5683) if network else 5683
        discovery_enabled = network.get('discovery_enabled', True) if network else True
        
        cursor.execute(update_sql, (
            device_info.get('description'),
            port,
            discovery_enabled,
            device_id
        ))
        
        logger.info(f"Updated existing device with ID: {device_id}")
        return device_id
    
    # If no existing device found, insert new one
    insert_sql = """
    INSERT INTO device (manufacturer, model, firmware_version, description, port, discovery_enabled)
    VALUES (%s, %s, %s, %s, %s, %s);
    """
    
    port = network.get('default_port', 5683) if network else 5683
    discovery_enabled = network.get('discovery_enabled', True) if network else True
    
    cursor.execute(insert_sql, (
        device_info['manufacturer'],
        device_info['model'],
        device_info['firmware_version'],
        device_info.get('description'),
        port,
        discovery_enabled
    ))
    
    return cursor.lastrowid

def determine_actuator_values(actuator: Dict[str, Any]) -> tuple:
    """Determine on/off or open/close values based on actuator type and state configuration."""
    state = actuator['state']
    actuator_type = actuator['type']
    possible_values = state['possible_values']
    data_type = state['data_type']
    
    if actuator_type in ['PUMP', 'LIGHT']:
        if data_type == 'BOOLEAN':
            if 'on_value' in state:
                on_up_value = state['on_value']
                off_down_value = state['off_value']
            else:
                on_up_value = possible_values[0]
                off_down_value = possible_values[1]
        else:  # ENUM
            on_up_value = state['on_value']
            off_down_value = state['off_value']
    else:  # BLIND
        if data_type == 'BOOLEAN':
            if 'open_value' in state:
                on_up_value = state['open_value']
                off_down_value = state['closed_value']
            else:
                on_up_value = possible_values[0]
                off_down_value = possible_values[1]
        else:  # ENUM
            on_up_value = state['open_value']
            off_down_value = state['closed_value']
    
    return on_up_value, off_down_value

def normalize_endpoint_path(path: str) -> str:
    """Normalize an endpoint path to ensure consistent format."""
    # Remove any leading/trailing whitespace
    path = path.strip()
    
    # Ensure path starts with a single /
    path = '/' + path.lstrip('/')
    
    # Remove any double slashes and trailing slashes
    while '//' in path:
        path = path.replace('//', '/')
    path = path.rstrip('/')
    
    # Validate the path format
    if not path.startswith('/'):
        raise ValueError(f"Invalid path format: {path}. Must start with /")
    
    # Check for valid characters
    if not all(c.isalnum() or c in '/_-' for c in path.strip('/')):
        raise ValueError(f"Invalid characters in path: {path}")
    
    return path

def get_or_update_sensor(cursor, sensor: Dict[str, Any], device_id: int) -> int:
    """Get existing sensor ID or insert new sensor and return the ID."""
    try:
        # Normalize and validate the endpoint path
        read_endpoint = normalize_endpoint_path(sensor['coap_endpoints']['read']['path'])
        
        # Validate value key
        value_key = sensor['coap_endpoints']['read']['value_key'].strip()
        if not value_key:
            raise ValueError(f"Empty value_key for sensor {sensor['name']}")
        
        measurement = sensor['measurement']
        range_values = measurement.get('range', {})
        
        # Find existing sensor
        find_sql = """
        SELECT id FROM sensor
        WHERE device_id = %s AND name = %s;
        """
        
        cursor.execute(find_sql, (device_id, sensor['name']))
        result = cursor.fetchone()
        
        if result:
            sensor_id = result['id']
            update_sql = """
            UPDATE sensor
            SET sensor_type = %s,
                unit = %s,
                data_type = %s,
                min_value = %s,
                max_value = %s,
                read_endpoint = %s,
                value_key = %s,
                sampling_interval = %s
            WHERE id = %s;
            """
            
            values = (
                sensor.get('type'),
                measurement['unit'],
                measurement['data_type'],
                range_values.get('min'),
                range_values.get('max'),
                read_endpoint,  # Using normalized path
                value_key,
                sensor.get('sampling', {}).get('interval'),
                sensor_id
            )
            
            cursor.execute(update_sql, values)
            logger.info(f"Updated sensor {sensor['name']} with normalized endpoint: {read_endpoint}")
            return sensor_id
        
        # Insert new sensor
        insert_sql = """
        INSERT INTO sensor (
            device_id, name, sensor_type, unit, data_type,
            min_value, max_value, read_endpoint, value_key, sampling_interval
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
        """
        
        cursor.execute(insert_sql, (
            device_id,
            sensor['name'],
            sensor.get('type'),
            measurement['unit'],
            measurement['data_type'],
            range_values.get('min'),
            range_values.get('max'),
            read_endpoint,  # Using normalized path
            value_key,
            sensor.get('sampling', {}).get('interval')
        ))
        
        return cursor.lastrowid
        
    except ValueError as e:
        raise ValueError(f"Invalid sensor configuration for {sensor['name']}: {str(e)}")

def get_or_update_actuator(cursor, actuator: Dict[str, Any], device_id: int) -> int:
    """Get existing actuator ID or insert new actuator and return the ID."""
    try:
        # Normalize and validate all endpoints
        status_endpoint = normalize_endpoint_path(actuator['endpoints']['status'])
        on_up_endpoint, off_down_endpoint = determine_actuator_endpoints(actuator)
        on_up_endpoint = normalize_endpoint_path(on_up_endpoint)
        off_down_endpoint = normalize_endpoint_path(off_down_endpoint)
        
        # Validate value key
        value_key = actuator['state']['value_key'].strip()
        if not value_key:
            raise ValueError(f"Empty value_key for actuator {actuator['name']}")
        
        on_up_value, off_down_value = determine_actuator_values(actuator)
        if not all([on_up_value, off_down_value]):
            raise ValueError(f"Missing on/off values for actuator {actuator['name']}")
        
        # Find existing actuator
        find_sql = """
        SELECT id FROM actuator
        WHERE device_id = %s AND name = %s;
        """
        
        cursor.execute(find_sql, (device_id, actuator['name']))
        result = cursor.fetchone()
        
        if result:
            actuator_id = result['id']
            update_sql = """
            UPDATE actuator
            SET type = %s,
                status_endpoint = %s,
                value_key = %s,
                on_up_value = %s,
                off_down_value = %s,
                on_up_endpoint = %s,
                off_down_endpoint = %s
            WHERE id = %s;
            """
            
            values = (
                actuator['type'],
                status_endpoint,
                value_key,
                on_up_value,
                off_down_value,
                on_up_endpoint,
                off_down_endpoint,
                actuator_id
            )
            
            cursor.execute(update_sql, values)
            logger.info(f"Updated actuator {actuator['name']} with normalized endpoints")
            return actuator_id
            
        # Insert new actuator
        insert_sql = """
        INSERT INTO actuator (
            device_id, name, type, status_endpoint, value_key,
            on_up_value, off_down_value, on_up_endpoint, off_down_endpoint
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
        """
        
        cursor.execute(insert_sql, (
            device_id,
            actuator['name'],
            actuator['type'],
            status_endpoint,
            value_key,
            on_up_value,
            off_down_value,
            on_up_endpoint,
            off_down_endpoint
        ))
        
        return cursor.lastrowid
        
    except ValueError as e:
        raise ValueError(f"Invalid actuator configuration for {actuator['name']}: {str(e)}")

def determine_actuator_endpoints(actuator: Dict[str, Any]) -> tuple:
    """Determine endpoints based on actuator type."""
    endpoints = actuator['endpoints']
    actuator_type = actuator['type']
    
    if actuator_type in ['PUMP', 'LIGHT']:
        return endpoints['turn_on'], endpoints['turn_off']
    else:  # BLIND
        return endpoints['open'], endpoints['close']

def get_or_update_actuator(cursor, actuator: Dict[str, Any], device_id: int) -> int:
    """Get existing actuator ID or insert new actuator and return the ID."""
    # Try to find existing actuator for this device with the same name
    find_sql = """
    SELECT id FROM actuator
    WHERE device_id = %s AND name = %s;
    """
    
    cursor.execute(find_sql, (device_id, actuator['name']))
    result = cursor.fetchone()
    
    on_up_value, off_down_value = determine_actuator_values(actuator)
    on_up_endpoint, off_down_endpoint = determine_actuator_endpoints(actuator)
    
    if result:
        actuator_id = result['id']
        # Update existing actuator
        update_sql = """
        UPDATE actuator
        SET type = %s,
            status_endpoint = %s,
            value_key = %s,
            on_up_value = %s,
            off_down_value = %s,
            on_up_endpoint = %s,
            off_down_endpoint = %s
        WHERE id = %s;
        """
        
        values = (
            actuator['type'],
            actuator['endpoints']['status'],
            actuator['state']['value_key'],
            on_up_value,
            off_down_value,
            on_up_endpoint,
            off_down_endpoint,
            actuator_id
        )
        
        cursor.execute(update_sql, values)
        logger.info(f"Updated existing actuator with ID: {actuator_id}")
        return actuator_id
    
    # If no existing actuator found, insert new one
    insert_sql = """
    INSERT INTO actuator (
        device_id, name, type, status_endpoint, value_key,
        on_up_value, off_down_value, on_up_endpoint, off_down_endpoint
    )
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
    """
    
    cursor.execute(insert_sql, (
        device_id,
        actuator['name'],
        actuator['type'],
        actuator['endpoints']['status'],
        actuator['state']['value_key'],
        on_up_value,
        off_down_value,
        on_up_endpoint,
        off_down_endpoint
    ))
    
    return cursor.lastrowid

def cleanup_old_components(cursor, device_id: int, current_sensors: Set[str], current_actuators: Set[str]):
    """Remove sensors and actuators that are no longer in the YAML file."""
    # Convert sets to lists and handle empty cases
    sensor_names = list(current_sensors) if current_sensors else ['']
    actuator_names = list(current_actuators) if current_actuators else ['']
    
    # For MySQL, we need to use IN with format strings
    # Create the placeholders for the IN clause
    sensor_placeholders = ', '.join(['%s'] * len(sensor_names))
    actuator_placeholders = ', '.join(['%s'] * len(actuator_names))
    
    # Remove old sensors
    if sensor_names:
        sensor_sql = f"DELETE FROM sensor WHERE device_id = %s AND name NOT IN ({sensor_placeholders})"
        cursor.execute(sensor_sql, [device_id] + sensor_names)
    else:
        cursor.execute("DELETE FROM sensor WHERE device_id = %s", (device_id,))
    
    # Remove old actuators
    if actuator_names:
        actuator_sql = f"DELETE FROM actuator WHERE device_id = %s AND name NOT IN ({actuator_placeholders})"
        cursor.execute(actuator_sql, [device_id] + actuator_names)
    else:
        cursor.execute("DELETE FROM actuator WHERE device_id = %s", (device_id,))


# Configure upload settings
UPLOAD_FOLDER = '/tmp/yaml-validator'
ALLOWED_EXTENSIONS = {'yaml', 'yml'}

# Ensure upload folder exists
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.post("/api/validate")
async def validate_yaml(file: UploadFile, background_tasks: BackgroundTasks):
    if not file.filename.endswith(('.yaml', '.yml')):
        raise HTTPException(status_code=400, detail="Invalid file type. Only YAML files are allowed")
    
    try:
        content = await file.read()
        yaml_content = content.decode('utf-8')
        
        # First validate the YAML
        config = yaml.safe_load(yaml_content)
        validate_yaml_config(config)  # Your existing validation function
        
        # If validation passes, schedule the database processing
        background_tasks.add_task(process_yaml_to_db, yaml_content)
        
        return JSONResponse({
            "success": True,
            "message": "Configuration is valid and scheduled for processing",
        })
        
    except yaml.YAMLError as e:
        return JSONResponse({
            "success": False,
            "error": f"Invalid YAML format: {str(e)}"
        }, status_code=400)
    except ValidationError as e:
        return JSONResponse({
            "success": False,
            "error": str(e)
        }, status_code=400)
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        return JSONResponse({
            "success": False,
            "error": "Internal server error"
        }, status_code=500)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=5001)
