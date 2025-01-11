import 'dart:convert';

import 'package:health_buddy/riskAssessment/src/model/suggestion.dart';

class AiSuggestionResponse {
  final String riskLevel;
  final Suggestion suggestions;

  AiSuggestionResponse({
    required this.riskLevel,
    required this.suggestions,
  });

  factory AiSuggestionResponse.fromJson(Map<String, dynamic> json) {
    return AiSuggestionResponse(
      riskLevel: json['riskLevel'],
      suggestions: Suggestion.fromJson(json['suggestions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'riskLevel': riskLevel,
      'suggestions': suggestions,
    };
  }
}

