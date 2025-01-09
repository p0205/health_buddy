import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/todo_controller.dart';
import '../../../models/todo_task.dart';
import '../../../models/user.dart';

class EditTaskForm extends StatefulWidget {
  final User user;
  final TodoTask todoTask;
  final DateTime date;

  const EditTaskForm({
    super.key,
    required this.user,
    required this.todoTask,
    required this.date
  });

  @override
  State<EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<EditTaskForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _descriptionController;
  late TimeOfDay startTime = TimeOfDay.now();
  late TimeOfDay endTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todoTask.title);
    _descriptionController = TextEditingController(text: widget.todoTask.description);
    _startTimeController = TextEditingController(text: widget.todoTask.startTime);
    _endTimeController = TextEditingController(text: widget.todoTask.endTime);

    // Initialize time values
    startTime = _parseTimeStringFromDb(widget.todoTask.startTime);
    endTime = _parseTimeStringFromDb(widget.todoTask.endTime);
  }

  TimeOfDay _parseTimeString(String timeString) {
    // Handle the time string parsing based on your format
    // This is an example, adjust based on your actual time format
    final timeParts = timeString.split(':');
    return TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1])
    );
  }

  TimeOfDay _parseTimeStringFromDb(String timeString) {
    if (timeString == '2400') {
      // Convert 2400 to 23:59
      return TimeOfDay(hour: 23, minute: 59);
    }

    // Ensure the time string is valid and in HHMM format
    if (timeString.length == 4) {
      final hour = int.parse(timeString.substring(0, 2));
      final minute = int.parse(timeString.substring(2, 4));

      // Validate hour and minute ranges
      if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
        return TimeOfDay(hour: hour, minute: minute);
      }
    }

    throw FormatException('Invalid time string format');
  }

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
  void dispose() {
    _titleController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedTask = TodoTask(
        id: widget.todoTask.id,
        title: _titleController.text,
        description: _descriptionController.text,
        startTime: startTime.format(context).replaceAll(':', ''),
        endTime: endTime.format(context).replaceAll(':', ''),
        isComplete: widget.todoTask.isComplete,
        type: widget.todoTask.type,
      );

      Provider.of<TodoController>(context, listen: false).updateTodoTask(updatedTask, this.widget.date, this.widget.user);
      Navigator.pop(context);
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<TodoController>(context, listen: false)
                    .deleteTodoTask(widget.user.id.toString(), widget.todoTask.id.toString(), widget.date);
                Navigator.pop(context); // Close edit form
                Navigator.pop(context); // Close delete confirmation dialog
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                  Padding(
                    padding: const EdgeInsets.only(right: 36.0),
                    child:TextFormField(
                      controller: _titleController,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(left: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title cannot be empty';
                        }
                        return null;
                      },
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Time:'),
                      const SizedBox(width: 4),
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
                  const Text(
                    'Description: ',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                    ),
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showDeleteConfirmation,
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.1),
                          foregroundColor: Colors.red,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _saveChanges,
                        child: const Text('Save'),
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
    );
  }
}