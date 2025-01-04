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

class LoadInitialDataEvent extends CaloriesCounterMainEvent {}

class ReloadMealList extends CaloriesCounterMainEvent {}

class DeleteMealBtnClicked extends CaloriesCounterMainEvent{
  final int userMealId;
  const DeleteMealBtnClicked({required this.userMealId});
  @override
  List<Object?> get props => [userMealId];
}

