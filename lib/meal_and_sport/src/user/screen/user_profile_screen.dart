import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/authentication/src/screens/main_menu_screen.dart';
import 'package:health_buddy/meal_and_sport/src/user/blocs/user_event.dart';
import 'package:health_buddy/meal_and_sport/src/user/blocs/user_state.dart';

import '../blocs/user_bloc.dart';



class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String initialName, initialAge, initialGoalCalories, initialGender, initialWeight, initialHeight, initialArea;
  late String initialFamilyMembers, initialOccupationType, initialWorkHours, initialHealthHistory;
  late String name, age, goalCalories, gender, weight, height, area, familyMembers, occupationType, workHours, healthHistory;
  final ValueNotifier<bool> _hasChangesNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    final userBloc = context.read<UserBloc>();
    final user = userBloc.state.user;

    // Initialize the variables to avoid LateInitializationError
    name = user?.name ?? '';
    goalCalories = user?.goalCalories?.toString() ?? '';
    age = user?.age.toString() ?? '';
    gender = user?.gender ?? ''; // Use default value to prevent late initialization error
    weight = user?.weight.toString() ?? '';
    height = user?.height.toString() ?? '';
    area = user?.areaOfLiving ?? '';
    familyMembers = user?.noOfFamilyMember?.toString() ?? '';
    occupationType = user?.occupationType ?? '';
    workHours = user?.occupationTime ?? '';
    healthHistory = user?.healthHistory ?? '';

    // Store initial values to compare with later
    initialName = name;
    initialGoalCalories = goalCalories;
    initialAge = age;
    initialGender = gender;
    initialWeight = weight;
    initialHeight = height;
    initialArea = area;
    initialFamilyMembers = familyMembers;
    initialOccupationType = occupationType;
    initialWorkHours = workHours;
    initialHealthHistory = healthHistory;
  }

    @override
    void dispose() {
      _hasChangesNotifier.dispose();
      super.dispose();
    }

    // Modify _hasChanges to update the ValueNotifier
    void _updateHasChanges() {
      _hasChangesNotifier.value =
          name != initialName ||
              goalCalories != initialGoalCalories ||
              age != initialAge ||
              gender != initialGender ||
              weight != initialWeight ||
              height != initialHeight ||
              area != initialArea ||
              familyMembers != initialFamilyMembers ||
              occupationType != initialOccupationType ||
              workHours != initialWorkHours ||
              healthHistory != initialHealthHistory;
    }
  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Changes'),
          content: const Text('Are you sure you want to update your profile?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Update'),
            ),
          ],
        );
      },
    ) ?? false; // Return false if dialog is dismissed
  }

  // Add this method to handle the update
  void _handleUpdate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      bool confirm = await _showConfirmationDialog();

      if (confirm && mounted) {
        Map<String, dynamic> updatedData = {};

        if (name != initialName) updatedData['name'] = name;
        if (goalCalories != initialGoalCalories) updatedData['goalCalories'] = goalCalories;
        if (age != initialName) updatedData['age'] = age;
        if (gender != initialGender) updatedData['gender'] = gender;
        if (weight != initialWeight) updatedData['weight'] = weight;
        if (height != initialHeight) updatedData['height'] = height;
        if (area != initialArea) updatedData['areaOfLiving'] = area;
        if (familyMembers != initialFamilyMembers) updatedData['noOfFamilyMember'] = familyMembers;
        if (occupationType != initialOccupationType) updatedData['occupationType'] = occupationType;
        if (workHours != initialWorkHours) updatedData['occupationTime'] = workHours;
        if (healthHistory != initialHealthHistory) updatedData['healthHistory'] = healthHistory;

        context.read<UserBloc>().add(UpdateProfileEvent(context.read<UserBloc>().state.user!.id, updatedData));

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();

    return BlocConsumer<UserBloc,UserState>(
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Edit Profile"),
            backgroundColor: Color(0xFF599BF9),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () =>  Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainMenuScreen()),
              )
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Picture
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        userBloc.add(UploadFileEvent());
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: context.read<UserBloc>().state.user?.profileImage != null
                            ? MemoryImage(base64Decode(context.read<UserBloc>().state.user!.profileImage!))
                            : AssetImage("assets/images/USER_ICON.png"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name Field
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      hintText: "Enter your name",
                    ),
                    validator: (value) {
                      if (value == null || value.length < 2) {
                        return "Name must be at least 2 characters.";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      name = value;
                      _updateHasChanges();
                    },
                  ),

                  // Age Field
                  TextFormField(
                    initialValue: age,
                    decoration: const InputDecoration(
                      labelText: "Age",
                      hintText: "Enter your age",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || int.tryParse(value) == null) {
                        return "Please enter a valid age.";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      age = value;
                      _updateHasChanges();
                    },
                  ),

                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Gender"),
                    value: gender == 'M' ? "male" : 'female',
                    items: const [
                      DropdownMenuItem(value: "male", child: Text("Male")),
                      DropdownMenuItem(value: "female", child: Text("Female")),
                    ],
                    onChanged: (value) {
                      gender = value == "male" ? 'M' : 'F';
                      _updateHasChanges();
                    },
                    validator: (value) =>
                    value == null ? "Please select a gender." : null,
                  ),

                  // Weight Field
                  TextFormField(
                    initialValue: weight,
                    decoration: const InputDecoration(
                      labelText: "Weight (kg)",
                      hintText: "Enter your weight in kilograms",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return "Please enter a valid weight.";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      weight = value;
                      _updateHasChanges();
                    },
                  ),

                  // Height Field
                  TextFormField(
                    initialValue: height,
                    decoration: const InputDecoration(
                      labelText: "Height (cm)",
                      hintText: "Enter your height in centimeters",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return "Please enter a valid height.";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      height = value;
                      _updateHasChanges();
                    },
                  ),
                  TextFormField(
                    initialValue: goalCalories,
                    decoration: const InputDecoration(
                      labelText: "Goal Calories Per Day (kcal)",
                      hintText: "Enter your goal calories in whole number",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          int.tryParse(value) == null ||
                          int.parse(value) <= 0) {
                        return "Please enter a valid calories in whole number.";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      goalCalories = value;
                      _updateHasChanges();
                    },
                  ),
                  // Area Field
                  TextFormField(
                    initialValue: area,
                    decoration: const InputDecoration(
                      labelText: "Area of Living",
                      hintText: "Enter your area of living",
                    ),
                    validator: (value) {
                      if (value == null || value.length < 2) {
                        return "Please enter your area of living.";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      area = value;
                      _updateHasChanges();
                    },
                  ),

                  // Family Members Field
                  TextFormField(
                    initialValue: familyMembers,
                    decoration: const InputDecoration(
                      labelText: "Number of Family Members",
                      hintText: "Enter the number of family members",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || int.tryParse(value) == null) {
                        return "Please enter a valid number.";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      familyMembers = value;
                      _updateHasChanges();
                    },
                  ),

                  // Occupation Type Field
                  TextFormField(
                    initialValue: occupationType,
                    decoration: const InputDecoration(
                      labelText: "Occupation Type",
                      hintText: "e.g., Software Engineer, Teacher, Project Manager",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your occupation type.";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      occupationType = value;
                      _updateHasChanges();
                    },
                  ),

                  // Work Hours Field
                  TextFormField(
                    initialValue: workHours,
                    decoration: const InputDecoration(
                      labelText: "Work Hours",
                      hintText: "e.g., 9:00 AM - 5:00 PM",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please specify your work hours.";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      workHours = value;
                      _updateHasChanges();
                    },
                  ),

                  // Health History Field
                  TextFormField(
                    initialValue: healthHistory,
                    decoration: const InputDecoration(
                      labelText: "Health History",
                      hintText: "Enter any relevant health history or conditions",
                    ),
                    maxLines: 4,
                    onChanged: (value) {
                      healthHistory = value;
                      _updateHasChanges();
                    },
                  ),

                  const SizedBox(height: 16),
                  // Submit Button

                  // Use ValueListenableBuilder for the button
                  ValueListenableBuilder<bool>(
                    valueListenable: _hasChangesNotifier,
                    builder: (context, hasChanges, child) {
                      return ElevatedButton(
                        onPressed: hasChanges
                            ? _handleUpdate:null,
                        child: const Text("Save Changes"),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }, listener: (context, state) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Changes'),
              content: const Text('Are you sure you want to update your profile image?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                  Navigator.of(context).pop(true);
                  context.read<UserBloc>().add(UploadProfileImageEvent(context.read<UserBloc>().state.file!, context.read<UserBloc>().state.user!.id));
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        ); // Return
    },
      listenWhen: (context,state){
        return (state.status == UserStatus.fileUploaded);
      },
    );
  }
}