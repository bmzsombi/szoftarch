-- First ensure we're using the right database
\c plantmonitor;

-- Devices table
CREATE TABLE devices (
    id SERIAL PRIMARY KEY,
    manufacturer VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    firmware_version VARCHAR(255) NOT NULL,
    description TEXT,
    port INTEGER DEFAULT 5683,
    discovery_enabled BOOLEAN DEFAULT true
);

-- Sensors table
CREATE TABLE sensors (
    id SERIAL PRIMARY KEY,
    device_id INTEGER REFERENCES devices(id),
    name VARCHAR(255) NOT NULL,
    sensor_type VARCHAR(50),
    unit VARCHAR(50) NOT NULL,
    data_type VARCHAR(10) CHECK (data_type IN ('INTEGER', 'FLOAT')),
    min_value FLOAT,
    max_value FLOAT,
    read_endpoint VARCHAR(255) NOT NULL,
    value_key VARCHAR(255) NOT NULL,
    sampling_interval INTEGER
);

-- Actuator types enumeration
CREATE TYPE actuator_type AS ENUM ('PUMP', 'LIGHT', 'BLIND');

-- Actuators table
CREATE TABLE actuators (
    id SERIAL PRIMARY KEY,
    device_id INTEGER REFERENCES devices(id),
    name VARCHAR(255) NOT NULL,
    type actuator_type NOT NULL,
    status_endpoint VARCHAR(255) NOT NULL,
    value_key VARCHAR(255) NOT NULL,
    on_up_key VARCHAR(255) NOT NULL,
    off_down_key VARCHAR(255) NOT NULL,
    on_up_endpoint VARCHAR(255) NOT NULL,
    off_down_endpoint VARCHAR(255) NOT NULL
);

-- Device instances table
CREATE TABLE device_instances (
    id SERIAL PRIMARY KEY,
    device_id INTEGER REFERENCES devices(id),
    name VARCHAR(255),
    location VARCHAR(255),
    user_id VARCHAR(255),
    installation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sensor measurements table
CREATE TABLE sensor_measurements (
    id SERIAL PRIMARY KEY,
    instance_id INTEGER REFERENCES device_instances(id),
    sensor_id INTEGER REFERENCES sensors(id),
    value FLOAT NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Actuator state history table
CREATE TABLE actuator_state_history (
    id SERIAL PRIMARY KEY,
    instance_id INTEGER REFERENCES device_instances(id),
    actuator_id INTEGER REFERENCES actuators(id),
    state BOOLEAN NOT NULL,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Add appropriate indexes
CREATE INDEX idx_sensor_measurements_instance_id ON sensor_measurements(instance_id);
CREATE INDEX idx_sensor_measurements_timestamp ON sensor_measurements(timestamp);
CREATE INDEX idx_actuator_history_instance_id ON actuator_state_history(instance_id);
CREATE INDEX idx_actuator_history_timestamp ON actuator_state_history(changed_at);
CREATE INDEX idx_sensors_device_id ON sensors(device_id);
CREATE INDEX idx_actuators_device_id ON actuators(device_id);
