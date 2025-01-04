part of 'add_user_sport_bloc.dart';


abstract class AddUserSportEvent extends Equatable{
  const AddUserSportEvent();

  @override
  List<Object?> get props => [];
}

class UserInput extends AddUserSportEvent{

  final double userInput;
  final Sport sport;

  const UserInput({required this.sport , required this.userInput});

  @override
  List<Object?> get props => [sport, userInput];
}

class DurationInMinutesSelected extends AddUserSportEvent{}

class DurationInHoursSelected extends AddUserSportEvent{}

class DisposeCalculation extends AddUserSportEvent{}

class CalculateBtnClicked extends AddUserSportEvent{}

class AddSportBtnClicked extends AddUserSportEvent{

  final double durationInHours;
  final double caloriesBurnt;


  const AddSportBtnClicked(
      {
        required this.durationInHours,
        required this.caloriesBurnt,
      }
  );

  @override
  List<Object?> get props => [ durationInHours, caloriesBurnt];
}
