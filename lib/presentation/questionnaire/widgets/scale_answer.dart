import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:flutter/material.dart';

import 'single_select_answer.dart';

/// Likert scale answer. Rows carry an intensity ramp so the repeated
/// Never/Sometimes/Often batteries can be answered by position rather than by
/// re-reading four near-identical labels each time.
class ScaleAnswer extends StatelessWidget {
  final QuestionnaireQuestion question;
  final void Function(Map<String, dynamic>) onAnswer;
  final String? initialOptionId;

  const ScaleAnswer({
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
        'numericValue': option.numericValue ?? index,
      },
    );
  }
}
