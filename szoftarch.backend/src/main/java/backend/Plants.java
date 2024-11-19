package backend;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class Plants {
    @JsonProperty
    private List<Plant> plants = new ArrayList<Plant>();

    public void addPlant(Plant p) {
        plants.add(p);
    }

    public List<Plant> getPlants() {
        return plants;
    }

    public void removePlant(Plant p) {
        plants.remove(p);
    }

    public Plant getPlant(int i) {
        return plants.get(i);
    }
}
