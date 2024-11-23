package backend.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import backend.Model.DeviceInstance;
import backend.Service.DeviceInstanceService;

@RestController
@RequestMapping("/deviceInstance")
public class DeviceInstanceController {
    

    @Autowired
    private DeviceInstanceService deviceInstanceService;

    // Növény hozzáadása mint plant típus
    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public DeviceInstance addInstanceServiceType(@RequestBody DeviceInstance deviceInstance) {
        return deviceInstanceService.addDeviceInstanceRepository(deviceInstance);
    }
}
