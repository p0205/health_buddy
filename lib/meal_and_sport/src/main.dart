import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/sport/search_sport/bloc/search_sport_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/sport/sport_main/blocs/sport_main_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/sport/sport_main/screen/sport_main_page.dart';
import 'package:health_buddy/meal_and_sport/src/user/blocs/user_bloc.dart';
import 'package:provider/provider.dart';
import 'calories_counter/calories_counter_main/blocs/calories_counter_main_bloc.dart';
import 'calories_counter/calories_counter_main/screen/calories_counter_main.dart';
import 'calories_counter/search_meal/blocs/search_meal_bloc.dart';


// void main() {
  // int userId = 1;
  // DateTime date  = DateTime.now();
  // // DateTime date  = new DateTime(2024,1,1);
  // runApp(
  //     MultiBlocProvider(
  //         providers: [
  //           BlocProvider<SearchFoodBloc>(
  //             create: (context) =>
  //                 SearchFoodBloc(),
  //           ),
  //           BlocProvider<SearchSportBloc>(
  //             create: (context) =>
  //                 SearchSportBloc(),
  //           ),
  //           BlocProvider<CaloriesCounterMainBloc>(
  //             create: (context) =>
  //                 CaloriesCounterMainBloc(userId: userId,date: date),
  //           ),
  //           BlocProvider<SportMainBloc>(
  //             create: (context) =>
  //                 SportMainBloc(userId: userId,date: date),
  //           ),
  //           BlocProvider<UserBloc>(
  //             create: (context) =>
  //                 UserBloc(),
  //           ),
  //
  //         ],
  //         child:  SportAndMealApp()
  //     ));
// }

class MealAndSportApp extends StatelessWidget {

  final int userId;
  final DateTime date;

  const MealAndSportApp({
    super.key,
    required this.userId,
    required this.date,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<SearchFoodBloc>(
            create: (context) =>
                SearchFoodBloc(),
          ),
          BlocProvider<SearchSportBloc>(
            create: (context) =>
                SearchSportBloc(),
          ),
          BlocProvider<CaloriesCounterMainBloc>(
            create: (context) =>
                CaloriesCounterMainBloc(),
          ),
          BlocProvider<SportMainBloc>(
            create: (context) =>
                SportMainBloc(),
          ),
          BlocProvider<UserBloc>(
            create: (context) =>
                UserBloc(),
          ),
        ],
      child:
      const MaterialApp(
      home: CaloriesCounter( date: "2024-12-10"),
      ) );

  }
}


class CaloriesCounter extends StatefulWidget{
  final String date;
  const CaloriesCounter({super.key,required this.date});

  @override
  State<CaloriesCounter> createState() => _CaloriesCounterState();
}

class _CaloriesCounterState extends State<CaloriesCounter> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<CaloriesCounterMainBloc,CaloriesCounterMainState>(
      listener: (context, state) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           CaloriesCounterMainScreen(bl),
        // );
      },
      listenWhen: (context,state){
        return (state.status == CaloriesCounterMainStatus.mealListLoaded);
      },
      child: Scaffold(
        body: Center(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,  // Centers children vertically
                    crossAxisAlignment: CrossAxisAlignment.center, // Centers children horizontally
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final model = context.read<CaloriesCounterMainBloc>();
                          model.add(LoadInitialDataEvent());
                        },
                        child: const Text("Load Calories Counter Page Data"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // final model = context.read<SportMainBloc>();
                          // model.add(LoadUserSportList());
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const SportMainPage(),settings: const RouteSettings(name: "/sportMain"),
                          //   ),
                          // );
                        },
                        child: const Text("Load Sport Page Data"),
                      ),
                    ],
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
