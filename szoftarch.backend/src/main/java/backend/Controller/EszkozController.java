package backend.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import backend.Model.Eszkoz;
import backend.Service.EszkozService;

@RestController
@RequestMapping("/eszkoz")
public class EszkozController {
 
    @Autowired
    private EszkozService eszkozService;

    // Növény hozzáadása mint plant típus
    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public Eszkoz addEszkozType(@RequestBody Eszkoz eszkoz) {
        return eszkozService.addEszkoz(eszkoz);
    }
    
}
