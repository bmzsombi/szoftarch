package backend.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.Model.OwnActuator;
import backend.Repository.OwnActuatorRepository;
@Service
public class OwnActuatorService {
 
    @Autowired
    private OwnActuatorRepository ownActuatorRepository;

    // Növény hozzáadása
    public OwnActuator addActuator(OwnActuator ownActuator) {
        return ownActuatorRepository.save(ownActuator); // A save() automatikusan elvégzi a mentést az adatbázisba
    }
}
