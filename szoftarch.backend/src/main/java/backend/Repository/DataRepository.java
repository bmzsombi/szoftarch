package backend.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import backend.Model.Data;

public interface DataRepository extends JpaRepository<Data, Long> {
    
}
