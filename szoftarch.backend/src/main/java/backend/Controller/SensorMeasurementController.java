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

import backend.Model.DeviceInstance;
import backend.Model.SensorMeasurement;
import backend.Repository.DeviceInstanceRepository;
import backend.Service.DeviceInstanceService;
import backend.Service.SensorMeasurementService;

@RestController
@RequestMapping("/sensorMeasurement")
public class SensorMeasurementController {

    @Autowired
    private SensorMeasurementService sensorMeasurementService;

    @Autowired
    private DeviceInstanceRepository deviceInstanceRepository;

    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED) // A státuszkód '201 Created' lesz
    public SensorMeasurement addSensorMeasurementType(@RequestBody SensorMeasurement sensorMeasurement) {

        DeviceInstance instance = deviceInstanceRepository.findById(sensorMeasurement.getInstance().getId())
            .orElseThrow(() -> new IllegalArgumentException("DeviceInstance not found with ID: " + sensorMeasurement.getInstance().getId()));

        sensorMeasurement.setInstance(instance);


        return sensorMeasurementService.addSensorMeasurement(sensorMeasurement);
    }


    // Minden növény lekérése
    @GetMapping("/all")
    public List<SensorMeasurement> getAllSensorMeasurement() {
        return sensorMeasurementService.getAllSensorMeasurement();
    }
}
