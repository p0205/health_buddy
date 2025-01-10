import 'package:flutter/material.dart';
import 'package:health_buddy/schedule_generator/src/models/todo_task.dart';
import 'package:provider/provider.dart';

import '../../../controller/todo_controller.dart';
import '../../../models/user.dart';

class CreateTaskForm extends StatefulWidget {
  final DateTime date;
  final User user;
  const CreateTaskForm({super.key, required this.date, required this.user});

  @override
  State<CreateTaskForm> createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String title = '';
  late String description = '';
  late String type = 'm'; // default type
  late TimeOfDay startTime = TimeOfDay.now();
  late TimeOfDay endTime = TimeOfDay.now();
  bool isComplete = false;

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: SingleChildScrollView(
          child: Card(
            elevation: 4,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Create New Task',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            title = value ?? '';
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text('Time: '),
                            TextButton.icon(
                              onPressed: () => _selectTime(context, true),
                              icon: const Icon(Icons.access_time),
                              label: Text(startTime.format(context)),
                            ),
                            const Text(' - '),
                            TextButton.icon(
                              onPressed: () => _selectTime(context, false),
                              icon: const Icon(Icons.access_time),
                              label: Text(endTime.format(context)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Type',
                            border: OutlineInputBorder(),
                          ),
                          value: type,
                          items: const [
                            DropdownMenuItem(value: 'm', child: Text('Meals')),
                            DropdownMenuItem(value: 'h', child: Text('Healthy Habits')),
                            DropdownMenuItem(value: 's', child: Text('Sports')),
                            DropdownMenuItem(value: 'c', child: Text('Common')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              type = value ?? 'c';
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          onSaved: (value) {
                            description = value ?? '';
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  // Create new task
                                  final newTask = TodoTask(
                                    title: title,
                                    description: description,
                                    type: type,
                                    startTime: startTime.format(context).replaceAll(':', ''),
                                    endTime: endTime.format(context).replaceAll(':', ''),
                                  );
                                  Provider.of<TodoController>(context, listen: false)
                                      .addTodoTask(newTask, widget.date, widget.user.id.toString());
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Create Task'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        )

    );
  }
}