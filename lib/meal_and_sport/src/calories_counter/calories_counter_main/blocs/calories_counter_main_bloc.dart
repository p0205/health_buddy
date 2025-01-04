import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/meal_summary.dart';
import '../../models/user_meal.dart';
import '../../repository/meal_repository.dart';

part 'calories_counter_main_event.dart';
part 'calories_counter_main_state.dart';

class CaloriesCounterMainBloc extends Bloc<CaloriesCounterMainEvent,CaloriesCounterMainState>{
  final MealApiRepository mealRepository = MealApiRepository();
  int userId;
  DateTime date;

  CaloriesCounterMainBloc({required this.userId, required this.date}): super(const CaloriesCounterMainState(status: CaloriesCounterMainStatus.loading)){
    on<AddBtnClicked>(_addMealBtnClicked);
    on<LoadInitialDataEvent>(_init);
    on<ReloadMealList>(_reload);
    on<DeleteMealBtnClicked>(_delete);
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
    emit(state.copyWith(status: CaloriesCounterMainStatus.loading, mealList: {}));
    final mealList = await mealRepository.getUserMealListByDate(userId, date);
    final nutritionalSummary = await mealRepository.getNutritionalSummary(userId,date);
    emit(state.copyWith(status: CaloriesCounterMainStatus.mealListLoaded, mealList: mealList, summary: nutritionalSummary));
  }

  Future<void> _reload(
      ReloadMealList event,
      Emitter<CaloriesCounterMainState> emit
      )async{
    emit(state.copyWith(status: CaloriesCounterMainStatus.loading, mealList: {}));
    final mealList = await mealRepository.getUserMealListByDate(userId, date);
    final nutritionalSummary = await mealRepository.getNutritionalSummary(userId,date);
    emit(state.copyWith(status: CaloriesCounterMainStatus.mealListReloaded, mealList: mealList, summary: nutritionalSummary));
  }

  Future<void> _delete(
      DeleteMealBtnClicked event,
      Emitter<CaloriesCounterMainState> emit
      )async{
    emit(state.copyWith(status: CaloriesCounterMainStatus.loading, mealList: {}));
    await mealRepository.deleteUserMeal(event.userMealId);
    emit(state.copyWith(status: CaloriesCounterMainStatus.loading, mealList: {}));
    final mealList = await mealRepository.getUserMealListByDate(userId, date);
    final nutritionalSummary = await mealRepository.getNutritionalSummary(userId,date);



    emit(state.copyWith(status: CaloriesCounterMainStatus.mealDeleted, mealList: mealList, summary: nutritionalSummary));
    // emit(state.copyWith(status: CaloriesCounterMainStatus.mealDeleted));
  }
}


