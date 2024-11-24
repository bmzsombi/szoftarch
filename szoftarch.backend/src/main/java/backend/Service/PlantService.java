package backend.Service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.Model.Plant;
import backend.Model.User;
import backend.Repository.PlantRepository;

@Service
public class PlantService {

    @Autowired
    private PlantRepository plantRepository;

    // Növény hozzáadása
    public Plant addPlant(Plant plant) {
        return plantRepository.save(plant); // A save() automatikusan elvégzi a mentést az adatbázisba
    }

    public List<Plant> getAllPlants() { 
        return plantRepository.findAll();
    }

    public void deletePlant(Long id) {
        plantRepository.deleteById(id);

    }

    public void deletePlantByScientificName(String scientificName) {
           Plant plant = plantRepository.findByScientificName(scientificName);
        if (plant != null) {
            plantRepository.delete(plant);
        }
    }

    public Optional<Plant> findById(Long id) {
       return plantRepository.findById(id);
    }

}

