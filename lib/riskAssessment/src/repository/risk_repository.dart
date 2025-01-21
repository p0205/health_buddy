
import 'dart:async';

import 'package:health_buddy/riskAssessment/src/model/questionnaire.dart';
import 'package:health_buddy/riskAssessment/src/model/suggestion.dart';
import 'package:health_buddy/riskAssessment/src/repository/risk_data_provider.dart';

import '../model/health_test_report.dart';
import '../model/user_test_status.dart';
import '../model/ai_suggestion_response.dart';
import '../model/health_test.dart';


class RiskRepository{

  final RiskDataProvider riskDataProvider = RiskDataProvider();

  // Future<List<HealthTest>> getAllTestType(){
  //   return riskDataProvider.getAllTestType();
  // }

  Future<List<UserTestStatus>> getUserTestStatus (int userId) async{
    return await riskDataProvider.getUserTestStatus(userId);
  }

  Future<Questionnaire> getFilteredQuestionnare  (int userId, int healthTestId)async{
    return await riskDataProvider.getFilteredQuestionnare(userId, healthTestId);
  }

  Future<AiSuggestionResponse> getAISuggestion(int userId,int score , int healthTestId)async{
    return await riskDataProvider.getAISuggestion(userId, score, healthTestId);
  }

  Future<HealthTestReport> getHealthReport(int userId, int healthTestId) async {
    return await riskDataProvider.getHealthReport(userId, healthTestId);
  }
}