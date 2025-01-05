
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
  final int? userId;
  final DateTime? date;
  final Map<String, List<UserMeal>?>? mealList;
  final CaloriesCounterMainStatus status;
  final MealSummary? summary;

  const CaloriesCounterMainState({
    this.mealList = const {},
    this.status = CaloriesCounterMainStatus.initial,
    this.summary,
    this.date,
    this.userId
});

  @override
  List<Object?> get props => [status,mealList,summary,date];

  CaloriesCounterMainState copyWith({
    Map<String, List<UserMeal>?>? mealList,
    CaloriesCounterMainStatus? status,
    String? mealType,
    MealSummary? summary,
     int? userId,
     DateTime? date
}){
    return CaloriesCounterMainState(
        status: status ?? this.status,
        mealList: mealList ?? this.mealList,
        summary: summary ?? this.summary,
      userId: userId ?? this.userId,
      date: date ?? this.date,
    );
  }

}
