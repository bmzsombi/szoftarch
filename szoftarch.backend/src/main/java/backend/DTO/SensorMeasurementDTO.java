package backend.DTO;

import java.time.LocalDateTime;

public class SensorMeasurementDTO {

    private Long instanceId;
    private Long sensorId;
    private Float value;
    private LocalDateTime timestamp;
    public Long getInstanceId() {
        return instanceId;
    }
    public void setInstanceId(Long instanceId) {
        this.instanceId = instanceId;
    }
    public Long getSensorId() {
        return sensorId;
    }
    public void setSensorId(Long sensorId) {
        this.sensorId = sensorId;
    }
    public Float getValue() {
        return value;
    }
    public void setValue(Float value) {
        this.value = value;
    }
    public LocalDateTime getTimestamp() {
        return timestamp;
    }
    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    // Getters and Setters
}
