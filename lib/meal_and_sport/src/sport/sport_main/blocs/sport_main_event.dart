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

class SportLoadUserIdAndDateEvent extends SportMainEvent{
  final int userId;
  final DateTime? date;
  const SportLoadUserIdAndDateEvent({required this.userId, required this.date});
  @override
  List<Object?> get props => [userId,date];
}

