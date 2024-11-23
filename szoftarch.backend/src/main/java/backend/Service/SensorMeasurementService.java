package backend.Service;

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
}

