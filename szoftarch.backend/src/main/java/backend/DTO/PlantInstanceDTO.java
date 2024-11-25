package backend.DTO;

import java.util.List;

public class PlantInstanceDTO {
    
    private String username; // A felhasználó neve
    private Long plantInstanceId;
    private Long userId; // A felhasználó ID-ja
    private Long plantId; // A növény ID-ja
    private String nickname; // Becenév
    private Long deviceInstanceId;
    
    public Long getDeviceInstanceId() {
        return deviceInstanceId;
    }
    public void setDeviceInstanceId(Long deviceInstanceId) {
        this.deviceInstanceId = deviceInstanceId;
    }
    //private List<Long> sensorIds; // A szenzorok ID-i (ha előre definiáltak)
    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }
    public Long getPlantInstanceId() {
        return plantInstanceId;
    }
    public void setPlantInstanceId(Long plantInstanceId) {
        this.plantInstanceId = plantInstanceId;
    }

    public Long getUserId() {
        return userId;
    }
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    public Long getPlantId() {
        return plantId;
    }
    public void setPlantId(Long plantId) {
        this.plantId = plantId;
    }
    public String getNickname() {
        return nickname;
    }
    public void setNickname(String nickname) {
        this.nickname = nickname;
    }
    /*public List<Long> getSensorIds() {
        return sensorIds;
    }
    public void setSensorIds(List<Long> sensorIds) {
        this.sensorIds = sensorIds;
    }*/
}
