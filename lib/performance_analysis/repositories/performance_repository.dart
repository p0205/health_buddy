import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:health_buddy/performance_analysis/models/daily_performance.dart';

class PerformanceRepository {
  final apiUrl = 'https://192.168.137.30/api/performance/';

  Future<DailyPerformance> getPerformance(int userId, DateTime date) async {
    print("Fetching data...");
    var formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    try {
      final response = await http.get(
        Uri.parse('http://192.168.137.30:5000/api/v1/performance/$userId/$formattedDate'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final performanceData = data['performance'];
        return DailyPerformance.fromJson(performanceData);
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
            'http://192.168.137.30:5000/api/v1/monthlyPerformance/$userId/$formattedDate'),
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