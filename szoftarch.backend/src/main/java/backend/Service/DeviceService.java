package backend.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.Model.Device;
import backend.Repository.DeviceRepository;

import java.util.List;

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
    
}
