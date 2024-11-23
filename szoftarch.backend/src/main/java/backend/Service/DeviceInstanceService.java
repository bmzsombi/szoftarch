package backend.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.Model.DeviceInstance;
import backend.Repository.DeviceInstanceRepository;

@Service
public class DeviceInstanceService {

     @Autowired
    private DeviceInstanceRepository deviceInstanceRepository;

    // Növény hozzáadása
    public DeviceInstance addDeviceInstanceRepository(DeviceInstance deviceInstanceService) {
        return deviceInstanceRepository.save(deviceInstanceService); // A save() automatikusan elvégzi a mentést az adatbázisba
    }

    public List<DeviceInstance> getAllDeviceInstance() {
        return deviceInstanceRepository.findAll();
    }
    
}
