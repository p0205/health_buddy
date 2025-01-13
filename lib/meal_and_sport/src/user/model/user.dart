class User {
  final int id;
  final String? email;
  final int? age;
  final String? gender;
  final String? name;
  final String? occupationType;
  final String? occupationTime;
  final String? healthHistory;
  final String? areaOfLiving;
  final int? noOfFamilyMember;
  final double weight;
  final double height;
  final int? goalCalories;
  final String? profileImage;  // For storing profile image as a byte array

  User({
    required this.id,
    this.email,
    this.age,
    this.gender,
    this.name,
    this.occupationType,
    this.occupationTime,
    this.healthHistory,
    this.areaOfLiving,
    this.noOfFamilyMember,
    required this.weight,
    required this.height,
    this.goalCalories,
    this.profileImage,
  });

  // Factory method to create a User from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      age: json['age'],
      gender: json['gender'],
      name: json['name'],
      occupationType: json['occupationType'],
      occupationTime: json['occupationTime'],
      healthHistory: json['healthHistory'],
      areaOfLiving: json['areaOfLiving'],
      noOfFamilyMember: json['noOfFamilyMember'],
      weight: json['weight'].toDouble(),
      height: json['height'].toDouble(),
      goalCalories: json['goalCalories'],
        profileImage: json['profileImage']
    );
  }

  // Method to convert a User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'age': age,
      'gender': gender,
      'name': name,
      'occupationType': occupationType,
      'occupationTime': occupationTime,
      'healthHistory': healthHistory,
      'areaOfLiving': areaOfLiving,
      'noOfFamilyMember': noOfFamilyMember,
      'weight': weight,
      'height': height,
      'goalCalories': goalCalories,
      'profileImage': profileImage,
    };
  }

  User copyWith({
    int? id,
    String? email,
    int? age,
    String? gender,
    String? name,
    String? occupationType,
    String? occupationTime,
    String? healthHistory,
    String? areaOfLiving,
    int? noOfFamilyMember,
    double? weight,
    double? height,
    int? goalCalories,
    String? profileImage,
    // ... other fields
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      name: name ?? this.name,
      occupationType: occupationType ?? this.occupationType,
      occupationTime: occupationTime ?? this.occupationTime,
      healthHistory: healthHistory ?? this.healthHistory,
      areaOfLiving: areaOfLiving ?? this.areaOfLiving,
      noOfFamilyMember: noOfFamilyMember ?? this.noOfFamilyMember,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      goalCalories: goalCalories ?? this.goalCalories,
      profileImage: profileImage ?? this.profileImage,

    );
  }

}
