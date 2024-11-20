package backend;

import org.springframework.web.bind.annotation.*;

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

    @GetMapping("/plants/{id}")
    public Plant getPlant(@PathVariable int id){
        return storage.getPlants().getPlant(id);
    }

    @PostMapping("/users")
    public void addUser(@RequestBody User user){
        System.out.println(user.getUsername());
        storage.getUsers().addUser(user);
    }

    @GetMapping("/users")
    public Users getUser() {
        return storage.getUsers();
    }
}
