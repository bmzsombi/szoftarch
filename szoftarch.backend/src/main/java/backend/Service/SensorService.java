package backend.Service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.Model.DeviceInstance;
import backend.Model.Sensor;
import backend.Repository.SensorRepository;

@Service
public class SensorService {
    
    @Autowired
    private SensorRepository sensorRepository;

    // Növény hozzáadása
    public Sensor addSensor(Sensor sensor) {
        return sensorRepository.save(sensor); // A save() automatikusan elvégzi a mentést az adatbázisba
    }

    public List<Sensor> getAllSensors() {
        return sensorRepository.findAll();
    }

    public Sensor findById(Long sensorId) {
        Optional<Sensor> sensorOpt = sensorRepository.findById(sensorId);
        if (sensorOpt.isPresent()) {
            return sensorOpt.get();  // Visszaadja a találatot, ha létezik
        } else {
            throw new RuntimeException("DeviceInstance not found with id: " + sensorId); // Vagy dobj egy megfelelő kivételt
        }
    }

    public void deleteSensor(Long id) {
        sensorRepository.deleteById(id);
    }

    public Optional<Sensor> getById(Long id) {
        return sensorRepository.findById(id);
    }
}
