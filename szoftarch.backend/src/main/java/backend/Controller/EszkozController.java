package backend.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import backend.Model.Device;
import backend.Service.DeviceService;

import java.util.List;

@RestController
@RequestMapping("/eszkoz")
public class EszkozController {
 
    @Autowired
    private DeviceService eszkozService;

    @GetMapping("/all")
    public List<Device> getAllEszkoz() {
        List<Device> eszkozList = eszkozService.getAllEszkoz();
        // Kiírja az összes eszközt a konzolra
        eszkozList.forEach(eszkoz -> System.out.println(eszkoz));
        return eszkozList;
    }

    // Növény hozzáadása mint plant típus
    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public Device addEszkozType(@RequestBody Device eszkoz) {
        return eszkozService.addEszkoz(eszkoz);
    }
    
}
