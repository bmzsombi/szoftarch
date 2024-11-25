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

import backend.DTO.DeviceInstanceDTO;
import backend.Model.ActuatorStateHistory;
import backend.Model.Device;
import backend.Model.DeviceInstance;
import backend.Model.OwnActuator;
import backend.Model.Sensor;
import backend.Model.SensorMeasurement;
import backend.Repository.DeviceInstanceRepository;
import backend.Service.DeviceInstanceService;
import backend.Service.DeviceService;

@RestController
@RequestMapping("/deviceInstance")
public class DeviceInstanceController {
    

    @Autowired
    private DeviceInstanceService deviceInstanceService;


    @Autowired
    private DeviceService deviceService;

    @Autowired
    private DeviceInstanceRepository deviceInstanceRepository;

    @GetMapping("/{deviceInstanceId}/sensorsMeasurement")
    public ResponseEntity<List<SensorMeasurement>> getSensorMeasurementByDeviceInstanceId(@PathVariable Long deviceInstanceId) {
        // Keresd meg a DeviceInstance-t az id alapján
        DeviceInstance deviceInstance = deviceInstanceRepository.findById(deviceInstanceId)
                .orElseThrow(() -> new RuntimeException("DeviceInstance not found"));
        
        // Vedd ki a DeviceInstance-hoz tartozó szenzorokat (SensorMeasurements)
        List<SensorMeasurement> sensorMeasurements = deviceInstance.getSensorMeasurements();
        
        // Ha vannak szenzorok, add vissza őket, egyébként üres listát
        if (sensorMeasurements != null && !sensorMeasurements.isEmpty()) {
            return ResponseEntity.ok(sensorMeasurements);
        } else {
            return ResponseEntity.noContent().build(); // Ha nincs szenzor, üres választ adunk
        }
    }

    @GetMapping("/{deviceInstanceId}/actuatorStateHistory")
    public ResponseEntity<List<ActuatorStateHistory>> getActuatorStateHistoryByDeviceInstanceId(@PathVariable Long deviceInstanceId) {
        // Keresd meg a DeviceInstance-t az id alapján
        DeviceInstance deviceInstance = deviceInstanceRepository.findById(deviceInstanceId)
                .orElseThrow(() -> new RuntimeException("DeviceInstance not found"));
        
        // Vedd ki a DeviceInstance-hoz tartozó szenzorokat (SensorMeasurements)
        List<ActuatorStateHistory> actuatorStateHistories = deviceInstance.getActuatorStateHistories();
        
        // Ha vannak szenzorok, add vissza őket, egyébként üres listát
        if (actuatorStateHistories != null && !actuatorStateHistories.isEmpty()) {
            return ResponseEntity.ok(actuatorStateHistories);
        } else {
            return ResponseEntity.noContent().build(); // Ha nincs szenzor, üres választ adunk
        }
    }

    @GetMapping("/{deviceInstanceId}/sensors")
    public ResponseEntity<List<Sensor>> getSensorByDeviceInstanceId(@PathVariable Long deviceInstanceId) {
        // Keresd meg a DeviceInstance-t az id alapján
        DeviceInstance deviceInstance = deviceInstanceRepository.findById(deviceInstanceId)
                .orElseThrow(() -> new RuntimeException("DeviceInstance not found"));
        
        // Vedd ki a DeviceInstance-hoz tartozó szenzorokat (SensorMeasurements)
        List<Sensor> actuatorStateHistories = deviceInstance.getDevice().getSensors();
        
        // Ha vannak szenzorok, add vissza őket, egyébként üres listát
        if (actuatorStateHistories != null && !actuatorStateHistories.isEmpty()) {
            return ResponseEntity.ok(actuatorStateHistories);
        } else {
            return ResponseEntity.noContent().build(); // Ha nincs szenzor, üres választ adunk
        }
    }

    @GetMapping("/{deviceInstanceId}/actuators")
    public ResponseEntity<List<OwnActuator>> getActuatorsByDeviceInstanceId(@PathVariable Long deviceInstanceId) {
        // Keresd meg a DeviceInstance-t az id alapján
        DeviceInstance deviceInstance = deviceInstanceRepository.findById(deviceInstanceId)
                .orElseThrow(() -> new RuntimeException("DeviceInstance not found"));
        
        // Vedd ki a DeviceInstance-hoz tartozó szenzorokat (SensorMeasurements)
        List<OwnActuator> actuatorStateHistories = deviceInstance.getDevice().getActuators();
        
        // Ha vannak szenzorok, add vissza őket, egyébként üres listát
        if (actuatorStateHistories != null && !actuatorStateHistories.isEmpty()) {
            return ResponseEntity.ok(actuatorStateHistories);
        } else {
            return ResponseEntity.noContent().build(); // Ha nincs szenzor, üres választ adunk
        }
    }

    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public DeviceInstance addDeviceInstance(@RequestBody DeviceInstanceDTO deviceInstanceDTO) {

        // A Device entitás betöltése az ID alapján
        Device device = deviceService.findById(deviceInstanceDTO.getDeviceId());
        
        // Új DeviceInstance objektum létrehozása és kitöltése
        DeviceInstance deviceInstance = new DeviceInstance();
        deviceInstance.setDevice(device);  // Beállítjuk a kapcsolódó Device-ot
        deviceInstance.setName(deviceInstanceDTO.getName());  // Beállítjuk a nevet
        deviceInstance.setLocation(deviceInstanceDTO.getLocation());  // Beállítjuk a helyet
        deviceInstance.setUsername(deviceInstanceDTO.getUsername());  // Beállítjuk a felhasználónevet
        deviceInstance.setInstallationDate(deviceInstanceDTO.getInstallationDate());  // Beállítjuk a telepítési dátumot
        
        // Az objektum mentése
        return deviceInstanceService.addDeviceInstance(deviceInstance);
    }


    @GetMapping("/all")
    public List<DeviceInstance> getAllDeviceInstance() {
        return deviceInstanceService.getAllDeviceInstance();
    }

    @DeleteMapping("/delete/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)  // A státuszkód '204 No Content' lesz, ha sikeres a törlés
    public void deletePlant(@PathVariable Long id) {
        deviceInstanceService.deleteDeviceInstance(id);
    }
}
