import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_buddy/schedule_generator/src/ui/schedule_module/pages/schedule_page.dart';

import '../../../controller/user_controller.dart';
import '../../../controller/todo_controller.dart';
import '../../../models/user.dart';
import '../../../repositories/user_repository.dart';
import '../../../repositories/todo_repository.dart';

class GenerateQuestionPage extends StatefulWidget {
  final User user;
  const GenerateQuestionPage({super.key, required this.user});

  @override
  State<GenerateQuestionPage> createState() => _GenerateQuestionPageState();
}

class _GenerateQuestionPageState extends State<GenerateQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _occupationController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _healthHistoryController = TextEditingController();
  final _familyMemberController = TextEditingController();

  String? _areaOfLiving;
  List<String> _healthHistory = [];
  bool _isLoading = false;

  final List<String> _areaOfLivingList = ['Urban', 'Rural', 'Suburban'];

  @override
  void dispose() {
    _occupationController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _healthHistoryController.dispose();
    _familyMemberController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      setState(() => _isLoading = true);

      final userController = UserController(UserRepository());
      final todoController = TodoController(TodoRepository());
      final occupationTime = '${_startTimeController.text} to ${_endTimeController.text}';
      final healthHistory = _healthHistory.join(',');

      await userController.updateUserDetails(
        widget.user,
        _occupationController.text,
        occupationTime,
        healthHistory,
        _areaOfLiving ?? _areaOfLivingList.first,
        int.parse(_familyMemberController.text),
      );

      final user = userController.user;

      // Wait for genTodo to complete
      print('Starting genTodo for user ${user?.id}');
      await todoController.genTodo(user!);
      print('Completed genTodo for user ${user.id}');

      if (mounted) {
        // Add a small delay to ensure DB operations are complete
        await Future.delayed(Duration(milliseconds: 10000));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SchedulePage(user_id: widget.user.id.toString()),
          ),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating details: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Question'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _occupationController,
                decoration: const InputDecoration(
                  labelText: 'Occupation',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter occupation';
                  return null;
                },
              ),

              const SizedBox(height: 20),
              const Text('Working Time'),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Start Time',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Required';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('to'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _endTimeController,
                      decoration: const InputDecoration(
                        labelText: 'End Time',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Required';
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Text('Health History'),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _healthHistoryController,
                      decoration: const InputDecoration(
                        labelText: 'Add health condition',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_healthHistoryController.text.isNotEmpty) {
                        setState(() {
                          _healthHistory.add(_healthHistoryController.text);
                          _healthHistoryController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
              ..._healthHistory.map((history) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(child: Text(history)),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _healthHistory.remove(history);
                        });
                      },
                    ),
                  ],
                ),
              )).toList(),

              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _areaOfLiving ?? _areaOfLivingList.first,
                decoration: const InputDecoration(
                  labelText: 'Area of Living',
                  border: OutlineInputBorder(),
                ),
                items: _areaOfLivingList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _areaOfLiving = value);
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'e.g:\nUrban: Kuala Lumpur, George Town, Johor Bahru\n'
                      'Suburban: Shah Alam, Cheras, Bayan Baru\n'
                      'Rural: Kampung Morten, Kulai Kria, Kundasang',
                ),
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: _familyMemberController,
                decoration: const InputDecoration(
                  labelText: 'Number of Family Members',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter number of family members';
                  if (int.tryParse(value!) == null) return 'Please enter a valid number';
                  return null;
                },
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}