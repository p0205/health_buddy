part of 'risk_bloc.dart';

enum RiskStatus {
  loading,
  testTypeLoaded,
  questionnaireLoaded,
  selected,
  loadingReport,
  reportLoaded,
  error,
  aiResponseLoading,
  aiResponseLoaded
}


class RiskState extends Equatable{

  final RiskStatus status;
  final List<UserTestStatus>? testStatus;
  // final List<HealthTest>? testType;
  final HealthTest? healthTestSelected;
  final List<Question>? questions;
  final int? score;
  final HealthTestReport? report;
  final String? errorMessage;

  const RiskState({
    this.status = RiskStatus.loading,
    this.testStatus,
    // this.testType,
    this.healthTestSelected,
    this.questions,
    this.score,
    this.report,
    this.errorMessage
  });


  @override
  List<Object?> get props => [status,testStatus, healthTestSelected,questions,report,errorMessage];

  RiskState copyWith ({
    RiskStatus? status,
    List<UserTestStatus>? testStatus,
    // List<HealthTest>? testType,
    HealthTest? healthTestSelected,
    List<Question>? questions,
    int? score,
    HealthTestReport? report,
    String? errorMessage
  })
  {
    return RiskState(
      status: status ?? this.status,
      testStatus: testStatus ?? this.testStatus,
      healthTestSelected: healthTestSelected ?? this.healthTestSelected,
      questions: questions ?? this.questions,
      score: score ?? this.score,
      report: report,
      errorMessage: errorMessage ?? this.errorMessage,
    );

  }
}




