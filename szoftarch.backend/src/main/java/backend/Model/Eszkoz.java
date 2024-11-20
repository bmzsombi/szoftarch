package backend.Model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table (name = "eszkoz") 
public class Eszkoz {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String manufacturer;
    private String model;
    private String firmware;

    public Eszkoz() {}

    public Eszkoz(String manufacturer, String model, String firmware)
    {
        this.manufacturer = manufacturer;
        this.model = model;
        this.firmware = firmware;
    }
    
}
