// mealAdded
// fail
// loading
// initial
// unsaved
part of 'add_meal_bloc.dart';

enum AddUserMealStatus{
  initial,
  loading,
  mealAdded,
  failure
}


class AddUserMealState extends Equatable {
  final AddUserMealStatus status;
  final double? amountIntakeInGrams;
  final double? carbsIntake;
  final double? proteinIntake;
  final double? fatIntake;
  final double? energyIntake;
  final String? message;
  final bool isNoOfServingSelected;
  final bool isCalculated;
  final int userId;
  final int mealId;


  const AddUserMealState({
    required this.userId,
    required this.mealId,
    this.status = AddUserMealStatus.initial,
    this.isNoOfServingSelected = false,
    this.isCalculated = false,
    this.amountIntakeInGrams,
    this.carbsIntake,
    this.proteinIntake,
    this.fatIntake,
    this.energyIntake,
    this.message
  });

  @override
  List<Object?> get props => [userId, mealId, status, amountIntakeInGrams, carbsIntake, proteinIntake, fatIntake,energyIntake, message, isNoOfServingSelected, isCalculated];


  AddUserMealState copyWith({
    int? userId,
    int? mealId,
    AddUserMealStatus? status,
    bool? isNoOfServingSelected,
    bool? isCalculated,
    double? amountIntakeInGrams,
    double? carbsIntake,
    double? proteinIntake,
    double? fatIntake,
    double? energyIntake,
    String? message

  }) {

    return AddUserMealState(
      userId: userId ?? this.userId,
      mealId: mealId ?? this.userId,
      status: status ?? this.status,
      isNoOfServingSelected: isNoOfServingSelected?? this.isNoOfServingSelected,
      isCalculated: isCalculated ?? this.isCalculated,
      amountIntakeInGrams: amountIntakeInGrams ?? this.amountIntakeInGrams,
      carbsIntake: carbsIntake ?? this.carbsIntake,
      proteinIntake: proteinIntake ?? this.proteinIntake,
      fatIntake: fatIntake ?? this.fatIntake,
      energyIntake: energyIntake ?? this.energyIntake,
      message: message ?? this.message,
    );
  }
}
