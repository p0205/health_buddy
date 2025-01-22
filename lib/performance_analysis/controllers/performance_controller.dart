import 'package:flutter/cupertino.dart';

import 'package:health_buddy/schedule_generator/src/core/enums/loading_state.dart';
import '../models/daily_performance.dart';
import '../repositories/performance_repository.dart';

class PerformanceController extends ChangeNotifier {
  PerformanceRepository _performanceRepository;

  PerformanceController(this._performanceRepository);

  LoadingState _loadingState = LoadingState.initial;
  String _errorMessage = '';
  DailyPerformance? _todayPerformances;
  List<DailyPerformance>? _monthlyPerformances;
  DateTime? _currentDate;
  int? _currentUserId;

  // Getters
  LoadingState get loadingState => _loadingState;
  String get errorMessage => _errorMessage;
  DailyPerformance? get performances => _todayPerformances;
  DateTime? get currentDate => _currentDate;
  int? get currentUserId => _currentUserId;

  // Method to update the repository
  void updateRepository(PerformanceRepository repository) {
    _performanceRepository = repository;
  }

  // Method to fetch performances without caching
  Future<void> fetchTodayPerformances(int userId, DateTime date) async {
    try {
      _loadingState = LoadingState.loading;
      notifyListeners();

      // Fetch from repository
      _todayPerformances = await _performanceRepository.getPerformance(userId, date);

      print(_todayPerformances?.totalTask.toString());

      _loadingState = LoadingState.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _loadingState = LoadingState.error;
      notifyListeners();
    }
  }

  // Method to fetch monthly performances without caching
  Future<void> fetchMonthlyPerformances(int userId, DateTime date) async {
    try {

      // Fetch from repository
      _monthlyPerformances = await _performanceRepository.getMonthlyPerformance(userId, date);

      _loadingState = LoadingState.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _loadingState = LoadingState.error;
      notifyListeners();
    }
  }

  // Method to refresh current data
  Future<void> refreshCurrentData(int userId, DateTime date) async {
    await fetchTodayPerformances(userId, date);
    await fetchMonthlyPerformances(userId, date);
  }

  DailyPerformance? getTodayPerformances() {
    return _todayPerformances;
  }

  List<DailyPerformance>? getMonthlyPerformances() {
    return _monthlyPerformances;
  }

  // Clean up resources
  @override
  void dispose() {
    super.dispose();
  }
}