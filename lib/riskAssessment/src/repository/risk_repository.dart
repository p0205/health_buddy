
import 'dart:async';

import 'package:health_buddy/riskAssessment/src/model/questionnaire.dart';
import 'package:health_buddy/riskAssessment/src/model/suggestion.dart';
import 'package:health_buddy/riskAssessment/src/repository/risk_data_provider.dart';

import '../model/ai_suggestion_response.dart';
import '../model/health_test.dart';


class RiskRepository{

  final RiskDataProvider riskDataProvider = RiskDataProvider();

  Future<List<HealthTest>> getAllTestType(){
    return riskDataProvider.getAllTestType();
  }

  Future<Questionnaire> getFilteredQuestionnare(int userId, int healthTestId){
    return riskDataProvider.getFilteredQuestionnare(userId, healthTestId);
  }

  Future<AiSuggestionResponse> getAISuggestion(int userId,int score , int healthTestId){
    return riskDataProvider.getAISuggestion(userId, score, healthTestId);
  }
}