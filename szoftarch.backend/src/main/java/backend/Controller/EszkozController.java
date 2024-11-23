package backend.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import backend.Model.Eszkoz;
import backend.Service.EszkozService;

import java.util.List;

@RestController
@RequestMapping("/eszkoz")
public class EszkozController {
 
    @Autowired
    private EszkozService eszkozService;

    @GetMapping("/all")
    public List<Eszkoz> getAllEszkoz() {
        List<Eszkoz> eszkozList = eszkozService.getAllEszkoz();
        // Kiírja az összes eszközt a konzolra
        eszkozList.forEach(eszkoz -> System.out.println(eszkoz));
        return eszkozList;
    }

    // Növény hozzáadása mint plant típus
    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public Eszkoz addEszkozType(@RequestBody Eszkoz eszkoz) {
        return eszkozService.addEszkoz(eszkoz);
    }
    
}
