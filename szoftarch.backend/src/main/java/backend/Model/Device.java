package backend.Model;

import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table (name = "device") 
public class Device {

    public Device() {}

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String manufacturer;

    @Column(nullable = false)
    private String model;

    @Column(nullable = false, name = "firmware_version")
    private String firmwareVersion;

    private String description;

    @Column(nullable = false)
    private Integer port = 5683;

    @Column(nullable = false, name = "discovery_enabled")
    private Boolean discoveryEnabled = true;

    @OneToMany(mappedBy = "device", cascade = CascadeType.ALL)
    private List<Sensor> sensors;

    @OneToMany(mappedBy = "device", cascade = CascadeType.ALL)
    private List<OwnActuator> actuators;

    @OneToMany(mappedBy = "device", cascade = CascadeType.ALL)
    private List<DeviceInstance> deviceInstances;

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getFirmwareVersion() {
        return firmwareVersion;
    }

    public void setFirmwareVersion(String firmwareVersion) {
        this.firmwareVersion = firmwareVersion;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getPort() {
        return port;
    }

    public void setPort(Integer port) {
        this.port = port;
    }

    public Boolean getDiscoveryEnabled() {
        return discoveryEnabled;
    }

    public void setDiscoveryEnabled(Boolean discoveryEnabled) {
        this.discoveryEnabled = discoveryEnabled;
    }

    public List<Sensor> getSensors() {
        return sensors;
    }

    public void setSensors(List<Sensor> sensors) {
        this.sensors = sensors;
    }

    public List<OwnActuator> getActuators() {
        return actuators;
    }

    public void setActuators(List<OwnActuator> actuators) {
        this.actuators = actuators;
    }

    public List<DeviceInstance> getDeviceInstances() {
        return deviceInstances;
    }

    public void setDeviceInstances(List<DeviceInstance> deviceInstances) {
        this.deviceInstances = deviceInstances;
    }


    
}
