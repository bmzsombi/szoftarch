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
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import backend.DTO.OwnActuatorDTO;
import backend.Model.Device;
import backend.Model.OwnActuator;
import backend.Model.PlantInstance;
import backend.Service.DeviceService;
import backend.Service.OwnActuatorService;
import backend.Service.PlantInstanceService;

@RestController
@RequestMapping("/actuator")
public class OwnActuatorController {
    
    @Autowired
    private OwnActuatorService ownActuatorService;

    @Autowired
    private DeviceService deviceService;

    @Autowired
    private PlantInstanceService plantInstanceService;

        // OwnActuator hozzáadása egy meglévő PlantInstance-hoz
    @PostMapping("/addToPlantInstance/{plantInstanceId}/{ownActuatorId}")
    public ResponseEntity<String> addOwnActuatorToPlantInstance(
        @PathVariable Long plantInstanceId,
        @PathVariable Long ownActuatorId
    ) {
        // A PlantInstance és OwnActuator lekérése az ID alapján
        PlantInstance plantInstance = plantInstanceService.getPlantInstanceById(plantInstanceId);
        OwnActuator ownActuator = ownActuatorService.getOwnActuatorById(ownActuatorId);

        // Ha bármelyik objektum nem található, akkor hibát dobunk
        if (plantInstance == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("PlantInstance not found");
        }
        if (ownActuator == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("OwnActuator not found");
        }

        // Hozzáadjuk az OwnActuator-t a PlantInstance-hoz
        plantInstance.getOwnActuators().add(ownActuator);
        ownActuator.setPlantInstance(plantInstance);  // Az OwnActuator-hoz is beállítjuk a kapcsolatot

        // Mentés
        plantInstanceService.savePlantInstance(plantInstance);

        return ResponseEntity.status(HttpStatus.OK).body("OwnActuator successfully added to PlantInstance");
    }

    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public OwnActuator addActuatorType(@RequestBody OwnActuatorDTO actuatorDTO) {

        // A Device entitás betöltése az ID alapján
        Device device = deviceService.findById(actuatorDTO.getDeviceId());

        PlantInstance plantInstance = plantInstanceService.findById(actuatorDTO.getPlantInstanceId())
        .orElseThrow(() -> new RuntimeException("PlantInstance not found with id: " + actuatorDTO.getPlantInstanceId()));
        
        // Új OwnActuator objektum létrehozása és kitöltése
        OwnActuator actuator = new OwnActuator();
        actuator.setDevice(device);  // Beállítjuk a Device-ot
        actuator.setName(actuatorDTO.getName());  // Beállítjuk a nevet
        actuator.setType(OwnActuator.ActuatorType.valueOf(actuatorDTO.getType()));  // Beállítjuk a típust
        actuator.setStatusEndpoint(actuatorDTO.getStatusEndpoint());
        actuator.setValueKey(actuatorDTO.getValueKey());
        actuator.setOnUpValue(actuatorDTO.getOnUpValue());
        actuator.setOffDownValue(actuatorDTO.getOffDownValue());
        actuator.setOnUpEndpoint(actuatorDTO.getOnUpEndpoint());
        actuator.setOffDownEndpoint(actuatorDTO.getOffDownEndpoint());
        actuator.setPlantInstance(plantInstance);
        // Az objektum mentése
        return ownActuatorService.addActuator(actuator);
    }


    @GetMapping("/all")
    public List<OwnActuator> getActuators() {
        return ownActuatorService.getAllActuators();
    }

    @DeleteMapping("/delete/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)  // A státuszkód '204 No Content' lesz, ha sikeres a törlés
    public void deletePlant(@PathVariable Long id) {
        ownActuatorService.deleteOwnActuator(id);
    }
}

