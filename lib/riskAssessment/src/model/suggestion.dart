import 'dart:convert';

class Suggestion {
  final List<String> exercise;
  final List<String> diet;
  final List<String> healthCheckups;

  Suggestion({
    required this.exercise,
    required this.diet,
    required this.healthCheckups,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      exercise: List<String>.from(json['exercise']),
      diet: List<String>.from(json['diet']),
      healthCheckups: List<String>.from(json['healthCheckups']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exercise': exercise,
      'diet': diet,
      'healthCheckups': healthCheckups,
    };
  }

  static Suggestion fromJsonString(String jsonString) {
    final jsonData = jsonDecode(jsonString);
    return Suggestion.fromJson(jsonData);
  }

  String toJsonString() {
    final jsonData = toJson();
    return jsonEncode(jsonData);
  }
  }

