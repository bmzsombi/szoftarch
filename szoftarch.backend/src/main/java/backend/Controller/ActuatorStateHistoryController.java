package backend.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import backend.Model.ActuatorStateHistory;
import backend.Service.ActuatorStateHistoryService;

@RestController
@RequestMapping("/actuatorStateHistory")
public class ActuatorStateHistoryController {
    
    @Autowired
    private ActuatorStateHistoryService actuatorStateHistoryService;

    // Növény hozzáadása mint plant típus
    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public ActuatorStateHistory addInstanceServiceType(@RequestBody ActuatorStateHistory actuatorStateHistory) {
        return actuatorStateHistoryService.addActuatorStateHistory(actuatorStateHistory);
    }

}
