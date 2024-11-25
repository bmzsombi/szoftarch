class Plant {
  final String scname;
  final String cname;
  final String cat;
  final int maxl;
  final int minl;
  final int maxenvhum;
  final int minenvhum;
  final int maxsom;
  final int minsom;
  final int maxtemp;
  final int mintemp;

  Plant({
    required this.scname,
    required this.cname,
    required this.cat,
    required this.maxl,
    required this.minl,
    required this.maxenvhum,
    required this.minenvhum,
    required this.maxsom,
    required this.minsom,
    required this.maxtemp,
    required this.mintemp
  });

  factory Plant.fromJson(Map<String, dynamic> json){
    return Plant(
      scname: json['scientific_name'],
      cname: json['common_name'],
      cat: json['category'],
      maxl: json['max_light'],
      minl: json['min_light'],
      maxenvhum: json['max_env_humid'],
      minenvhum: json['min_env_humid'],
      maxsom: json['max_soil_moist'],
      minsom: json['min_soil_moist'],
      maxtemp: json['max_temp'],
      mintemp: json['min_temp']
    );
  }
}
