import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onOkPressed;

  const PopupDialog({
    super.key,
    this.title = 'HEALTH BUDDY',
    required this.message,
    this.onOkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Rounded corners with softer radius
      ),
      elevation: 10, // Adding elevation for shadow
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85, // 85% of screen width for wider dialog
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white, // White background
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.pinkAccent.withOpacity(0.3), // Pink shadow for emphasis
              blurRadius: 8,
              offset: Offset(0, 4), // Shadow for the container
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Title with pink color
            Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD81B60), // Dark pink for the title
              ),
            ),
            const SizedBox(height: 12),

            // Message with black text
            Text(
              message,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // OK button with pink background and curved shape
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onOkPressed != null) onOkPressed!();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white, // White text on pink button
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                backgroundColor: Color(0xFFFF4081), // Vibrant pink for button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Curved button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}