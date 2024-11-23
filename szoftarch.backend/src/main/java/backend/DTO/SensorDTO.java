package backend.DTO;

public class SensorDTO {

    private Long deviceId;       // Az eszköz ID-ja, amelyhez a sensor tartozik
    private String name;         // A szenzor neve
    private String sensorType;   // A szenzor típusa
    private String unit;         // Az egység
    private String dataType;     // Az adat típus (pl. INTEGER, FLOAT)
    private Float minValue;      // Minimális érték
    private Float maxValue;      // Maximális érték
    private String readEndpoint; // Az olvasási végpont
    private String valueKey;     // Az érték kulcs
    private Integer samplingInterval; // Mintavételi intervallum

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

    public String getSensorType() {
        return sensorType;
    }

    public void setSensorType(String sensorType) {
        this.sensorType = sensorType;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }

    public Float getMinValue() {
        return minValue;
    }

    public void setMinValue(Float minValue) {
        this.minValue = minValue;
    }

    public Float getMaxValue() {
        return maxValue;
    }

    public void setMaxValue(Float maxValue) {
        this.maxValue = maxValue;
    }

    public String getReadEndpoint() {
        return readEndpoint;
    }

    public void setReadEndpoint(String readEndpoint) {
        this.readEndpoint = readEndpoint;
    }

    public String getValueKey() {
        return valueKey;
    }

    public void setValueKey(String valueKey) {
        this.valueKey = valueKey;
    }

    public Integer getSamplingInterval() {
        return samplingInterval;
    }

    public void setSamplingInterval(Integer samplingInterval) {
        this.samplingInterval = samplingInterval;
    }
}
