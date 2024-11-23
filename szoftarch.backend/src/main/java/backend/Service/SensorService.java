package backend.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
}
