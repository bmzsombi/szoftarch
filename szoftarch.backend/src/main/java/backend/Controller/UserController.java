package backend.Controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import backend.Model.Eszkoz;
import backend.Model.User;
import backend.Service.UserService;

@RestController
@RequestMapping("/users")
public class UserController {
    
    @Autowired
    private UserService userService;

    // User hozzáadása
    @PostMapping("/addType")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public User addUserType(@RequestBody User user) {
        return userService.addUser(user);
    }

    @GetMapping("/all")
    public List<User> getAllUser() {
        return userService.getAllUser();
    }

    @GetMapping("/find")
    public User getUserByName(@RequestParam String username) {
        return userService.findByName(username);
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
