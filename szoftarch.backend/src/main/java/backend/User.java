package backend;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.awt.*;

public class User {
    @JsonProperty
    private String name;
    @JsonProperty
    private String password;
    @JsonProperty
    private String email;
    @JsonProperty
    private UserRole role;

    public User(){}

    public User(String name, String email, UserRole role) {
        this.name = name;
        this.email = email;
        this.role = role;
    }
}
