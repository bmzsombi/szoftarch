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

    // Növény hozzáadása mint plant típus
    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)
    public DeviceInstance addInstanceServiceType(@RequestBody DeviceInstance deviceInstance) {
        Device device = deviceService.getDeviceById(deviceInstance.getId());
        
        deviceInstance.setDevice(device);
        //System.out.println("\n Mi az id: " + deviceInstance.getDevice().getId());
        
        return deviceInstanceService.addDeviceInstanceRepository(deviceInstance);
    }

    @GetMapping("/all")
    public List<DeviceInstance> getAllDeviceInstance() {
        return deviceInstanceService.getAllDeviceInstance();
    }
}
