class Actuator {
  final int id;
  final String name;

  Actuator({
    required this.id,
    required this.name,
  });

/*
  @override
  String toString() {
    return '$scname $cname ($cat)';
  }
*/
  factory Actuator.fromJson(Map<String, dynamic> json){
    return Actuator(
      id: json['id'],
      name: json['name'],
    );
  }
}