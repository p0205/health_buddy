import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/riskAssessment/src/blocs/risk_bloc.dart';
import 'package:health_buddy/riskAssessment/src/screen/risk_main_screen.dart';
import 'package:health_buddy/riskAssessment/src/screen/risk_questionnaire_screen.dart';
import 'package:health_buddy/riskAssessment/src/screen/suggestion_loading_screen.dart';

import '../../../authentication/src/screens/main_menu_screen.dart';
import '../../../meal_and_sport/src/calories_counter/calories_counter_main/blocs/calories_counter_main_bloc.dart';
import '../../../meal_and_sport/src/sport/sport_main/blocs/sport_main_bloc.dart';
import '../../../meal_and_sport/src/user/blocs/user_bloc.dart';

class SuggestionScreen extends StatefulWidget {
  // final String? riskLevel;
  // final Map<String, List<String>> suggestions;

  const SuggestionScreen({
    super.key,
    // this.riskLevel,
    // required this.suggestions,
  });

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health Test Result',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Color(0xFF599BF9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>
                  RiskMainScreen()),
            );
          },
        ),
      ),

      body: BlocBuilder<RiskBloc,RiskState>(

        builder: ( context,  state){
          final riskBloc = context.read<RiskBloc>();

          if(riskBloc.state.report == null ){
            if(riskBloc.state.status == RiskStatus.aiResponseLoading){
              return SuggestionLoadingScreen();
            }else{
              return const Center(child: CircularProgressIndicator());
            }
          }
          else if (state.status == RiskStatus.error) {
            // Show error dialog
            Future.delayed(Duration.zero, () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(
                      context
                          .read<RiskBloc>()
                          .state
                          .errorMessage!,
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainMenuScreen(),
                            ),
                          );
                        },
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
            });
          }


          final suggestions = context.read<RiskBloc>().state.report!.suggestions;
          final riskLevel = context.read<RiskBloc>().state.report!.riskLevel;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRiskLevelHeader(context),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Based on your assessment, here are some tailored suggestions:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      _buildSuggestionSection('Exercise', suggestions.exercise , Icons.directions_run, Colors.blue.shade50, riskLevel == 'high'),
                      _buildSuggestionSection('Diet', suggestions.diet , Icons.restaurant_menu, Colors.green.shade50, riskLevel == 'moderate'),
                      _buildSuggestionSection('Health Checkups', suggestions.healthCheckups, Icons.local_hospital, Colors.red.shade50, riskLevel == 'low'),
                      const SizedBox(height: 24),
                      _buildCompletionMessage(),
                      const SizedBox(height: 16),
                      _buildActionButton(context),
                    ],
                  ),
                ),
              ],
            ),
          );
        },

      ),
    );
  }


  Widget _buildRiskLevelHeader(BuildContext context) {
    final riskLevel = context.read<RiskBloc>().state.report!.riskLevel;
    final healthTest = context.read<RiskBloc>().state.healthTestSelected!.diseaseName;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Hero(
        tag: 'riskLevelCard',
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_getRiskColor(riskLevel), _getRiskColor(riskLevel).withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getRiskIcon(riskLevel),
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$healthTest Risk",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  (riskLevel ?? 'Unknown').toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getPositiveMessage(riskLevel),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionSection(String title, List<String> items, IconData icon, Color backgroundColor, bool initiallyExpanded) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: backgroundColor,
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        children: [
          ...items.map((item) => _buildSuggestionItem(item)),

        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String suggestion) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              suggestion,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionMessage() {
    return const Text(
      "Thank you for completing the test! 🎉 Remember, every small step counts toward a healthier you.",
      style: TextStyle(
        fontSize: 16,
        fontStyle: FontStyle.italic,
        color: Colors.grey,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12), // Spacing between buttons
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              _showRetestConfirmationDialog(context);
            },
            child: const Text(
              "Retake the Test",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showRetestConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Retest"),
          content: const Text(
            "Are you sure you want to retake the test? This will clear your current result.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                context.read<RiskBloc>().add(ResetReportEvent());
                context.read<RiskBloc>().add(
                  LoadQuestionnaireEvent(
                    userId: context.read<UserBloc>().state.userId!,
                    test: context.read<RiskBloc>().state.healthTestSelected!,
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RiskQuestionnaire(),
                  ),
                );
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }


}

Color _getRiskColor(String riskLevel) {
  switch (riskLevel.toLowerCase() ?? '') {
    case 'low':
      return Colors.green;
    case 'moderate':
      return Colors.orange;
    case 'high':
      return Colors.red;
    case 'very high':
      return Colors.deepPurple; // A darker shade to signify the severity
    default:
      return Colors.purple;
  }
}

IconData _getRiskIcon(String riskLevel) {
  switch (riskLevel.toLowerCase() ?? '') {
    case 'low':
      return Icons.check_circle;
    case 'moderate':
      return Icons.warning;
    case 'high':
      return Icons.error;
    case 'very high':
      return Icons.dangerous; // Icon to indicate extreme risk
    default:
      return Icons.info;
  }
}

String _getPositiveMessage(String riskLevel) {
  switch (riskLevel.toLowerCase() ?? '') {
    case 'low':
      return "Great job! Keep up the good work with these tips. 🌟";
    case 'moderate':
      return "You're on the right track! These tips can help you improve. 💪";
    case 'high':
      return "Don't worry! These tips can help you manage and improve your health. 💖";
    case 'very high':
      return "It's critical to act now. Follow these tips to reduce risks and prioritize your health. 🚨";
    default:
      return "Every step counts! Let's work on your health together. 🌈";
  }
}
