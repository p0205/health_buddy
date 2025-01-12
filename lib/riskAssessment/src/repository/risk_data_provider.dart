
import 'dart:convert';
import 'dart:core';
import 'dart:io' show Platform;
import 'package:health_buddy/riskAssessment/src/model/health_test_report.dart';
import 'package:health_buddy/riskAssessment/src/model/user_test_status.dart';
import 'package:health_buddy/riskAssessment/src/model/ai_suggestion_response.dart';
import 'package:health_buddy/riskAssessment/src/model/health_test.dart';
import 'package:health_buddy/riskAssessment/src/model/questionnaire.dart';
import 'package:health_buddy/riskAssessment/src/model/suggestion.dart';
import 'package:http/http.dart' as http;
import 'package:health_buddy/constants.dart' as Constants;

//Exception throw when foodSearch fails
class GetAllTestTypeFailure implements Exception{}
class GetFilteredQuestionFailure implements Exception{}
class GetAISuggestionFailure implements Exception{}
class GetHealthReportFailure implements Exception{}

class RiskDataProvider{

  final String _baseUrl;
  final http.Client _httpClient;

  RiskDataProvider({http.Client? httpClient})
      : _baseUrl = _getBaseUrl(),
        _httpClient = httpClient ?? http.Client();


  static String _getBaseUrl() {
    if (Platform.isAndroid) {
      return Constants.BaseUrl + Constants.SportNMealPort; // Android emulator localhost
    } else {
      return "http://localhost:8080";
    }
  }


  // // api : GET localhost:8080/riskAssessment/test
  // Future<List<HealthTest>> getAllTestType() async {
  //   final uri = Uri.parse('$_baseUrl/riskAssessment/test');
  //   final response = await _httpClient.get(uri);
  //
  //   if(response.statusCode != 200){
  //     throw GetAllTestTypeFailure();
  //   }
  //   List<HealthTest> tests =  HealthTest.fromJsonList(json.decode(response.body));
  //   return tests;
  // }

  // api : GET localhost:8080/riskAssessment/test/{userId}
  Future<List<UserTestStatus>> getUserTestStatus(int userId) async {
    final uri = Uri.parse('$_baseUrl/riskAssessment/test/${userId.toString()}');
    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw GetAllTestTypeFailure();
    }
    List<UserTestStatus> userTestStatus =  UserTestStatus.fromJsonList(json.decode(response.body));
    return userTestStatus;
  }

  // api : GET localhost:8080/ai/filter-questions/{userId}/{healthTestId}
  Future<Questionnaire> getFilteredQuestionnare(int userId, int healthTestId) async {

    final uri = Uri.parse('$_baseUrl/ai/filter-questions/${userId.toString()}/${healthTestId.toString()}');
    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw GetFilteredQuestionFailure();
    }
    // Questionnaire questionnaire =  Questionnaire.fromJson(response);
    Questionnaire questionnaire =  Questionnaire.fromJson(json.decode(response.body));
    return questionnaire;
  }

  // api : GET http://localhost:8080/ai/suggestions/{userId}/{healthTestId}?score=?
  Future<AiSuggestionResponse> getAISuggestion(int userId,int score , int healthTestId) async {

    final uri = Uri.parse('$_baseUrl/ai/suggestions/${userId.toString()}/${healthTestId.toString()}?score=${score}');

    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw GetAISuggestionFailure();
    }

   AiSuggestionResponse aiSuggestionResponse = AiSuggestionResponse.fromJson(json.decode(response.body));
    return aiSuggestionResponse;
  }

  // api : GET http://localhost:8080/riskAssessment/{userId}/{healthTestId}
  Future<HealthTestReport> getHealthReport(int userId, int healthTestId) async {

    final uri = Uri.parse('$_baseUrl/riskAssessment/${userId.toString()}/${healthTestId.toString()}');

    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw GetHealthReportFailure();
    }

    HealthTestReport healthTestReport = HealthTestReport.fromJson(json.decode(response.body));
    return healthTestReport;
  }

}