
import 'package:equatable/equatable.dart';

enum UserStatus{
  loading,
  userInfoLoaded
}


class UserState extends Equatable {

  final int? userId;
  final String? email;
  final String? name;
  final String? profileIcon;
  final String? token;
  final bool? isFirstLogin;
  final UserStatus status;
  const UserState( {
    this.userId,
    this.name,
    this.email,
    this.profileIcon,
    this.token,
    this.isFirstLogin,
    this.status = UserStatus.loading
  });

  @override
  List<Object> get props => [];

  UserState copyWith ({
    final int? userId,
    final String? email,
    final String? name,
    final String? profileIcon,
    final String? token,
    final bool? isFirstLogin,
    final UserStatus? status
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
    );
  }
}

