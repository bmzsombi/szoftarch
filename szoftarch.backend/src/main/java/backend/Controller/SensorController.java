package backend.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import backend.Model.Sensor;
import backend.Service.SensorService;

@RestController
@RequestMapping("/sensor")
public class SensorController {
    
    @Autowired
    private SensorService sensorService;

    // Növény hozzáadása mint plant típus
    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public Sensor addSensorType(@RequestBody Sensor sensor) {
        return sensorService.addSensor(sensor);
    }
}
