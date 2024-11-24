package backend.Service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.Model.DeviceInstance;
import backend.Repository.DeviceInstanceRepository;

@Service
public class DeviceInstanceService {

     @Autowired
    private DeviceInstanceRepository deviceInstanceRepository;

    // Növény hozzáadása
    public DeviceInstance addDeviceInstance(DeviceInstance deviceInstanceService) {
        return deviceInstanceRepository.save(deviceInstanceService); // A save() automatikusan elvégzi a mentést az adatbázisba
    }

    public List<DeviceInstance> getAllDeviceInstance() {
        return deviceInstanceRepository.findAll();
    }

    public DeviceInstance findById(Long instanceId) {
        Optional<DeviceInstance> instanceOpt = deviceInstanceRepository.findById(instanceId);
        if (instanceOpt.isPresent()) {
            return instanceOpt.get();  // Visszaadja a találatot, ha létezik
        } else {
            throw new RuntimeException("DeviceInstance not found with id: " + instanceId); // Vagy dobj egy megfelelő kivételt
        }
    }

    public void deleteDeviceInstance(Long id) {
        deviceInstanceRepository.deleteById(id);
    }
    
}
