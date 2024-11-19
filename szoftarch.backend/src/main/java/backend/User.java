package backend;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.awt.*;

public class User {
    @JsonProperty
    private String username;
    @JsonProperty
    private String password;
    @JsonProperty
    private String email;
    @JsonProperty
    private UserRole role;

    public User(){}

    public User(String username, String email, UserRole role) {
        this.username = username;
        this.email = email;
        this.role = role;
    }

    public String getUsername() {
        return username;
    }
}
