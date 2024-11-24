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

import backend.DTO.SensorMeasurementDTO;
import backend.Model.DeviceInstance;
import backend.Model.Sensor;
import backend.Model.SensorMeasurement;
import backend.Service.DeviceInstanceService;
import backend.Service.SensorMeasurementService;
import backend.Service.SensorService;

@RestController
@RequestMapping("/sensorMeasurement")
public class SensorMeasurementController {

    @Autowired
    private SensorMeasurementService sensorMeasurementService;

    @Autowired
    private DeviceInstanceService deviceInstanceService;

    @Autowired
    private SensorService sensorService;

    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED) // A státuszkód '201 Created' lesz
    public SensorMeasurement addSensorMeasurementType(@RequestBody SensorMeasurementDTO sensorMeasurementDTO) {
        DeviceInstance instance = deviceInstanceService.findById(sensorMeasurementDTO.getInstanceId());
        Sensor sensor = sensorService.findById(sensorMeasurementDTO.getSensorId());
        
        SensorMeasurement sensorMeasurement = new SensorMeasurement();
        sensorMeasurement.setInstance(instance);
        sensorMeasurement.setSensor(sensor);
        sensorMeasurement.setValue(sensorMeasurementDTO.getValue());
        sensorMeasurement.setTimestamp(sensorMeasurementDTO.getTimestamp());
        
        return sensorMeasurementService.addSensorMeasurement(sensorMeasurement);
    }

    // Minden növény lekérése
    @GetMapping("/all")
    public List<SensorMeasurement> getAllSensorMeasurement() {
        return sensorMeasurementService.getAllSensorMeasurement();
    }

    @DeleteMapping("/delete/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)  // A státuszkód '204 No Content' lesz, ha sikeres a törlés
    public void deletePlant(@PathVariable Long id) {
        sensorMeasurementService.deleteSensorMeasurement(id);
    }
}
