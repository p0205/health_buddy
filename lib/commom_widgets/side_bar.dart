import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/sport/sport_main/screen/sport_main_page.dart';


import '../authentication/src/screens/main_menu_screen.dart';
import '../meal_and_sport/src/calories_counter/calories_counter_main/blocs/calories_counter_main_bloc.dart';
import '../meal_and_sport/src/calories_counter/calories_counter_main/screen/calories_counter_main.dart';
import '../meal_and_sport/src/sport/sport_main/blocs/sport_main_bloc.dart';
import '../meal_and_sport/src/user/blocs/user_bloc.dart';

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
              child: _buildUserProfileHeader(),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                final token = context.read<UserBloc>().state.token;
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainMenuScreen(token: token!),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Schedule'),
              onTap: () {
                Navigator.pop(context);
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
              title: const Text('Assessment'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
              );

  }

  Widget _buildUserProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: profileIcon != null
                ? NetworkImage(profileIcon!) // Load image from URL
                : const AssetImage('assets/images/USER_ICON.png') as ImageProvider, // Fallback to default image
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
