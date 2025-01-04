
import 'package:equatable/equatable.dart';

class UserState extends Equatable {

  final int? userId;
  final String? email;
  final String? name;
  final String? profileIcon;
  final String? token;
  const UserState( {this.userId, this.name,this.email, this.profileIcon,this.token});

  @override
  List<Object> get props => [];

  UserState copyWith ({
    final int? userId,
    final String? email,
    final String? name,
    final String? profileIcon,
    final String? token
  })
  {
    return UserState(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      profileIcon: profileIcon ?? this.profileIcon,
      token: token ?? this.token,
    );
  }
}

