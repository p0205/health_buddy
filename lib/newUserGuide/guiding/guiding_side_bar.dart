import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/sport/sport_main/screen/sport_main_page.dart';
import 'package:showcaseview/showcaseview.dart';


class GuidingSideBarWidget extends StatefulWidget {

  final String userName;
  final String userEmail;
  final String? profileIcon; // Accept profileIcon as nullable



  const GuidingSideBarWidget({
    super.key,
    required this.userName,
    required this.userEmail,
    this.profileIcon,
  });

  @override
  State<GuidingSideBarWidget> createState() => _GuidingSideBarState();
}

class _GuidingSideBarState extends State<GuidingSideBarWidget> {

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _scheduleKey = GlobalKey();
  final GlobalKey _calsIntakeKey = GlobalKey();
  final GlobalKey _calsBurntKey = GlobalKey();
  final GlobalKey _performanceKey = GlobalKey();
  final GlobalKey _assessmentKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    //Start showcase view after current widget frames are drawn.
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase(
          [_homeKey, _scheduleKey, _calsIntakeKey, _calsBurntKey, _performanceKey, _assessmentKey]),
    );
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
              color: Color(0xFF599BF9),
            ),
            child: _buildUserProfileHeader(),
          ),
          Showcase(
            key: _homeKey,
            description: "View your daily dashboard to track tasks, calories burned, intake, and performance.",
            child: ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
            ),
          ),
          Showcase(
            key: _homeKey,
            description: "Manage your profile here.",
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
            ),
          ),
          Showcase(
            key: _scheduleKey,
            description:"Generate personalized daily schedules using AI." ,
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Schedule'),
            ),
          ),
          Showcase(
            key: _calsIntakeKey,
            description: "Add your meals—breakfast, lunch, dinner, or snacks—and see your calorie breakdown for the day.",
            child: ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text('Calories Intake'),
            ),
          ),
          Showcase(
            key: _calsBurntKey,
            description:"Log your workouts, track calories burned, and check your activity history by date." ,
            child: ListTile(
              leading: const Icon(Icons.local_fire_department),
              title: const Text('Calories Burned'),
            ),
          ),
          Showcase(
            key: _performanceKey,
            description: "Keep an eye on your progress with weekly and monthly performance insights.",
            child: ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text('Performance'),
            ),
          ),
          Showcase(
            key: _assessmentKey,
            description: "Answer a quick health quiz, and we’ll help assess your risk for certain conditions.",
            child: ListTile(
              leading: const Icon(Icons.assessment),
              title: const Text('Risk Assessment'),
            ),
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
            backgroundImage: widget.profileIcon != null
                ? NetworkImage(widget.profileIcon!) // Load image from URL
                : const AssetImage('assets/images/USER_ICON.png') as ImageProvider, // Fallback to default image
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.userEmail,
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
