
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
  final String? email;
  final String? name;
  final String? profileIcon;
  final String? token;
  final bool? isFirstLogin;
  final UserStatus status;
  final User? user;
  final File? file;
  const UserState( {
    this.userId,
    this.name,
    this.email,
    this.profileIcon,
    this.token,
    this.isFirstLogin,
    this.status = UserStatus.loading,
    this.user,
    this.file
  });

  @override
  List<Object?> get props => [
    userId,
    email,
    name,
    profileIcon,
    token,
    isFirstLogin,
    status,
    user,
    file
  ];

  UserState copyWith ({
    final int? userId,
    final String? email,
    final String? name,
    final String? profileIcon,
    final String? token,
    final bool? isFirstLogin,
    final UserStatus? status,
    final  User? user,
    final File? file
  })
  {
    return UserState(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      profileIcon: profileIcon ?? this.profileIcon,
      token: token ?? this.token,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
      status: status ?? this.status,
      user: user ?? this.user,
      file: file ?? this.file
    );
  }
}

