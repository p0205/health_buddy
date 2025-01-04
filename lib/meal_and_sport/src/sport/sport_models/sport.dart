class Sport{
  int? id;
  String name;
  double? caloriesBurntPerHourPerKg;
  String? type;


  Sport({this.id, required this.name, this.caloriesBurntPerHourPerKg, this.type});

  factory Sport.fromJson(Map<String,dynamic> json) => Sport(
      id: json['id'],
      name: json['name'].toString().toUpperCase(),
      caloriesBurntPerHourPerKg: json['caloriesBurntPerHourPerKg'],
      type: json['type'],
  );

  Map<String,dynamic> toJson(){
    return{
      "id" : id,
      "name" : name,
      'caloriesBurntPerHourPerKg' : caloriesBurntPerHourPerKg,
      'type': type,
    };
  }

  static List<Sport> fromJsonArray(List<dynamic> jsonArray){
    return jsonArray.map((json) => Sport.fromJson(json)).toList();
  }

}
