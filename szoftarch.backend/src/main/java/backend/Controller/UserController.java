package backend.Controller;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import backend.DTO.PlantInstanceDTO;
import backend.DTO.UserDTO;
import backend.Model.PlantInstance;
import backend.Model.User;
import backend.Service.PlantInstanceService;
import backend.Service.UserService;

@RestController
@RequestMapping("/users")
public class UserController {
    
    @Autowired
    private UserService userService;

    @Autowired
    private PlantInstanceService plantInstanceService;
    

    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)
    public User addUserType(@RequestBody UserDTO userDTO) {
        // DTO-ból User entitás létrehozása
        User user = new User();
        user.setUsername(userDTO.getUsername());
        user.setPassword(userDTO.getPassword());
        user.setEmail(userDTO.getEmail());
        user.setRole(userDTO.getRole());
        user.setManufacturer_id(userDTO.getManufacturerId());
    
        // Az alapértelmezett lista már üres, nem kell explicit inicializálni
        return userService.addUser(user);
    }

    @PostMapping("/{username}/addPlantInstance/{plantInstanceId}")
    @ResponseStatus(HttpStatus.OK)  // 200 OK státuszkód a frissítéshez
    public PlantInstance addExistingPlantInstanceToUser(
        @PathVariable String username,
        @PathVariable Long plantInstanceId) {
    
        // A metódus a service rétegen keresztül végzi el a hozzárendelést
        return plantInstanceService.addExistingPlantInstanceToUser(username, plantInstanceId);
    }
    



    @GetMapping("/all")
    public List<User> getAllUser() {
        return userService.getAllUser();
    }

    @GetMapping("/find")
    public User getUserByName(@RequestParam String username) {
        return userService.findByName(username);
    }

    @DeleteMapping("/delete/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)  // A státuszkód '204 No Content' lesz, ha sikeres a törlés
    public void deletePlant(@PathVariable Long id) {
        userService.deleteUser(id);
    }

    // Feltételezem nektek frontend oldalróól ez lesz a hasznosab
    // User hozzáadása
    @PostMapping("/add")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public User addUser(@RequestParam String username, @RequestParam String password, @RequestParam String email,
            @RequestParam String role, @RequestParam Integer manufacturer_id) {
        User user = new User(username, password, email, role, manufacturer_id);
        
        
        return userService.addUser(user);
    }

    @PostMapping("/loginFull")
    public User loginFull(@RequestBody User loginRequest) {
        Optional<User> user = userService.login(loginRequest.getUsername(), loginRequest.getPassword());
        return user.orElseThrow(() -> new RuntimeException("Invalid username or password"));
    }

    @PostMapping("/login")
    public ResponseEntity<Boolean> login(@RequestBody User loginRequest) {
        boolean isAuthenticated = userService.isAuthenticated(loginRequest.getUsername(), loginRequest.getPassword());
        return ResponseEntity.ok(isAuthenticated);
    }

}
