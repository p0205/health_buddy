
part of 'search_meal_bloc.dart';

enum SearchFoodStatus {
  initial,
  loading,
  foodsLoaded,
  failure,
  selected,
  addNewMealSelected
}


class SearchFoodState extends Equatable{

  final List<Meal>? foods;
  final SearchFoodStatus status;
  final String? message;
  final Meal? selectedFood;

  const SearchFoodState({
    this.status = SearchFoodStatus.initial,
    this.foods = const [],
    this.message,
    this.selectedFood
});


  @override
  List<Object?> get props => [status,foods];

  SearchFoodState copyWith ({
    List<Meal>? foods,
    SearchFoodStatus? status,
    String? message,
    Meal? selectedFood
  })
  {
    return SearchFoodState(
      status: status ?? this.status,
      foods: foods ?? this.foods,
      message:  message ?? this.message,
      selectedFood: selectedFood ?? this.selectedFood
    );
  }
}




