import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/questionnaire/models/question_option.dart';
import 'package:detoxia/domain/questionnaire/models/question_type.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:detoxia/presentation/questionnaire/widgets/answer_option_tile.dart';
import 'package:detoxia/presentation/questionnaire/widgets/question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('QuestionCard renders scale question text and options', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: QuestionCard(
              question: _scaleQuestion,
              sectionTitle: 'Scrolling',
              showPrivacyNote: true,
              onAnswer: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Scrolling'), findsOneWidget);
    expect(find.text('How often do you scroll?'), findsOneWidget);
    expect(find.text('Sensitive answers stay on this device.'), findsOneWidget);
    expect(find.byType(AnswerOptionTile), findsNWidgets(4));
    expect(find.text('Never'), findsOneWidget);
    expect(find.text('Rarely'), findsOneWidget);
    expect(find.text('Often'), findsOneWidget);
    expect(find.text('Very often'), findsOneWidget);
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
