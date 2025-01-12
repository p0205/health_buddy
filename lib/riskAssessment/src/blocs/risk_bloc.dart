import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/riskAssessment/src/model/ai_suggestion_response.dart';
import 'package:health_buddy/riskAssessment/src/model/health_test.dart';
import 'package:health_buddy/riskAssessment/src/model/health_test_report.dart';
import 'package:health_buddy/riskAssessment/src/model/question.dart';
import 'package:health_buddy/riskAssessment/src/model/questionnaire.dart';
import 'package:health_buddy/riskAssessment/src/model/suggestion.dart';
import 'package:health_buddy/riskAssessment/src/repository/risk_repository.dart';

import '../model/user_test_status.dart';


part 'risk_event.dart';
part 'risk_state.dart';

class RiskBloc extends Bloc<RiskEvent,RiskState>{

  final RiskRepository riskRepository = RiskRepository();

  RiskBloc() : super(const RiskState()) {

    // on<LoadTestTypeEvent>(_loadTestType);
    on<LoadUserTestStatusEvent>(_loadUserTestStatus);
    on<LoadQuestionnaireEvent>(_fetchQuestionnareForSelectedTest);
    on<CompleteQuestionnaireEvent>(_getAiResponse);
    on<GetHealthReportEvent>(_getHealthReport);
    on<ResetRiskStateEvent>(_resetRiskState);
    on<ResetReportEvent>(_resetReport);
  }

  // Future<void> _loadTestType(LoadTestTypeEvent event, Emitter<RiskState> emit) async {
  //   List<HealthTest> testType = await riskRepository.getAllTestType();
  //   emit(state.copyWith(status: RiskStatus.testTypeLoaded, testType: testType));
  // }

  Future<void> _loadUserTestStatus(LoadUserTestStatusEvent event, Emitter<RiskState> emit) async {
    List<UserTestStatus> testStatus = await riskRepository.getUserTestStatus(event.userId);
    emit(state.copyWith(status: RiskStatus.testTypeLoaded, testStatus: testStatus));
  }



  Future<void> _fetchQuestionnareForSelectedTest(LoadQuestionnaireEvent event, Emitter<RiskState> emit) async {
    Questionnaire questionnaire = await riskRepository.getFilteredQuestionnare(event.userId, event.test.id);

    final score = questionnaire.calculatedScore;
    final questions = questionnaire.questions;
    final healthTest = event.test;
    emit(state.copyWith(status: RiskStatus.questionnaireLoaded, questions: questions, score: score, healthTestSelected: healthTest));
  }

  Future<void> _getAiResponse(CompleteQuestionnaireEvent event, Emitter<RiskState> emit) async {
    int score = state.score ?? 0;
    final int totalScore = event.score + score;
    emit(state.copyWith(score: totalScore));

    AiSuggestionResponse aiSuggestionResponse = await riskRepository.getAISuggestion(event.userId, totalScore, state.healthTestSelected!.id);
    HealthTestReport report = HealthTestReport(riskLevel: aiSuggestionResponse.riskLevel, suggestions: aiSuggestionResponse.suggestions);
    emit(state.copyWith(report: report));
  }

  Future<void> _getHealthReport(GetHealthReportEvent event, Emitter<RiskState> emit) async {
    HealthTestReport report = await riskRepository.getHealthReport(event.userId, event.test.id);
    emit(state.copyWith(status: RiskStatus.reportLoaded, report: report, healthTestSelected: event.test));
  }

  Future<void> _resetRiskState(ResetRiskStateEvent event, Emitter<RiskState> emit) async {
    emit(const RiskState());
    add(LoadUserTestStatusEvent(userId: event.userId));
  }

  Future<void> _resetReport(ResetReportEvent event, Emitter<RiskState> emit) async {
    emit(state.copyWith(report: null));
  }
}


