package backend.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import backend.Model.Plant;
import backend.Service.PlantService;

@RestController
@RequestMapping("/plants")
public class PlantController {

    @Autowired
    private PlantService plantService;

    // Növény hozzáadása mint plant típus
    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public Plant addPlantType(@RequestBody Plant plant) {
        return plantService.addPlant(plant);
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