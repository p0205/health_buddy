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

  LoginSuccessEvent({required this.userId, required this.name, required this.email,required this.token});

  @override
  List<Object> get props => [userId];
}

class LoginReset extends UserEvent {}
