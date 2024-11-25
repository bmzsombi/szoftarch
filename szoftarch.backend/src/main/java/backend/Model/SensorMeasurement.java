package backend.Model;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonProperty;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class SensorMeasurement {

    public SensorMeasurement() {}

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "instance_id", nullable = false)
    @JsonBackReference  
    private DeviceInstance instance;

    @ManyToOne
    @JoinColumn(name = "sensor_id", nullable = false)
    @JsonBackReference 
    private Sensor sensor;

    @Column(nullable = false)
    private Float value;

    @Column(nullable = false)
    private LocalDateTime timestamp = LocalDateTime.now();

    // Ez kell?
    @JsonProperty("sensorId")  // A JSON-ban megjelenő mező neve
    public Long getSensorId() {
        return sensor != null ? sensor.getId() : null;  // Az érzékelő id-ja
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public DeviceInstance getInstance() {
        return instance;
    }

    public void setInstance(DeviceInstance instance) {
        this.instance = instance;
    }

    public Sensor getSensor() {
        return sensor;
    }

    public void setSensor(Sensor sensor) {
        this.sensor = sensor;
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
    
}
