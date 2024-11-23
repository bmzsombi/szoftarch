package backend.DTO;

import java.time.LocalDateTime;

public class DeviceInstanceDTO {

    private Long deviceId;      // Az eszköz ID-ja
    private String name;        // A DeviceInstance neve
    private String location;    // Az eszköz helye
    private String username;    // Felhasználónév
    private LocalDateTime installationDate; // Telepítés dátuma

    // Getters and Setters
    public Long getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(Long deviceId) {
        this.deviceId = deviceId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public LocalDateTime getInstallationDate() {
        return installationDate;
    }

    public void setInstallationDate(LocalDateTime installationDate) {
        this.installationDate = installationDate;
    }
}
