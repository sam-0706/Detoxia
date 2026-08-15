import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/questionnaire/models/question_option.dart';
import 'package:detoxia/domain/questionnaire/models/question_type.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:detoxia/presentation/questionnaire/widgets/question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('tapping a scale option returns the selected numeric value', (
    tester,
  ) async {
    Map<String, dynamic>? captured;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: QuestionCard(
            question: _scaleQuestion,
            sectionTitle: 'Scrolling',
            onAnswer: (answer) => captured = answer,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Often'));
    // The tile paints its selected state before handing the answer back, so
    // the callback lands a beat after the tap rather than on the same frame.
    await tester.pumpAndSettle();

    expect(captured, isNotNull);
    expect(captured!['selectedOptionId'], 's2');
    expect(captured!['numericValue'], 2);
  });
}

const _scaleQuestion = QuestionnaireQuestion(
  questionId: 'scroll_test_q1',
  sectionId: 'scroll_test',
  questionType: QuestionType.scale,
  text: 'How often do you scroll?',
  options: [
    QuestionOption(optionId: 's0', label: 'Never', numericValue: 0),
    QuestionOption(optionId: 's1', label: 'Rarely', numericValue: 1),
    QuestionOption(optionId: 's2', label: 'Often', numericValue: 2),
    QuestionOption(optionId: 's3', label: 'Very often', numericValue: 3),
  ],
);
