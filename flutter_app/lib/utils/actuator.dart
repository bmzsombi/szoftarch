class Actuator {
  final int id;
  final String name;
  final String onUpEndpoint;
  final String offDownEndpoint;

  Actuator({
    required this.id,
    required this.name,
    required this.onUpEndpoint,
    required this.offDownEndpoint
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
      offDownEndpoint: json["offDownEndpoint"],
      onUpEndpoint: json["onUpEndpoint"]
    );
  }
}