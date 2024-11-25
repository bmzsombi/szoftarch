package backend.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import backend.Model.PlantInstance;
import backend.Model.SensorMeasurement;

public interface PlantInstanceRepository extends JpaRepository<PlantInstance, Long> {
    
    @Query("SELECT sm FROM SensorMeasurement sm " +
           "WHERE sm.instance.device.id IN " +
           "(SELECT di.device.id FROM DeviceInstance di WHERE di.device.id = :deviceId)")
    List<SensorMeasurement> findSensorMeasurementsByDeviceId(@Param("deviceId") Long deviceId);


}

