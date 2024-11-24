package backend.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.Model.SensorMeasurement;
import backend.Repository.SensorMeasurementRepository;

@Service
public class SensorMeasurementService {
    

    @Autowired
    private SensorMeasurementRepository sensorMeasurementRepository;

    // Növény hozzáadása
    public SensorMeasurement addSensorMeasurement(SensorMeasurement sensorMeasurement) {
        return sensorMeasurementRepository.save(sensorMeasurement); // A save() automatikusan elvégzi a mentést az adatbázisba
    }

    public List<SensorMeasurement> getAllSensorMeasurement() {
        return sensorMeasurementRepository.findAll();
    }

    public void deleteSensorMeasurement(Long id) {
        sensorMeasurementRepository.deleteById(id);
    }
}

