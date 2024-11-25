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
import backend.Model.DeviceInstance;
import backend.Model.PlantInstance;
import backend.Model.SensorMeasurement;
import backend.Repository.DeviceInstanceRepository;
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
    private DeviceInstanceRepository deviceInstanceRepository;

    @GetMapping("/{plantInstanceId}/deviceInstance")
    public ResponseEntity<DeviceInstance> getDeviceInstance(@PathVariable Long plantInstanceId) {
        DeviceInstance deviceInstance = plantInstanceService.getDeviceInstanceByPlantInstanceId(plantInstanceId);
        if (deviceInstance != null) {
            return ResponseEntity.ok(deviceInstance);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping("/addDevice")
    public ResponseEntity<PlantInstance> addDeviceToPlantInstance(@RequestBody PlantInstanceDTO dto) {
        // Ellenőrizd, hogy létezik a PlantInstance az id alapján
        PlantInstance plantInstance = plantInstanceRepository.findById(dto.getPlantInstanceId())
            .orElseThrow(() -> new RuntimeException("PlantInstance not found"));
    
        // Ellenőrizd, hogy létezik a Device az id alapján
        DeviceInstance device = deviceInstanceRepository.findById(dto.getDeviceInstanceId())
            .orElseThrow(() -> new RuntimeException("Device not found"));
    
        // Állítsd be a Device-t a PlantInstance-hoz
        plantInstance.setDeviceInstance(device);
    
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