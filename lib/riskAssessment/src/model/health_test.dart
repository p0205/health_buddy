
class HealthTest {
  final int id;
  final String diseaseName;

  HealthTest({
    required this.id,
    required this.diseaseName,
  });

  factory HealthTest.fromJson(Map<String, dynamic> json) {
    return HealthTest(
      id: json['id'],
      diseaseName: json['diseaseName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'diseaseName': diseaseName,

    };
  }

  static List<HealthTest> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => HealthTest.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<HealthTest> questions) {
    return questions.map((question) => question.toJson()).toList();
  }
}


