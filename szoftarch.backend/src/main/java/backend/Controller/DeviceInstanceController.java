package backend.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import backend.DTO.DeviceInstanceDTO;
import backend.Model.Device;
import backend.Model.DeviceInstance;
import backend.Service.DeviceInstanceService;
import backend.Service.DeviceService;

@RestController
@RequestMapping("/deviceInstance")
public class DeviceInstanceController {
    

    @Autowired
    private DeviceInstanceService deviceInstanceService;

    @Autowired
    private DeviceService deviceService;

    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public DeviceInstance addDeviceInstance(@RequestBody DeviceInstanceDTO deviceInstanceDTO) {

        // A Device entitás betöltése az ID alapján
        Device device = deviceService.findById(deviceInstanceDTO.getDeviceId());
        
        // Új DeviceInstance objektum létrehozása és kitöltése
        DeviceInstance deviceInstance = new DeviceInstance();
        deviceInstance.setDevice(device);  // Beállítjuk a kapcsolódó Device-ot
        deviceInstance.setName(deviceInstanceDTO.getName());  // Beállítjuk a nevet
        deviceInstance.setLocation(deviceInstanceDTO.getLocation());  // Beállítjuk a helyet
        deviceInstance.setUsername(deviceInstanceDTO.getUsername());  // Beállítjuk a felhasználónevet
        deviceInstance.setInstallationDate(deviceInstanceDTO.getInstallationDate());  // Beállítjuk a telepítési dátumot
        
        // Az objektum mentése
        return deviceInstanceService.addDeviceInstance(deviceInstance);
    }


    @GetMapping("/all")
    public List<DeviceInstance> getAllDeviceInstance() {
        return deviceInstanceService.getAllDeviceInstance();
    }
}
