class MealSummary {
  final double caloriesIntake;
  final double? caloriesLeft;
  final double carbsIntake;
  final double proteinIntake;
  final double fatIntake;
  final String date;

  MealSummary({
    required this.caloriesIntake,
    this.caloriesLeft,
    required this.carbsIntake,
    required this.proteinIntake,
    required this.fatIntake,
    required this.date,
  });

  // Factory constructor to create a NutritionalSummary from a map (parsed JSON)
  factory MealSummary.fromJson(Map<String, dynamic> json) {
    return MealSummary(
      caloriesIntake: json['caloriesIntake']?.toDouble() ?? 0.0,
      caloriesLeft: json['caloriesLeft']?.toDouble(),
      carbsIntake: json['carbsIntake']?.toDouble() ?? 0.0,
      proteinIntake: json['proteinIntake']?.toDouble() ?? 0.0,
      fatIntake: json['fatIntake']?.toDouble() ?? 0.0,
      date: json['date']?? "",
    );
  }

  // Method to convert NutritionalSummary to a map (if needed for sending to an API)
  Map<String, dynamic> toJson() {
    return {
      'caloriesIntake': caloriesIntake,
      'caloriesLeft': caloriesLeft,
      'carbsIntake': carbsIntake,
      'proteinIntake': proteinIntake,
      'fatIntake': fatIntake,
      'date': date,
    };
  }
}
