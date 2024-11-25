package backend.Repository;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import backend.Model.Sensor;
import backend.Model.SensorMeasurement;

public interface SensorMeasurementRepository extends JpaRepository<SensorMeasurement, Long> {
        List<SensorMeasurement> findBySensor(Sensor sensor);

        @Query("SELECT sm FROM SensorMeasurement sm WHERE sm.sensor = :sensor ORDER BY sm.timestamp DESC")
        List<SensorMeasurement> findLastFiveBySensor(@Param("sensor") Sensor sensor, Pageable pageable);
}

