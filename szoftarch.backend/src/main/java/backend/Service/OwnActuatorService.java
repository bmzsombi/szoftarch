package backend.Service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.Model.DeviceInstance;
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

    public List<OwnActuator> getAllActuators() {
        return ownActuatorRepository.findAll();
    }

    public OwnActuator findById(Long actuatorId) {
        Optional<OwnActuator> actuatorOpt = ownActuatorRepository.findById(actuatorId);
        if (actuatorOpt.isPresent()) {
            return actuatorOpt.get();  // Visszaadja a találatot, ha létezik
        } else {
            throw new RuntimeException("DeviceInstance not found with id: " + actuatorId); // Vagy dobj egy megfelelő kivételt
        }
    }
}
