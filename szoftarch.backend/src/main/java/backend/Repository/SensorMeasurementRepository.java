package backend.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import backend.Model.SensorMeasurement;

public interface SensorMeasurementRepository extends JpaRepository<SensorMeasurement, Long> {
    
}
