import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/sport/sport_main/screen/sport_main_page.dart';
import '../../meal_and_sport/src/calories_counter/calories_counter_main/blocs/calories_counter_main_bloc.dart';
import '../../meal_and_sport/src/calories_counter/calories_counter_main/screen/calories_counter_main.dart';
import '../../meal_and_sport/src/calories_counter/search_meal/blocs/search_meal_bloc.dart';
import '../../meal_and_sport/src/sport/search_sport/bloc/search_sport_bloc.dart';
import '../../meal_and_sport/src/sport/sport_main/blocs/sport_main_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/main_menu_screen.dart';
import 'screens/splash_screen.dart'; // Include the SplashScreen

// void main() {
//   // runApp(MyApp());
// }

class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Login App',
      debugShowCheckedModeBanner: false, // Remove debug banner
      // initialRoute: '/', // Set SplashScreen as the default route
      // routes: {
      //   '/': (context) => SplashScreen(),
      //   // Show SplashScreen first
      //   // '/login': (context) => LoginScreen(),
      //   // // Route for LoginScreen
      //   // '/mainMenu': (context) => MainMenuScreen(token: ''),
      //   // Placeholder for MainMenu
      //   // '/mealMain': (context) => CaloriesCounterMainScreen(date: DateTime.now()),
      //   // '/sportMain': (context) => SportMainPage(),
      // },
      home: SplashScreen(),
    );
  }
}