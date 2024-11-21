package backend.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

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

    // Feltételezem nektek frontend oldalróól ez lesz a hasznosab
    // User hozzáadása
    @PostMapping("/add")
    @ResponseStatus(HttpStatus.CREATED)  // A státuszkód '201 Created' lesz
    public User addUser(@RequestParam String username, @RequestParam String password, @RequestParam String email,
            @RequestParam String role, @RequestParam Integer manufacturer_id) {
        User user = new User(username, password, email, role, manufacturer_id);
        
        
        return userService.addUser(user);
    }
}
