import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/sport/sport_main/screen/sport_main_page.dart';
import 'package:health_buddy/meal_and_sport/src/user/screen/user_profile_screen.dart';
import 'package:health_buddy/riskAssessment/src/blocs/risk_bloc.dart';
import 'package:health_buddy/riskAssessment/src/screen/risk_main_screen.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:health_buddy/constants.dart' as Constants;
import 'package:http/http.dart' as http;


import '../authentication/src/screens/main_menu_screen.dart';
import '../meal_and_sport/src/calories_counter/calories_counter_main/blocs/calories_counter_main_bloc.dart';
import '../meal_and_sport/src/calories_counter/calories_counter_main/screen/calories_counter_main.dart';
import '../meal_and_sport/src/sport/sport_main/blocs/sport_main_bloc.dart';
import '../meal_and_sport/src/user/blocs/user_bloc.dart';
import '../performance_analysis/ui/pages/performance_page.dart';
import '../schedule_generator/src/ui/schedule_module/pages/schedule_page.dart';

class SideBar extends StatelessWidget {
  final int userId;
  final String userName;
  final String userEmail;
  final String? profileIcon; // Accept profileIcon as nullable

  const SideBar({
    super.key,
    required this.userName,
    required this.userEmail,
    this.profileIcon, required this.userId,
  });

  Future<void> _logout(BuildContext context) async {
    try {
      final token = context.read<UserBloc>().state.token!;
      final url = Uri.parse('${Constants.BaseUrl}${Constants.AunthenticationPort}/logout'); // Replace with your backend logout URL

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      final prefs = await SharedPreferences.getInstance();
      if (response.statusCode == 200) {
        if (prefs.getBool('rememberMe') == false) {
          // Clear all stored data
          await prefs.clear();
        } else {
          // Clear only the token
          final email = prefs.getString('email');
          await prefs.setString('email', email!);
          await prefs.setBool('rememberMe', true);
        }

            Restart.restartApp();
        // Optionally, clear any other session data or token if needed
        // You can also clear the token here if you're storing it in SharedPreferences
        // await prefs.remove('token');

        // Logout successful
        // showPopupDialog(
        //   context,
        //   'Logged out successfully',
        //   onOkPressed: () {
        //     Restart.restartApp(
        //     );
        //   },
        // );
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

        return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 160,
              decoration: const BoxDecoration(
                color: Color(0xFF599BF9)
              ),
              child: _buildUserProfileHeader(context),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () async {
                final bloc = context.read<CaloriesCounterMainBloc>();
                final sportBloc = context.read<SportMainBloc>();

                // Trigger loading events
                bloc.add(DateChangedEvent(date: DateTime.now()));
                bloc.add(ReloadMealList());
                sportBloc.add(SportDateChangedEvent(date: DateTime.now()));
                sportBloc.add(LoadUserSportList());
                // Show a loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                // Wait for the data to be loaded based on the state property
                await Future.wait([
                  bloc.stream.firstWhere((state) => state.status == CaloriesCounterMainStatus.mealListLoaded),
                  sportBloc.stream.firstWhere((state) => state.status == SportMainStatus.sportListLoaded ||state.status == SportMainStatus.noRecordFound  ),
                ]);

                // Dismiss the loading dialog
                Navigator.of(context, rootNavigator: true).pop();

                // Proceed to navigation
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainMenuScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: ()  {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Schedule'),
              onTap: () {
                Navigator.pop(context);
                final userId = context.read<UserBloc>().state.userId.toString();
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => SchedulePage(user_id: userId),
                ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text('Calories Intake'),
              onTap: () {
                final bloc = context.read<CaloriesCounterMainBloc>();
                // final sportBloc = context.read<SportMainBloc>();
                bloc.add(DateChangedEvent(date: DateTime.now()));
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_fire_department),
              title: const Text('Calories Burned'),
              onTap: () {
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text('Performance'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerformancePage(userId: userId),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assessment),
              title: const Text('Risk Assessment'),
              onTap: () {
                final bloc = context.read<RiskBloc>();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) {
                        return BlocProvider.value(
                          value: bloc,
                          child: RiskMainScreen(),
                        );
                      }, settings: const RouteSettings(name: "/riskMain")
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Close the dialog without logging out
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _logout(context);
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

              },
            ),
          ],
        ),
              );


  }

  Widget _buildUserProfileHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: context.read<UserBloc>().state.user?.profileImage != null
                ? MemoryImage(base64Decode(context.read<UserBloc>().state.user!.profileImage!))
                : AssetImage("assets/images/USER_ICON.png"),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.read<UserBloc>().state.user!.name!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.read<UserBloc>().state.user!.email!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
