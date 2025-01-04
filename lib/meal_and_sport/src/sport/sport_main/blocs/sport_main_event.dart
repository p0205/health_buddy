part of 'sport_main_bloc.dart';

abstract class SportMainEvent extends Equatable{
  const SportMainEvent();

  @override
  List<Object?> get props => [];
}

class AddBtnClicked extends SportMainEvent {

  const AddBtnClicked();
  @override
  List<Object?> get props => [];
}

class LoadUserSportList extends SportMainEvent {}

class SportAdded extends SportMainEvent {}

class DeleteSportBtnClicked extends SportMainEvent{
  final int userSportId;
  const DeleteSportBtnClicked({required this.userSportId});
  @override
  List<Object?> get props => [userSportId];
}

