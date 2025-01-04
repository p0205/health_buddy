class MealSummary {
  final double caloriesLeft;
  final double carbsIntake;
  final double proteinIntake;
  final double fatIntake;
  final String date;

  MealSummary({
    required this.caloriesLeft,
    required this.carbsIntake,
    required this.proteinIntake,
    required this.fatIntake,
    required this.date,
  });

  // Factory constructor to create a NutritionalSummary from a map (parsed JSON)
  factory MealSummary.fromJson(Map<String, dynamic> json) {
    return MealSummary(
      caloriesLeft: json['caloriesLeft']?.toDouble() ?? 0.0,
      carbsIntake: json['carbsIntake']?.toDouble() ?? 0.0,
      proteinIntake: json['proteinIntake']?.toDouble() ?? 0.0,
      fatIntake: json['fatIntake']?.toDouble() ?? 0.0,
      date: json['date']?? "",
    );
  }

  // Method to convert NutritionalSummary to a map (if needed for sending to an API)
  Map<String, dynamic> toJson() {
    return {
      'caloriesLeft': caloriesLeft,
      'carbsIntake': carbsIntake,
      'proteinIntake': proteinIntake,
      'fatIntake': fatIntake,
      'date': date,
    };
  }
}
