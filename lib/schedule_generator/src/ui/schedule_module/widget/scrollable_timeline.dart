import 'package:flutter/material.dart';
import 'package:health_buddy/schedule_generator/src/models/user.dart';
import 'package:health_buddy/schedule_generator/src/ui/schedule_module/pages/generate_question.dart';
import 'package:provider/provider.dart';
import 'package:health_buddy/schedule_generator/src/controller/todo_controller.dart';

import '../../../core/enums/loading_state.dart';
import '../../../models/todo_task.dart';
import 'edit_task_form.dart';

class ScrollableTimeline extends StatefulWidget {
  // valuable from other page
  final User user;
  final DateTime date;
  const ScrollableTimeline({super.key, required this.user, required this.date});

  @override
  State<ScrollableTimeline> createState() => _ScrollableTimelineState();
}

class _ScrollableTimelineState extends State<ScrollableTimeline> {
  // todo controller
  double hourLabelWidth = 46.0;
  double todoTaskContainerPadding = 8.0;
  double todoTaskContainerVerticalSpacing = 4.0;

  List<TodoTask> todoTasks = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch tasks after the first frame is rendered
      Provider.of<TodoController>(context, listen: false)
          .fetchTodoTasks(widget.date, widget.user.id.toString());
    });
  }
  //
  // @override
  // void didUpdateWidget(covariant ScrollableTimeline oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.date != widget.date|| oldWidget.user.id != widget.user.id) {
  //     Provider.of<TodoController>(context, listen: false).fetchTodoTasks(widget.date, widget.user.id.toString());
  //   }
  // }
  @override
  void didUpdateWidget(covariant ScrollableTimeline oldWidget) {
    print("didUpdateWidget");
    super.didUpdateWidget(oldWidget);
    if (oldWidget.date != widget.date || oldWidget.user.id != widget.user.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<TodoController>(context, listen: false)
            .fetchTodoTasks(widget.date, widget.user.id.toString());
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<TodoController>(
      builder: (context, todoController, child) {
        //check loading state
        if (todoController.loadingState == LoadingState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (todoController.loadingState == LoadingState.error) {
          return const Center(
            child: Text('Something went wrong!'),
          );
        }
        if (todoController.todo == null) {
          return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 40.0,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text('Press Start to Generate Schedule'),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                      width: 180,
                      child: TextButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GenerateQuestionPage(
                                      user: widget.user,
                                    ),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            "Start",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                      )
                  ),

                ],
              )
          );

        }
        if (todoController.todoTasks.isEmpty) {
          return const Center(
            child: Text('No task found!'),
          );
        }

        todoTasks = todoController.todoTasks;
        return
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: hourLabelWidth,
                      child: Column(
                        children: [
                          for (var i = 0; i < 24; i++)
                            SizedBox(
                              width: hourLabelWidth,
                              height: 100,
                              child: Text(
                                '${i.toString().padLeft(2, '0')} 00',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: createTimeTable(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
      },
    );

  }

  List<Widget> createTimeTable(){
    List<Widget> timeTable = [];
    var currTime = '0000';
    List<TodoTask> concurrentTasks = [];
    double duration;
    todoTasks.sort((a, b) => a.startTime.compareTo(b.startTime));
    if (todoTasks.isEmpty) return [];
    for (var i = 0; i < todoTasks.length; i++) {
      duration =  convertToHours(todoTasks[i].startTime)-convertToHours(currTime);
      if (todoTasks[i].startTime == currTime) {
        concurrentTasks = [todoTasks[i]];
        for (var j = i+1; j < todoTasks.length; j++) {
          if (convertToHours(todoTasks[j].startTime) < convertToHours(todoTasks[i].endTime)) {
            concurrentTasks.add(todoTasks[j]);
          }
        }
        currTime = processConcurrentTasks(concurrentTasks, timeTable, currTime);
        concurrentTasks = [];
      } else if (duration > 0) {
        timeTable.add(createWhiteSpace(duration * 100));
        currTime = todoTasks[i].startTime;
        concurrentTasks = [todoTasks[i]];
        for (var j = i+1; j < todoTasks.length; j++) {
          if (convertToHours(todoTasks[j].startTime) < convertToHours(todoTasks[i].endTime)) {
            concurrentTasks.add(todoTasks[j]);
          }
        }
        currTime = processConcurrentTasks(concurrentTasks, timeTable, currTime);
        concurrentTasks = [];
      }
    }
    return timeTable;
  }

  String processConcurrentTasks(
      List<TodoTask> concurrentTasks, List<Widget> timeTable, String currTime) {
    if (concurrentTasks.length > 1) {
      timeTable.add(createConcurrentTaskList(concurrentTasks, currTime));
      concurrentTasks.sort((a, b) => a.endTime.compareTo(b.endTime));
      return concurrentTasks.last.endTime;
    } else {
      timeTable.add(createTaskContainer(concurrentTasks.first));
      return concurrentTasks.first.endTime;
    }
  }


  double convertToHours(String time) {
    int hours = int.parse(time.substring(0, 2));
    int minutes = int.parse(time.substring(2, 4));
    return hours + minutes / 60.0;
  }

  Widget createWhiteSpace(double height){
    return SizedBox(
      width: double.infinity,
      height: height,
    );
  }

  double calculateHeight(String startTime, String endTime){
    return ((convertToHours(endTime)-convertToHours(startTime)) * 100);
  }

  Widget createConcurrentTaskList(List<TodoTask> concurrentTasks, String currTime){
    return
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var todoTask in concurrentTasks)
            if (todoTask.startTime == currTime)
              Expanded(
                flex: 1,
                child:
                createTaskContainer(todoTask),

              )
            else
              Expanded(
                flex: 1,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: calculateHeight(currTime, todoTask.startTime),
                    ),

                    createTaskContainer(todoTask),
                  ],
                ),
              )
        ],
      );
  }

  Widget createTaskContainer(TodoTask todoTask) {
    // Define colors based on task type
    Color getTypeColor() {
      switch (todoTask.type.toLowerCase()) {
        case 'm':
          return Colors.red.withOpacity(0.2);
        case 'h':
          return Colors.green.withOpacity(0.2);
        case 's':
          return Colors.yellow.withOpacity(0.2);
        case 'c':
          return Colors.blue.withOpacity(0.2);
        default:
          return Colors.grey.withOpacity(0.2);
      }
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => EditTaskForm(
              user: this.widget.user,
              todoTask: todoTask,
              date: this.widget.date
          ),  // Properly return the widget
        );
      },
      child: Container(
        height: calculateHeight(todoTask.startTime, todoTask.endTime) - 8.0,
        margin: EdgeInsets.only(
          top: todoTaskContainerVerticalSpacing,
          bottom: todoTaskContainerVerticalSpacing,
          right: todoTaskContainerVerticalSpacing,
        ),
        decoration: BoxDecoration(
          color: getTypeColor(),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          title: Text(
            todoTask.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          trailing: Container(
            width: 1,
            height: 1,
            child: Checkbox(
              value: todoTask.isComplete,
              onChanged: (value) {
                if (todoTask.isComplete == true) {
                  todoTask.isComplete = false;
                } else {
                  todoTask.isComplete = true;
                }
                final updatedTask = TodoTask(
                  id: todoTask.id,
                  title: todoTask.title,
                  description: todoTask.description,
                  startTime: todoTask.startTime,
                  endTime: todoTask.endTime,
                  isComplete: todoTask.isComplete,
                  type: todoTask.type,
                );
                Provider.of<TodoController>(context, listen: false)
                    .updateTodoTask(updatedTask, this.widget.date, this.widget.user);
              },
            ),
          ),
        ),
      ),
    );
  }
}
