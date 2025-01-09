//search food return List<Food> (id ,name)
//search specific food return Food


import 'dart:convert';
import 'dart:core';
import 'dart:io' show File, Platform;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../models/meal_summary.dart';
import '../models/user_meal.dart';

//Exception throw when foodSearch fails
class GetMatchingFoodListFailure implements Exception{}
class GetFoodFailure implements Exception{}
class AddMealFailure implements Exception{}
class AddUserMealFailure implements Exception{}
class DeleteUserMealFailure implements Exception{}
class GetUserMealListByDateFailure implements Exception{}
class GetNutritionalSummaryFailure implements Exception{}

class MealApiProvider{

  final String _baseUrl;
  final http.Client _httpClient;
  final dio = Dio();

  MealApiProvider({http.Client? httpClient})
      : _baseUrl = _getBaseUrl(),
        _httpClient = httpClient ?? http.Client();


  static String _getBaseUrl() {
    if (Platform.isAndroid) {
      return "10.0.2.2:8080"; // Android emulator localhost

    } else {
      return "localhost:8080";
    }
  }

  // // physical Android devices
  // static String _getBaseUrl() {
  //   return "10.131.76.45:8080";
  // }
  //
  // static String _getBaseUrl() {
  //   return "192.168.18.30:8080";
  // }

  // api : localhost:8080/meal/search
  Future<List<Meal>> getMatchingMealList(String query) async {
    final uri = Uri.http(_baseUrl,"/meal/search",{'name':query});
    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw GetMatchingFoodListFailure();
    }
    List<Meal> foods =  Meal.fromJsonArray(json.decode(response.body));
    return foods;
  }

  // api : GET localhost:8080/meal/{mealId}
  Future<Meal> getMeal(int id) async {

    final uri = Uri.http(_baseUrl,"/meal/${id.toString()}");

    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw GetFoodFailure();
    }
    Meal food =  Meal.fromJson(json.decode(response.body));
    return food;
  }

  // api : POST localhost:8080/meal
  Future<void> addMeal(Meal meal)async{

    final uri = Uri.http(_baseUrl,"/meal");

    final response = await _httpClient.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(meal));

    if(response.statusCode != 201){
      throw AddMealFailure();
    }
  }

  // api : GET localhost:8080/meal/user?userId=?,date=?
  Future<Map<String, List<UserMeal>>> getUserMealListByDate(int userId, DateTime date) async {
    String formatedDate = formatDate(date);

    final uri = Uri.http(_baseUrl,"/meal/user",{"userId": userId.toString(), "date": formatedDate});
    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){

      throw GetUserMealListByDateFailure();
    }

    final Map<String, dynamic> data = json.decode(response.body);
    return data.map((key, value) {
      final meals = (value as List).map((meal) => UserMeal.fromJson(meal)).toList();
      return MapEntry(key, meals);
    });
  }


  Future<void> addUserMeal(UserMeal userMeal) async {

    // final uri = Uri.http(_baseUrl,"/meal/user",{"userId": userId.toString()});
    final uri = Uri.http(_baseUrl,"/meal/user");
    final response = await _httpClient.post(
        uri,
        headers: {"Content-Type": "application/json"},

        body: jsonEncode(userMeal)
    );

    if(response.statusCode != 201){
      throw AddUserMealFailure();
    }
  }

  Future<MealSummary> getNutritionalSummary(int userId,DateTime date) async{
    String formatedDate = formatDate(date);

    final uri = Uri.http(_baseUrl,"/meal/user/summary",{"userId": userId.toString(), "date": formatedDate});
    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){

      throw GetNutritionalSummaryFailure();
    }
    final Map<String, dynamic> data = json.decode(response.body);
    return MealSummary.fromJson(data);
  }

  // api : GET localhost:8080/meal/user/{mealId}
  Future<UserMeal?> getUserMeal(int userId, int mealId) async { return null;}

  // api : DELETE localhost:8080/meal/user/{userMealId}
  Future<void> deleteUserMeal(int userMealId) async {
    final uri = Uri.http(_baseUrl,"/meal/user/delete/${userMealId.toString()}");
    final response = await _httpClient.delete(uri);
    if(response.statusCode != 204){
      throw DeleteUserMealFailure();
    }
  }



  // Future<Meal?> extractNutrition(File file, StreamController<double> progressController) async {
  //   final uri = Uri.http(_baseUrl, "/image/extract");
  //   final formData = FormData.fromMap({
  //     'file': await MultipartFile.fromFile(file.path),
  //   });
  //
  //   try {
  //     final response = await dio.post(
  //       uri.toString(),
  //       data: formData,
  //       onSendProgress: (int sent, int total) {
  //         // Emit progress as a value between 0.0 and 1.0
  //         progressController.add(sent / total);
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // Return the Meal object after successful upload
  //       return Meal.fromJson(response.data);
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     throw Exception("File upload failed: $e");
  //   } finally {
  //     progressController.close();
  //   }
  // }
  Future<Meal?> extractNutrition(File file) async{
    final uri = Uri.http(_baseUrl,"/image/extract");
    // var request = http.MultipartRequest("POST",uri);
    // request.files.add(await http.MultipartFile.fromPath("file",file.path));
    //
    // var response = await request.send();
    // if(response.statusCode == 200){
    //   //TODO: Upload successfully
    //   print("Uploaded");
    // }else{
    //   //TODO: Handle error
    // }
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    final response = await dio.post(
        uri.toString(),
        data: formData,
        onSendProgress: (int sent, int total) {
      },);
    if(response.statusCode == 200){
      //TODO: Upload successfully
      Meal meal = Meal.fromJson((response.data));
      return meal;
    }else{
      return null;
    }
  }

}

String formatDate(DateTime dateTime){
  return dateTime.toString().split(' ')[0];
}
