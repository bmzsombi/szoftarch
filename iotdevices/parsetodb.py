#!/usr/bin/env python3

import yaml
import psycopg2
from typing import Dict, Any, Optional, Set
import sys
import logging
from datetime import datetime

# Database configuration
DB_CONFIG = {
    'dbname': 'plantmonitor',
    'user': 'postgres',
    'password': '',
    'host': 'localhost',
    'port': '5432'
}

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def get_db_connection():
    """Create and return a database connection."""
    try:
        return psycopg2.connect(**DB_CONFIG)
    except psycopg2.Error as e:
        logger.error(f"Failed to connect to database: {e}")
        sys.exit(1)

def get_or_insert_device(cursor, device_info: Dict[str, Any], network: Optional[Dict[str, Any]]) -> int:
    """Get existing device ID or insert new device and return the ID."""
    find_sql = """
    SELECT id FROM devices
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
        device_id = result[0]
        # Update existing device
        update_sql = """
        UPDATE devices
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
    INSERT INTO devices (manufacturer, model, firmware_version, description, port, discovery_enabled)
    VALUES (%s, %s, %s, %s, %s, %s)
    RETURNING id;
    """
    
    port = network.get('default_port', 5683) if network else 5683
    discovery_enabled = network.get('discovery_enabled', True) if network else True
    
    values = (
        device_info['manufacturer'],
        device_info['model'],
        device_info['firmware_version'],
        device_info.get('description'),
        port,
        discovery_enabled
    )
    
    cursor.execute(insert_sql, values)
    device_id = cursor.fetchone()[0]
    logger.info(f"Inserted new device with ID: {device_id}")
    return device_id

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
        SELECT id FROM sensors
        WHERE device_id = %s AND name = %s;
        """
        
        cursor.execute(find_sql, (device_id, sensor['name']))
        result = cursor.fetchone()
        
        if result:
            sensor_id = result[0]
            update_sql = """
            UPDATE sensors
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
        INSERT INTO sensors (
            device_id, name, sensor_type, unit, data_type,
            min_value, max_value, read_endpoint, value_key, sampling_interval
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        RETURNING id;
        """
        
        values = (
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
        )
        
        cursor.execute(insert_sql, values)
        sensor_id = cursor.fetchone()[0]
        logger.info(f"Inserted new sensor {sensor['name']} with endpoint: {read_endpoint}")
        return sensor_id
        
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
        SELECT id FROM actuators
        WHERE device_id = %s AND name = %s;
        """
        
        cursor.execute(find_sql, (device_id, actuator['name']))
        result = cursor.fetchone()
        
        if result:
            actuator_id = result[0]
            update_sql = """
            UPDATE actuators
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
        INSERT INTO actuators (
            device_id, name, type, status_endpoint, value_key,
            on_up_value, off_down_value, on_up_endpoint, off_down_endpoint
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        RETURNING id;
        """
        
        values = (
            device_id,
            actuator['name'],
            actuator['type'],
            status_endpoint,
            value_key,
            on_up_value,
            off_down_value,
            on_up_endpoint,
            off_down_endpoint
        )
        
        cursor.execute(insert_sql, values)
        actuator_id = cursor.fetchone()[0]
        logger.info(f"Inserted actuator {actuator['name']} with normalized endpoints")
        return actuator_id
        
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
    SELECT id FROM actuators
    WHERE device_id = %s AND name = %s;
    """
    
    cursor.execute(find_sql, (device_id, actuator['name']))
    result = cursor.fetchone()
    
    on_up_value, off_down_value = determine_actuator_values(actuator)
    on_up_endpoint, off_down_endpoint = determine_actuator_endpoints(actuator)
    
    if result:
        actuator_id = result[0]
        # Update existing actuator
        update_sql = """
        UPDATE actuators
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
    INSERT INTO actuators (
        device_id, name, type, status_endpoint, value_key,
        on_up_value, off_down_value, on_up_endpoint, off_down_endpoint
    )
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    RETURNING id;
    """
    
    values = (
        device_id,
        actuator['name'],
        actuator['type'],
        actuator['endpoints']['status'],
        actuator['state']['value_key'],
        on_up_value,
        off_down_value,
        on_up_endpoint,
        off_down_endpoint
    )
    
    cursor.execute(insert_sql, values)
    actuator_id = cursor.fetchone()[0]
    logger.info(f"Inserted new actuator with ID: {actuator_id}")
    return actuator_id

def cleanup_old_components(cursor, device_id: int, current_sensors: Set[str], current_actuators: Set[str]):
    """Remove sensors and actuators that are no longer in the YAML file."""
    # Remove old sensors
    cursor.execute(
        "DELETE FROM sensors WHERE device_id = %s AND name NOT IN %s",
        (device_id, tuple(current_sensors) if current_sensors else ('',))
    )
    
    # Remove old actuators
    cursor.execute(
        "DELETE FROM actuators WHERE device_id = %s AND name NOT IN %s",
        (device_id, tuple(current_actuators) if current_actuators else ('',))
    )

def process_yaml_file(yaml_path: str):
    """Process the YAML file and insert/update data in the database."""
    try:
        with open(yaml_path, 'r') as file:
            config = yaml.safe_load(file)
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
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
            
            # Clean up old components that are no longer in the YAML
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
        logger.error(f"Failed to process YAML file: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python yaml_to_db.py <config.yaml>")
        sys.exit(1)
    
    process_yaml_file(sys.argv[1])
