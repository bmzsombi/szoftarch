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

import backend.DTO.SensorDTO;
import backend.Model.Device;
import backend.Model.PlantInstance;
import backend.Model.Sensor;
import backend.Service.DeviceService;
import backend.Service.PlantInstanceService;
import backend.Service.SensorService;

@RestController
@RequestMapping("/sensor")
public class SensorController {
    
    @Autowired
    private SensorService sensorService;

    @Autowired
    private DeviceService deviceService;

    @Autowired
    private PlantInstanceService plantInstanceService;

    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public Sensor addSensorType(@RequestBody SensorDTO sensorDTO) {

        // A Device entitás betöltése az ID alapján
        Device device = deviceService.findById(sensorDTO.getDeviceId());

        // A PlantInstance entitás betöltése az ID alapján
        PlantInstance plantInstance = plantInstanceService.findById(sensorDTO.getPlantInstanceId())
        .orElseThrow(() -> new RuntimeException("PlantInstance not found with id: " + sensorDTO.getPlantInstanceId()));

        // Új Sensor objektum létrehozása és kitöltése
        Sensor sensor = new Sensor();
        sensor.setDevice(device);  // Beállítjuk a kapcsolódó Device-ot
        sensor.setName(sensorDTO.getName());  // Beállítjuk a szenzor nevét
        sensor.setSensorType(sensorDTO.getSensorType());  // Beállítjuk a szenzor típusát
        sensor.setUnit(sensorDTO.getUnit());  // Beállítjuk az egységet
        sensor.setDataType(Sensor.DataType.valueOf(sensorDTO.getDataType()));  // Beállítjuk az adat típusát
        sensor.setMinValue(sensorDTO.getMinValue());  // Beállítjuk a minimális értéket
        sensor.setMaxValue(sensorDTO.getMaxValue());  // Beállítjuk a maximális értéket
        sensor.setReadEndpoint(sensorDTO.getReadEndpoint());  // Beállítjuk az olvasási végpontot
        sensor.setValueKey(sensorDTO.getValueKey());  // Beállítjuk az érték kulcsot
        sensor.setSamplingInterval(sensorDTO.getSamplingInterval());  // Beállítjuk a mintavételi intervallumot
        sensor.setPlantInstance(plantInstance);  // Hozzárendeljük a PlantInstance objektumot

        // Az objektum mentése
        return sensorService.addSensor(sensor);
    }

    @GetMapping("/all")
    public List<Sensor> getAllSensors() {
        return sensorService.getAllSensors();
    }

    @GetMapping("/getById/{id}")
    public Sensor getById(@PathVariable Long id) {
        return sensorService.getById(id).orElseThrow(() -> new RuntimeException("Sensor not found with id: " + id));
    }

    @DeleteMapping("/delete/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)  // A státuszkód '204 No Content' lesz, ha sikeres a törlés
    public void deletePlant(@PathVariable Long id) {
        sensorService.deleteSensor(id);
    }
}
