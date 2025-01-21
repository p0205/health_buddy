class CalendarDayData {
  final DateTime date;
  final double completionPercentage;
  final int completedTasks;
  final int totalTasks;

  CalendarDayData({
    required this.date,
    required this.completionPercentage,
    required this.completedTasks,
    required this.totalTasks,
  });
}