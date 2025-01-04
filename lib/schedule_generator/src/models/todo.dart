class Todo{
  int id;
  int userId;
  DateTime? date;
  String? day;

  Todo({
    required this.id,
    required this.userId,
    this.date,
    this.day,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    try {
      return Todo(
        id: json['id'],
        userId: json['user_id'],
        date: json['date'] != null ? DateTime.parse(json['date']) : null,
        day: json['day']??'',
      );
    } catch (e) {
      rethrow;
    }
  }
}