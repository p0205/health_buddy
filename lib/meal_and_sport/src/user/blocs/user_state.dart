
import 'dart:io';

import 'package:equatable/equatable.dart';

import '../model/user.dart';



enum UserStatus{
  loading,
  userInfoLoaded,
  fileUploaded,
  failure
}


class UserState extends Equatable {

  final int? userId;

  final String? name;

  final String? token;
  final bool? isFirstLogin;
  final UserStatus status;
  final User? user;
  final File? file;
  const UserState( {
    this.userId,
    this.name,

    this.token,
    this.isFirstLogin,
    this.status = UserStatus.loading,
    this.user,
    this.file
  });

  @override
  List<Object?> get props => [
    userId,

    name,

    token,
    isFirstLogin,
    status,
    user,
    file
  ];

  UserState copyWith ({
    final int? userId,
    final String? name,
    final String? token,
    final bool? isFirstLogin,
    final UserStatus? status,
    final  User? user,
    final File? file
  })
  {
    return UserState(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      token: token ?? this.token,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
      status: status ?? this.status,
      user: user ?? this.user,
      file: file ?? this.file
    );
  }
}

