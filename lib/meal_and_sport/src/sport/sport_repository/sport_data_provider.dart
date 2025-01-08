import 'dart:convert';
import 'dart:core';
import 'dart:io' show Platform;

import 'package:http/http.dart' as http;

import '../sport_models/sport.dart';
import '../sport_models/sport_summary.dart';
import '../sport_models/user_sport.dart';

//Exception throw when foodSearch fails
class SearchMatchingSportListFailure implements Exception{}
class GetSportFailure implements Exception{}
class AddSportFailure implements Exception{}
class AddUserSportFailure implements Exception{}
class GetUserSportFailure implements Exception{}
class GetTotalCalsBurntFailure implements Exception{}
class DeleteUserSportFailure implements Exception{}
class GetDistinctSportTypesFailure implements Exception{}

class SportDataProvider{

  final String _baseUrl;
  final http.Client _httpClient;

  SportDataProvider({http.Client? httpClient})
      : _baseUrl = _getBaseUrl(),
        _httpClient = httpClient ?? http.Client();

  //emulator
  // static String _getBaseUrl() {
  //   if (Platform.isAndroid) {
  //     return "10.0.2.2:8080"; // Android emulator localhost
  //
  //   } else {
  //     return "localhost:8080";
  //   }
  // }

  // //physical device
  // static String _getBaseUrl() {
  //   return "192.168.1.3:8080";
  // // }
  static String _getBaseUrl() {
    return "10.0.2.2:8080";
  }

  // api : GET localhost:8080/sport/search
  Future<List<Sport>> getMatchingSportList(String query) async {

    final uri = Uri.http(_baseUrl,"/sport/search",{'query':query});
    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw SearchMatchingSportListFailure();
    }
    List<Sport> sports =  Sport.fromJsonArray(json.decode(response.body));
    return sports;
  }

  // api : GET localhost:8080/sport/{sportId}
  Future<Sport> getSport(int id) async {
    final uri = Uri.http(_baseUrl,"/sport/${id.toString()}");

    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw GetSportFailure();
    }
    Sport sport =  Sport.fromJson(json.decode(response.body));
    return sport;
  }

  // api : POST localhost:8080/sport
  Future<void> addSport(Sport sport)async{
    final uri = Uri.http(_baseUrl,"/sport");

    final response = await _httpClient.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(sport));

    if(response.statusCode != 201){
      throw AddSportFailure();
    }
  }

  // api : GET localhost:8080/sport/type
  Future<List<String>> getDistinctSportTypes() async {

    final uri = Uri.http(_baseUrl,"/sport/types");
    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw GetDistinctSportTypesFailure();
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => item.toString()).toList();
  }

  // api : GET localhost:8080/sport/user/{userId}?date=?
  Future<Map<String, List<UserSport>>> getUserSportListByDate(int userId, DateTime date) async {

    String formatedDate = formatDate(date);

    final uri = Uri.http(_baseUrl,"/sport/user/${userId.toString()}",{"date": formatedDate});
    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw GetUserSportFailure();
    }

    final Map<String, dynamic> data = json.decode(response.body);
    return data.map((key, value) {
      final sports = (value as List).map((sport) => UserSport.fromJson(sport)).toList();
      return MapEntry(key, sports);
    });
  }

  // api : POST localhost:8080/sport/user
  Future<void> addUserSport(int userId,int sportId, double durationInHours, double caloriesBurnt) async {

    Map<String,Object> request = {
      "userId": userId,
      "sportId": sportId,
      "durationInHours": durationInHours,
    };

    final uri = Uri.http(_baseUrl,"/sport/user");

    final response = await _httpClient.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request)
    );
    if(response.statusCode != 201){
      throw AddUserSportFailure();
    }


  }

  // api : GET localhost:8080/sport/user/{userId}/summary?date=?
  Future<SportSummary> getSportSummary(int userId,DateTime date) async{
    String formatedDate = formatDate(date);

    final uri = Uri.http(_baseUrl,"/sport/user/${userId.toString()}/summary",{"date": formatedDate});
    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw GetTotalCalsBurntFailure();
    }

    final Map<String, dynamic> data = json.decode(response.body);

    return SportSummary.fromJson(data);
  }

  // api : GET localhost:8080/sport/{userId}/{sportId}?date=?
  // Future<UserSport?> getUserSport(int userId, int sportId, DateTime date) async { return null;}

  // api : DELETE localhost:8080/sport/user/{userSportId}
  Future<void> deleteUserSport(int userSportId) async {
    final uri = Uri.http(_baseUrl,"/sport/user/${userSportId.toString()}");
    final response = await _httpClient.delete(uri);
    if(response.statusCode != 204){
      throw DeleteUserSportFailure();
    }
  }


}

String formatDate(DateTime dateTime){
  return dateTime.toString().split(' ')[0];
}
