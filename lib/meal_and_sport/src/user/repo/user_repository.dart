
import 'dart:io';

import 'package:health_buddy/meal_and_sport/src/user/repo/user_data_provider.dart';

import '../model/user.dart';

class UserRepository{

  final UserDataProvider userDataProvider = UserDataProvider();

  // Future<User> fetchUser(int id) async {
  //   print("Enter user repository...");
  //   return await userDataProvider.fetchUser(id);
  //
  // }

  Future<String> getUserWeight(int id)async{
    return await userDataProvider.getUserWeight(id);
  }
  Future<void> markFirstLogin(int userId, bool isFirstLogin) async{
    return await userDataProvider.markFirstLogin(userId, isFirstLogin);
  }

  Future<User> fetchUser(int id) async {
    return await userDataProvider.fetchUser(id);
  }

  Future<void> updateProfile(int id, Map<String, dynamic> updatedData ) async {
    return await userDataProvider.updateProfile(id,updatedData);
  }

  Future<String?> uploadProfileImage(File file, int userId ) async {
    return await userDataProvider.uploadProfileImage(file,userId);
  }
}