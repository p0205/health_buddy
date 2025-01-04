
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';


import '../../models/meal.dart';


import 'package:equatable/equatable.dart';

import '../../repository/meal_repository.dart';

part 'search_meal_state.dart';
part 'search_meal_event.dart';
class SearchFoodBloc extends Bloc<SearchFoodEvent,SearchFoodState>{

  final MealApiRepository foodApiRepository = MealApiRepository();

  SearchFoodBloc()
      : super(const SearchFoodState()) {
    on<SearchQueryChanged>(_searchMatchingFood,
        transformer: debounce(const Duration(milliseconds: 500)));

    on<FoodSelected>(_onSelectFood);
    on<BackToSearchFoodPage>(_backToSearchFoodPage);
    on<AddNewMealBtnSelected>(_addNewMealBtnSelected);
  }


    Future<void> _searchMatchingFood(
        SearchQueryChanged event,
        Emitter<SearchFoodState> emit
        ) async {
          if(event.query.length > 3){
            try{
              emit(state.copyWith(status: SearchFoodStatus.loading));
              final foods = await foodApiRepository.searchMatchingFood(event.query);
              emit(state.copyWith(status: SearchFoodStatus.foodsLoaded, foods: foods));
            }catch(e)
            {
              emit(state.copyWith(status: SearchFoodStatus.failure , message: e.toString()));
            }
          }else{
            emit(state.copyWith(status : SearchFoodStatus.initial , foods: []));
          }
      }

    EventTransformer<Event> debounce<Event>(Duration duration){
      return (event,mapper) => event.debounceTime(duration).flatMap(mapper);
    }

    Future<void> _onSelectFood(FoodSelected event, Emitter<SearchFoodState> emit) async {
      emit(state.copyWith(status:SearchFoodStatus.loading));

      try{
        final food = await foodApiRepository.selectFood(event.id);
        emit(state.copyWith(status: SearchFoodStatus.selected, selectedFood: food));
      }catch(e){
        emit(state.copyWith(status: SearchFoodStatus.failure, message: e.toString()));
      }
    }

  Future<void> _backToSearchFoodPage(BackToSearchFoodPage event, Emitter<SearchFoodState> emit) async {
    emit(state.copyWith(status:SearchFoodStatus.selected));
  }

  Future<void> _addNewMealBtnSelected(AddNewMealBtnSelected event, Emitter<SearchFoodState> emit) async {
    emit(state.copyWith(status:SearchFoodStatus.addNewMealSelected));
  }

  }
