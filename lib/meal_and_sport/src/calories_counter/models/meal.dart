class Meal{
  int? id;
  String name;
  double? unitWeight;
  double? energyPer100g;
  double? carbsPer100g;
  double? proteinPer100g;
  double? fatPer100g;


  Meal({this.id, required this.name,this.unitWeight,this.energyPer100g,this.carbsPer100g,this.proteinPer100g,this.fatPer100g});

  factory Meal.fromJson(Map<String,dynamic> json) => Meal(
      id: json['id'],
      name: json['name'] ?? "",
      unitWeight: json['unitWeight'],
      energyPer100g: json['energyPer100g'],
      carbsPer100g: json['carbsPer100g'],
      proteinPer100g: json['proteinPer100g'],
      fatPer100g: json['fatPer100g']

  );

  Map<String,dynamic> toJson(){
    return{
      "id" : id,
      "name" : name,
      'unitWeight' : unitWeight,
      'energyPer100g': energyPer100g,
      'carbsPer100g': carbsPer100g,
      'proteinPer100g':proteinPer100g,
      'fatPer100g': fatPer100g,
    };
  }

  static List<Meal> fromJsonArray(List<dynamic> jsonArray){
    return jsonArray.map((json) => Meal.fromJson(json)).toList();
  }

}
