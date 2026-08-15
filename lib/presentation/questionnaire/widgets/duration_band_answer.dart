import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:flutter/material.dart';

import 'single_select_answer.dart';

/// Duration-band answer — carries the band midpoint through to scoring.
class DurationBandAnswer extends StatelessWidget {
  final QuestionnaireQuestion question;
  final void Function(Map<String, dynamic>) onAnswer;
  final String? initialOptionId;

  const DurationBandAnswer({
    super.key,
    required this.question,
    required this.onAnswer,
    this.initialOptionId,
  });

  @override
  Widget build(BuildContext context) {
    final options = question.options;
    if (options == null || options.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleSelectAnswer(
      options: options,
      onAnswer: onAnswer,
      initialOptionId: initialOptionId,
      showIntensity: true,
      payloadBuilder: (option, index) => {
        'selectedOptionId': option.optionId,
        if (option.midpointDurationMinutes != null)
          'midpointDurationMinutes': option.midpointDurationMinutes,
      },
    );
  }
}
