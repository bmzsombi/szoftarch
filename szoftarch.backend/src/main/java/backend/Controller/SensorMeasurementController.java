package backend.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import backend.Model.SensorMeasurement;
import backend.Service.SensorMeasurementService;

@RestController
@RequestMapping("/sensorMeasurement")
public class SensorMeasurementController {

    @Autowired
    private SensorMeasurementService sensorMeasurementService;

    // Növény hozzáadása mint plant típus
    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public SensorMeasurement addSensorMeasurementType(@RequestBody SensorMeasurement sensorMeasurement) {
        return sensorMeasurementService.addSensorMeasurement(sensorMeasurement);
    }
}
