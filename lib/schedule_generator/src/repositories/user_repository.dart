import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import 'package:health_buddy/constants.dart' as Constants;

class UserRepository {
  User? user;

  // Fetch user data
  Future<User> getUser(String userId) async {
    User? selectedUser;

    try{// edit this part 
      print("Fetching data...");

      // Fetch user by sending a GET request
      final userResponse = await http.get(

        Uri.parse(Constants.BaseUrl + Constants.SchedulePort + '/api/v1/user/'+userId), //change api url - ip address needed if using physical device

        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
      );
      if (userResponse.statusCode == 200) {
        var responseJson = json.decode(userResponse.body);
        if (responseJson.isNotEmpty) {
          // add from Json function
          // Access the nested 'todo' object
          Map<String, dynamic> userJson = responseJson['user'];

          // Create a Todo instance from the nested 'todo' object
          selectedUser = await User.fromJson(userJson);

          if(selectedUser != null) {
            user = selectedUser;
          } else {
            print('User is null');
          }
        }
      }
    } catch (error) {
      print('Error fetching data: $error');
    }

    return user!;  // Use non-null assertion since we just assigned it
  }
  User addGenDetails(
      User user,
      String occupationType,
      String occupationTime,
      String healthHistory,
      String areaOfLiving,
      int noOfFamilyMember,
      ){
    return User.detailed(
      id: user.id,
      email: user.email,
      password: user.password,
      age: user.age,
      gender: user.gender,
      weight: user.weight,
      height: user.height,
      name: user.name,
      occupationType: occupationType,
      occupationTime: occupationTime,
      healthHistory: healthHistory,
      areaOfLiving: areaOfLiving,
      noOfFamilyMember: noOfFamilyMember,
    );
  }

  // Method to add user goals calories
  User addGoalCalories(User user, int goalCalories){
    User tempUser = User.detailed(
      id: user.id,
      email: user.email,
      password: user.password,
      age: user.age,
      gender: user.gender,
      weight: user.weight,
      height: user.height,
      name: user.name,
      occupationType: user.occupationType,
      occupationTime: user.occupationTime,
      healthHistory: user.healthHistory,
      areaOfLiving: user.areaOfLiving,
      noOfFamilyMember: user.noOfFamilyMember,
    );

    tempUser.goalCalories = goalCalories;
    return tempUser;
  }
}