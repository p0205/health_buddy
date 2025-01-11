
import 'condition.dart';

class Question {
  final int id;
  final String question;
  final List<Condition> conditions;

  Question({
    required this.id,
    required this.question,
    required this.conditions,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      conditions: (json['conditions'] as List<dynamic>)
          .map((conditionJson) => Condition.fromJson(conditionJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'conditions': conditions.map((condition) => condition.toJson()).toList(),
    };
  }

  static List<Question> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Question.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<Question> questions) {
    return questions.map((question) => question.toJson()).toList();
  }
}


