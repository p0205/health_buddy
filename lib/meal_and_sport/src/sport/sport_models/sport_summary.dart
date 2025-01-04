class SportSummary {

  String date;
  double totalCalsBurnt;
  Map<String, double> calsBurntByType;

  SportSummary(this.date, this.totalCalsBurnt,this.calsBurntByType);

  factory SportSummary.fromJson(Map<String, dynamic> json) {
    return SportSummary(
      json['date'],
      json['totalCalsBurnt']?.toDouble() ?? 0.0, // Handle possible null or missing value
      _parseCaloriesByType(json['calsBurntByType'] ?? {}),
    );
  }

  // Helper function to parse calsBurntByType
  static Map<String, double> _parseCaloriesByType(Map<String, dynamic> json) {
    final Map<String, double> result = {};
    json.forEach((key, value) {
      if (value != null) {
        // Ensure that each value is parsed as a double
        result[key] = value is num ? value.toDouble() : 0.0; // Safely convert
      }
    });
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      'totalCalsBurnt': totalCalsBurnt,
      'calsBurntByType': calsBurntByType,
    };
  }

}