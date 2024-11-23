#!/usr/bin/env python3

import yaml
import re
from typing import List, Dict, Union, Tuple

"""this file validates the yaml files before they are processed further"""


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

def validate_yaml_file(file_path: str) -> Tuple[bool, str]:
    """Validate a YAML file against the schema requirements."""
    try:
        with open(file_path, 'r') as file:
            config = yaml.safe_load(file)
        validate_yaml_config(config)
        return True, "Configuration is valid"
    except ValidationError as e:
        return False, str(e)
    except yaml.YAMLError as e:
        return False, f"YAML parsing error: {str(e)}"
    except Exception as e:
        return False, f"Unexpected error: {str(e)}"

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: python validator.py <config.yaml>")
        sys.exit(1)
    
    is_valid, message = validate_yaml_file(sys.argv[1])
    if is_valid:
        print("✅", message)
        sys.exit(0)
    else:
        print("❌", message)
        sys.exit(1)
