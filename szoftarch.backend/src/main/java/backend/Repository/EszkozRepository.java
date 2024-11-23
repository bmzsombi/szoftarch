package backend.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import backend.Model.Eszkoz;


public interface EszkozRepository extends JpaRepository<Eszkoz, Long>{
    
}
