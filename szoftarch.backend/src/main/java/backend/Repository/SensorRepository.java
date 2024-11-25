package backend.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import backend.Model.Sensor;
import backend.Model.SensorMeasurement;

public interface SensorRepository extends JpaRepository<Sensor, Long>{
    
}
