class UserMeal{
  int? id;
  String mealType;
  int userId;
  int mealId;
  String? date;
  String? mealName;
  double amountInGrams;
  double? calories;
  double? carbsInGrams;
  double? proteinInGrams;
  double? fatInGrams;

  UserMeal(
      {this.id,
      required this.mealType,
        required this.userId,
        required this.mealId,
      this.mealName,
      this.date,
        required this.amountInGrams,
      this.calories,
      this.carbsInGrams,
      this.proteinInGrams,
      this.fatInGrams});

  factory UserMeal.fromJson(Map<String,dynamic> json) => UserMeal(
      id: json['id'],
      mealType: json['mealType'],
      userId: json['userId'],
      mealId: json['mealId'],
      mealName: json['mealName'],
      date: json['date'],
      amountInGrams: json['amountInGrams'],
      calories: json['calories'],
      carbsInGrams: json['carbsInGrams'],
      proteinInGrams: json['proteinInGrams'],
      fatInGrams: json['fatInGrams']
  );

  Map<String,dynamic> toJson(){
    return{
      "id" : id,
      "mealType" : mealType,
      "userId" : userId,
      'mealId' : mealId,
      "date" : date,
      "mealName" : mealName,
      'amountInGrams': amountInGrams,
      'calories': calories,
      'carbsInGrams':carbsInGrams,
      'proteinInGrams': proteinInGrams,
      'fatInGrams': fatInGrams,
    };
  }

  static List<UserMeal> fromJsonArray(List<dynamic> jsonArray){
    return jsonArray.map((json) => UserMeal.fromJson(json)).toList();
  }
}