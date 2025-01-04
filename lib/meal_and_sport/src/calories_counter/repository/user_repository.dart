
import 'package:health_buddy/meal_and_sport/src/calories_counter/repository/user_data_provider.dart';

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
}