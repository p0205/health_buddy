
class Condition {
  final String condition;
  final int score;
  final int? weight;

  Condition({
    required this.condition,
    required this.score,
    this.weight,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      condition: json['condition'],
      score: json['score'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'condition': condition,
      'score': score,
      'weight': weight,
    };
  }
}
