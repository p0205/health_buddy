import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../sport_models/sport_summary.dart';
import '../../sport_models/user_sport.dart';
import '../../sport_repository/sport_repository.dart';

part 'sport_main_event.dart';
part 'sport_main_state.dart';

class SportMainBloc extends Bloc<SportMainEvent,SportMainState>{
  final SportRepository sportRepository = SportRepository();


  SportMainBloc(): super(const SportMainState(status: SportMainStatus.loading)){
    on<AddBtnClicked>(_addSportBtnClicked);
    on<LoadUserSportList>(_loadUserSportList);
    on<SportAdded>(_sportAdded);
    on<DeleteSportBtnClicked>(_delete);
    on<SportLoadUserIdAndDateEvent>(_loadIdAndDate);
    on<SportDateChangedEvent>(_onDateChanged);
  }

  Future<void> _onDateChanged(
      SportDateChangedEvent event,
      Emitter<SportMainState> emit
      )async{
    emit(state.copyWith(date: event.date));
    add(LoadUserSportList());
  }

  Future<void> _loadIdAndDate(
      SportLoadUserIdAndDateEvent event,
      Emitter<SportMainState> emit
      )async{
    emit(state.copyWith(userId: event.userId, date: event.date));
  }

  Future<void> _addSportBtnClicked(
      AddBtnClicked event,
      Emitter<SportMainState> emit
      )async{
    emit(state.copyWith(status: SportMainStatus.addSportBtnClicked));
  }

  Future<void> _loadUserSportList(
      LoadUserSportList event,
      Emitter<SportMainState> emit
      )async{
    emit(state.copyWith(status: SportMainStatus.loading, sportList: {}));
    final sportList = await sportRepository.getUserSportListByDate(state.userId!, state.date!);
    final SportSummary sportSummary = await sportRepository.getSportSummary(state.userId!, state.date!);
    if(sportList.isNotEmpty){
      emit(state.copyWith(status: SportMainStatus.sportListLoaded, sportList: sportList, sportSummary: sportSummary, dateString: sportSummary.date.toString().split(' ')[0]));
    }else{
      emit(state.copyWith(status: SportMainStatus.noRecordFound, dateString: sportSummary.date.toString().split(' ')[0]));
    }
  }

  Future<void> _sportAdded(
      SportAdded event,
      Emitter<SportMainState> emit
      )async{
    emit(state.copyWith(status: SportMainStatus.loading, sportList: {}));
    final sportList = await sportRepository.getUserSportListByDate(state.userId!, state.date!);
    final SportSummary sportSummary = await sportRepository.getSportSummary(state.userId!, state.date!);
    if(sportList.isNotEmpty){
      emit(state.copyWith(status: SportMainStatus.sportAdded, sportList: sportList, sportSummary: sportSummary, dateString: sportSummary.date.toString().split(' ')[0]));

    }else{
      emit(state.copyWith(status: SportMainStatus.noRecordFound, dateString: sportSummary.date.toString().split(' ')[0]));
    }
  }

  Future<void> _delete(
      DeleteSportBtnClicked event,
      Emitter<SportMainState> emit
      )async{
    emit(state.copyWith(status: SportMainStatus.loading, sportList: {}));
    await sportRepository.deleteUserSport(event.userSportId);
    final sportList = await sportRepository.getUserSportListByDate(state.userId!, state.date!);
    final SportSummary sportSummary = await sportRepository.getSportSummary(state.userId!, state.date!);
    if(sportList.isNotEmpty){
      emit(state.copyWith(status: SportMainStatus.sportDeleted, sportList: sportList, sportSummary: sportSummary, dateString: sportSummary.date.toString().split(' ')[0]));
    }else{
      emit(state.copyWith(status: SportMainStatus.noRecordFound, dateString: sportSummary.date.toString().split(' ')[0]));
    }
  }
}


