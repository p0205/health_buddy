
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {

  @override
  List<Object> get props => [];
}

class LoginInitial extends UserState {}

class LoginLoading extends UserState {}

class LoginSuccess extends UserState {
  final int userId;

  LoginSuccess({required this.userId});
  @override
  List<Object> get props => [userId];
}

class LoginFailure extends UserState {
  final String error;

  LoginFailure({required this.error});

  @override
  List<Object> get props => [error];}