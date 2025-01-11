import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/commom_widgets/side_bar.dart';
import 'package:health_buddy/meal_and_sport/src/user/blocs/user_bloc.dart';
import 'package:health_buddy/riskAssessment/src/blocs/risk_bloc.dart';
import 'package:health_buddy/riskAssessment/src/model/health_test.dart';

import 'risk_questionnaire_screen.dart';

class RiskMainScreen extends StatefulWidget {


  @override
  State<RiskMainScreen> createState() => _RiskMainScreenState();
}

class _RiskMainScreenState extends State<RiskMainScreen> {

  @override
  Widget build(BuildContext context) {


      return  Scaffold(
        appBar: AppBar(
          title: const Text("Risk Assessment",textAlign: TextAlign.center),
          backgroundColor: Colors.blue,
          titleTextStyle: const TextStyle(
              fontFamily: 'Itim',
              fontSize: 25,
              fontWeight: FontWeight.bold
          ),

        ),
        drawer: SideBar(userName: context.read<UserBloc>().state.name!, userEmail: context.read<UserBloc>().state.email!, userId: context.read<UserBloc>().state.userId!),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<RiskBloc,RiskState>(
            builder: (context,state) {
              if(state.testType!=null) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select a Health Test to Begin 🩺',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Choose from the available tests below to start risk assessment.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView(
                          children: (state.testType!).map((test) {
                            return _buildTestOptionCard(context, test);
                          }).toList(),
                        ),
                      ),
                    ]
                );
              }
              return Center(child: CircularProgressIndicator());
            }
            ),
          ),
        );

  }
  Widget _buildTestOptionCard(BuildContext context, HealthTest test) {
    final isCompleted = true; // Assuming `HealthTest` has an `isCompleted` field.
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListTile(
        leading: isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green, size: 28) // Green check icon
            : const Icon(Icons.circle_outlined, color: Colors.grey, size: 28), // Grey icon for not started
        title: Text(
          test.diseaseName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: isCompleted
            ? const Icon(Icons.description, color: Colors.green) // Indicator for completed test
            : const Icon(Icons.arrow_forward_ios, color: Colors.grey), // Default forward icon
        onTap: () {
          // if (isCompleted) {
          //   // Navigate to the results screen
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => ResultsScreen(
          //         userId: context.read<UserBloc>().state.userId!,
          //         test: test,
          //       ),
          //     ),
          //   );
          // } else {
          //   // Navigate to the questionnaire for new tests
          //   context.read<RiskBloc>().add(
          //     HealthTestSelectedEvent(
          //       userId: context.read<UserBloc>().state.userId!,
          //       test: test,
          //     ),
          //   );
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const RiskQuestionnaire(),
          //     ),
          //   );
          // }
        },
      ),
    );
  }

}
