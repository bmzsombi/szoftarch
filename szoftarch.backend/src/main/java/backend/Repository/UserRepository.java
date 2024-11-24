package backend.Repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import backend.Model.User;

public interface UserRepository extends JpaRepository<User, Long>  {

    User findByUsername(String username);
    Optional<User> findByUsernameAndPassword(String username, String password);
    boolean existsByUsername(String username);
    
}
