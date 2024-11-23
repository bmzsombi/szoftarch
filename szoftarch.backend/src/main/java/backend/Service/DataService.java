package backend.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.Model.Data;
import backend.Repository.DataRepository;

@Service
public class DataService {
    
    @Autowired
    private DataRepository dataRepository;

    // Növény hozzáadása
    public Data addData(Data data) {
        return dataRepository.save(data); // A save() automatikusan elvégzi a mentést az adatbázisba
    }
}
