part of 'add_meal_bloc.dart';

abstract class AddUserMealEvent extends Equatable{
  const AddUserMealEvent();


  @override
  List<Object?> get props => [];
}

class NoOfServingsSelected extends AddUserMealEvent{}
class AmountInGramsSelected extends AddUserMealEvent{}

class UserInput extends AddUserMealEvent{

  final double userInput;
  final Meal food;

  const UserInput({required this.food , required this.userInput});
  @override
  List<Object?> get props => [food, userInput];
}


class DisposeCalculation extends AddUserMealEvent{}

class CalculateBtnClicked extends AddUserMealEvent{

}

class AddMealBtnClicked extends AddUserMealEvent{

  final String mealType;
  final double amountInGrams;
  final double? carbsInGrams;
  final double? proteinInGrams;
  final double? fatInGrams;
  final double? calories;


  const AddMealBtnClicked(
      {
        required this.mealType,
        required this.amountInGrams,
        required this.carbsInGrams,
        required this.proteinInGrams,
        required this.fatInGrams,
        required this.calories,
      }
      );
  @override
  List<Object?> get props => [ mealType, amountInGrams, carbsInGrams, proteinInGrams, fatInGrams, calories];
}
