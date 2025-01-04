import 'package:azlistview/azlistview.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../sport_models/sport.dart';
import '../../sport_repository/sport_repository.dart';

part 'add_sport_event.dart';
part 'add_sport_state.dart';

class AddSportBloc extends Bloc<AddSportEvent,AddSportState>{

  final SportRepository sportRepository = SportRepository();

  AddSportBloc() : super( const AddSportState()) {
    on<SportTypeListSelected>(_sportTypeListSelected);
    // on<LoadSportTypeList>(_loadSportTypeList);
    on<AddSportBtnSelectedEvent>(_addSportBtnSelected);
    on<SportTypeSelected>(_sportTypeSelected);

    on<AddSportEvent>((event, emit) {
    });
  }

  Future<void> _sportTypeListSelected(SportTypeListSelected event, Emitter<AddSportState> emit) async {
    List<String> sportTypeNameList = await sportRepository.getDistinctSportTypes();
    List<SportTypeList> items = initList(sportTypeNameList);
    emit(state.copyWith(sportTypeList: items,selectedSportType: null, status: AddSportStatus.sportTypeListSelected));
  }

  Future<void> _addSportBtnSelected(AddSportBtnSelectedEvent event, Emitter<AddSportState> emit) async {
    try{
      Sport sport = Sport(name: event.name, caloriesBurntPerHourPerKg: event.caloriesBurnt, type: state.selectedSportType);
      await sportRepository.addSport(sport);
      emit(state.copyWith(status: AddSportStatus.sportAdded));
    }catch(e){
      emit(state.copyWith(status: AddSportStatus.failure, message: e.toString()));
    }
  }

  Future<void> _sportTypeSelected(SportTypeSelected event, Emitter<AddSportState> emit) async {
    emit(state.copyWith(selectedSportType: event.sportType, status: AddSportStatus.initial ));
  }
}

class SportTypeList extends ISuspensionBean{
  final String title;
  final String tag;
  SportTypeList({required this.title,required this.tag});

  @override
  String getSuspensionTag() => tag;
}

List<SportTypeList> initList(List<String> items){
  return items.map((item)=> SportTypeList(title: item, tag: item[0])).toList();
}