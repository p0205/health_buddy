part of 'greeting_bloc.dart';

abstract class GreetingEvent {
  const GreetingEvent();

  @override
  List<Object?> get props => [];
}

class ShowGreetingEvent extends GreetingEvent {}

class DismissGreetingEvent extends GreetingEvent {}

class CompletedTutorialEvent extends GreetingEvent {
  final int userId;
  final bool isFirstLogin;

  const CompletedTutorialEvent({required this.userId, required this.isFirstLogin});

  @override
  List<Object?> get props => [userId,isFirstLogin];
}