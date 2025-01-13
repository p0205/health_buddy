import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/sport/sport_main/screen/sport_main_page.dart';
import 'package:health_buddy/meal_and_sport/src/user/screen/user_profile_screen.dart';
import 'package:health_buddy/riskAssessment/src/blocs/risk_bloc.dart';
import 'package:health_buddy/riskAssessment/src/screen/risk_main_screen.dart';


import '../authentication/src/screens/main_menu_screen.dart';
import '../meal_and_sport/src/calories_counter/calories_counter_main/blocs/calories_counter_main_bloc.dart';
import '../meal_and_sport/src/calories_counter/calories_counter_main/screen/calories_counter_main.dart';
import '../meal_and_sport/src/sport/sport_main/blocs/sport_main_bloc.dart';
import '../meal_and_sport/src/user/blocs/user_bloc.dart';
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

  @override
  Widget build(BuildContext context) {

        return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 160,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: _buildUserProfileHeader(context),
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
                Navigator.pop(context);
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
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
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
