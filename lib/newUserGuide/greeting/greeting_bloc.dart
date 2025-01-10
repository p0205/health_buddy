import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/calories_counter/repository/user_repository.dart';


part 'greeting_event.dart';
part 'greeting_state.dart';

class GreetingBloc extends Bloc<GreetingEvent, GreetingState> {
  UserRepository userRepository = UserRepository();
  GreetingBloc() : super(GreetingHiddenState()){
    on<ShowGreetingEvent>(_showGreeting);
    on<DismissGreetingEvent>(_hideGreeting);
    on<CompletedTutorialEvent>(_setFirstLoginToFalse);
  }

   _showGreeting(GreetingEvent event,Emitter<GreetingState> emit){
    emit(GreetingVisibleState());
   }
  _hideGreeting(GreetingEvent event,Emitter<GreetingState> emit){
    emit(GreetingHiddenState());
  }

  Future<void> _setFirstLoginToFalse(
      CompletedTutorialEvent event,
      Emitter<GreetingState> emit
      )async{
    userRepository.markFirstLogin(event.userId, event.isFirstLogin);
  }
}
