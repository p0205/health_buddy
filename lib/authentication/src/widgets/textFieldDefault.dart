import 'package:flutter/material.dart';

Widget DefaultTextFormField({
  required TextEditingController controller,
  required String labelText,
  required IconData prefixIcon,
  required String? Function(String?)? validator,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,

  // Modify colors here
  Color cursorColor = Colors.black,  // Red cursor color
  Color borderColor = Colors.black,  // Red border color
  Color labelColor = Colors.black,   // Red label color
}) {
  return TextFormField(
    controller: controller,
    cursorColor: cursorColor,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: labelColor),
      floatingLabelStyle: TextStyle(color: borderColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),  // Increased radius for more rounded corners
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),  // Consistent rounded corners when focused
        borderSide: BorderSide(color: borderColor),
      ),
      prefixIcon: Icon(prefixIcon, color: borderColor), // Change icon color to match the border
    ),
    obscureText: obscureText,
    keyboardType: keyboardType,
    validator: validator,
  );
}