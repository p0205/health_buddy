import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/authentication/src/main.dart';
import 'package:health_buddy/authentication/src/screens/main_menu_screen.dart';
import 'package:health_buddy/meal_and_sport/src/main.dart';
import 'package:health_buddy/meal_and_sport/src/sport/search_sport/bloc/search_sport_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/sport/sport_main/blocs/sport_main_bloc.dart';
import 'package:health_buddy/newUserGuide/guiding/guiding_dashboard.dart';
import 'package:health_buddy/performance_analysis/controllers/performance_controller.dart';
import 'package:health_buddy/performance_analysis/repositories/performance_repository.dart';
import 'package:health_buddy/riskAssessment/src/blocs/risk_bloc.dart';
import 'package:health_buddy/riskAssessment/src/screen/risk_main_screen.dart';
import 'package:health_buddy/schedule_generator/src/main.dart';
import 'package:provider/provider.dart';



import 'authentication/src/screens/splash_screen.dart';
import 'meal_and_sport/src/calories_counter/calories_counter_main/blocs/calories_counter_main_bloc.dart';
import 'meal_and_sport/src/calories_counter/search_meal/blocs/search_meal_bloc.dart';
import 'meal_and_sport/src/user/blocs/user_bloc.dart';
import 'newUserGuide/greeting/greeting_bloc.dart';

import 'package:health_buddy/schedule_generator/src/controller/todo_controller.dart';
import 'package:health_buddy/schedule_generator/src/controller/user_controller.dart';
import 'package:health_buddy/schedule_generator/src/repositories/todo_repository.dart';
import 'package:health_buddy/schedule_generator/src/repositories/user_repository.dart';
import 'package:health_buddy/schedule_generator/src/ui/schedule_module/pages/schedule_page.dart';

void main() {
  runApp(

    // MultiBlocProvider(
    //
    //   providers: [
    //     BlocProvider<SearchFoodBloc>(
    //       create: (context) => SearchFoodBloc(),
    //     ),
    //     BlocProvider(
    //       create: (context) => GreetingBloc(),
    //     ),
    //     BlocProvider<UserBloc>(
    //       create: (context) => UserBloc(),
    //     ),
    //     BlocProvider<SearchSportBloc>(
    //       create: (context) => SearchSportBloc(),
    //     ),
    //
    //     BlocProvider<CaloriesCounterMainBloc>(
    //       create: (context) => CaloriesCounterMainBloc(),
    //     ),
    //     BlocProvider<SportMainBloc>(
    //       create: (context) => SportMainBloc(),
    //     ),
    MultiProvider(
        providers: [
          // Bloc Providers
          BlocProvider<SearchFoodBloc>(
            create: (context) => SearchFoodBloc(),
          ),
          BlocProvider(
            create: (context) => GreetingBloc(),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(),
          ),
          BlocProvider<SearchSportBloc>(
            create: (context) => SearchSportBloc(),
          ),
          BlocProvider<CaloriesCounterMainBloc>(
            create: (context) => CaloriesCounterMainBloc(),
          ),
          BlocProvider<SportMainBloc>(
            create: (context) => SportMainBloc(),
          ),
          // Other Providers
          Provider(
            create: (context) => TodoRepository(),
          ),
          Provider(
            create: (context) => UserRepository(),
          ),
          ChangeNotifierProvider(
            create: (context) => TodoController(
              context.read<TodoRepository>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => UserController(
              context.read<UserRepository>(),
            ),
          ),
          BlocProvider<RiskBloc>(
            create: (context) => RiskBloc(),
          ),
          Provider(create: (_) => PerformanceRepository()),
          ChangeNotifierProxyProvider<PerformanceRepository, PerformanceController>(
            create: (context) => PerformanceController(context.read<PerformanceRepository>()),
            update: (context, repository, controller) => controller!..updateRepository(repository),
          ),
      ], child:MyApp() ,
      ),
      );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      title: 'Health Buddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: GuidingDashboard(username: "Ali",)
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
