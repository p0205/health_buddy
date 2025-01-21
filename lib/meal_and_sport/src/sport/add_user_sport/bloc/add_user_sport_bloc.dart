import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../user/repo/user_repository.dart';
import '../../sport_models/sport.dart';
import '../../sport_repository/sport_repository.dart';

part 'add_user_sport_event.dart';
part 'add_user_sport_state.dart';

class AddUserSportBloc extends Bloc<AddUserSportEvent,AddUserSportState>{

  final SportRepository sportRepository = SportRepository();
  final UserRepository userRepository = UserRepository();
  final Sport sport;
  final int userId;



  AddUserSportBloc({required this.sport,required this.userId})
      : super(AddUserSportState(
    userId: userId, sportId: sport.id!,
  )) {
    on<DurationInHoursSelected>(_onDurationInHoursSelected);
    on<DurationInMinutesSelected>(_onDurationInMinutesSelected);
    on<UserInput>(_onUserInput);
    on<CalculateBtnClicked>(_onCalculateBtnClicked);
    on<DisposeCalculation>(_onDisposeCalculation);
    on<AddSportBtnClicked>(_onAddSport);
  }

  Future<void> _onDurationInHoursSelected(
      DurationInHoursSelected event,
      Emitter<AddUserSportState> emit
      ) async {
    emit(state.copyWith(isDurationInHoursSelected: true));
  }

  Future<void> _onDurationInMinutesSelected(
      DurationInMinutesSelected event,
      Emitter<AddUserSportState> emit
      ) async {
    emit(state.copyWith(isDurationInHoursSelected: false));
  }


  Future<void> _onUserInput(
      UserInput event,
      Emitter<AddUserSportState> emit
      )  async {
    double? durationInHours;

    if(!state.isDurationInHoursSelected) {
      durationInHours = event.userInput/60;
    }else{
      durationInHours = event.userInput;
    }

    emit(state.copyWith(userId: userId, sportId: sport.id, durationInHours: durationInHours));
  }

  Future<void> _onCalculateBtnClicked(
      CalculateBtnClicked event,
      Emitter<AddUserSportState> emit
      ) async {
    final double? caloriesBurnt;
    final String userWeight = await userRepository.getUserWeight(userId);
    try{
      caloriesBurnt = state.durationInHours! * double.parse(userWeight) * sport.caloriesBurntPerHourPerKg!;
      emit(state.copyWith(isCalculated: true, caloriesBurnt: caloriesBurnt));
    }catch(e){
      emit(state.copyWith(status: AddUserSportStatus.failure,message: e.toString()));
    }
  }

  Future<void> _onDisposeCalculation(
      DisposeCalculation event,
      Emitter<AddUserSportState> emit
      ) async {
    emit(state.copyWith(isCalculated: false));
  }


  Future<void> _onAddSport(
      AddSportBtnClicked event,
      Emitter<AddUserSportState> emit
      ) async {
    try{
      await sportRepository.addUserSport(userId, sport.id!, state.durationInHours!, state.caloriesBurnt!);
      emit(state.copyWith(status: AddUserSportStatus.userSportAdded));
    }catch(e){
      emit(state.copyWith(status: AddUserSportStatus.failure, message: e.toString()));
    }
  }
}