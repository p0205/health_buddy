part of 'risk_bloc.dart';

enum RiskStatus {
  loading,
  testTypeLoaded,
  questionnaireLoaded,
  selected,
}


class RiskState extends Equatable{

  final RiskStatus status;
  final List<HealthTest>? testType;
  final HealthTest? healthTestSelected;
  final List<Question>? questions;
  final int? score;
  final String? riskLevel;
  final Suggestion? suggestions;

  const RiskState({
    this.status = RiskStatus.loading,
    this.testType,
    this.healthTestSelected,
    this.questions,
    this.score,
    this.riskLevel,
    this.suggestions
  });


  @override
  List<Object?> get props => [status,healthTestSelected,questions,testType, riskLevel,suggestions];

  RiskState copyWith ({
    RiskStatus? status,
    List<HealthTest>? testType,
    HealthTest? healthTestSelected,
    List<Question>? questions,
    int? score,
    String? riskLevel,
    Suggestion?  suggestions
  })
  {
    return RiskState(
      status: status ?? this.status,
      testType: testType ?? this.testType,
      healthTestSelected: healthTestSelected ?? this.healthTestSelected,
      questions: questions ?? this.questions,
      score: score ?? this.score,
      riskLevel: riskLevel ?? this.riskLevel,
      suggestions: suggestions ?? this.suggestions
    );
  }
}




