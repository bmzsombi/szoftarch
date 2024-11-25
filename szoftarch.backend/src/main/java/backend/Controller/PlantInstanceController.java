package backend.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import backend.DTO.PlantInstanceDTO;
import backend.Model.Device;
import backend.Model.PlantInstance;
import backend.Model.SensorMeasurement;
import backend.Repository.DeviceRepository;
import backend.Repository.PlantInstanceRepository;
import backend.Service.PlantInstanceService;

@RestController
@RequestMapping("/plantInstances")
public class PlantInstanceController {
    
    @Autowired
    private PlantInstanceService plantInstanceService;

    @Autowired
    private PlantInstanceRepository plantInstanceRepository;

    @Autowired
    private DeviceRepository deviceRepository;

    // adja vissza a sensorokat
    /*@GetMapping("/{plantInstanceId}/sensors")
    public List<Sensor> getSensorsByPlantInstanceId(@PathVariable Long plantInstanceId) {
        // PlantInstance keresése ID alapján
        PlantInstance plantInstance = plantInstanceService.getById(plantInstanceId)
                .orElseThrow(() -> new RuntimeException("PlantInstance not found with id: " + plantInstanceId));

        // Visszaadjuk a PlantInstance-hoz tartozó szenzorok listáját
        return plantInstance.getSensors();  // A PlantInstance-ban lévő sensorokat adjuk vissza
    }*/

    /*@GetMapping("/{plantInstanceId}/actuators")
    public List<OwnActuator> getActuatorsByPlantInstanceId(@PathVariable Long plantInstanceId) {
        // PlantInstance keresése ID alapján
        PlantInstance plantInstance = plantInstanceService.getById(plantInstanceId)
                .orElseThrow(() -> new RuntimeException("PlantInstance not found with id: " + plantInstanceId));

        // Visszaadjuk a PlantInstance-hoz tartozó szenzorok listáját
        return plantInstance.getOwnActuators();  // A PlantInstance-ban lévő sensorokat adjuk vissza
    }*/

    @GetMapping("/{id}/sensorMeasurements")
    public ResponseEntity<List<SensorMeasurement>> getSensorMeasurements(@PathVariable Long id) {
        List<SensorMeasurement> sensorMeasurements = plantInstanceService.getSensorMeasurementsByPlantInstance(id);
        if (sensorMeasurements.isEmpty()) {
            return ResponseEntity.noContent().build(); // Ha nincsenek mérési adatok
        }
        return ResponseEntity.ok(sensorMeasurements);
    }

    @PostMapping("/addDevice")
    public ResponseEntity<PlantInstance> addDeviceToPlantInstance(@RequestBody PlantInstanceDTO dto) {
        // Ellenőrizd, hogy létezik a PlantInstance az id alapján
        PlantInstance plantInstance = plantInstanceRepository.findById(dto.getPlantInstanceId())
            .orElseThrow(() -> new RuntimeException("PlantInstance not found"));
    
        // Ellenőrizd, hogy létezik a Device az id alapján
        Device device = deviceRepository.findById(dto.getDeviceId())
            .orElseThrow(() -> new RuntimeException("Device not found"));
    
        // Állítsd be a Device-t a PlantInstance-hoz
        plantInstance.setDevice(device);
    
        // Mentsd el a módosított PlantInstance-t
        plantInstanceRepository.save(plantInstance);
    
        // Válasz a módosított PlantInstance-tel
        return ResponseEntity.ok(plantInstance);
    }
    
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)  // 204 No Content válasz státusz
    public void deletePlantInstance(@PathVariable Long id) {
        plantInstanceService.deletePlantInstanceById(id);
    }

    @PostMapping("/addTypeById")
    @ResponseStatus(HttpStatus.CREATED)
    public PlantInstance createPlantInstanceById(@RequestBody PlantInstanceDTO plantInstanceDTO) {
        return plantInstanceService.createPlantInstanceFromDTO(plantInstanceDTO);
    }

    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)
    public PlantInstance createPlantInstance(@RequestBody PlantInstanceDTO plantInstanceDTO) {
        return plantInstanceService.createPlantInstanceFromDTOByName(plantInstanceDTO);
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

}