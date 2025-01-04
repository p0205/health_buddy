class TodoTask{
  final int id;
  final int todoId;
  String title;
  String description;
  bool isComplete;
  String type;
  String startTime;
  String endTime;

  TodoTask({
    this.id = 0,
    this.todoId = 0,
    this.title = "",
    this.description = "",
    this.isComplete  = false,
    this.type = "",
    this.startTime="",
    this.endTime="",
  });

  factory TodoTask.fromJson(Map<String, dynamic> json){
    try{
      return TodoTask(
        id: json['id'],
        todoId: json['todo_id'],
        title: json['title'],
        description: json['description']==null?"":json['description'],
        isComplete: json['is_complete']==1?true:false,
        type: json['type'],
        startTime: json['start_time'],
        endTime: json['end_time'],
      );
    } catch (e){
      rethrow;
    }
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'todoId': todoId,
      'title': title,
      'description': description,
      'isComplete': isComplete,
      'type': type,
      'startTime': startTime.toString(),
      'endTime': endTime.toString(),
    };
  }

  @override
  String toString() {
    return '''TodoTask
    {id: $id, 
    todoId: $todoId, 
    title: $title, 
    description: $description, 
    isComplete: $isComplete, 
    type: $type, 
    startTime: $startTime, 
    endTime: $endTime}
    ''';
  }
}

