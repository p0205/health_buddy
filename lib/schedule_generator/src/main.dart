import 'package:flutter/material.dart';
import 'package:health_buddy/schedule_generator/src/repositories/todo_repository.dart';
import 'package:provider/provider.dart';

import 'controller/todo_controller.dart';
import 'controller/user_controller.dart';
import 'repositories/user_repository.dart';
import 'ui/schedule_module/pages/schedule_page.dart';
//
// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         Provider(
//           create: (context) => TodoRepository(),
//         ),
//         Provider(
//           create: (context) => UserRepository(),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => TodoController(
//               context.read<TodoRepository>()
//           ),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => UserController(
//               context.read<UserRepository>()
//           ),
//         ),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

class ScheduleGeneratorApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => TodoRepository(),
        ),
        Provider(
          create: (context) => UserRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoController(
              context.read<TodoRepository>()
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => UserController(
              context.read<UserRepository>()
          ),
        ),
      ],
      child: const MyApp(),
    );
  }

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Buddy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:
        const SchedulePage(user_id: '4'),
    );
  }
}


