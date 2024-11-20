package backend;

import com.fasterxml.jackson.annotation.JsonProperty;

import backend.Model.User;

import java.util.ArrayList;
import java.util.List;

public class Users {
    @JsonProperty
    private List<User> users = new ArrayList<User>();

    public Users() {}

    public Users(List<User> users) {
        this.users = users;
    }

    public void addUser(User user) {
        users.add(user);
    }

    public List<User> getUsers() {
        return users;
    }

    public void removeUser(User user) {
        users.remove(user);
    }
}
