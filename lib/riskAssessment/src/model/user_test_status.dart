import 'dart:convert';

import 'package:health_buddy/riskAssessment/src/model/health_test.dart';
import 'package:health_buddy/riskAssessment/src/model/suggestion.dart';

class UserTestStatus {
  final bool isCompleted;
  final HealthTest healthTest;

  UserTestStatus({
    required this.isCompleted,
    required this.healthTest,
  });

  static List<UserTestStatus> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => UserTestStatus.fromJson(json)).toList();
  }

  factory UserTestStatus.fromJson(Map<String, dynamic> json) {
    return UserTestStatus(
      isCompleted: json['isCompleted'],
      healthTest: HealthTest.fromJson(json['healthTest']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isCompleted': isCompleted,
      'healthTest': healthTest,
    };
  }
}

