part of 'calories_counter_main_bloc.dart';

abstract class CaloriesCounterMainEvent extends Equatable{
  const CaloriesCounterMainEvent();

  @override
  List<Object?> get props => [];
}

class AddBtnClicked extends CaloriesCounterMainEvent {
  final String mealType;
  const AddBtnClicked({required this.mealType});
  @override
  List<Object?> get props => [mealType];
}

class LoadUserIdAndDateEvent extends CaloriesCounterMainEvent {
  final int userId;
  final DateTime date;
  const LoadUserIdAndDateEvent({required this.userId,required this.date});
  @override
  List<Object?> get props => [userId,date];
}

class LoadInitialDataEvent extends CaloriesCounterMainEvent {}

class ReloadMealList extends CaloriesCounterMainEvent {}

class DeleteMealBtnClicked extends CaloriesCounterMainEvent{
  final int userMealId;
  const DeleteMealBtnClicked({required this.userMealId});
  @override
  List<Object?> get props => [userMealId];
}

class DateChangedEvent extends CaloriesCounterMainEvent{
  final DateTime date;
  const DateChangedEvent({required this.date});
  @override
  List<Object?> get props => [date];
}

class NullGoalCaloriesEvent extends CaloriesCounterMainEvent{}


