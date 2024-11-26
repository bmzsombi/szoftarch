// class Plant {
//   final int id;
//   final String scname;
//   final String cname;
//   final String cat;
//   final int maxl;
//   final int minl;
//   final int maxenvhum;
//   final int minenvhum;
//   final int maxsom;
//   final int minsom;
//   final int maxtemp;
//   final int mintemp;

//   Plant({
//     required this.id,
//     required this.scname,
//     required this.cname,
//     required this.cat,
//     required this.maxl,
//     required this.minl,
//     required this.maxenvhum,
//     required this.minenvhum,
//     required this.maxsom,
//     required this.minsom,
//     required this.maxtemp,
//     required this.mintemp,
//   });

//   @override
//   String toString() {
//     return '$scname $cname ($cat)';
//   }

//   factory Plant.fromJson(Map<String, dynamic> json){
//     return Plant(
//       id: json['id'],
//       scname: json['scientificName'],
//       cname: json['common_name'],
//       cat: json['category'],
//       maxl: json['max_light'],
//       minl: json['min_light'],
//       maxenvhum: json['max_env_humid'],
//       minenvhum: json['min_env_humid'],
//       maxsom: json['max_soil_moist'],
//       minsom: json['min_soil_moist'],
//       maxtemp: json['max_temp'],
//       mintemp: json['min_temp']
//     );
//   }
// }

class Plant {
  final int id;
  final String scientificName;
  final String commonName;
  final String category;
  final int maxLight;
  final int minLight;
  final int maxEnvHumid;
  final int minEnvHumid;
  final int maxSoilMoist;
  final int minSoilMoist;
  final int maxTemp;
  final int minTemp;

  Plant({
    required this.id,
    required this.scientificName,
    required this.commonName,
    required this.category,
    required this.maxLight,
    required this.minLight,
    required this.maxEnvHumid,
    required this.minEnvHumid,
    required this.maxSoilMoist,
    required this.minSoilMoist,
    required this.maxTemp,
    required this.minTemp,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      scientificName: json['scientificName'],
      commonName: json['common_name'],
      category: json['category'],
      maxLight: json['max_light'],
      minLight: json['min_light'],
      maxEnvHumid: json['max_env_humid'],
      minEnvHumid: json['min_env_humid'],
      maxSoilMoist: json['max_soil_moist'],
      minSoilMoist: json['min_soil_moist'],
      maxTemp: json['max_temp'],
      minTemp: json['min_temp'],
    );
  }

  @override
  String toString() {
    return '$scientificName ($commonName, $category)';
  }
}

class PlantInstance {

  final int id;
  final Plant plant;
  final String? nickname;

  PlantInstance({
    required this.id,
    required this.plant,
    this.nickname
  });

  factory PlantInstance.fromJson(Map<String, dynamic> json) {
    return PlantInstance(
      id: json['id'],
      plant: Plant.fromJson(json['plant']),
      nickname: json['nickname'],
    );
  }
}
