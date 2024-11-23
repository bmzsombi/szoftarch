package backend.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import backend.DTO.OwnActuatorDTO;
import backend.Model.Device;
import backend.Model.OwnActuator;
import backend.Service.DeviceService;
import backend.Service.OwnActuatorService;

@RestController
@RequestMapping("/actuator")
public class OwnActuatorController {
    
    @Autowired
    private OwnActuatorService ownActuatorService;

    @Autowired
    private DeviceService deviceService;

    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public OwnActuator addActuatorType(@RequestBody OwnActuatorDTO actuatorDTO) {

        // A Device entitás betöltése az ID alapján
        Device device = deviceService.findById(actuatorDTO.getDeviceId());
        
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
        
        // Az objektum mentése
        return ownActuatorService.addActuator(actuator);
    }


    @GetMapping("/all")
    public List<OwnActuator> getActuators() {
        return ownActuatorService.getAllActuators();
    }
}

