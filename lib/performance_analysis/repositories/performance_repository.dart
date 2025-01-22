import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:health_buddy/performance_analysis/models/daily_performance.dart';
import 'package:health_buddy/constants.dart' as Constants;

class PerformanceRepository {
  Future<DailyPerformance> getPerformance(int userId, DateTime date) async {
    print("Fetching data...");
    var formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    try {
      final response = await http.get(
        Uri.parse(
            "${Constants.BaseUrl}${Constants.SchedulePort}/api/v1/performance/$userId/$formattedDate"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final performanceData = data['performance'];

        return DailyPerformance(
          userId: performanceData['user_id'] is int
              ? performanceData['user_id']
              : int.parse(performanceData['user_id']),
          date: DateTime.parse(performanceData['date']),
          totalPercentage: (performanceData['total_task'] ?? 0) > 0
              ? ((performanceData['completed_task'] ?? 0) /
              (performanceData['total_task'] ?? 1) *
              100)
              .toInt()
              : 0,
          completedTask: performanceData['completed_task'] is int
              ? performanceData['completed_task']
              : int.parse(performanceData['completed_task']),
          totalTask: performanceData['total_task'] is int
              ? performanceData['total_task']
              : int.parse(performanceData['total_task']),
          id: 1,
        );
      } else {
        throw Exception('Failed to load performance');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to load performance: $e');
    }
  }


  // get all performances in a month
  Future<List<DailyPerformance>> getMonthlyPerformance(int userId, DateTime date) async {
    print("Fetching data...");
    var formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    try {
      final response = await http.get(
        Uri.parse(
            Constants.BaseUrl+Constants.SchedulePort+'/api/v1/monthlyPerformance/$userId/$formattedDate'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)["performance"];
        return data.map((performanceData) =>
            DailyPerformance.fromJson(performanceData)).toList();
      } else {
        throw Exception('Failed to load performance');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to load performance: $e');
    }
  }
}