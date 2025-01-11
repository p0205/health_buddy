import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/riskAssessment/src/blocs/risk_bloc.dart';
import 'package:health_buddy/riskAssessment/src/screen/suggestion_loading_screen.dart';

import '../../../authentication/src/screens/main_menu_screen.dart';

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
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<RiskBloc,RiskState>(

        builder: ( context,  state){

          if(context.read<RiskBloc>().state.suggestions == null || context.read<RiskBloc>().state.riskLevel == null){
            return SuggestionLoadingScreen();
          }

          final suggestions = context.read<RiskBloc>().state.suggestions!;
          final riskLevel = context.read<RiskBloc>().state.riskLevel!;
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
    final riskLevel = context.read<RiskBloc>().state.riskLevel!;
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
                    const Text(
                      'Your Health Status',
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainMenuScreen(),
            ),
          );
        },
        child: const Text(
          "Go to Dashboard",
          style: TextStyle(
              fontSize: 18,
              color: Colors.white
          ),
        ),
      ),
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
    default:
      return "Every step counts! Let's work on your health together. 🌈";
  }
}



// void main() {
//   runApp(
//     MyApp()
//   );
// }
//
// Map<String, List<String>> suggestions= {
//   "exercise": [
//     "Engage in at least 150 minutes of moderate-intensity aerobic activity or 75 minutes of vigorous-intensity aerobic activity per week.",
//     "Incorporate activities like brisk walking, jogging, cycling, or swimming into your routine.",
//     "Aim for at least 30 minutes of exercise most days of the week.",
//     "Consider joining a fitness class or finding an exercise buddy for motivation and support."
//   ],
//   "diet": [
//     "Adopt a DASH (Dietary Approaches to Stop Hypertension) diet, which emphasizes fruits, vegetables, whole grains, lean protein, and low-fat dairy.",
//     "Limit your sodium intake to less than 2,300 milligrams per day, ideally aiming for 1,500 milligrams or less.",
//     "Reduce your consumption of saturated and trans fats, found in processed foods, fatty meats, and full-fat dairy products.",
//     "Increase your intake of potassium-rich foods like bananas, sweet potatoes, and beans, which can help lower blood pressure."
//   ],
//   "healthCheckups": [
//     "Schedule regular checkups with your doctor to monitor your blood pressure and overall health.",
//     "Discuss your blood pressure readings with your doctor and follow their recommendations for management.",
//     "Ask your doctor about any necessary lifestyle modifications or medications to control your blood pressure.",
//     "Be proactive in managing your health and seek medical attention if you experience any unusual symptoms."
//   ]
// };
//
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false, // Disable the debug banner
//       title: 'Health Buddy',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       // home: SuggestionPage(riskLevel: 'moderate', suggestions: suggestions,),
//       home: LoadingPage()
//     );
//   }
// }
