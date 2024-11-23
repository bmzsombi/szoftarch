package backend;

public class EntityStorage {
    private Users users = new Users();
    private Plants plants = new Plants();

    public EntityStorage() {}

    public EntityStorage(Users users, Plants plants) {
        this.users = users;
        this.plants = plants;
    }

    public Users getUsers() {
        return users;
    }

    public void setUsers(Users users) {
        this.users = users;
    }

    public Plants getPlants() {
        return plants;
    }

    public void setPlants(Plants plants) {
        this.plants = plants;
    }
}
