package backend.Repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import backend.Model.PlantInstance;
import backend.Model.SensorMeasurement;

public interface PlantInstanceRepository extends JpaRepository<PlantInstance, Long> {
    

}

