class ScheduleTask{
  final String id;
  final String scheduleId;
  final String title;
  final String type;
  final DateTime startTime;
  final DateTime endTime;

  ScheduleTask(
      this.id,
      this.scheduleId,
      this.title,
      this.type,
      this.startTime,
      this.endTime);
}