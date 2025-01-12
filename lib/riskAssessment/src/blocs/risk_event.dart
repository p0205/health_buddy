part of 'risk_bloc.dart';

abstract class RiskEvent extends Equatable{
  const RiskEvent();
  @override
  List<Object?> get props => [];
}

// class LoadTestTypeEvent extends RiskEvent{}

class LoadQuestionnaireEvent extends RiskEvent{
  final int userId;
  final HealthTest test;
  const LoadQuestionnaireEvent({
      required this.userId,
      required this.test
  });
}

class CompleteQuestionnaireEvent extends RiskEvent{
  final int userId;
  final int score;

  const CompleteQuestionnaireEvent({
    required this.userId,
    required this.score,
  });
}


class LoadUserTestStatusEvent extends RiskEvent{
  final int userId;
  const LoadUserTestStatusEvent({
    required this.userId,
  });
}

class GetHealthReportEvent extends  RiskEvent{
  final int userId;
  final HealthTest test;
  const GetHealthReportEvent({
    required this.userId,
    required this.test,
  });
}

class ResetRiskStateEvent extends RiskEvent {
  final int userId;
  const ResetRiskStateEvent({
    required this.userId,
  });
}


class ResetReportEvent extends RiskEvent{}

class HealthTestSelectedEvent extends RiskEvent{
  final HealthTest test;
  const HealthTestSelectedEvent({
    required this.test,
  });
}