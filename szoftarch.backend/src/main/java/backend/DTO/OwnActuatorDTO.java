package backend.DTO;

public class OwnActuatorDTO {

    private Long deviceId;      // A kapcsolódó Device ID
    private String name;        // Az aktor neve
    private String type;        // Az aktor típusa (PUMP, LIGHT, BLIND)
    private String statusEndpoint;
    private String valueKey;
    private String onUpValue;
    private String offDownValue;
    private String onUpEndpoint;
    private String offDownEndpoint;

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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getStatusEndpoint() {
        return statusEndpoint;
    }

    public void setStatusEndpoint(String statusEndpoint) {
        this.statusEndpoint = statusEndpoint;
    }

    public String getValueKey() {
        return valueKey;
    }

    public void setValueKey(String valueKey) {
        this.valueKey = valueKey;
    }

    public String getOnUpValue() {
        return onUpValue;
    }

    public void setOnUpValue(String onUpValue) {
        this.onUpValue = onUpValue;
    }

    public String getOffDownValue() {
        return offDownValue;
    }

    public void setOffDownValue(String offDownValue) {
        this.offDownValue = offDownValue;
    }

    public String getOnUpEndpoint() {
        return onUpEndpoint;
    }

    public void setOnUpEndpoint(String onUpEndpoint) {
        this.onUpEndpoint = onUpEndpoint;
    }

    public String getOffDownEndpoint() {
        return offDownEndpoint;
    }

    public void setOffDownEndpoint(String offDownEndpoint) {
        this.offDownEndpoint = offDownEndpoint;
    }
}
