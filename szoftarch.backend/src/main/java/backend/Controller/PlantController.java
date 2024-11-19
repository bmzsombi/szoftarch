package backend.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import backend.Plant;
import backend.Service.PlantService;

@RestController
@RequestMapping("/plants")
public class PlantController {

    @Autowired
    private PlantService plantService;

    // Növény hozzáadása
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public Plant addPlant(@RequestBody Plant plant) {
        return plantService.addPlant(plant);
    }
}