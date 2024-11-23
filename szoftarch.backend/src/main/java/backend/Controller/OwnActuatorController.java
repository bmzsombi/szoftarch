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

import backend.Model.OwnActuator;
import backend.Service.OwnActuatorService;

@RestController
@RequestMapping("/actuator")
public class OwnActuatorController {
    
    @Autowired
    private OwnActuatorService ownActuatorService;

    // Növény hozzáadása mint plant típus
    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public OwnActuator addSensorType(@RequestBody OwnActuator actuator) {
        return ownActuatorService.addActuator(actuator);
    }

    @GetMapping("/all")
    public List<OwnActuator> getActuators() {
        return ownActuatorService.getAllActuators();
    }
}

