package backend.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import backend.Model.Device;


public interface DeviceRepository extends JpaRepository<Device, Long>{
    
}
