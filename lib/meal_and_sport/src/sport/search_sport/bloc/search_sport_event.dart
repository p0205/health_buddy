part of 'search_sport_bloc.dart';

abstract class SearchSportEvent extends Equatable{
  const SearchSportEvent();
  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchSportEvent{
  final String query;

  //constructor
  const SearchQueryChanged({required this.query});

  List<Object?> get props => [query];
}

class SportSelectedEvent extends SearchSportEvent{
  final int id;
  const SportSelectedEvent({required this.id});
}

class BackToSearchSportPageEvent extends SearchSportEvent{
  const BackToSearchSportPageEvent();
}

class AddNewSportBtnSelectedEvent extends SearchSportEvent{
  const AddNewSportBtnSelectedEvent();
}

