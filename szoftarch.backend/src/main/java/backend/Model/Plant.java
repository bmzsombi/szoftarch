package backend.Model;

import com.fasterxml.jackson.annotation.JsonProperty;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "plants")
public class Plant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @JsonProperty
    private String  scientificName, common_name, category;
    @JsonProperty 
    private Integer max_light, min_light, max_env_humid, min_env_humid, max_soil_moist, min_soil_moist, max_temp, min_temp;

    //Getterek setterek
    public String getScientificName() {
        return scientificName;
    }

    public void setScientificName(String scientific_name) {
        this.scientificName = scientific_name;
    }

    public String getCommon_name() {
        return common_name;
    }

    public void setCommon_name(String common_name) {
        this.common_name = common_name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
    
    public Integer getMax_light() {
        return max_light;
    }

    public void setMax_light(Integer max_light) {
        this.max_light = max_light;
    }

    public Integer getMin_light() {
        return min_light;
    }

    public void setMin_light(Integer min_light) {
        this.min_light = min_light;
    }

    public Integer getMax_env_humid() {
        return max_env_humid;
    }

    public void setMax_env_humid(Integer max_env_humid) {
        this.max_env_humid = max_env_humid;
    }

    public Integer getMin_env_humid() {
        return min_env_humid;
    }

    public void setMin_env_humid(Integer min_env_humid) {
        this.min_env_humid = min_env_humid;
    }

    public Integer getMax_soil_moist() {
        return max_soil_moist;
    }

    public void setMax_soil_moist(Integer max_soil_moist) {
        this.max_soil_moist = max_soil_moist;
    }

    public Integer getMin_soil_moist() {
        return min_soil_moist;
    }

    public void setMin_soil_moist(Integer min_soil_moist) {
        this.min_soil_moist = min_soil_moist;
    }

    public Integer getMax_temp() {
        return max_temp;
    }

    public void setMax_temp(Integer max_temp) {
        this.max_temp = max_temp;
    }

    public Integer getMin_temp() {
        return min_temp;
    }

    public void setMin_temp(Integer min_temp) {
        this.min_temp = min_temp;
    }

    public Plant() {}

    public Plant(String scientific_name2, String common_name2, String category2, Integer max_light2, Integer min_light2,
            Integer max_env_humid2, Integer min_env_humid2, Integer max_soil_moist2, Integer min_soil_moist2,
            Integer max_temp2, Integer min_temp2) {
        this.scientificName = scientific_name2;
        this.common_name = common_name2;
        this.category = category2;
        this.max_light = max_light2;
        this.min_light = min_light2;
        this.max_env_humid = max_env_humid2;
        this.min_env_humid = min_env_humid2;
        this.max_soil_moist = max_soil_moist2;
        this.min_soil_moist = min_soil_moist2;
        this.max_temp = max_temp2;
        this.min_temp = min_temp2;

    }

}
