package backend.Model;

import jakarta.persistence.Entity;
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

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY) // Kapcsolat az Eszkoz táblával
    @JoinColumn(name = "eszkoz_id", nullable = false) // Az idegen kulcs neve
    private Eszkoz eszkoz;

    //Ez notnull kéne, hogy legyen
    private String name;
    private String type, endpoint, value_code, on_endpoint, off_endpoint;

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getType() {
        return type;
    }
    public void setType(String type) {
        this.type = type;
    }
    public String getEndpoint() {
        return endpoint;
    }
    public void setEndpoint(String endpoint) {
        this.endpoint = endpoint;
    }
    public String getValue_code() {
        return value_code;
    }
    public void setValue_code(String value_code) {
        this.value_code = value_code;
    }
    public String getOn_endpoint() {
        return on_endpoint;
    }
    public void setOn_endpoint(String on_endpoint) {
        this.on_endpoint = on_endpoint;
    }
    public String getOff_endpoint() {
        return off_endpoint;
    }
    public void setOff_endpoint(String off_endpoint) {
        this.off_endpoint = off_endpoint;
    }
    public OwnActuator() {}
    public OwnActuator(Eszkoz eszkoz, String type, String endpoint, String value_code, String on_endpoint, String off_endpoint)
    {
        this.eszkoz = eszkoz;
        this.type = type;
        this.endpoint = endpoint;
        this.value_code = value_code;
        this.on_endpoint = on_endpoint;
        this.off_endpoint = off_endpoint;
    }


    
    
}
