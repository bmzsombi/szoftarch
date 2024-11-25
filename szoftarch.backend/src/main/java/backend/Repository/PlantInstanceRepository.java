package backend.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import backend.Model.PlantInstance;

public interface PlantInstanceRepository extends JpaRepository<PlantInstance, Long> {
    
}
