part of 'risk_bloc.dart';

enum RiskStatus {
  loading,
  testTypeLoaded,
  questionnaireLoaded,
  selected,
  reportLoaded
}


class RiskState extends Equatable{

  final RiskStatus status;
  final List<UserTestStatus>? testStatus;
  // final List<HealthTest>? testType;
  final HealthTest? healthTestSelected;
  final List<Question>? questions;
  final int? score;
  final HealthTestReport? report;

  const RiskState({
    this.status = RiskStatus.loading,
    this.testStatus,
    // this.testType,
    this.healthTestSelected,
    this.questions,
    this.score,
    this.report
  });


  @override
  List<Object?> get props => [status,testStatus, healthTestSelected,questions,report];

  RiskState copyWith ({
    RiskStatus? status,
    List<UserTestStatus>? testStatus,
    // List<HealthTest>? testType,
    HealthTest? healthTestSelected,
    List<Question>? questions,
    int? score,
    HealthTestReport? report
  })
  {
    return RiskState(
      status: status ?? this.status,
      testStatus: testStatus ?? this.testStatus,
      // testType: testType ?? this.testType,
      healthTestSelected: healthTestSelected ?? this.healthTestSelected,
      questions: questions ?? this.questions,
      score: score ?? this.score,
      report: report ?? this.report
    );

  }
}




