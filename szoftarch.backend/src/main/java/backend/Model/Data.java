package backend.Model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table (name = "data")
public class Data {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    Integer eszkoz_id, sensor_actuator_id, time; //A time mi legyen?
    String type; //adatbázisban enum - szükséges?
    Float value;

    public Data() {}
    public Data(Integer eszkoz_id, Integer sensor_actuator_id, Integer time, String type, Float value)
    {
        this.eszkoz_id = eszkoz_id;
        this.sensor_actuator_id = sensor_actuator_id;
        this.time = time;
        this.type = type;
        this.value = value;

    }
}
