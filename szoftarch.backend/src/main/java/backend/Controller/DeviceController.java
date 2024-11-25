package backend.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import backend.DTO.DeviceDTO;
import backend.Model.Device;
import backend.Repository.DeviceRepository;
import backend.Service.DeviceService;

import java.util.List;

@RestController
@RequestMapping("/device")
public class DeviceController {
 
    @Autowired
    private DeviceService deviceService;

    @Autowired
    private DeviceRepository deviceRepository;

    @GetMapping("/all")
    public List<Device> getAllDevice() {
        return deviceService.getAllDevice();
    }

    // Növény hozzáadása mint plant típus
    @PostMapping("/add")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public Device adddeviceType(@RequestBody Device device) {
        return deviceService.addDevice(device);
    }

    @PostMapping("/addType")
    public ResponseEntity<Device> addDevice(@RequestBody DeviceDTO deviceDTO) {
        Device device = new Device();
        device.setManufacturer(deviceDTO.getManufacturer());
        device.setModel(deviceDTO.getModel());
        device.setFirmwareVersion(deviceDTO.getFirmwareVersion());
        device.setDescription(deviceDTO.getDescription());
        device.setPort(deviceDTO.getPort());
        device.setDiscoveryEnabled(deviceDTO.getDiscoveryEnabled());

        // Esetleg a kapcsolódó szenzorokat és aktorokat itt adhatsz hozzá
        deviceRepository.save(device);

        return ResponseEntity.status(HttpStatus.CREATED).body(device);
    }

    @DeleteMapping("/delete/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)  // A státuszkód '204 No Content' lesz, ha sikeres a törlés
    public void deletePlant(@PathVariable Long id) {
        deviceService.deleteDevice(id);
    }
    
}
