package backend.Model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonManagedReference;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table (name = "actuator")
public class OwnActuator {

    public OwnActuator() {}

    public enum ActuatorType {
        PUMP, LIGHT, BLIND
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @ManyToOne
    @JoinColumn(name = "device_id", nullable = false)
    @JsonBackReference
    private Device device;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private ActuatorType type;

    @ManyToOne
    @JoinColumn(name = "plant_instance_id")  // A kapcsolódó PlantInstance
    @JsonBackReference
    private PlantInstance plantInstance;

    public PlantInstance getPlantInstance() {
        return plantInstance;
    }

    public void setPlantInstance(PlantInstance plantInstance) {
        this.plantInstance = plantInstance;
    }

    @Column(nullable = false, name = "status_endpoint")
    private String statusEndpoint;

    @Column(nullable = false, name = "value_key")
    private String valueKey;

    @Column(nullable = false, name = "on_up_value")
    private String onUpValue;

    @Column(nullable = false, name = "off_down_value")
    private String offDownValue;

    @Column(nullable = false, name = "on_up_endpoint")
    private String onUpEndpoint;

    @Column(nullable = false, name = "off_down_endpoint")
    private String offDownEndpoint;

    public Device getDevice() {
        return device;
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

    public ActuatorType getType() {
        return type;
    }

    public void setType(ActuatorType type) {
        this.type = type;
    }

    public String getStatusEndpoint() {
        return statusEndpoint;
    }

    public void setStatusEndpoint(String statusEndpoint) {
        this.statusEndpoint = statusEndpoint;
    }

    public String getValueKey() {
        return valueKey;
    }

    public void setValueKey(String valueKey) {
        this.valueKey = valueKey;
    }

    public String getOnUpValue() {
        return onUpValue;
    }

    public void setOnUpValue(String onUpKey) {
        this.onUpValue = onUpKey;
    }

    public String getOffDownValue() {
        return offDownValue;
    }

    public void setOffDownValue(String offDownKey) {
        this.offDownValue = offDownKey;
    }

    public String getOnUpEndpoint() {
        return onUpEndpoint;
    }

    public void setOnUpEndpoint(String onUpEndpoint) {
        this.onUpEndpoint = onUpEndpoint;
    }

    public String getOffDownEndpoint() {
        return offDownEndpoint;
    }

    public void setOffDownEndpoint(String offDownEndpoint) {
        this.offDownEndpoint = offDownEndpoint;
    }


}
