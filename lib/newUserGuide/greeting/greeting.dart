import 'package:flutter/material.dart';

class GreetingOverlay extends StatelessWidget {
  final String userName;
  final VoidCallback onDismiss;

  const GreetingOverlay({
    super.key,
    required this.userName,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.black.withOpacity(0.5), // Semi-transparent background
        child: Center(
          child: Material(
            borderRadius: BorderRadius.circular(16),
            elevation: 8,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hi, ${userName.split(' ').first}! 👋",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Welcome to Health Buddy! Health Buddy is your personal companion to achieve your health goals. Let's get started!",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: onDismiss,
                    child: Text("Start"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
