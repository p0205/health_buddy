
import 'package:health_buddy/riskAssessment/src/model/suggestion.dart';

class HealthTestReport {
  final int? userId;
  final int? healthTestId;
  final int? score;
  final String riskLevel;
  final Suggestion suggestions;

  HealthTestReport({
     this.userId,
     this.healthTestId,
     this.score,
    required this.riskLevel,
    required this.suggestions,
  });

  factory HealthTestReport.fromJson(Map<String, dynamic> json) {
    return HealthTestReport(
      userId: json['userId'],
      healthTestId: json['healthTestId'],
      score: json['score'],
      riskLevel: json['riskLevel'],
      suggestions: Suggestion.fromJson(json['suggestions']),
    );
  }

}
