import 'question.dart';


class Questionnaire {
  final List<Question> questions;
  final int calculatedScore;

  Questionnaire({
    required this.questions,
    required this.calculatedScore,
  });


  factory Questionnaire.fromJson(Map<String, dynamic> json) => Questionnaire(
    questions: List<Question>.from(json['questions'].map((x) => Question.fromJson(x))),
    calculatedScore: json['calculatedScore'],
  );

  Map<String, dynamic> toJson() => {
    'questions': List<dynamic>.from(questions.map((x) => x.toJson())),
    'calculatedScore': calculatedScore
  };

  @override
  String toString() => toJson().toString();
}