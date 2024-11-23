package backend.Model;

import java.time.LocalDateTime;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;

@Entity
public class DeviceInstance {

    public DeviceInstance() {}

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "device_id", nullable = false)
    @JsonIgnore
    private Device device;

    private String name;
    private String location;

    @Column(name = "user_id")
    private String userId;

    @Column(name = "installation_date")
    private LocalDateTime installationDate = LocalDateTime.now();

    @OneToMany(mappedBy = "instance", cascade = CascadeType.ALL)
    private List<SensorMeasurement> sensorMeasurements;

    @OneToMany(mappedBy = "instance", cascade = CascadeType.ALL)
    private List<ActuatorStateHistory> actuatorStateHistories;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Device getDevice() {
        return device;
    }

    public Long getDeviceId(){ 
        return device.getId();
    }

    public void setDevice(Device device) {
        this.device = device;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public LocalDateTime getInstallationDate() {
        return installationDate;
    }

    public void setInstallationDate(LocalDateTime installationDate) {
        this.installationDate = installationDate;
    }

    public List<SensorMeasurement> getSensorMeasurements() {
        return sensorMeasurements;
    }

    public void setSensorMeasurements(List<SensorMeasurement> sensorMeasurements) {
        this.sensorMeasurements = sensorMeasurements;
    }

    public List<ActuatorStateHistory> getActuatorStateHistories() {
        return actuatorStateHistories;
    }

    public void setActuatorStateHistories(List<ActuatorStateHistory> actuatorStateHistories) {
        this.actuatorStateHistories = actuatorStateHistories;
    }
    
}
