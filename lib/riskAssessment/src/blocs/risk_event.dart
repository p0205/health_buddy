part of 'risk_bloc.dart';

abstract class RiskEvent extends Equatable{
  const RiskEvent();
  @override
  List<Object?> get props => [];
}

class LoadTestTypeEvent extends RiskEvent{}

class HealthTestSelectedEvent extends RiskEvent{
  final int userId;
  final HealthTest test;
  const HealthTestSelectedEvent({
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



