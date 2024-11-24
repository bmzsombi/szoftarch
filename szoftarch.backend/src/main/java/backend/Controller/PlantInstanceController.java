package backend.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import backend.DTO.PlantInstanceDTO;
import backend.Model.PlantInstance;
import backend.Model.Sensor;
import backend.Service.PlantInstanceService;

@RestController
@RequestMapping("/plantInstances")
public class PlantInstanceController {

    @Autowired
    private PlantInstanceService plantInstanceService;

    // adja vissza a sensorokat
    @GetMapping("/{plantInstanceId}/sensors")
    public List<Sensor> getSensorsByPlantInstanceId(@PathVariable Long plantInstanceId) {
        // PlantInstance keresése ID alapján
        PlantInstance plantInstance = plantInstanceService.getById(plantInstanceId)
                .orElseThrow(() -> new RuntimeException("PlantInstance not found with id: " + plantInstanceId));

        // Visszaadjuk a PlantInstance-hoz tartozó szenzorok listáját
        return plantInstance.getSensors();  // A PlantInstance-ban lévő sensorokat adjuk vissza
    }

    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)
    public PlantInstance createPlantInstance(@RequestBody PlantInstanceDTO plantInstanceDTO) {
        return plantInstanceService.createPlantInstanceFromDTO(plantInstanceDTO);
    }

        // Összes PlantInstance lekérése
    @GetMapping("/all")
    public List<PlantInstance> getAllPlantInstances() {
        return plantInstanceService.getAllPlantInstances();
    }

    // Egy konkrét PlantInstance lekérése id alapján
    @GetMapping("/getById/{id}")
    public PlantInstance getPlantInstanceById(@PathVariable Long id) {
        return plantInstanceService.getPlantInstanceById(id);
    }

    // http://localhost:5000/plantInstances/2/add/1
    @PostMapping("/{userId}/add/{plantId}")
    @ResponseStatus(HttpStatus.CREATED)
    public PlantInstance addPlantInstanceToUser(@PathVariable Long userId, @PathVariable Long plantId) {
        return plantInstanceService.addPlantInstanceToUser(userId, plantId);
    }

    // http://localhost:5000/plantInstances/dude/add/1
    @PostMapping("/{username}/addByName/{plantId}")
    @ResponseStatus(HttpStatus.CREATED)
    public PlantInstance addPlantInstanceToUserByName(@PathVariable String username, @PathVariable Long plantId) {
        return plantInstanceService.addPlantInstanceToUserByName(username, plantId);
    }

    // adja vissza a sensorokat
}