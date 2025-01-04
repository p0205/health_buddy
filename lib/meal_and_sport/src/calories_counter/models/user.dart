import 'dart:ffi';

class User{

  int id;
  int age;
  String email;

  String gender;
  int? goalCalories;
  String name;
  double? weight;
  double? height;


  User(
     this.id,
     this.age,
     this.name,
     this.email,
     this.gender,
    this.weight,
    this.height,
    this.goalCalories,
);

  factory User.fromJson(Map<String,dynamic> json) => User(
      json['id'],
      json['age'],
      json['name'],
      json['email'],
      json['gender'],
      json['weight'],
      json['height'],
      json['goal_calories']
  );

  Map<String,dynamic> toJson(){
    return{
      "id" : id,
      "name" : name,
      'age' : age,
      'email': email,
      'gender': gender,
      'weight':weight,
      'height': height,
      'goal_calories': goalCalories,
    };
  }
}