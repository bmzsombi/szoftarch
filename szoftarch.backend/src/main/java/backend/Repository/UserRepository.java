package backend.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import backend.Model.User;

public interface UserRepository extends JpaRepository<User, Long>  {
    
}
