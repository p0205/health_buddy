import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_menu_screen.dart';
import 'screens/splash_screen.dart'; // Include the SplashScreen

// void main() {
//   // runApp(MyApp());
// }

class AuthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Login App',
      debugShowCheckedModeBanner: false, // Remove debug banner
      initialRoute: '/', // Set SplashScreen as the default route
      routes: {
        '/': (context) => SplashScreen(),
        // Show SplashScreen first
        '/login': (context) => LoginScreen(),
        // Route for LoginScreen
        '/mainMenu': (context) => MainMenuScreen(token: ''),
        // Placeholder for MainMenu
      },
    );
  }
}