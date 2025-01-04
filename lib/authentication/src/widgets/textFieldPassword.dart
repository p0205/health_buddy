import 'package:flutter/material.dart';

class PasswordTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final Color cursorColor;
  final Color borderColor;

  const PasswordTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.cursorColor = Colors.black,
    this.borderColor = Colors.black,
  }) : super(key: key);

  @override
  _PasswordTextFormFieldState createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !_isPasswordVisible,
      cursorColor: widget.cursorColor,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Colors.grey),  // Label color
        floatingLabelStyle: TextStyle(color: widget.borderColor),  // Floating label color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),  // Increased border radius for more rounded corners
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),  // Matching the rounded corners when focused
          borderSide: BorderSide(color: widget.borderColor),  // Red border when focused
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: widget.borderColor,  // Prefix icon color
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: widget.cursorColor,  // Suffix icon color matches the cursor
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: widget.validator ??
              (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters';
            } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{6,}$')
                .hasMatch(value)) {
              return 'Include uppercase, lowercase, number, and symbol';
            }
            return null;
          },
    );
  }
}
