
part of "add_user_sport_bloc.dart";

enum AddUserSportStatus{
  initial,
  loading,
  userSportAdded,
  durationInHoursSelected,
  failure
}


extension AddUserSportStateX on AddUserSportState {
  bool get isInitial => this == AddUserSportStatus.initial;
  bool get isLoading => this == AddUserSportStatus.loading;
  bool get isDurationInHoursSelected => this == AddUserSportStatus.durationInHoursSelected;
  bool get isUserSportAdded=> this == AddUserSportStatus.userSportAdded;
  bool get isFailure => this == AddUserSportStatus.failure;
}


class AddUserSportState extends Equatable {
  final AddUserSportStatus status;
  final double? durationInHours;
  final double? caloriesBurnt;
  final bool isCalculated;
  final bool isDurationInHoursSelected;
  final int userId;
  final int sportId;

  final String? message;

  const AddUserSportState({
    required this.userId,
    required this.sportId,
    this.status = AddUserSportStatus.initial,
    this.isCalculated = false,
    this.isDurationInHoursSelected = true,
    this.durationInHours,
    this.caloriesBurnt,
    this.message
  });

  @override
  List<Object?> get props => [userId, sportId, status,  isCalculated, isDurationInHoursSelected, durationInHours, caloriesBurnt];

  AddUserSportState copyWith({
    int? userId,
    int? sportId,
    AddUserSportStatus? status,
    bool? isCalculated,
    bool? isDurationInHoursSelected,
    double? durationInHours,
    double? caloriesBurnt,
    String? message

  }) {
    return AddUserSportState(
      userId: userId ?? this.userId,
      sportId: sportId ?? this.sportId,
      status: status ?? this.status,
      isCalculated: isCalculated ?? this.isCalculated,
      isDurationInHoursSelected: isDurationInHoursSelected ?? this.isDurationInHoursSelected,
      durationInHours: durationInHours ?? this.durationInHours,
      caloriesBurnt: caloriesBurnt ?? this.caloriesBurnt,
      message: message ?? this.message,
    );
  }
}
