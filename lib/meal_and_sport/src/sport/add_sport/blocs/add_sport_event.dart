part of 'add_sport_bloc.dart';

abstract class AddSportEvent extends Equatable{
  const AddSportEvent();
  @override
  List<Object?> get props => [];
}

class SportTypeListSelected extends AddSportEvent{}

class LoadSportTypeList extends AddSportEvent{}

class AddSportBtnSelectedEvent extends AddSportEvent{
  final String name;
  final double caloriesBurnt;

  const AddSportBtnSelectedEvent({required this.name, required this.caloriesBurnt});
}

class SportTypeSelected extends AddSportEvent{
  final String sportType;

  const SportTypeSelected({required this.sportType});
}

// type, name, caloriesBurnt

//type: dropDown list (with alphabet filter) with search bar?
// class AddMealBtnSelectedEvent extends AddSportEvent {
//   final String mealNameInputString;
//   final String? unitWeightInputString;
//   final String? energyInputString;
//   final String? carbsInputString;
//   final String? proteinInputString;
//   final String? fatInputString;
//
//   const AddMealBtnSelectedEvent(
//       {
//         required this.mealNameInputString,
//         required this.unitWeightInputString,
//         required this.energyInputString,
//         required this.carbsInputString,
//         required this.proteinInputString,
//         required this.fatInputString,
//       }
//       );
// }




