class DeviceInstance {
  final int id;
  final String device;
  final String name;
  final String location;
  final int installationDate;


  DeviceInstance({
    required this.id,
    required this.device,
    required this.name,
    required this.location,
    required this.installationDate,
  });

  factory DeviceInstance.fromJson(Map<String, dynamic> json){
    return DeviceInstance(
      id: json['id'],
      device: json['scientificName'],
      name: json['common_name'],
      location: json['category'],
      installationDate: json['max_light'],
    );
  }
}