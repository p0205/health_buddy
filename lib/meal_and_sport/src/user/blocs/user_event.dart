import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginSuccessEvent extends UserEvent {
  final int userId;
  final String name;
  final String email;
  final String token;
  final bool isFirstLogin;

  LoginSuccessEvent({required this.userId, required this.name, required this.email,required this.token,required this.isFirstLogin});

  @override
  List<Object> get props => [userId];
}

class LoginReset extends UserEvent {}
