import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/user/blocs/user_event.dart';
import 'package:health_buddy/meal_and_sport/src/user/blocs/user_state.dart';

import '../../../user/blocs/user_bloc.dart';
import '../blocs/calories_counter_main_bloc.dart';

class SetGoalCaloriesScreen extends StatefulWidget {
  final int userId;

  const SetGoalCaloriesScreen({super.key, required this.userId});

  @override
  State<SetGoalCaloriesScreen> createState() => _SetGoalCaloriesScreenState();
}

class _SetGoalCaloriesScreenState extends State<SetGoalCaloriesScreen> {
  final TextEditingController _caloriesController = TextEditingController();
  String? _selectedGender;
  String? _selectedAgeGroup;
  String? _selectedOccupation;
  String? _selectedActivityLevel;
  String? _selectedBodyGoal;

  int _calculateCalories() {
    // Example baseline values (can be adjusted based on user selection)
    int baseCalories = 2000;

    if (_selectedAgeGroup == "18-25") {
      baseCalories += 200;
    }
    else if (_selectedAgeGroup == "26-40") {
      baseCalories += 100;
    } else if (_selectedAgeGroup == "41-60") {
      baseCalories += 0;
    } else if (_selectedAgeGroup == "60+") {
      baseCalories -= 200;
    }

    if (_selectedGender == "Male") {
      baseCalories += 200;
    } else if (_selectedGender == "Female") {
      baseCalories -= 200;
    }

    if (_selectedOccupation == "Manual Labor") {
      baseCalories += 300;
    } else if (_selectedOccupation == "Desk Job") {
      baseCalories -= 100;
    }

    if (_selectedActivityLevel == "Active (5-7 days of exercise)") {
      baseCalories += 300;
    } else if (_selectedActivityLevel == "Moderate (3-4 days of exercise)") {
      baseCalories += 200;
    } else if (_selectedActivityLevel == "Sedentary (Little/no exercise)") {
      baseCalories -= 100;
    }

    if (_selectedBodyGoal == "Lose Weight") {
      baseCalories -= 500;
    } else if (_selectedBodyGoal == "Gain Weight") {
      baseCalories += 500;
    }

    return baseCalories.clamp(1200, 4000); // Clamp to a safe range
  }

  void _updateCalorieHint() {
    if (_selectedGender != null &&
        _selectedAgeGroup != null &&
        _selectedOccupation != null &&
        _selectedActivityLevel != null &&
        _selectedBodyGoal != null) {
      final int suggestedCalories = _calculateCalories();
      _caloriesController.text = suggestedCalories.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc,UserState>(
      listener: (context,state) {
        context.read<CaloriesCounterMainBloc>().add(DateChangedEvent(date: DateTime.now()));
      },
      listenWhen: (context, state){
        return (state.status == UserStatus.userInfoLoaded);
      },
      child: BlocListener<CaloriesCounterMainBloc, CaloriesCounterMainState>(
        listener: (context, state) {
          if (state.status == CaloriesCounterMainStatus.mealListLoaded) {
            if (Navigator.canPop(context)) {
              showDialog(
                  context: context,
                  builder : (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Goal Calories Set!"),
                    content: const Text(
                      "Your daily calorie goal has been successfully set. ",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.settings.name == "/mealMain");
                        },
                        child: const Text("OK"),
                      ),
                    ]
                  );
            });
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Set Goal Calories"),
            backgroundColor: Colors.blueAccent,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Set Your Daily Calorie Goal",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "If you're unsure about your goal, we'll suggest a value based on your inputs. "
                      "Alternatively, you can enter your own custom goal below.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  "Gender",
                  ["Male", "Female"],
                  _selectedGender,
                      (value) {
                    setState(() {
                      _selectedGender = value;
                      _updateCalorieHint();
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  "Age Group",
                  ["18-25", "26-40", "41-60", "60+"],
                  _selectedAgeGroup,
                      (value) {
                    setState(() {
                      _selectedAgeGroup = value;
                      _updateCalorieHint();
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  "Occupation",
                  ["Desk Job", "Manual Labor", "Other"],
                  _selectedOccupation,
                      (value) {
                    setState(() {
                      _selectedOccupation = value;
                      _updateCalorieHint();
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  "Activity Level",
                  ["Sedentary (Little/no exercise)", "Moderate (3-4 days of exercise)", "Active (5-7 days of exercise)"],
                  _selectedActivityLevel,
                      (value) {
                    setState(() {
                      _selectedActivityLevel = value;
                      _updateCalorieHint();
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  "Body Goal",
                  ["Lose Weight", "Maintain Weight", "Gain Weight"],
                  _selectedBodyGoal,
                      (value) {
                    setState(() {
                      _selectedBodyGoal = value;
                      _updateCalorieHint();
                    });
                  },
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _caloriesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Calories (kcal)",
                    hintText: "Suggested based on your inputs or enter your custom value",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    onPressed: () {
                      final String input = _caloriesController.text.trim();
                      if (input.isEmpty || int.tryParse(input) == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a valid calorie goal."),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }
                      final int goalCalories = int.parse(input);
                      _saveGoalCalories(widget.userId, goalCalories);
                    },
                    child: const Text(
                      "Set Goal",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String? selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: options.map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _saveGoalCalories(int userId, int goalCalories) {
    // Save the goal calories to the user's profile (mock function here)
    Map<String, dynamic> updatedData = {};
    updatedData['goalCalories'] = goalCalories;
    context.read<UserBloc>().add(UpdateProfileEvent(widget.userId, updatedData));
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    super.dispose();
  }
}
