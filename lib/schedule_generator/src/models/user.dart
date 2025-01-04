import 'package:flutter/foundation.dart';

class User {
  int id;
  String email;
  String password;
  int age;
  String gender;
  int weight;
  int height;
  String name;
  String? occupationType;
  String? occupationTime;
  String? healthHistory;
  String? areaOfLiving;
  int? noOfFamilyMember;
  int? goalCalories;

  // First constructor (basic user information)
  User({
    required this.id,
    required this.email,
    required this.password,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.name,
  });

  // Second constructor (with optional parameters)
  User.detailed({
    required this.id,
    required this.email,
    required this.password,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.name,
    this.occupationType,
    this.occupationTime,
    this.healthHistory,
    this.areaOfLiving,
    this.noOfFamilyMember,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User.detailed(
        id: json['id'],
        email: json['email'],
        password: json['password'],
        age: json['age'],
        gender: json['gender'],
        weight: json['weight'],
        height: json['height'],
        name: json['name'],
        occupationType: json['occupationType']??'',
        occupationTime: json['occupationTime']??'',
        healthHistory: json['healthHistory']??'',
        areaOfLiving: json['areaOfLiving']??'',
        noOfFamilyMember: json['noOfFamilyMember']??0,
      );
    } catch (e) {
      rethrow;
    }
  }

  // to json
  // For camelCase JSON (matching your fromJson)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'name': name,
      'occupationType': occupationType,
      'occupationTime': occupationTime,
      'healthHistory': healthHistory,
      'areaOfLiving': areaOfLiving,
      'noOfFamilyMember': noOfFamilyMember,
      'goalCalories': goalCalories,
    };
  }
}