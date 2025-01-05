part of 'sport_main_bloc.dart';


enum SportMainStatus{
  initial,
  loading,
  noRecordFound,
  sportListLoaded,
  sportAdded,
  addSportBtnClicked,
  sportDeleted,
}

class SportMainState extends Equatable{
  final int? userId;
  final DateTime? date;
  final Map<String, List<UserSport>?> sportList;
  final SportMainStatus status;
  final SportSummary? sportSummary;
  final String? dateString;

  const SportMainState({
    this.userId,
    this.date,
    this.sportList = const {},
    this.status = SportMainStatus.initial,
    this.sportSummary,
    this.dateString
  });

  @override
  List<Object?> get props => [status,sportList,sportSummary,date];

  SportMainState copyWith({
     int? userId,
     DateTime? date,
    Map<String, List<UserSport>?>? sportList,
    SportMainStatus? status,
    SportSummary? sportSummary,
    String? dateString
  }){
    return SportMainState(
        userId: userId ?? this.userId,
        date: date ?? this.date,
        status: status ?? this.status,
      sportList: sportList ?? this.sportList,
      sportSummary: sportSummary ?? this.sportSummary,
      dateString:  dateString ?? this.dateString
    );
  }

}
