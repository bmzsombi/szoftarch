package backend.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.Model.Device;
import backend.Model.OwnActuator;
import backend.Repository.DeviceRepository;

import java.util.List;
import java.util.Optional;

@Service
public class DeviceService {
    
    @Autowired
    private DeviceRepository eszkozRepository;

    // Növény hozzáadása
    public Device addDevice(Device eszkoz) {
        return eszkozRepository.save(eszkoz);
    }


    public Device getDeviceById(Long deviceId) {
        // Ha nem találjuk az adott id-val rendelkező Device-ot, akkor egy kivételt dobunk
        return eszkozRepository.findById(deviceId)
            .orElseThrow(() -> new RuntimeException("Device not found with id " + deviceId));
    
    }

    public List<Device> getAllDevice() {
        return eszkozRepository.findAll();
    }


    public Device findById(Long deviceId) {
        Optional<Device> deviceOpt = eszkozRepository.findById(deviceId);
        if (deviceOpt.isPresent()) {
            return deviceOpt.get();  // Visszaadja a találatot, ha létezik
        } else {
            throw new RuntimeException("DeviceInstance not found with id: " + deviceId); // Vagy dobj egy megfelelő kivételt
        }
    }
    
}
