package backend.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import backend.Model.Plant;
import backend.Service.PlantService;

@RestController
@RequestMapping("/plants")
public class PlantController {

    @Autowired
    private PlantService plantService;

    @GetMapping("/all")
    public List<Plant> getAllPlants() {
        return plantService.getAllPlants();
    }

    // Növény hozzáadása mint plant típus
    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public Plant addPlantType(@RequestBody Plant plant) {
        return plantService.addPlant(plant);
    }

    // Növény törlése ID alapján
    @DeleteMapping("/delete/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)  // A státuszkód '204 No Content' lesz, ha sikeres a törlés
    public void deletePlant(@PathVariable Long id) {
        plantService.deletePlant(id);
    }

    // Növény törlése scientific_name alapján
    @DeleteMapping("/deleteByName/{scientificName}")
    @ResponseStatus(HttpStatus.NO_CONTENT)  // A státuszkód '204 No Content' lesz, ha sikeres a törlés
    public void deletePlantByScientificName(@PathVariable String scientificName) {
        plantService.deletePlantByScientificName(scientificName);
    }


    // Feltételezem nektek frontend oldalróól ez lesz a hasznosabb
    @PostMapping("/add")
    @ResponseStatus(HttpStatus.CREATED) // A státuszkód '201 Created' lesz
    public Plant addPlant(@RequestParam String scientific_name, @RequestParam String common_name, @RequestParam String category, @RequestParam Integer max_light,
        @RequestParam Integer min_light, @RequestParam Integer max_env_humid, @RequestParam Integer min_env_humid, @RequestParam Integer max_soil_moist,
        @RequestParam Integer min_soil_moist,@RequestParam Integer max_temp, @RequestParam Integer min_temp) {
       
            Plant plant = new Plant(
            scientific_name,
            common_name,
            category,
            max_light,
            min_light,
            max_env_humid,
            min_env_humid,
            max_soil_moist,
            min_soil_moist,
            max_temp,
            min_temp
        );
        // Plant hozzáadása az adatbázishoz
        return plantService.addPlant(plant);
    }
}