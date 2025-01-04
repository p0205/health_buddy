
part of 'calories_counter_main_bloc.dart';

enum CaloriesCounterMainStatus{
  initial,
  loading,
  mealListLoaded,
  mealListReloaded,
  addMealBtnClicked,
  mealDeleted
}

class CaloriesCounterMainState extends Equatable{
  final Map<String, List<UserMeal>?>? mealList;
  final CaloriesCounterMainStatus status;
  final MealSummary? summary;

  const CaloriesCounterMainState({
    this.mealList = const {},
    this.status = CaloriesCounterMainStatus.initial,
    this.summary,
});

  @override
  List<Object?> get props => [status,mealList,summary];

  CaloriesCounterMainState copyWith({
    Map<String, List<UserMeal>?>? mealList,
    CaloriesCounterMainStatus? status,
    String? mealType,
    MealSummary? summary
}){
    return CaloriesCounterMainState(
        status: status ?? this.status,
        mealList: mealList ?? this.mealList,
        summary: summary ?? this.summary,
    );
  }

}
