import 'dart:async';

import 'package:flutter/material.dart';
class SuggestionLoadingScreen extends StatefulWidget {
  const SuggestionLoadingScreen({super.key});

  @override
  State<SuggestionLoadingScreen> createState() => _SuggestionLoadingScreenState();
}

class _SuggestionLoadingScreenState extends State<SuggestionLoadingScreen> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  List<String> loadingTexts = [
    'Analyzing your health data',
    'Generating personalized insights',
    'Crafting tailored recommendations',
    'Preparing your health roadmap',
  ];
  int _currentTextIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize glow animation controller
    _bounceController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Change loading texts periodically
    Future.delayed(Duration.zero, () {
      setState(() {
        _currentTextIndex = 0;
      });
      _startTextTimer();
    });
  }

  void _startTextTimer() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentTextIndex = (_currentTextIndex + 1) % loadingTexts.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title text
            SizedBox(height: 20),

            // Animated health cross icon with pulsating glow
            AnimatedBuilder(
              animation: _bounceController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _bounceAnimation.value),
                  child: Icon(
                    Icons.health_and_safety,
                    color: Color(0xFF4CAF50), // Green icon
                    size: 80,
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Dynamic loading text
            Text(
              loadingTexts[_currentTextIndex],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            SizedBox(height: 20),

            // Footer text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "We're preparing your personalized health insights. This may take a moment. Thank you for your patience!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );

  }
}
