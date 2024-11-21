package backend.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.Model.User;
import backend.Repository.UserRepository;

@Service
public class UserService {
    
    @Autowired
    private UserRepository userRepository;

    // Növény hozzáadása
    public User addUser(User user) {
        return userRepository.save(user); // A save() automatikusan elvégzi a mentést az adatbázisba
    }
}
