package backend.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import backend.Model.Device;
import backend.Service.DeviceService;

import java.util.List;

@RestController
@RequestMapping("/device")
public class DeviceController {
 
    @Autowired
    private DeviceService deviceService;

    @GetMapping("/all")
    public List<Device> getAllDevice() {
        return deviceService.getAllDevice();
    }

    // Növény hozzáadása mint plant típus
    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public Device adddeviceType(@RequestBody Device device) {
        return deviceService.addDevice(device);
    }

    @DeleteMapping("/delete/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)  // A státuszkód '204 No Content' lesz, ha sikeres a törlés
    public void deletePlant(@PathVariable Long id) {
        deviceService.deleteDevice(id);
    }
    
}
