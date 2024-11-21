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
@Table(name = "sensor")
public class Sensor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY) // Kapcsolat az Eszkoz táblával
    @JoinColumn(name = "eszkoz_id", nullable = false) // Az idegen kulcs neve
    private Eszkoz eszkoz;

    private String name;
    private String mertekegyseg;
    private String tipus;
    private Float minValue;
    private Float maxValue;
    private String endpoint;
    private String valueCode; 
    private Integer samplingRate;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMertekegyseg() {
        return mertekegyseg;
    }

    public void setMertekegyseg(String mertekegyseg) {
        this.mertekegyseg = mertekegyseg;
    }

    public String getTipus() {
        return tipus;
    }

    public void setTipus(String tipus) {
        this.tipus = tipus;
    }

    public Float getMinValue() {
        return minValue;
    }

    public void setMinValue(Float minValue) {
        this.minValue = minValue;
    }

    public Float getMaxValue() {
        return maxValue;
    }

    public void setMaxValue(Float maxValue) {
        this.maxValue = maxValue;
    }

    public String getEndpoint() {
        return endpoint;
    }

    public void setEndpoint(String endpoint) {
        this.endpoint = endpoint;
    }

    public String getValueCode() {
        return valueCode;
    }

    public void setValueCode(String valueCode) {
        this.valueCode = valueCode;
    }

    public Integer getSamplingRate() {
        return samplingRate;
    }

    public void setSamplingRate(Integer samplingRate) {
        this.samplingRate = samplingRate;
    }

    // Üres konstruktor a Hibernate-hez
    public Sensor() {}

    // Paraméteres konstruktor
    public Sensor(Eszkoz eszkoz, String name, String mertekegyseg, String tipus,
                  Float minValue, Float maxValue, String endpoint, 
                  String valueCode, Integer samplingRate) {
        this.eszkoz = eszkoz;
        this.name = name;
        this.mertekegyseg = mertekegyseg;
        this.tipus = tipus;
        this.minValue = minValue;
        this.maxValue = maxValue;
        this.endpoint = endpoint;
        this.valueCode = valueCode;
        this.samplingRate = samplingRate;
    }
}
