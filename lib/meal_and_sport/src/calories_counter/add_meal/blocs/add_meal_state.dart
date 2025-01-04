part of 'add_meal_bloc.dart';

enum AddMealStatus {
  initial,
  loading,
  failure,
  mealAdded,
  fileUploaded,
  extractNutriSelected,
  nutriExtracted,
  reviewInfoLoaded,
  noTableDetected,
}


class AddMealState extends Equatable{

  final Meal? meal;
  final AddMealStatus status;
  final String? message;
  final bool isUnitWeightSelected;
  final File? file;
  final bool isReviewEditable;
  final double? uploadProgress;


  const AddMealState({
    this.status = AddMealStatus.initial,
    this.meal,
    this.message,
    this.isUnitWeightSelected = false,
    this.file,
    this.isReviewEditable = false,
    this.uploadProgress
  });


  @override
  List<Object?> get props => [status,meal,isUnitWeightSelected,file,isReviewEditable,uploadProgress];

  AddMealState copyWith ({
    Meal? meal,
    AddMealStatus? status,
    String? message,
    bool? isUnitWeightSelected,
    File? file,
    bool? isReviewEditable,
    double? uploadProgress
  })
  {
    return AddMealState(
        status: status ?? this.status,
        meal: meal ?? this.meal,
        message:  message ?? this.message,
        isUnitWeightSelected: isUnitWeightSelected?? this.isUnitWeightSelected,
        file: file ?? this.file,
        isReviewEditable: isReviewEditable ?? this.isReviewEditable,
        uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }
}




