import 'package:flutter/material.dart';

Widget DefaultButton({
  required String text,
  required VoidCallback onPressed,
  Color textColor = Colors.white,
  Color? backgroundColor = const Color(0xFF05100B),
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
  double borderRadius = 50.0,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(color: textColor),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  );
}
