package backend.Model;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonManagedReference;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "plant_instances")
public class PlantInstance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    @JsonBackReference
    private User user; // Melyik felhasználóhoz tartozik

    @ManyToOne
    @JoinColumn(name = "plant_id", nullable = false)
    private Plant plant; // Melyik növénytípus

    @OneToOne
    @JoinColumn(name = "device_instance_id", referencedColumnName = "id", nullable = true)
    private DeviceInstance deviceInstance; // A PlantInstance-hez rendelt eszköz


    /*@OneToMany(mappedBy = "plantInstance", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Sensor> sensors = new ArrayList<>(); // A növényhez tartozó szenzorok

    
    @OneToMany(mappedBy = "plantInstance", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonBackReference
    private List<OwnActuator> ownActuators = new ArrayList<>(); // A növényhez tartozó aktorok*/
     

    public DeviceInstance getDeviceInstance() {
        return deviceInstance;
    }

    public void setDeviceInstance(DeviceInstance deviceInstance) {
        this.deviceInstance = deviceInstance;
    }

    private String nickname;

    /*public List<Sensor> getSensors() {
        return sensors;
    }

    public void setSensors(List<Sensor> sensors) {
        this.sensors = sensors;
    }

    public List<OwnActuator> getOwnActuators() {
        return ownActuators;
    }

    public void setOwnActuators(List<OwnActuator> ownActuators) {
        this.ownActuators = ownActuators;
    }*/

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }



    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Plant getPlant() {
        return plant;
    }

    public void setPlant(Plant plant) {
        this.plant = plant;
    }

}