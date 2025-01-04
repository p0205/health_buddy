part of 'add_sport_bloc.dart';

enum AddSportStatus {
  initial,
  failure,
  sportAdded,
  sportTypeListSelected,
}


class AddSportState extends Equatable{
  final AddSportStatus status;
  final String? message;
  final List<SportTypeList>? sportTypeList;
  final String? selectedSportType;

   const AddSportState({
    this.status = AddSportStatus.initial,
    this.message,
    this.sportTypeList,
    this.selectedSportType
  });


  @override
  List<Object?> get props => [status,message,sportTypeList,selectedSportType];

  AddSportState copyWith ({
    Sport? sport,
    AddSportStatus? status,
    String? message,
    List<SportTypeList>? sportTypeList,
    String? selectedSportType
  })
  {
    return AddSportState(
      status: status ?? this.status,
      message:  message ?? this.message,
      sportTypeList:  sportTypeList ?? this.sportTypeList,
      selectedSportType:  selectedSportType ?? this.selectedSportType,
    );
  }
}




