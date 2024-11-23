package backend.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.Model.Plant;
import backend.Repository.PlantRepository;

@Service
public class PlantService {

    @Autowired
    private PlantRepository plantRepository;

    // Növény hozzáadása
    public Plant addPlant(Plant plant) {
        return plantRepository.save(plant); // A save() automatikusan elvégzi a mentést az adatbázisba
    }
}

