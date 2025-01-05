import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/user/blocs/user_event.dart';
import 'package:health_buddy/meal_and_sport/src/user/blocs/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  // final UserRepository userRepository;

  UserBloc() : super(const UserState()) {
    on<LoginSuccessEvent>(_setUserInfo);
    // on<LoginReset>(_onLoginReset);
  }
  Future<void> _setUserInfo(
      LoginSuccessEvent event,
      Emitter<UserState> emit,
      ) async {
    emit(state.copyWith(userId : event.userId, email: event.email, name: event.name,token: event.token));
  }

  // Future<void> _onLoginSubmitted(
  //     LoginSubmitted event,
  //     Emitter<UserState> emit,
  //     ) async {
  //   int id = 1;
  //   emit(LoginSuccess(userId: 1));
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
  // }

  // void _onLoginReset(LoginReset event, Emitter<UserState> emit) {
  //   emit(LoginInitial());
  // }

}
