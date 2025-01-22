import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:health_buddy/meal_and_sport/src/user/blocs/user_bloc.dart';
import 'package:health_buddy/performance_analysis/ui/section/trend_calendar.dart';
import 'package:provider/provider.dart';
import '../../../meal_and_sport/src/calories_counter/calories_counter_main/blocs/calories_counter_main_bloc.dart';
import '../../../meal_and_sport/src/sport/sport_main/blocs/sport_main_bloc.dart';
import '../../controllers/performance_controller.dart';
import 'package:health_buddy/schedule_generator/src/core/enums/loading_state.dart';
import 'package:intl/intl.dart';

import '../../models/daily_performance.dart';

class PerformancePage extends StatefulWidget {
  final int userId;
  const PerformancePage({super.key, required this.userId});

  @override
  _PerformancePageState createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime _selectedWeekStart = DateTime.now().subtract(
    Duration(days: (DateTime.now().weekday % 7) - 1),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch tasks after the first frame is rendered
      context.read<CaloriesCounterMainBloc>().add(DateChangedEvent(date: DateTime.now()));
      context.read<SportMainBloc>().add(SportDateChangedEvent(date: DateTime.now()));
      Provider.of<PerformanceController>(context, listen: false)
          .fetchTodayPerformances(widget.userId, DateTime.now()
      );
    });
  }

  void _changeWeek(int delta) {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.add(Duration(days: 7 * delta));
      _focusedDay = _selectedWeekStart;
    });
  }


  @override
  Widget build(BuildContext context) {
    final double caloriesBurnt = (context.read<SportMainBloc>().state.sportSummary?.totalCalsBurnt ?? 0.0);
    final double caloriesIntake = (context.read<CaloriesCounterMainBloc>().state.summary?.caloriesIntake ?? 0.0);
    print(caloriesIntake);

    return Consumer<PerformanceController>(
      builder: (context, performanceController, child) {
        if (performanceController.loadingState == LoadingState.loading) {
          return Scaffold(
            appBar: AppBar(
              title: Text('PERFORMANCE'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (performanceController.loadingState == LoadingState.error) {
          return Scaffold(
            appBar: AppBar(
              title: Text('PERFORMANCE'),
            ),
            body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error:'),
                    SizedBox(height: 8),
                    Text('performanceController.errorMessage'),
                    ElevatedButton(
                      onPressed: () {
                        performanceController.refreshCurrentData(1, DateTime.now().subtract(Duration(days:1))
                        );
                      },
                      child: Text('Retry'),
                    )
                  ],
                )
            ),
          );
        }
        return _buildPerformancePage(performanceController, caloriesBurnt, caloriesIntake);
      },
    );
  }

  Widget _buildPerformancePage(PerformanceController performanceController, double caloriesBurnt, double caloriesIntake) {
    print(performanceController.getTodayPerformances()?.totalTask.toString());
    final double caloriesGoal = context.read<UserBloc>().state.user?.goalCalories?.toDouble() ?? 0.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('PERFORMANCE'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Healthy Habits Completion
              Center(
                child: Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DAILY TASK',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Text(
                              'Healthy Habits',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Incomplete Tasks',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey.shade400,
                        ),
                        Row(
                          children: [
                            Text(
                              performanceController.getTodayPerformances() != null
                                  ? performanceController.getTodayPerformances()!.completedTask.toString()
                                  : '0',
                              style: TextStyle(
                                fontSize: 36,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            Text(
                              performanceController.getTodayPerformances() != null
                                  ? (performanceController.getTodayPerformances()!.totalTask - performanceController.getTodayPerformances()!.completedTask).toString()
                                  : '0',
                              style: TextStyle(
                                fontSize: 36,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 300,
                          child: performanceController.getTodayPerformances() != null && performanceController.getTodayPerformances()!.totalTask > 0
                              ? PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  color: Colors.green,
                                  value: performanceController.getTodayPerformances()!.completedTask > 0
                                      ? performanceController.getTodayPerformances()!.completedTask.toDouble()
                                      : 1, // Set a minimum value of 1 to avoid zero
                                  title: performanceController.getTodayPerformances()!.completedTask > 0
                                      ? performanceController.getTodayPerformances()!.totalPercentage.toStringAsFixed(2) + '%'
                                      : '0%',
                                  radius: 60,
                                  titleStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  color: Colors.red,
                                  value: (performanceController.getTodayPerformances()!.totalTask - performanceController.getTodayPerformances()!.completedTask) > 0
                                      ? (performanceController.getTodayPerformances()!.totalTask - performanceController.getTodayPerformances()!.completedTask).toDouble()
                                      : 1, // Set a minimum value of 1 to avoid zero
                                  title: (performanceController.getTodayPerformances()!.totalTask - performanceController.getTodayPerformances()!.completedTask) > 0
                                      ? ((performanceController.getTodayPerformances()!.totalTask
                                      - performanceController.getTodayPerformances()!.completedTask)
                                      / performanceController.getTodayPerformances()!.totalTask *100).toStringAsFixed(2) + '%'
                                      : '100%',
                                  radius: 60,
                                  titleStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              centerSpaceRadius: 50,
                              sectionsSpace: 2,
                            ),
                          )
                              : Container(), // Display nothing if data is null or total task is 0
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // 2. Tracker Section
              const Text(
                'Tracker',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 2,
                itemBuilder: (context, index) {
                  final tasks = [
                    {
                      'title': 'Calories Burnt',
                      'maxvalue': caloriesGoal as double,
                      'value': caloriesBurnt as double,
                    },
                    {
                      'title': 'Calories Intake',
                      'maxvalue': caloriesGoal as double,
                      'value': caloriesIntake as double,
                    }
                  ];
                  return TaskTrackerCard(task: tasks[index]['title'] as String, maxvalue: tasks[index]['maxvalue'] as double, value: tasks[index]['value'] as double);
                },
              ),
              const SizedBox(height: 24),
              // 4. Trend Analysis
              const Text(
                'Trend Analysis',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TrendCalender(
                focusedDay: _focusedDay,
                selectedDay: _selectedDay ?? _focusedDay,
                userId: widget.userId,
              ),
              const SizedBox(height: 16),
              Container(
                height: 280, // Increased height to accommodate navigation
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Text(
                            "Weekly Report",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_left, color: Colors.purple),
                              onPressed: () => _changeWeek(-1),
                            ),
                            Text(
                              _getWeekRange(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_right, color: Colors.purple),
                              onPressed: () {
                                // Prevent navigating beyond current week
                                if (_selectedWeekStart.isBefore(
                                    DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1))
                                )) {
                                  _changeWeek(1);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _buildDailyBarChart(performanceController),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getWeekRange() {
    // Get the end of the selected week
    DateTime endOfWeek = _selectedWeekStart.add(const Duration(days: 6));

    return "${DateFormat('MMM d').format(_selectedWeekStart)} - ${DateFormat('MMM d').format(endOfWeek)}";
  }

  Widget _buildDailyBarChart(PerformanceController performanceController) {
    final dailyData = _getSelectedWeekData(performanceController);
    final currentWeekStart = DateTime.now().subtract(
        Duration(days: DateTime.now().weekday - 1)
    );

    return BarChart(
      BarChartData(
        barGroups: _createDailyBarGroups(dailyData),
        titlesData: FlTitlesData(
          leftTitles: SideTitles(
            showTitles: true,
            getTitles: (value) => "${value.toInt()}%",
            interval: 20,
            reservedSize: 35,
          ),
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              final date = _selectedWeekStart.add(Duration(days: value.toInt()));
              return DateFormat('E').format(date).toUpperCase();
            },
            margin: 8,
          ),
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final date = _selectedWeekStart.add(Duration(days: group.x));
              return BarTooltipItem(
                "${DateFormat('MMM d').format(date)}\n${rod.y.toInt()}% completed",
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(width: 1, color: Colors.black26),
            bottom: BorderSide(width: 1, color: Colors.black26),
          ),
        ),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.black12,
              strokeWidth: 1,
            );
          },
        ),
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
      ),
    );
  }

  List<BarChartGroupData> _createDailyBarGroups(Map<int, double> dailyData) {
    return List.generate(7, (index) {
      // Ensure alignment of index and data
      final percentage = dailyData[index] ?? 0.0;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            y: percentage,
            colors: [_getBarColor(percentage)],
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }

  Color _getBarColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.lightGreen;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }

  Map<int, double> _getSelectedWeekData(PerformanceController performanceController) {
    final monthlyPerformances = performanceController.getMonthlyPerformances() ?? [];
    Map<int, double> dailyPerformances = {};

    // Collect data for each day of the selected week
    for (var i = 0; i < 7; i++) {
      DateTime currentDay = _selectedWeekStart.add(Duration(days: i));

      // Adjust index to match Sunday correctly
      int index = currentDay.weekday % 7; // Converts Sunday (7) to index 0
      var dayPerformance = monthlyPerformances.firstWhere(
            (performance) =>
        performance.date.year == currentDay.year &&
            performance.date.month == currentDay.month &&
            performance.date.day == currentDay.day,
        orElse: () => DailyPerformance(
          date: currentDay,
          totalTask: 0,
          completedTask: 0,
          totalPercentage: 0,
          id: 0,
          userId: 0,
        ),
      );

      dailyPerformances[index] = dayPerformance.totalPercentage.toDouble();
    }

    return dailyPerformances;
  }
}

class TaskTrackerCard extends StatelessWidget {
  final String task;
  final double maxvalue;
  final double value;
  const TaskTrackerCard({required this.task, required this.maxvalue, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    final percentage = (value / maxvalue) * 100;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: value / maxvalue,
                  color: Colors.purple,
                  backgroundColor: Colors.grey.shade200,
                  strokeWidth: 6,
                ),
                 Text(
                   percentage.toStringAsFixed(2) + '%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}