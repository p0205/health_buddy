part of 'add_meal_bloc.dart';

abstract class AddMealEvent extends Equatable{
  const AddMealEvent();
  @override
  List<Object?> get props => [];
}

class AddMealBtnSelectedEvent extends AddMealEvent {
  final String mealNameInputString;
  final String? unitWeightInputString;
  final String? energyInputString;
  final String? carbsInputString;
  final String? proteinInputString;
  final String? fatInputString;

  const AddMealBtnSelectedEvent(
      {
        required this.mealNameInputString,
        required this.unitWeightInputString,
        required this.energyInputString,
        required this.carbsInputString,
        required this.proteinInputString,
        required this.fatInputString,
      }
  );
}

class Per100SelectedEvent extends AddMealEvent {}

class UnitWeightSelectedEvent extends AddMealEvent {}

class UploadFileEvent extends AddMealEvent{}

class UpdateProgressEvent extends AddMealEvent {
  final double progress;

  const UpdateProgressEvent(this.progress);
}

class ExtractNutriEvent extends AddMealEvent{
  final File file;
  final String name;
  const ExtractNutriEvent({required this.file, required this.name});
}

class ToggleEditableEvent extends AddMealEvent{}

class ReviewPageLoadedEvent extends AddMealEvent{}



