package backend.Model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
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

    @ManyToOne
    @JoinColumn(name = "device_id", nullable = false)
    private Device device;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private ActuatorType type;

    @Column(nullable = false, name = "status_endpoint")
    private String statusEndpoint;

    @Column(nullable = false, name = "value_key")
    private String valueKey;

    @Column(nullable = false, name = "on_up_key")
    private String onUpKey;

    @Column(nullable = false, name = "off_down_key")
    private String offDownKey;

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

    public String getOnUpKey() {
        return onUpKey;
    }

    public void setOnUpKey(String onUpKey) {
        this.onUpKey = onUpKey;
    }

    public String getOffDownKey() {
        return offDownKey;
    }

    public void setOffDownKey(String offDownKey) {
        this.offDownKey = offDownKey;
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
