package backend.Service;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;


import backend.DTO.PlantInstanceDTO;
import backend.Model.Device;
import backend.Model.Plant;
import backend.Model.PlantInstance;
import backend.Model.Sensor;
import backend.Model.SensorMeasurement;
import backend.Model.User;
import backend.Repository.DeviceRepository;
import backend.Repository.PlantInstanceRepository;
import backend.Repository.PlantRepository;
import backend.Repository.SensorMeasurementRepository;

import backend.Repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;

@Service
public class PlantInstanceService {

    @Autowired
    private PlantInstanceRepository plantInstanceRepository;

    @Autowired
    private PlantRepository plantRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DeviceRepository deviceRepository;

    @Autowired
    private SensorMeasurementRepository sensorMeasurementRepository;

    public List<SensorMeasurement> getSensorMeasurementsByPlantInstance(Long plantInstanceId) {
        // Először a PlantInstance alapján lekérjük a Device-ot
        Optional<PlantInstance> plantInstanceOpt = plantInstanceRepository.findById(plantInstanceId);
        if (plantInstanceOpt.isPresent()) {
            Device device = plantInstanceOpt.get().getDevice();
            
            // A Device-hez tartozó összes Sensor ID lekérése
            List<Long> sensorIds = device.getSensors().stream()
                                          .map(Sensor::getId)
                                          .collect(Collectors.toList());
            
            // A lekért Sensor ID-k alapján lekérjük a SensorMeasurement-eket
            return sensorMeasurementRepository.findBySensor_IdIn(sensorIds);
        }
        return Collections.emptyList(); // Ha a PlantInstance nem létezik
    }

    public PlantInstance addPlantInstanceToUser(Long userId, Long plantId) {
        // User és Plant ellenőrzése és betöltése
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));
        Plant plant = plantRepository.findById(plantId)
            .orElseThrow(() -> new RuntimeException("Plant not found with id: " + plantId));

        // PlantInstance létrehozása
        PlantInstance plantInstance = new PlantInstance();
        plantInstance.setUser(user);
        plantInstance.setPlant(plant);

        // Mentés
        return plantInstanceRepository.save(plantInstance);
    }

    public PlantInstance addPlantInstanceToUserByName(String username, Long plantId) {
        // User és Plant ellenőrzése és betöltése
        User user = userRepository.findByUsername(username);
        Plant plant = plantRepository.findById(plantId)
            .orElseThrow(() -> new RuntimeException("Plant not found with id: " + plantId));

        // PlantInstance létrehozása
        PlantInstance plantInstance = new PlantInstance();
        plantInstance.setUser(user);
        plantInstance.setPlant(plant);

        // Mentés
        return plantInstanceRepository.save(plantInstance);
    }

    public List<PlantInstance> getAllPlantInstances() {
        return plantInstanceRepository.findAll();
    }

    public PlantInstance getPlantInstanceById(Long id) {
        return plantInstanceRepository.findById(id)
        .orElseThrow(() -> new EntityNotFoundException("Plant not found with id: " + id));
    }

    public PlantInstance savePlantInstance(PlantInstance plantInstance) {
        return plantInstanceRepository.save(plantInstance);
    }

    public PlantInstance createPlantInstanceFromDTO(PlantInstanceDTO dto) {
        // Ellenőrizd, hogy a user létezik
        User user = userRepository.findById(dto.getUserId())
            .orElseThrow(() -> new RuntimeException("User not found"));

        // Ellenőrizd, hogy a növény létezik
        Plant plant = plantRepository.findById(dto.getPlantId())
            .orElseThrow(() -> new RuntimeException("Plant not found"));

        Device device = deviceRepository.findById((dto.getDeviceId()))
        .orElseThrow(() -> new RuntimeException("Plant not found"));

        // Hozz létre egy új PlantInstance-t
        PlantInstance plantInstance = new PlantInstance();
        plantInstance.setUser(user);
        plantInstance.setPlant(plant);
        plantInstance.setNickname(dto.getNickname());
        plantInstance.setDevice(device);

        // Ha vannak szenzor ID-k, adjuk hozzá azokat
    
        // Mentés az adatbázisba
        return plantInstanceRepository.save(plantInstance);
    }

    public PlantInstance createPlantInstanceFromDTOByName(PlantInstanceDTO dto) {
        // Ellenőrizd, hogy a felhasználó létezik a username alapján
        User user = userRepository.findByUsername(dto.getUsername());
    
        // Ellenőrizd, hogy a növény létezik
        Plant plant = plantRepository.findById(dto.getPlantId())
            .orElseThrow(() -> new RuntimeException("Plant not found"));

    
        // Hozz létre egy új PlantInstance-t
        PlantInstance plantInstance = new PlantInstance();
        plantInstance.setUser(user);
        plantInstance.setPlant(plant);
        plantInstance.setNickname(dto.getNickname());
    
        // Ha vannak szenzor ID-k, adjuk hozzá azokat
    
        // Mentés az adatbázisba
        return plantInstanceRepository.save(plantInstance);
    }
    
    public Optional<PlantInstance> findById(Long plantInstanceId) {
        return plantInstanceRepository.findById(plantInstanceId);
    }

    public PlantInstance addExistingPlantInstanceToUser(String username, Long plantInstanceId) {
        // Felhasználó betöltése username alapján
        User user = userRepository.findByUsername(username);

        // PlantInstance betöltése ID alapján
        PlantInstance plantInstance = plantInstanceRepository.findById(plantInstanceId)
            .orElseThrow(() -> new RuntimeException("PlantInstance not found with id: " + plantInstanceId));

        // PlantInstance felhasználóhoz rendelése
        plantInstance.setUser(user);

        // Frissített PlantInstance mentése
        return plantInstanceRepository.save(plantInstance);
    }

    public Optional<PlantInstance> getById(Long plantInstanceId) {
        return plantInstanceRepository.findById(plantInstanceId);
    }

    public void deletePlantInstanceById(Long id) {
        if (plantInstanceRepository.existsById(id)) {
            plantInstanceRepository.deleteById(id);
        } else {
            throw new EntityNotFoundException("PlantInstance not found with ID " + id);
        }
    }

}