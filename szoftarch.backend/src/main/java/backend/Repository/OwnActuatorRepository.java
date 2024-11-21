package backend.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import backend.Model.OwnActuator;

public interface OwnActuatorRepository extends JpaRepository<OwnActuator, Long>{
    
}
