package backend.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import backend.Model.DeviceInstance;

public interface DeviceInstanceRepository extends JpaRepository<DeviceInstance, Long> {
    
}
