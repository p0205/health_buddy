import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/performance_controller.dart';
import 'repositories/performance_repository.dart';
import 'ui/pages/performance_page.dart';


class PerformanceAnalysisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => PerformanceRepository()),
        ChangeNotifierProxyProvider<PerformanceRepository, PerformanceController>(
          create: (context) => PerformanceController(context.read<PerformanceRepository>()),
          update: (context, repository, controller) => controller!..updateRepository(repository),
        ),
      ],
      child: const PerformanceApp(),
    );
  }
}

class PerformanceApp extends StatelessWidget {
  const PerformanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PERFORMANCE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PerformancePage(userId: 1),
    );
  }
}