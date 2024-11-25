package backend.DTO;


public class UserDTO {

    private String username;
    private String password;
    private String email;
    private String role;

    public UserDTO(String username2, String password2, String email2, String role2) {
        username = username2;
        password = password2;
        email = email2;
        role = role2;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }


}
