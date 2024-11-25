package backend.DTO;

import java.util.List;

public class PlantInstanceDTO {
    
    private Long userId; // A felhasználó ID-ja
    private Long plantId; // A növény ID-ja
    private String nickname; // Becenév
    private Long deviceId;
    
    //private List<Long> sensorIds; // A szenzorok ID-i (ha előre definiáltak)
    
    public Long getDeviceId() {
        return deviceId;
    }
    public void setDeviceId(Long deviceId) {
        this.deviceId = deviceId;
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
