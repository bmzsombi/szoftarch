package backend.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import backend.Plant;

public interface PlantRepository extends JpaRepository<Plant, Long> {
    // Itt bármilyen egyedi lekérdezést hozzáadhatsz, ha szükséges
}