
import 'package:health_buddy/meal_and_sport/src/sport/sport_repository/sport_data_provider.dart';

import '../sport_models/sport.dart';
import '../sport_models/sport_summary.dart';
import '../sport_models/user_sport.dart';

class SportRepository{

  final SportDataProvider sportDataProvider = SportDataProvider();

  Future<List<Sport>> searchMatchingSport (query) async {
    List<Sport> foods = await sportDataProvider.getMatchingSportList(query);
    return foods;
  }

  Future<Sport> getSport(int id) async{
    Sport sport = await sportDataProvider.getSport(id);
    return sport;
  }

  Future<void> addSport(Sport sport) async {
    await sportDataProvider.addSport(sport);
  }

  Future<List<String>> getDistinctSportTypes() async {
    return await sportDataProvider.getDistinctSportTypes();
  }

  Future<Map<String, List<UserSport>>> getUserSportListByDate(int userId, DateTime date) async {
    return await sportDataProvider.getUserSportListByDate(userId, date);
  }

  Future<void> addUserSport (int userId, int sportId, double durationInHours, double calsBurnt) async {
    await sportDataProvider.addUserSport(userId, sportId, durationInHours, calsBurnt);
  }

  Future<SportSummary> getSportSummary(int userId,DateTime date) async {
    return await sportDataProvider.getSportSummary(userId, date);
  }

  Future<void> deleteUserSport(int userSportId) async{
    await sportDataProvider.deleteUserSport(userSportId);
  }
}