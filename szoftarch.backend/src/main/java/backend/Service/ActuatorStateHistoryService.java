package backend.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.Model.ActuatorStateHistory;
import backend.Repository.ActuatorStateHistoryRepository;

@Service
public class ActuatorStateHistoryService {
    

    @Autowired
    private ActuatorStateHistoryRepository actuatorStateHistoryRepository;

    // Növény hozzáadása
    public ActuatorStateHistory addActuatorStateHistory(ActuatorStateHistory actuatorStateHistory) {
        return actuatorStateHistoryRepository.save(actuatorStateHistory); // A save() automatikusan elvégzi a mentést az adatbázisba
    }
}
