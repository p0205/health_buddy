import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/authentication/src/screens/splash_screen.dart';
import 'package:http/http.dart' as http;
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../newUserGuide/greeting/greeting.dart';
import '../../../commom_widgets/side_bar.dart';
import '../../../meal_and_sport/src/calories_counter/calories_counter_main/blocs/calories_counter_main_bloc.dart';
import '../../../meal_and_sport/src/calories_counter/calories_counter_main/screen/calories_counter_main.dart';
import '../../../meal_and_sport/src/calories_counter/search_meal/blocs/search_meal_bloc.dart';
import '../../../meal_and_sport/src/sport/search_sport/bloc/search_sport_bloc.dart';
import '../../../meal_and_sport/src/sport/sport_main/blocs/sport_main_bloc.dart';
import '../../../meal_and_sport/src/sport/sport_main/screen/sport_main_page.dart';
import '../../../meal_and_sport/src/user/blocs/user_bloc.dart';
import '../../../newUserGuide/greeting/greeting_bloc.dart';
import 'login_screen.dart';

// Reusable Popup Dialog Function
void showPopupDialog(BuildContext context, String message, {VoidCallback? onOkPressed}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Notification'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onOkPressed != null) onOkPressed();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

class MainMenuScreen extends StatelessWidget {
  final String token;

  // Constructor to receive the token
  const MainMenuScreen({super.key, required this.token});

  Future<void> _logout(BuildContext context) async {
    try {
      final url = Uri.parse('http://10.0.2.2:8000/api/logout'); // Replace with your backend logout URL

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('email');
        await prefs.remove('password');
        await prefs.remove('rememberMe');

        // Optionally, clear any other session data or token if needed
        // You can also clear the token here if you're storing it in SharedPreferences
        // await prefs.remove('token');

        // Logout successful
        showPopupDialog(
          context,
          'Logged out successfully',
          onOkPressed: () {
            Restart.restartApp(
            );
          },
        );
      } else {
        // Handle logout failure
        showPopupDialog(
          context,
          'Logout failed',
        );
      }
    } catch (e) {
      // Handle connection errors
      showPopupDialog(
        context,
        'An error occurred: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    toCaloriesBurntPage() {
      final bloc = context.read<SportMainBloc>();
      bloc.add(SportDateChangedEvent(date: DateTime.now()));
      bloc.add(LoadUserSportList());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) {
              return BlocProvider.value(
                value: bloc,
                child: SportMainPage(bloc:bloc),
              );
            }, settings: const RouteSettings(name: "/sportMain")
        ),
      );
    }

    toCaloriesIntakePage() {
      final bloc = context.read<CaloriesCounterMainBloc>();
      // final sportBloc = context.read<SportMainBloc>();
      bloc.add(DateChangedEvent(date: DateTime.now()));
      bloc.add(LoadInitialDataEvent());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) {
              return
                BlocProvider.value(
                  value: bloc,
                  child: CaloriesCounterMainScreen(bloc: bloc),
                );
            }, settings: const RouteSettings(name: "/mealMain")
        ),
      );
    }




    final bloc = context.read<UserBloc>();
    final name = bloc.state.name;
    final email = bloc.state.email;
    final id = bloc.state.userId;


    final caloriesBurnt = (context.read<SportMainBloc>().state.sportSummary?.totalCalsBurnt ?? 0.0)
        .toStringAsFixed(2)
        .trim();
    final caloriesIntake = (context.read<CaloriesCounterMainBloc>().state.summary?.caloriesIntake ?? 0.0)
        .toStringAsFixed(2)
        .trim();

    return Scaffold(
      appBar: AppBar(
        title: Text('Health Buddy',
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: SideBar(userId: id!, userEmail: email!,userName: name!),
      body: SafeArea(
        child: Stack(
          children: [Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/BACKGROUND.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 16.0), // Adjusted top padding
                  child: Text(
                      "My Dashboard",
                      style:  TextStyle(
                        fontFamily: 'Itim',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center
                  ),
                ),
                CircleAvatar(
                  radius: 100.0,
                  backgroundImage: AssetImage('assets/images/LOGO.png'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to profile edit screen
                  },
                  child: Text('Edit Profile'),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    padding: EdgeInsets.all(16.0),
                    children: [
                      _buildStatCard(title: 'Task Completed',value:  '0', icon: Icons.task_alt),
                      _buildStatCard(title: 'Calories Burned',value:  '$caloriesBurnt kcal', icon: Icons.local_fire_department,onTap: toCaloriesBurntPage),
                      _buildStatCard(title: 'Today Performance',value:  '0%',icon:  Icons.show_chart),
                      _buildStatCard(title: 'Calories Intake', value: '$caloriesIntake kcal', icon: Icons.restaurant,onTap: toCaloriesIntakePage),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _logout(context);
                    },
                    child: Text('Logout'),
                  ),
                ),
              ],
            ),
          ),
            // BlocBuilder<GreetingBloc, GreetingState>(
            //   builder: (context, state) {
            //     if (state is GreetingVisibleState) {
            //       return GreetingOverlay(
            //         userName: name,
            //         onDismiss: () {
            //           context.read<GreetingBloc>().add(DismissGreetingEvent());
            //         },
            //       );
            //     }
            //     return SizedBox.shrink(); // Return empty if greeting is not visible
            //   },
            // ),
          ]
        ),
      ),
    );




  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
     VoidCallback? onTap, // Add the onTap callback
  }) {
    return GestureDetector(
      onTap: onTap, // Use the passed onTap callback
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40.0,
                color: Colors.blue,
              ),
              SizedBox(height: 10.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.0),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }


}

