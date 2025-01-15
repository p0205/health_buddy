import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/meal_summary.dart';
import '../../models/user_meal.dart';
import '../../repository/meal_repository.dart';

part 'calories_counter_main_event.dart';
part 'calories_counter_main_state.dart';

class CaloriesCounterMainBloc extends Bloc<CaloriesCounterMainEvent,CaloriesCounterMainState>{
  final MealApiRepository mealRepository = MealApiRepository();


  CaloriesCounterMainBloc(): super(const CaloriesCounterMainState(status: CaloriesCounterMainStatus.loading)){
    on<AddBtnClicked>(_addMealBtnClicked);
    on<LoadInitialDataEvent>(_init);
    on<ReloadMealList>(_reload);
    on<DeleteMealBtnClicked>(_delete);
    on<LoadUserIdAndDateEvent>(_loadIdAndDate);
    on<DateChangedEvent>(_onDateChanged);
    on<NullGoalCaloriesEvent>(_nullGoalCalories);
  }

  Future<void> _nullGoalCalories (
      NullGoalCaloriesEvent event,
      Emitter<CaloriesCounterMainState> emit
      )async{
    emit(state.copyWith(status: CaloriesCounterMainStatus.goalCaloriesNotFound));

  }

  Future<void> _onDateChanged(
      DateChangedEvent event,
      Emitter<CaloriesCounterMainState> emit
      )async{
    print("Calories Date changed");
    emit(state.copyWith(status: CaloriesCounterMainStatus.loading, date: event.date));
    add(LoadInitialDataEvent());
  }
  Future<void> _loadIdAndDate(
      LoadUserIdAndDateEvent event,
      Emitter<CaloriesCounterMainState> emit
      )async{
    emit(state.copyWith(userId: event.userId, date: event.date));
  }

  Future<void> _addMealBtnClicked(
      AddBtnClicked event,
      Emitter<CaloriesCounterMainState> emit
      )async{
    emit(state.copyWith(status: CaloriesCounterMainStatus.addMealBtnClicked, mealType: event.mealType));
  }

  Future<void> _init(
      LoadInitialDataEvent event,
      Emitter<CaloriesCounterMainState> emit
  )async{
    print("Calories Date load initial data");
    emit(state.copyWith(status: CaloriesCounterMainStatus.loading, mealList: {}));
    final mealList = await mealRepository.getUserMealListByDate(state.userId!, state.date!);
    final nutritionalSummary = await mealRepository.getNutritionalSummary(state.userId!, state.date!);
    emit(state.copyWith(status: CaloriesCounterMainStatus.mealListLoaded, mealList: mealList, summary: nutritionalSummary));
    print("summary: calories intake");
    print(state.summary?.caloriesIntake);
  }

  Future<void> _reload(
      ReloadMealList event,
      Emitter<CaloriesCounterMainState> emit
      )async{
    emit(state.copyWith(status: CaloriesCounterMainStatus.loading, mealList: {}));
    final mealList = await mealRepository.getUserMealListByDate(state.userId!, state.date!);
    final nutritionalSummary = await mealRepository.getNutritionalSummary(state.userId!, state.date!);
    emit(state.copyWith(status: CaloriesCounterMainStatus.mealListReloaded, mealList: mealList, summary: nutritionalSummary));
    emit(state.copyWith(status: CaloriesCounterMainStatus.initial));
  }

  Future<void> _delete(
      DeleteMealBtnClicked event,
      Emitter<CaloriesCounterMainState> emit
      )async{
    emit(state.copyWith(status: CaloriesCounterMainStatus.loading, mealList: {}));
    await mealRepository.deleteUserMeal(event.userMealId);
    final mealList = await mealRepository.getUserMealListByDate(state.userId!, state.date!);
    final nutritionalSummary = await mealRepository.getNutritionalSummary(state.userId!, state.date!);
    emit(state.copyWith(status: CaloriesCounterMainStatus.mealDeleted, mealList: mealList, summary: nutritionalSummary));
    // emit(state.copyWith(status: CaloriesCounterMainStatus.mealDeleted));
  }
}


