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
  final Map<String, List<UserSport>?> sportList;
  final SportMainStatus status;
  final SportSummary? sportSummary;
  final String? dateString;

  const SportMainState({
    this.sportList = const {},
    this.status = SportMainStatus.initial,
    this.sportSummary,
    this.dateString
  });

  @override
  List<Object?> get props => [status,sportList,sportSummary];

  SportMainState copyWith({
    Map<String, List<UserSport>?>? sportList,
    SportMainStatus? status,
    SportSummary? sportSummary,
    String? dateString
  }){
    return SportMainState(
      status: status ?? this.status,
      sportList: sportList ?? this.sportList,
      sportSummary: sportSummary ?? this.sportSummary,
      dateString:  dateString ?? this.dateString
    );
  }

}
