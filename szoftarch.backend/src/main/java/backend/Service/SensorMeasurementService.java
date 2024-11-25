package backend.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import backend.Model.Sensor;
import backend.Model.SensorMeasurement;
import backend.Repository.SensorMeasurementRepository;
import backend.Repository.SensorRepository;

@Service
public class SensorMeasurementService {
    

    @Autowired
    private SensorMeasurementRepository sensorMeasurementRepository;

    @Autowired
    private SensorRepository sensorRepository; 

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

    public List<SensorMeasurement> getTop5SensorMeasurements(Long sensorId) {
        Sensor sensor = sensorRepository.findById(sensorId)
                .orElseThrow(() -> new RuntimeException("Sensor not found"));
        return sensorMeasurementRepository.findTop5BySensorOrderByTimestampDesc(sensor);
    }

}

