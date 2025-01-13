import 'dart:io';

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


class LoadUserProfileEvent extends UserEvent{
  final int userId;
  LoadUserProfileEvent(this.userId);
}

class UpdateProfileEvent extends UserEvent {
  final int userId;
  final Map<String, dynamic> updatedData;
  UpdateProfileEvent(this.userId,this.updatedData);
}

class UploadProfileImageEvent extends UserEvent {
  final File file;
  final int userId;
  UploadProfileImageEvent(this.file,this.userId);
}
class UploadFileEvent extends UserEvent {}


