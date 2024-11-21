package backend.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.Model.Eszkoz;
import backend.Repository.EszkozRepository;

import java.util.List;

@Service
public class EszkozService {
    
    @Autowired
    private EszkozRepository eszkozRepository;

    // Növény hozzáadása
    public Eszkoz addEszkoz(Eszkoz eszkoz) {
        return eszkozRepository.save(eszkoz); // A save() automatikusan elvégzi a mentést az adatbázisba
    }

    public List<Eszkoz> getAllEszkoz() {
        return eszkozRepository.findAll();
    }
    
}
