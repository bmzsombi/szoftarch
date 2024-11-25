class Sensor {
  final int id;
  final String name;
  final String chartTitle;
  final String valueAxisTitle;

  Sensor({
    required this.id,
    required this.name,
    required this.chartTitle,
    required this.valueAxisTitle
  });

/*
  @override
  String toString() {
    return '$scname $cname ($cat)';
  }
*/
  factory Sensor.fromJson(Map<String, dynamic> json){
    return Sensor(
      id: json['id'],
      name: json['name'],
      chartTitle: json['sensorType'],
      valueAxisTitle: json['unit']
    );
  }
}