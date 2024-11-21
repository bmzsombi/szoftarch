package backend.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import backend.Model.Sensor;

public interface SensorRepository extends JpaRepository<Sensor, Long>{
    
}
