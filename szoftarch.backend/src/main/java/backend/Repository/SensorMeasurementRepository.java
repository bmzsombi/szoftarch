package backend.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import backend.Model.Sensor;
import backend.Model.SensorMeasurement;

public interface SensorMeasurementRepository extends JpaRepository<SensorMeasurement, Long> {
        List<SensorMeasurement> findBySensor(Sensor sensor);

        // Lekérdezés a SensorMeasurement-ek lekérésére Sensor ID alapján
        List<SensorMeasurement> findBySensor_IdIn(List<Long> sensorIds);

}

