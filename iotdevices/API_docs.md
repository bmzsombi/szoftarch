# YAML Configuration Validator API Documentation

## Overview
This API service validates and processes YAML configuration files for IoT devices, sensors, and actuators. The validated configurations are stored in a MySQL database for further use.

## Port
The API listens on port 5001.

## Endpoint

### POST `/api/validate`
Validates a YAML configuration file and processes it for database storage.

#### Request
- **Method**: POST
- **Content-Type**: multipart/form-data
- **Parameter**: 
  - `file`: YAML file upload (*.yaml, *.yml)

#### Response
- **Success Response (200)**:
  ```json
  {
    "success": true,
    "message": "Configuration is valid and scheduled for processing"
  }
  ```
- **Error Response (400)**:
  ```json
  {
    "success": false,
    "error": "<error message>"
  }
  ```
  
# Device Instance Manager API Documentation

## Overview
The Device Instance Manager API manages Docker container instances of IoT devices. It handles the creation, monitoring, and deletion of device instances, maintaining their data in a MySQL database and ensuring proper networking configuration.

## Port
The API listens on port 5002.

## Endpoints

### POST `/api/instances`
Creates and starts a new device instance.

#### Request
- **Method**: POST
- **Content-Type**: application/json
- **Body**:
  ```json
  {
    "device_id": <integer>,
    "location": <string>,
    "user": <string>,
    "name": <string>
  }
  ```

#### Response
- **Success (201)**:
  ```json
  {
    "instance_id": <integer>,
    "message": "Instance started successfully"
  }
  ```
- **Error (400/500)**:
  ```json
  {
    "error": "<error message>"
  }
  ```

### DELETE `/api/instances/{instance_id}`
Stops and removes a device instance.

#### Request
- **Method**: DELETE
- **URL Parameter**: instance_id (integer)

#### Response
- **Success (200)**:
  ```json
  {
    "message": "Instance {instance_id} stopped successfully"
  }
  ```
- **Error (404/500)**:
  ```json
  {
    "error": "<error message>"
  }
  ```

# Actuator Control API Documentation

## Overview
The Actuator Control API provides an interface for controlling IoT device actuators using CoAP (Constrained Application Protocol). It manages communication between clients and device instances, handling command translation and state management.

## Port
The API listens on port 5003.

## Endpoint

### PUT `/api/instances/{instance_id}/actuators/{actuator_id}`
Controls a specific actuator on a device instance.

#### Request
- **Method**: PUT
- **Content-Type**: application/json
- **URL Parameters**:
  - `instance_id` (integer): Device instance identifier
  - `actuator_id` (integer): Actuator identifier
- **Body**:
  ```json
  {
    "action": <boolean | string>
  }
  ```
  Accepted action values:
  - Boolean: `true`, `false`
  - Strings: `"on"`, `"off"`, `"up"`, `"down"`

#### Response
- **Success (200)**:
  ```json
  {
    "status": "success",
    "instance_id": <integer>,
    "actuator_id": <integer>,
    "action": <original_action_value>,
    "result": <device_response_object>
  }
  ```
- **Error Responses**:
  - 400: Invalid action value
  - 404: Actuator or instance not found
  - 500: Internal server error
  - 502: Device communication error

  
