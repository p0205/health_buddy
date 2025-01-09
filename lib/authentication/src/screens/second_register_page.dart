import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/buttonDefault.dart';
import '../widgets/loadingDefault.dart';
import '../widgets/popupDialogDefault.dart';
import '../widgets/textFieldDefault.dart';
import 'login_screen.dart';
import 'otp_page.dart';

class SecondRegisterPage extends StatefulWidget {
  final String email;
  final String password;

  const SecondRegisterPage({required this.email, required this.password});

  @override
  _SecondRegisterPageState createState() => _SecondRegisterPageState();
}

class _SecondRegisterPageState extends State<SecondRegisterPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String? _selectedGender;
  final List<String> _genders = ['Male', 'Female'];
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  void showPopupDialog(BuildContext context, String message,
      {VoidCallback? onOkPressed}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Disable the back button
          child: PopupDialog(
            message: message,
            onOkPressed: onOkPressed,
          ),
        );
      },
    );
  }

  Future<void> _toOtpPage() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final int age = int.parse(_ageController.text);
      final double weight = double.parse(_weightController.text);
      final double height = double.parse(_heightController.text);

      try {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>
              OTPPage(email: widget.email,
                  name: _nameController.text,
                  password: widget.password,
                  gender: _selectedGender == "Female" ? 'F' : 'M',
                  age: age,
                  weight: weight,
                  height: height)),
        );
      }
      finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complete Registration')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/BACKGROUND.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextFormField(
                  controller: _nameController,
                  labelText: 'Name',
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  items: _genders.map<DropdownMenuItem<String>>((
                      String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    labelStyle: TextStyle(color: Colors.black),
                    floatingLabelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    prefixIcon: Icon(Icons.person_2, color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DefaultTextFormField(
                  controller: _ageController,
                  labelText: 'Age',
                  prefixIcon: Icons.cake,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    } else if (int.tryParse(value) == null ||
                        int.parse(value) < 18) {
                      return 'Please enter a valid age (18 or older)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DefaultTextFormField(
                  controller: _weightController,
                  labelText: 'Weight (in kg)',
                  prefixIcon: Icons.fitness_center,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    } else if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DefaultTextFormField(
                  controller: _heightController,
                  labelText: 'Height (in cm)',
                  prefixIcon: Icons.height,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    } else if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                _isLoading
                    ? LoadingIndicator()
                    : DefaultButton(
                  text: 'Register',
                  onPressed: _toOtpPage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


