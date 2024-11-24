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
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import backend.DTO.ActuatorStateHistoryDTO;
import backend.Model.ActuatorStateHistory;
import backend.Model.DeviceInstance;
import backend.Model.OwnActuator;
import backend.Service.ActuatorStateHistoryService;
import backend.Service.DeviceInstanceService;
import backend.Service.OwnActuatorService;

@RestController
@RequestMapping("/actuatorStateHistory")
public class ActuatorStateHistoryController {
    
    @Autowired
    private ActuatorStateHistoryService actuatorStateHistoryService;

    @Autowired
    private DeviceInstanceService deviceInstanceService;

    @Autowired
    private OwnActuatorService ownActuatorService;

    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public ActuatorStateHistory addActuatorStateHistoryType(@RequestBody ActuatorStateHistoryDTO actuatorStateHistoryDTO) {

        // A DeviceInstance és OwnActuator entitások betöltése az ID-k alapján
        DeviceInstance instance = deviceInstanceService.findById(actuatorStateHistoryDTO.getInstanceId());
        OwnActuator actuator = ownActuatorService.findById(actuatorStateHistoryDTO.getActuatorId());
        
        // Új ActuatorStateHistory objektum létrehozása és kitöltése
        ActuatorStateHistory actuatorStateHistory = new ActuatorStateHistory();
        actuatorStateHistory.setInstance(instance);  // Beállítjuk a DeviceInstance-t
        actuatorStateHistory.setActuator(actuator);  // Beállítjuk az OwnActuator-t
        actuatorStateHistory.setState(actuatorStateHistoryDTO.getState());  // Beállítjuk a state-et
        actuatorStateHistory.setChangedAt(actuatorStateHistoryDTO.getChangedAt());  // Beállítjuk a changedAt értéket
        
        // Az objektum mentése
        return actuatorStateHistoryService.addActuatorStateHistory(actuatorStateHistory);
    }


    @GetMapping("/all")
    public List<ActuatorStateHistory> getAllActuatorStateHistory() {
        return actuatorStateHistoryService.getAllActuatorStateHistory();
    }

    @DeleteMapping("/delete/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)  // A státuszkód '204 No Content' lesz, ha sikeres a törlés
    public void deletePlant(@PathVariable Long id) {
        actuatorStateHistoryService.deleteActuatorStateHistory(id);
    }

}
