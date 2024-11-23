package backend.Model;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class ActuatorStateHistory {

    public ActuatorStateHistory() {}

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "instance_id", nullable = false)
    @JsonIgnore
    private DeviceInstance instance;

    // innen szedi a nvevét
    @ManyToOne
    @JoinColumn(name = "actuator_id", nullable = false)
    @JsonIgnore
    private OwnActuator actuator;

    @Column(nullable = false)
    private Boolean state;

    @Column(name = "changed_at", nullable = false)
    private LocalDateTime changedAt = LocalDateTime.now();

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public DeviceInstance getInstance() {
        return instance;
    }

    public void setInstance(DeviceInstance instance) {
        this.instance = instance;
    }

    public OwnActuator getActuator() {
        return actuator;
    }

    public void setActuator(OwnActuator actuator) {
        this.actuator = actuator;
    }

    public Boolean getState() {
        return state;
    }

    public void setState(Boolean state) {
        this.state = state;
    }

    public LocalDateTime getChangedAt() {
        return changedAt;
    }

    public void setChangedAt(LocalDateTime changedAt) {
        this.changedAt = changedAt;
    }
    
}
