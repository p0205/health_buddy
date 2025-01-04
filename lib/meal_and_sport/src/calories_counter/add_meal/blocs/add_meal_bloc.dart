import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/meal.dart';
import '../../repository/meal_repository.dart';

part 'add_meal_state.dart';
part 'add_meal_event.dart';

class AddMealBloc extends Bloc<AddMealEvent,AddMealState>{

  final MealApiRepository mealRepository = MealApiRepository();

  AddMealBloc() : super(const AddMealState()) {
    on<Per100SelectedEvent>(_per100SelectedEvent);
    on<UnitWeightSelectedEvent>(_unitWeightSelectedEvent);
    on<AddMealBtnSelectedEvent>(_addMealBtnSelectedEvent);
    on<UploadFileEvent>(_uploadFile);
    on<ExtractNutriEvent>(_extractNutri);
    on<ToggleEditableEvent>(_toggleEditable);
    on<ReviewPageLoadedEvent>(_reviewPageLoaded);
  }
  Future<void> _reviewPageLoaded(ReviewPageLoadedEvent event, Emitter<AddMealState> emit) async {
    emit(state.copyWith(status: AddMealStatus.reviewInfoLoaded));
  }

  Future<void> _toggleEditable(ToggleEditableEvent event, Emitter<AddMealState> emit) async {
    emit(state.copyWith(isReviewEditable: !state.isReviewEditable));
  }

  Future<void> _per100SelectedEvent(Per100SelectedEvent event, Emitter<AddMealState> emit) async {
    emit(state.copyWith(isUnitWeightSelected: false));
  }

  Future<void> _unitWeightSelectedEvent(UnitWeightSelectedEvent event, Emitter<AddMealState> emit) async {
    emit(state.copyWith(isUnitWeightSelected: true));
  }

  Future<void> _addMealBtnSelectedEvent(AddMealBtnSelectedEvent event, Emitter<AddMealState> emit) async {
    double unitWeight;
    double? energyPer100g;
    double? carbsPer100g;
    double? proteinPer100g;
    double? fatPer100g;

    String name = event.mealNameInputString;

    event.energyInputString != "" ?
    energyPer100g = double.parse(event.energyInputString!) : null;

    event.carbsInputString != "" ?
    carbsPer100g = double.parse(event.carbsInputString!) : null;

    event.proteinInputString != "" ?
    proteinPer100g = double.parse(event.proteinInputString!) : null;

    event.fatInputString != "" ?
    fatPer100g = double.parse(event.fatInputString!) : null;
    try{
      final Meal meal;
      if(state.isUnitWeightSelected){
        unitWeight = double.parse(event.unitWeightInputString!);
        double factor = unitWeight/100;
        energyPer100g!=null ? energyPer100g = (energyPer100g/factor) : null;
        carbsPer100g!=null ? carbsPer100g = carbsPer100g/factor : null;
        proteinPer100g!=null ? proteinPer100g = proteinPer100g/factor : null;
        fatPer100g!=null ? fatPer100g = fatPer100g/factor : null;
        meal = Meal(name: name, unitWeight: unitWeight, energyPer100g: energyPer100g, carbsPer100g: carbsPer100g, proteinPer100g:proteinPer100g, fatPer100g: fatPer100g);
      }else{
        meal = Meal(name: name, energyPer100g: energyPer100g, carbsPer100g: carbsPer100g, proteinPer100g:proteinPer100g, fatPer100g: fatPer100g);
      }
      await mealRepository.addMeal(meal);
      emit(state.copyWith(status: AddMealStatus.mealAdded));
    }catch(e){
      emit(state.copyWith(status: AddMealStatus.failure,message: e.toString()));
    }
  }

  Future<void> _extractNutri (
      ExtractNutriEvent event,
      Emitter<AddMealState> emit
      )async{
    try{
      emit(state.copyWith(status: AddMealStatus.loading));
      Meal? meal = await mealRepository.extractNutrition(event.file);
      meal!.name = event.name;
      emit(state.copyWith(status: AddMealStatus.nutriExtracted, meal: meal));
    }catch(e){
      emit(state.copyWith(status: AddMealStatus.failure,message: e.toString()));
    }
  }

  Future<void> _uploadFile (
      UploadFileEvent event,
      Emitter<AddMealState> emit
      )async{
    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        // allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        final file = File(result.files.single.path!);
        emit(state.copyWith(status: AddMealStatus.fileUploaded, file: file));
      } else {
        emit(state.copyWith(status: AddMealStatus.failure,message:"No file selected"));
      }
    }catch(e){
      emit(state.copyWith(status: AddMealStatus.failure,message: e.toString()));
    }
  }

// Future<void> _searchMatchingFood(
  //     SearchQueryChanged event,
  //     Emitter<SearchFoodState> emit
  //     ) async {
  //   if(event.query.length > 3){
  //     try{
  //       emit(state.copyWith(status: SearchFoodStatus.loading));
  //       final foods = await foodApiRepository.searchMatchingFood(event.query);
  //       emit(state.copyWith(status: SearchFoodStatus.foodsLoaded, foods: foods));
  //     }catch(e)
  //     {
  //       emit(state.copyWith(status: SearchFoodStatus.failure , message: e.toString()));
  //     }
  //   }else{
  //     emit(state.copyWith(status : SearchFoodStatus.initial , foods: []));
  //   }
  // }
  //
  // EventTransformer<Event> debounce<Event>(Duration duration){
  //   return (event,mapper) => event.debounceTime(duration).flatMap(mapper);
  // }
  //
  // Future<void> _onSelectFood(FoodSelected event, Emitter<SearchFoodState> emit) async {
  //   emit(state.copyWith(status:SearchFoodStatus.loading));
  //
  //   try{
  //     final food = await foodApiRepository.selectFood(event.id);
  //     emit(state.copyWith(status: SearchFoodStatus.selected, selectedFood: food));
  //   }catch(e){
  //     emit(state.copyWith(status: SearchFoodStatus.failure, message: e.toString()));
  //   }
  // }
  //

  //
  // Future<void> _addNewMealBtnSelected(AddNewMealBtnSelected event, Emitter<SearchFoodState> emit) async {
  //   emit(state.copyWith(status:SearchFoodStatus.addNewMealSelected));
  // }

}
