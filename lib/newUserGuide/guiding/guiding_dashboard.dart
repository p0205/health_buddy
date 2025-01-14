import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../newUserGuide/greeting/greeting.dart';
import '../../../../commom_widgets/side_bar.dart';
import '../../../../newUserGuide/greeting/greeting_bloc.dart';
import '../../authentication/src/screens/main_menu_screen.dart';
import '../../meal_and_sport/src/calories_counter/calories_counter_main/blocs/calories_counter_main_bloc.dart';
import '../../meal_and_sport/src/sport/sport_main/blocs/sport_main_bloc.dart';
import '../../meal_and_sport/src/user/blocs/user_bloc.dart';
import 'guiding_side_bar.dart';

class GuidingDashboard extends StatefulWidget {
  final String username;
  const GuidingDashboard({super.key, required this.username});

  @override
  State<GuidingDashboard> createState() => _GuidingDashboardState();
}

class _GuidingDashboardState extends State<GuidingDashboard> {
  final GlobalKey _caloriesBurnedKey = GlobalKey();
  final GlobalKey _caloriesIntakeKey = GlobalKey();
  final GlobalKey _todayPerformanceKey = GlobalKey();
  final GlobalKey _taskCompletedKey = GlobalKey();
  final GlobalKey _sideBarKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // Ensure Greeting is shown when necessary
    context.read<GreetingBloc>().add(ShowGreetingEvent());

    final userBlocState = context.read<UserBloc>().state;
    final String username = userBlocState.name!;
    final String email = userBlocState.user!.email!;
    final userId = userBlocState.userId;
    return ShowCaseWidget(
      builder: (context) => Stack(
        children: [
          Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Health Buddy'),
              backgroundColor: Color(0xFF599BF9),
              leading: Showcase(
                key: _sideBarKey,
                description: "Your side bar is here.",
                disposeOnTap: true, // Close the showcase when tapped
                onTargetClick: () {
                  // Open the drawer when the user taps on the showcase
                  _scaffoldKey.currentState?.openDrawer();
                },
                disableBarrierInteraction:true,
                child: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    // Open drawer explicitly
                    Scaffold.of(context).openDrawer();
                  },

                ),
              )
            ),
            drawer: GuidingSideBarWidget(userEmail: email, userName: username), //There is an  built-in icon here
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
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
                          padding: const EdgeInsets.only(top: 50.0, bottom: 16.0),
                          child: Text(
                            "My Dashboard",
                            style: TextStyle(
                              fontFamily: 'Itim',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
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
                              Showcase(
                                key: _taskCompletedKey,
                                description:
                                "This section shows the number of tasks you've completed today. It's a great way to track your daily progress!",
                                child: _buildStatCard(
                                  title: 'Task Completed',
                                  value: '0',
                                  icon: Icons.task_alt,
                                ),
                              ),
                              Showcase(
                                key: _caloriesBurnedKey,
                                description:
                                "Here, you can see the total calories you've burned today through your physical activities.",
                                child: _buildStatCard(
                                  title: 'Calories Burned',
                                  value: ' 0 kcal',
                                  icon: Icons.local_fire_department,
                                ),
                              ),
                              Showcase(
                                key: _todayPerformanceKey,
                                description:
                                "This is your overall performance percentage for the day. It combines your tasks, calories burned, and intake into a simple score.",
                                child: _buildStatCard(
                                  title: 'Today Performance',
                                  value: '0%',
                                  icon: Icons.show_chart,
                                ),
                              ),
                              Showcase(
                                key: _caloriesIntakeKey,
                                description:
                                "This section displays the total calories you've consumed today. Keep an eye on it to maintain a healthy balance!",
                                child: _buildStatCard(
                                  title: 'Calories Intake',
                                  value: ' 0 kcal',
                                  icon: Icons.restaurant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // _logout(context);
                            },
                            child: Text('Logout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<GreetingBloc, GreetingState>(
                    builder: (context, state) {
                      if (state is GreetingVisibleState) {
                        return GreetingOverlay(
                          userName: widget.username,
                          onDismiss: () {
                            context.read<GreetingBloc>().add(DismissGreetingEvent());
                            ShowCaseWidget.of(context).startShowCase([
                              _taskCompletedKey,
                              _caloriesBurnedKey,
                              _todayPerformanceKey,
                              _caloriesIntakeKey,
                              _sideBarKey
                            ]);
                          },
                        );
                      }
                      return SizedBox.shrink(); // Return empty if greeting is not visible
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      onFinish: (){
        context.read<GreetingBloc>().add(CompletedTutorialEvent(userId: userId!, isFirstLogin: false));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<SportMainBloc>.value(
                  value: context.read<SportMainBloc>(),
                ),
                BlocProvider<CaloriesCounterMainBloc>.value(
                  value: context.read<CaloriesCounterMainBloc>(),
                ),
              ],
              child: MainMenuScreen(),
            ),
          ),
        );
        _showOverlayDialog();
      },
    );

  }

  void _showOverlayDialog() {

    // Close the drawer
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("Welcome aboard!")),
          content: Text("Your journey towards a healthier lifestyle begins now. Your Health Buddy is here to help!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Got it"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
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
    );
  }
}
