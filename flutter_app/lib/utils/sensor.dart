class Sensor {
  final int id;
  final String name;

  Sensor({
    required this.id,
    required this.name,
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
    );
  }
}