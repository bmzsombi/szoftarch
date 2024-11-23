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
    public Device addEszkoz(Device eszkoz) {
        return eszkozRepository.save(eszkoz);
    }

    public List<Device> getAllEszkoz() {
        return eszkozRepository.findAll();
    }
    
}
