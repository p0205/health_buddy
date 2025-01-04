class UserSport {
  int id;
  int userId;
  int sportId;
  String sportName;
  String date;
  double durationInHours;
  double caloriesBurnt;


  UserSport(this.id, this.userId, this.sportId,this.sportName,  this.date, this.durationInHours,
      this.caloriesBurnt);

  factory UserSport.fromJson(Map<String, dynamic> json) =>
      UserSport(
        json['id'],
        json['userId'],
        json['sportId'],
        json['sportName'].toString().toUpperCase(),
        json['date'],
        json['durationInHours'],
        json['caloriesBurnt'],
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      'sportId': sportId,
      'sportName': sportName,
      "date": date,
      "durationInHours": durationInHours,
      'caloriesBurnt': caloriesBurnt,
    };
  }

  static List<UserSport> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => UserSport.fromJson(json)).toList();
  }
}