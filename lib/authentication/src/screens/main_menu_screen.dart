import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../commom_widgets/side_bar.dart';
import '../../../meal_and_sport/src/calories_counter/calories_counter_main/blocs/calories_counter_main_bloc.dart';
import '../../../meal_and_sport/src/calories_counter/calories_counter_main/screen/calories_counter_main.dart';
import '../../../meal_and_sport/src/sport/sport_main/blocs/sport_main_bloc.dart';
import '../../../meal_and_sport/src/sport/sport_main/screen/sport_main_page.dart';
import '../../../meal_and_sport/src/user/blocs/user_bloc.dart';
import 'package:health_buddy/constants.dart' as Constants;

import '../../../meal_and_sport/src/user/blocs/user_state.dart';

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


  // Constructor to receive the token
  const MainMenuScreen({super.key});
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
    final id = bloc.state.userId;


    final caloriesBurnt = (context.read<SportMainBloc>().state.sportSummary?.totalCalsBurnt ?? 0.0)
        .toStringAsFixed(2)
        .trim();
    final caloriesIntake = (context.read<CaloriesCounterMainBloc>().state.summary?.caloriesIntake ?? 0.0)
        .toStringAsFixed(2)
        .trim();

    return Scaffold(
      appBar: AppBar(
          title: Text('Health Buddy',),
          backgroundColor: Color(0xFF599BF9)

      ),
      drawer: SideBar(userId: id!, userEmail: context.read<UserBloc>().state.user!.email!,userName: context.read<UserBloc>().state.name!),
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
            child: BlocBuilder<UserBloc,UserState>(
              builder: (context,state){
                print("DASHBOARD");
                print(context.read<UserBloc>().state.name);
                return  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, bottom: 16.0), // Adjusted top padding
                      child: Text(
                          "Welcome Back, ${context.read<UserBloc>().state.user?.name?.split(' ').first ?? 'User'}!",
                          style:  TextStyle(
                            fontFamily: 'Itim',
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center
                      ),
                    ),
                    CircleAvatar(
                      radius: 100.0,
                      backgroundImage: context.read<UserBloc>().state.user?.profileImage != null
                          ? MemoryImage(base64Decode(context.read<UserBloc>().state.user!.profileImage!))
                          : AssetImage("assets/images/USER_ICON.png"),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Navigate to profile edit screen
                    //   },
                    //   child: Text('Edit Profile'),
                    // ),
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
                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       _logout(context);
                    //     },
                    //     child: Text('Logout'),
                    //   ),
                    // ),
                  ],
                );
              }

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

