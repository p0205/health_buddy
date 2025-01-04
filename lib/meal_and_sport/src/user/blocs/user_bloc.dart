import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/user/blocs/user_event.dart';
import 'package:health_buddy/meal_and_sport/src/user/blocs/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  // final UserRepository userRepository;

  UserBloc() : super(LoginSuccess(userId:1)) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>(_onLoginReset);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event,
      Emitter<UserState> emit,
      ) async {
    int id = 1;
    emit(LoginSuccess(userId: 1));
    // emit(LoginLoading());
    // try {
      // final isSuccess = await userRepository.login(
      //   email: event.email,
      //   password: event.password,
      // );
    //
    //   if (isSuccess) {
    //     emit(LoginSuccess());
    //   } else {
    //     emit(LoginFailure(error: "Invalid email or password"));
    //   }
    // } catch (e) {
    //   emit(LoginFailure(error: e.toString()));
    // }
  }

  void _onLoginReset(LoginReset event, Emitter<UserState> emit) {
    emit(LoginInitial());
  }
}
