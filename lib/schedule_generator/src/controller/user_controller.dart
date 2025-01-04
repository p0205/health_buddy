import 'package:flutter/cupertino.dart';

import '../core/enums/loading_state.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';

class UserController extends ChangeNotifier {
  final UserRepository _userRepository;

  UserController(this._userRepository);

  LoadingState _loadingState = LoadingState.initial;
  String _errorMessage = '';
  User? _user;

  // Getters
  LoadingState get loadingState => _loadingState;
  String get errorMessage => _errorMessage;
  User? get user => _user;

  // Method to fetch user
  Future<void> fetchUser(String userId) async {
    try {
      _loadingState = LoadingState.loading;
      notifyListeners();
      const duration = Duration(seconds: 2);
      await Future.delayed(duration);
      _user = await _userRepository.getUser(userId);
      print(_user);

      _loadingState = LoadingState.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _loadingState = LoadingState.error;
      notifyListeners();
    }
  }

  // Method to update user information
  Future<void> updateUserDetails(
      User user,
      String occupationType,
      String occupationTime,
      String healthHistory,
      String areaOfLiving,
      int noOfFamilyMember,
      ) async {
    try {
      _loadingState = LoadingState.loading;
      notifyListeners();
      const duration = Duration(seconds: 2);
      await Future.delayed(duration);
      _user = _userRepository.addGenDetails(
        user,
        occupationType,
        occupationTime,
        healthHistory,
        areaOfLiving,
        noOfFamilyMember,
      );

      _loadingState = LoadingState.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _loadingState = LoadingState.error;
      notifyListeners();
    }
  }

  // Method to add user goals calories
  Future<void> addUserGoalCalories(User user, int goalCalories) async {
    try {
      _loadingState = LoadingState.loading;
      notifyListeners();
      const duration = Duration(seconds: 2);
      await Future.delayed(duration);
      _user = _userRepository.addGoalCalories(user, goalCalories);

      _loadingState = LoadingState.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _loadingState = LoadingState.error;
      notifyListeners();
    }
  }
}