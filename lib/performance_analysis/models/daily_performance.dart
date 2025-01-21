class DailyPerformance {
  final int id;
  final DateTime date;
  final int totalPercentage;
  final int userId;
  final int totalTask;
  final int completedTask;

  DailyPerformance({
    required this.id,
    required this.date,
    required this.totalPercentage,
    required this.userId,
    required this.totalTask,
    required this.completedTask,
  });

  factory DailyPerformance.fromJson(Map<String, dynamic> json) {
    return DailyPerformance(
      id: json['id'] ?? 0,
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      totalPercentage: json['total_percentage'] ?? 0,
      userId: json['user_id'] ?? 0,
      totalTask: json['total_task'] ?? 0,
      completedTask: json['completed_task'] ?? 0,
    );
  }
}