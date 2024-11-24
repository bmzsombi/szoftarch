package backend.Service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.Model.Plant;
import backend.Model.User;
import backend.Repository.PlantRepository;
import backend.Repository.UserRepository;

@Service
public class UserService {
    
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PlantRepository plantRepository;

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

    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    public User addPlantToUser(Long userId, Long plantId) {
        // Felhasználó lekérése az ID alapján
        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("User not found"));

        // Növény lekérése az ID alapján
        Plant plant = plantRepository.findById(plantId).orElseThrow(() -> new RuntimeException("Plant not found"));

        // A növény hozzáadása a felhasználóhoz
        user.getPlants().add(plant);

        // Felhasználó mentése
        userRepository.save(user);

        return user;
    }
}
