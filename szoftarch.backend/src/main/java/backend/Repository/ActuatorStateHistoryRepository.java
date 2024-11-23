package backend.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import backend.Model.ActuatorStateHistory;


public interface ActuatorStateHistoryRepository extends JpaRepository<ActuatorStateHistory, Long>{
    
}
