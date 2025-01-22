import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../models/daily_performance.dart';
import '../../controllers/performance_controller.dart';
import 'package:health_buddy/schedule_generator/src/core/enums/loading_state.dart';

class TrendCalender extends StatefulWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final int userId;
  const TrendCalender({super.key, required this.focusedDay, required this.selectedDay, required this.userId});

  @override
  State<TrendCalender> createState() => _TrendCalenderState();
}

class _TrendCalenderState extends State<TrendCalender> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late Map<DateTime, double> _percentages = {}; // Initialize with empty map

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay;
    _focusedDay = widget.focusedDay;
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final controller = Provider.of<PerformanceController>(context, listen: false);
      final yesterday = DateTime.now().subtract(const Duration(days: 1));

      // Fetch data in parallel
      await Future.wait([
        controller.fetchTodayPerformances(widget.userId, DateTime.now()),
        controller.fetchMonthlyPerformances(widget.userId, DateTime.now()),
      ]);

      if (mounted) {
        setState(() {
          _percentages = _generateDailyPercentages(
            controller.getMonthlyPerformances() ?? [],
          );
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  Map<DateTime, double> _generateDailyPercentages(List<DailyPerformance> performances) {
    Map<DateTime, double> percentages = {};
    for (var performance in performances) {
      // Normalize the DateTime to remove time component
      DateTime normalizedDate = DateTime(
        performance.date.year,
        performance.date.month,
        performance.date.day,
      );
      percentages[normalizedDate] = performance.totalPercentage.toDouble();
    }
    return percentages;
  }

  double _calculateMonthlyAverage() {
    if (_percentages.isEmpty) return 0.0;

    final daysWithData = _percentages.entries
        .where((entry) =>
    entry.key.year == _focusedDay.year &&
        entry.key.month == _focusedDay.month &&
        entry.value > 0)
        .toList();

    if (daysWithData.isEmpty) return 0.0;

    final sum = daysWithData.fold(0.0, (sum, entry) => sum + entry.value);
    return sum / daysWithData.length;
  }

  void _onPageChanged(DateTime focusedDay) {
    if (mounted) {
      setState(() {
        _focusedDay = focusedDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PerformanceController>(
      builder: (context, performanceController, child) {
        if (performanceController.loadingState == LoadingState.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (performanceController.loadingState == LoadingState.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Error loading data'),
                const SizedBox(height: 8),
                Text(performanceController.errorMessage ?? 'Unknown error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _initializeData(),
                  child: const Text('Retry'),
                )
              ],
            ),
          );
        }

        return _buildCalendar(performanceController);
      },
    );
  }

  Widget _buildCalendar(PerformanceController performanceController) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              'Monthly Average Task Completion: \n${_calculateMonthlyAverage().toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.purple[900],
              ),
            ),
          ),
          _buildTableCalendar(),
        ],
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      rowHeight: 80,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        if (mounted) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
      onPageChanged: _onPageChanged,
      onHeaderTapped: (_) => _showMonthYearPicker(context),
      headerStyle: const HeaderStyle(
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.purple,
        ),
        formatButtonVisible: false,
        titleCentered: true,
        headerPadding: EdgeInsets.symmetric(vertical: 4.0),
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.purple),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.purple),
      ),
      calendarStyle: const CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.purple,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.purpleAccent,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
      ),
      calendarBuilders: _buildCalendarBuilders(),
    );
  }

  CalendarBuilders _buildCalendarBuilders() {
    return CalendarBuilders(
      defaultBuilder: (context, day, focusedDay) {
        final normalizedDay = DateTime(day.year, day.month, day.day);
        final percentage = _percentages[normalizedDay];

        if (percentage == null || percentage == 0) {
          return _buildDefaultCell(day);
        }
        return _buildPercentageCell(day, percentage, false, false);
      },
      selectedBuilder: (context, day, focusedDay) {
        final normalizedDay = DateTime(day.year, day.month, day.day);
        final percentage = _percentages[normalizedDay];
        return _buildPercentageCell(day, percentage ?? 0, true, false);
      },
      todayBuilder: (context, day, focusedDay) {
        final normalizedDay = DateTime(day.year, day.month, day.day);
        final percentage = _percentages[normalizedDay];
        return _buildPercentageCell(day, percentage ?? 0, false, true);
      },
    );
  }

  Widget _buildDefaultCell(DateTime day) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      child: Center(
        child: Text(
          '${day.day}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPercentageCell(DateTime day, double percentage, bool isSelected, bool isToday) {
    Color backgroundColor;
    Color textColor;

    if (isSelected) {
      backgroundColor = Colors.purple;
      textColor = Colors.white;
    } else if (isToday) {
      backgroundColor = Colors.purpleAccent;
      textColor = Colors.white;
    } else {
      backgroundColor = percentage >= 50 ? Colors.green[100]! : Colors.red[100]!;
      textColor = percentage >= 50 ? Colors.green : Colors.red;
    }

    return Container(
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected || isToday ? Colors.white : Colors.black,
              ),
            ),
            if (percentage > 0)
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected || isToday ? Colors.white : textColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Rest of the month/year picker code remains the same...
  void _showMonthYearPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Month and Year'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              selectedDate: _focusedDay,
              onChanged: (DateTime dateTime) {
                Navigator.pop(context);
                _showMonthPicker(context, dateTime);
              },
            ),
          ),
        );
      },
    );
  }

  void _showMonthPicker(BuildContext context, DateTime selectedYear) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Month ${selectedYear.year}'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    final selectedDate = DateTime(selectedYear.year, index + 1);
                    final newSelectedDay = DateTime(
                      selectedYear.year,
                      index + 1,
                      min(_selectedDay.day, DateUtils.getDaysInMonth(selectedYear.year, index + 1)),
                    );

                    if (mounted) {
                      setState(() {
                        _focusedDay = selectedDate;
                        _selectedDay = newSelectedDay;
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _focusedDay.month == index + 1 ? Colors.purple : Colors.purple[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        DateFormat('MMM').format(DateTime(2024, index + 1)),
                        style: TextStyle(
                          color: _focusedDay.month == index + 1 ? Colors.white : Colors.purple[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}