
import 'dart:async';
import 'dart:io';
import '../models/meal.dart';
import '../models/meal_summary.dart';
import '../models/user_meal.dart';
import 'meal_data_provider.dart';


class MealApiRepository{

  final MealApiProvider mealApiProvider = MealApiProvider();

  Future<List<Meal>> searchMatchingFood (query) async {
    List<Meal> foods = await mealApiProvider.getMatchingMealList(query);
    return foods;
  }

  Future<Meal> selectFood(int id) async{
    Meal food = await mealApiProvider.getMeal(id);
    return food;
  }

  Future<void> addMeal(Meal meal) async {
    await mealApiProvider.addMeal(meal);
  }

  Future<Map<String, List<UserMeal>>> getUserMealListByDate(int userId, DateTime date) async {
    return await mealApiProvider.getUserMealListByDate(userId, date);
  }


  Future<void> addUserMeal (UserMeal userMeal) async {
    await mealApiProvider.addUserMeal(userMeal);
  }

  Future<MealSummary> getNutritionalSummary(int userId,DateTime date) async {

    return await mealApiProvider.getNutritionalSummary(userId, date);
  }

  Future<void> deleteUserMeal(int userMealId) async{
    await mealApiProvider.deleteUserMeal(userMealId);
  }
  Future<Meal?> extractNutrition(File file) async{

    return await mealApiProvider.extractNutrition(file);
  }
}