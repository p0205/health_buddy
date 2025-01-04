// lib/utils/date_extensions.dart
extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year &&
        month == other.month &&
        day == other.day;
  }

  // You can add more date-related extension methods here
  DateTime get dateOnly => DateTime(year, month, day);
}