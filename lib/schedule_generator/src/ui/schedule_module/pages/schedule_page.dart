import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:health_buddy/schedule_generator/src/controller/user_controller.dart';
import 'package:health_buddy/schedule_generator/src/core/enums/loading_state.dart';
import 'package:health_buddy/schedule_generator/src/ui/schedule_module/widget/create_task_form.dart';
import 'package:provider/provider.dart';

import '../widget/scrollable_timeline.dart';

class SchedulePage extends StatefulWidget {
  final String user_id;
  const SchedulePage({super.key, required this.user_id});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  var _selectedDate = DateTime.now();
  var _user;
  late Key _timelineKey;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch tasks after the first frame is rendered
      Provider.of<UserController>(context, listen: false)
          .fetchUser(widget.user_id);
    });
    _timelineKey = UniqueKey();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
        builder: (context, userController, child){
          if (userController.loadingState == LoadingState.loading){
            return Scaffold(
              appBar: AppBar(
                title: const Text("Schedule"),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (userController.loadingState == LoadingState.error){
            return Scaffold(
              appBar: AppBar(
                title: const Text("Schedule"),
              ),
              body: Center(
                child: Text(userController.errorMessage),
              ),
            );
          }
          if (userController.loadingState == LoadingState.loaded && userController.user != null){
            return Scaffold(
              appBar: AppBar(
                title: const Text("Schedule"),
              ),
              body:
              Column(
                children: [
                  EasyDateTimeLinePicker.itemBuilder(
                    firstDate: DateTime(2023, 1, 1),
                    lastDate: DateTime(2026, 1, 1),
                    focusedDate: _selectedDate,
                    itemExtent: 64.0,
                    itemBuilder: (context, date, isSelected, isDisabled, isToday, onTap) {
                      return InkResponse(
                          onTap: onTap,
                          child:
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: const Color.fromRGBO(190, 187, 189, 0.49),
                                  width: 1,
                                ),
                                gradient: isSelected ? const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xff3371FF),
                                      Color(0xff8426D6),
                                    ]
                                ): null,
                              ),
                              child: Center(
                                child: Text(date.day.toString()),
                              )
                          )
                      );
                    },
                    onDateChange: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ScrollableTimeline(
                      key: _timelineKey,
                      user: userController.user??_user,
                      date: _selectedDate
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Add your onPressed code here!
                  showDialog(
                      context: context,
                      builder: (BuildContext context)
                      {
                        return CreateTaskForm(
                          date: _selectedDate,
                          user: userController.user??_user,
                        );
                      }
                  );
                },
                backgroundColor: Colors.deepPurple,
                child: const Icon(Icons.add),
              ),
            );
          }
          else{
            return const SizedBox();
          }
        }
    );
  }

}
