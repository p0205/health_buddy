import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/buttonDefault.dart';
import '../widgets/loadingDefault.dart';
import '../widgets/textFieldDefault.dart';
import '../widgets/textFieldPassword.dart';
import 'second_register_page.dart';
import '../widgets/popupDialogDefault.dart';
import 'package:health_buddy/constants.dart' as Constants;

class FirstRegisterPage extends StatefulWidget {
  const FirstRegisterPage({super.key});

  @override
  State<FirstRegisterPage> createState() => _FirstRegisterPageState();
}

class _FirstRegisterPageState extends State<FirstRegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Function to show popup messages
  void showPopupDialog(BuildContext context, String message, {VoidCallback? onOkPressed}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PopupDialog(
          message: message,
          onOkPressed: onOkPressed,
        );
      },
    );
  }

  // Function to check if the email is available
  Future<void> _checkEmailAvailability() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse(Constants.BaseUrl + Constants.AunthenticationPort + '/check-email'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}),
        );

        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SecondRegisterPage(email: email, password: _passwordController.text),
            ),
          );
        } else {
          showPopupDialog(context, 'This email is already taken.');
        }
      } catch (e) {
        showPopupDialog(context, 'Error checking email: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/BACKGROUND.png'), // Your background image
            fit: BoxFit.cover, // Cover the whole screen
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
                  controller: _emailController,
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                PasswordTextFormField(
                  controller: _passwordController,
                  labelText: 'Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,12}$')
                        .hasMatch(value)) {
                      return 'Password must be 8-12 characters,\nincluding at least one uppercase letter,\none lowercase letter, one numeral, and one symbol.';
                    }
                    return null;
                  },

                ),
                SizedBox(height: 16.0),
                PasswordTextFormField(
                  labelText: 'Confirm Password',
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                _isLoading
                    ? LoadingIndicator()
                    : DefaultButton(
                  text: 'Register',
                  onPressed: _checkEmailAvailability,
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}