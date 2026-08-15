import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:flutter/material.dart';

import 'single_select_answer.dart';

/// Single-choice answer — pick one, auto-advances.
class SingleChoiceAnswer extends StatelessWidget {
  final QuestionnaireQuestion question;
  final void Function(Map<String, dynamic>) onAnswer;
  final String? initialOptionId;

  const SingleChoiceAnswer({
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
      payloadBuilder: (option, index) => {
        'selectedOptionId': option.optionId,
        if (option.numericValue != null) 'numericValue': option.numericValue,
      },
    );
  }
}
