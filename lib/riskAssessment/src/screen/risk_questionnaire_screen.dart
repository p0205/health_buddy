// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/riskAssessment/src/blocs/risk_bloc.dart';
import 'package:health_buddy/riskAssessment/src/model/question.dart';
import 'package:health_buddy/riskAssessment/src/screen/questionnaire_loading_screen.dart';
import 'package:health_buddy/riskAssessment/src/screen/suggestion_screen.dart';
import 'package:survey_kit/survey_kit.dart';

import '../../../authentication/src/screens/main_menu_screen.dart';
import '../../../meal_and_sport/src/user/blocs/user_bloc.dart';
import 'risk_app_bar.dart';




class RiskQuestionnaire extends StatefulWidget {

  const RiskQuestionnaire({super.key});

  @override
  State<RiskQuestionnaire> createState() => _RiskQuestionnaireState();
}

class _RiskQuestionnaireState extends State<RiskQuestionnaire> {


  @override
  Widget build(BuildContext context) {

      return Scaffold(
        body: Container(
          color: Colors.white,
          child: BlocBuilder<RiskBloc,RiskState>(
            builder: ( context,  state) {
              if(state.status == RiskStatus.questionnaireLoaded && state.questions!=null) {
                return Align(
                  alignment: Alignment.center,
                  child: FutureBuilder<Task>(
                    future: getTask(context
                        .read<RiskBloc>()
                        .state
                        .questions!,
                        context
                            .read<RiskBloc>()
                            .state
                            .healthTestSelected!.diseaseName
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData &&
                          snapshot.data != null) {
                        final task = snapshot.data!;
                        return SurveyKitView(task: task,);
                      }
                      return const CircularProgressIndicator.adaptive();
                    },
                  ),
                );
              }
              return const SuggestionLoadingScreen();
            },
          ),
        ),
      );
  }

  Step _instructStep(String healthTestName){
    return Step(
      id: 'Intro',
      content: [
        TextContent(
          text: 'Welcome to $healthTestName Test! 🩺',
          fontSize: 22,
        ),
        TextContent(
          text: 'Take a quick health test to assess your risks. Once completed, our AI will provide you with personalized health suggestions to support your well-being. 🧠✨',
        ),
      ],
      isMandatory: false,
      buttonText: "Let's GO!",
    );
  }

  Step _completeStep(){
    return Step(
      id: 'Complete',
      content: [
        TextContent(
          text: 'All done!',
          fontSize: 22,
        ),
        TextContent(
          text: 'Submit the form. This will take some time to generate your personalized suggestion.',
        ),
      ],
      isMandatory: false,
      buttonText: "Submit",
    );
  }

  List<Step> createStepsFromQuestions(List<Question> questions) {
    return questions.map((question) {
      // Map conditions to text choices
      final List<TextChoice> textChoices = question.conditions.map((condition) {
        return TextChoice(
          id: condition.condition,
          value: condition.score.toString(),
          text: condition.condition,
        );
      }).toList();

      // Create a step for each question
      return Step(
        id: '${question.id}',
        content: [
          TextContent(
            text: question.question,
            fontSize: 25,
          ),
        ],
        isMandatory: true,
        answerFormat: SingleChoiceAnswerFormat(
          textChoices: textChoices,
          defaultSelection: textChoices[0]
        ),
      );
    }).toList();
  }

  Future<Task> getTask(List<Question> questions,String testName) {
    final task = OrderedTask(
      steps: [
        _instructStep(testName),
        ...createStepsFromQuestions(questions),
        _completeStep()
      ],
      id: 'questions',
    );
    return Future.value(task);
  }

}


class SurveyKitView extends StatefulWidget {
  const SurveyKitView({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<SurveyKitView> createState() => _SurveyKitViewState();
}

class _SurveyKitViewState extends State<SurveyKitView> {

  @override
  Widget build(BuildContext context) {
    return SurveyKit(
      appBar: RiskAppBar(),
      onResult: (SurveyResult result) {

        int score = 0;

        for (var stepResult in result.results) {
            if (stepResult.result is String) {
              // Handle String answers
              score += int.tryParse(stepResult.result ?? "0") ?? 0;
            } else if (stepResult.result is TextChoice) {
              final textChoice = stepResult.result as TextChoice;
              // Directly handle TextChoice, as it's not iterable
              score += int.tryParse(textChoice.value ?? "0") ?? 0;
            } else {
              log("Unexpected valueIdentifier type: ${stepResult.valueIdentifier.runtimeType}");
            }

        }
        int userId = context.read<UserBloc>().state.userId!;
        context.read<RiskBloc>().add(CompleteQuestionnaireEvent(score: score,userId:userId ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuggestionScreen(

            ),
          ),
        );
      },
      task: widget.task,
      // localizations: const <String, String>{
      //   'cancel': 'Cancel',
      //   'next': 'Next',
      // },
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue,
            Colors.white,
          ],
        ),
      ),
      stepShell: (
          Step step,
          Widget? answerWidget,
          BuildContext context,
          ) {


        final questionAnswer = QuestionAnswer.of(context);
        final surveyConfiguration = SurveyConfiguration.of(context);
        final surveyController = surveyConfiguration.surveyController;
        final mediaQuery = MediaQuery.of(context);


        return LayoutBuilder(
          builder: (context, constraints) {

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: ContentWidget(
                                content: step.content,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (answerWidget != null)
                        answerWidget,
                      Container(
                        width: double.infinity,
                        height: 80 + mediaQuery.viewPadding.bottom,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SafeArea(
                            child: OutlinedButton(
                              onPressed:
                                   () => surveyController.nextStep(
                                context,
                                questionAnswer.stepResult,
                              ),
                              child:  Text(step.buttonText ?? "Next"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
//
// Widget appBar(){
//
//   return AppBar(
//     elevation: 0,
//     leading: StreamBuilder<SurveyState>(
//       stream: surveyStream,
//       builder: (context, snapshot) {
//         if (snapshot.data == null) {
//           return const SizedBox.shrink();
//         }
//
//         final state = snapshot.data!;
//
//         return (state as PresentingSurveyState).isFirstStep
//             ? const SizedBox.shrink()
//             : backButton;
//       },
//     ),
//     title: const SurveyProgress(),
//     actions: [
//       cancelButton,
//     ],
//   );
// }
//
// //
// //
// // ThemeData get theme => Theme.of(context).copyWith(
// //   useMaterial3: true,
// //   primaryColor: Colors.cyan,
// //   appBarTheme: const AppBarTheme(
// //     color: Colors.white,
// //     iconTheme: IconThemeData(
// //       color: Colors.cyan,
// //     ),
// //     titleTextStyle: TextStyle(
// //       color: Colors.cyan,
// //     ),
// //   ),
// //   iconTheme: const IconThemeData(
// //     color: Colors.cyan,
// //   ),
// //   textSelectionTheme: const TextSelectionThemeData(
// //     cursorColor: Colors.cyan,
// //     selectionColor: Colors.cyan,
// //     selectionHandleColor: Colors.cyan,
// //   ),
// //   cupertinoOverrideTheme: const CupertinoThemeData(
// //     primaryColor: Colors.cyan,
// //   ),
// //   outlinedButtonTheme: OutlinedButtonThemeData(
// //     style: ButtonStyle(
// //       minimumSize: MaterialStateProperty.all(
// //         const Size(150.0, 60.0),
//       ),
//       side: MaterialStateProperty.resolveWith(
//             (Set<MaterialState> state) {
//           if (state.contains(MaterialState.disabled)) {
//             return const BorderSide(
//               color: Colors.grey,
//             );
//           }
//           return const BorderSide(
//             color: Colors.cyan,
//           );
//         },
//       ),
//       shape: MaterialStateProperty.all(
//         RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//       ),
//       textStyle: MaterialStateProperty.resolveWith(
//             (Set<MaterialState> state) {
//           if (state.contains(MaterialState.disabled)) {
//             return Theme.of(context).textTheme.labelLarge?.copyWith(
//               color: Colors.grey,
//             );
//           }
//           return Theme.of(context).textTheme.labelLarge?.copyWith(
//             color: Colors.cyan,
//           );
//         },
//       ),
//     ),
//   ),
//   textButtonTheme: TextButtonThemeData(
//     style: ButtonStyle(
//       textStyle: MaterialStateProperty.all(
//         Theme.of(context).textTheme.labelLarge?.copyWith(
//           color: Colors.cyan,
//         ),
//       ),
//     ),
//   ),
//   textTheme: const TextTheme(
//     displayMedium: TextStyle(
//       fontSize: 28.0,
//       color: Colors.black,
//     ),
//     headlineSmall: TextStyle(
//       fontSize: 24.0,
//       color: Colors.black,
//     ),
//     bodyMedium: TextStyle(
//       fontSize: 18.0,
//       color: Colors.black,
//     ),
//     titleMedium: TextStyle(
//       fontSize: 18.0,
//       color: Colors.black,
//     ),
//   ),
//   inputDecorationTheme: const InputDecorationTheme(
//     labelStyle: TextStyle(
//       color: Colors.black,
//     ),
//   ),
//   colorScheme: ColorScheme.fromSwatch(
//     primarySwatch: Colors.cyan,
//   )
//       .copyWith(
//     onPrimary: Colors.white,
//   )
//       .copyWith(background: Colors.white),
// );