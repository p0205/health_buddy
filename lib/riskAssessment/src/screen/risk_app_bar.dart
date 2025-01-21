
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class RiskAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RiskAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final surveyController = SurveyConfiguration.of(context).surveyController;
    final surveyStream =
        SurveyStateProvider.of(context).surveyStateStream.stream;

    // final cancelButton = TextButton(
    //   child: Text(
    //     SurveyConfiguration.of(context).localizations?['cancel'] ?? 'Cancel',
    //     style: TextStyle(
    //       color: Theme.of(context).primaryColor,
    //     ),
    //   ),
    //   onPressed: () =>   Navigator.popUntil(context, (route) => route.settings.name == "/riskMain")
    // );

    final backButton = BackButton(
      onPressed: () {
        surveyController.stepBack(
          context: context,
        );
      },
    );

    return StreamBuilder<SurveyState>(
      stream: surveyStream,
      builder: (context, snapshot) {
        final state = snapshot.data;

        if (!snapshot.hasData ||
            state != null && state is! PresentingSurveyState) {
          return AppBar();
        }

        final leading = (state as PresentingSurveyState?)?.isFirstStep ?? true
            ? const SizedBox.shrink()
            : backButton;

        return AppBar(
          elevation: 0,
          leading: leading,
          title: const SurveyProgress(),
          backgroundColor: Color(0xFF599BF9),
          // actions: [
          //   cancelButton,
          // ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size(
    double.infinity,
    40,
  );
}
