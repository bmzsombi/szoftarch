package backend.Service;

import java.util.List;
import java.util.Optional;

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
        if (userRepository.existsByUsername(user.getUsername())) {
            throw new IllegalArgumentException("User with this name already exists");
        }
        return userRepository.save(user); // A save() automatikusan elvégzi a mentést az adatbázisba
    }

    public User findByName(String username){
        return userRepository.findByUsername(username);
    }

    public List<User> getAllUser() {
        return userRepository.findAll();
    }

    public Optional<User> login(String username, String password) {
        return userRepository.findByUsernameAndPassword(username, password);
    }

    public boolean isAuthenticated(String username, String password) {
        return userRepository.findByUsernameAndPassword(username, password).isPresent();
    }
}
