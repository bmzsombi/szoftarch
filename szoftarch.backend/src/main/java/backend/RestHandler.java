package backend;

import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api")
public class RestHandler
{
    EntityStorage storage = new EntityStorage();

    @PostMapping("/plants")
    public void addPlant(@RequestBody Plant plant){
        /* itt majd hozzaadja a db-hez */
        storage.getPlants().addPlant(plant);
    }

    @GetMapping("/plants")
    public Plants getPlant(){
        return storage.getPlants();
    }

    @PostMapping("/users")
    public void addUser(@RequestBody User user){
        storage.getUsers().addUser(user);
    }

    @GetMapping("/users")
    public Users getUser() {
        return storage.getUsers();
    }
}
