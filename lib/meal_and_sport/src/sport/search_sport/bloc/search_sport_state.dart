

part of 'search_sport_bloc.dart';


enum SearchSportStatus {
  initial,
  loading,
  sportsLoaded,
  failure,
  selected,
  addNewSportSelected
}


class SearchSportState extends Equatable{

  final List<Sport>? sports;
  final SearchSportStatus status;
  final String? message;
  final Sport? selectedSport;

  const SearchSportState({
    this.status = SearchSportStatus.initial,
    this.sports = const [],
    this.message,
    this.selectedSport
  });


  @override
  List<Object?> get props => [status,sports];

  SearchSportState copyWith ({
    List<Sport>? sports,
    SearchSportStatus? status,
    String? message,
    Sport? selectedSport
  })
  {
    return SearchSportState(
        status: status ?? this.status,
        sports: sports ?? this.sports,
        message:  message ?? this.message,
        selectedSport: selectedSport ?? this.selectedSport
    );
  }
}




