import 'package:detoxia/domain/questionnaire/models/question_option.dart';
import 'package:detoxia/domain/questionnaire/models/question_type.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_section.dart';
import 'package:detoxia/domain/questionnaire/models/visibility_rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QuestionOption.fromJson round-trips JSON', () {
    const json = {
      'optionId': 'opt_1',
      'label': 'First option',
      'numericValue': 2,
      'midpointMinutes': 300,
      'midpointDurationMinutes': 45,
      'tag': 'triggerTag',
    };

    final option = QuestionOption.fromJson(json);

    expect(option.toJson(), json);
  });

  test('QuestionnaireQuestion.fromJson parses scale questions', () {
    const json = {
      'questionId': 'routine_commute_phone',
      'questionType': 'scale',
      'text':
          'During commute, I use my phone for scrolling, browsing, or entertainment.',
      'scoreDomain': 'routineRisk',
      'scaleMin': 0,
      'scaleMax': 3,
      'options': [
        {'optionId': 'p0', 'label': 'Never', 'numericValue': 0},
        {'optionId': 'p1', 'label': 'Sometimes', 'numericValue': 1},
        {'optionId': 'p2', 'label': 'Often', 'numericValue': 2},
        {'optionId': 'p3', 'label': 'Very often', 'numericValue': 3},
      ],
    };

    final question = QuestionnaireQuestion.fromJson(json);

    expect(question.questionType, QuestionType.scale);
    expect(question.scaleMin, 0);
    expect(question.scaleMax, 3);
    expect(question.options, isNotNull);
    expect(question.options!.length, 4);
    expect(question.toJson(), json);
  });

  test('QuestionnaireQuestion.fromJson parses single choice questions', () {
    const json = {
      'questionId': 'routine_commute_mode',
      'questionType': 'singleChoice',
      'text': 'How do you usually commute?',
      'scoreDomain': 'routineRisk',
      'options': [
        {'optionId': 'mode_walk', 'label': 'Walk'},
        {'optionId': 'mode_bike', 'label': 'Bike'},
        {'optionId': 'mode_bus', 'label': 'Bus'},
      ],
    };

    final question = QuestionnaireQuestion.fromJson(json);

    expect(question.questionType, QuestionType.singleChoice);
    expect(question.options, isNotNull);
    expect(question.options!.length, 3);
    expect(question.toJson(), json);
  });

  test('QuestionnaireSection.fromJson parses sections with questions', () {
    const json = {
      'sectionId': 'routine_map',
      'sectionTitle': 'Your daily routine',
      'sectionSubtitle': "Windows are fine - don't worry about exact times.",
      'engineTarget': 'routineAnalysis',
      'order': 2,
      'completionMessage': 'Routine Map unlocked',
      'questions': [
        {
          'questionId': 'routine_wake',
          'questionType': 'timeWindow',
          'text': 'When do you usually wake up?',
          'scoreDomain': 'routineRisk',
          'options': [
            {'optionId': 'wake_6_7', 'label': '6-7 AM', 'midpointMinutes': 390},
          ],
        },
        {
          'questionId': 'routine_sleep_attempt',
          'questionType': 'timeWindow',
          'text': 'When do you usually try to sleep?',
          'scoreDomain': 'routineRisk',
          'options': [
            {
              'optionId': 'sleep_10_11pm',
              'label': '10-11 PM',
              'midpointMinutes': 1350,
            },
          ],
        },
      ],
    };

    final section = QuestionnaireSection.fromJson(json);

    expect(section.sectionId, 'routine_map');
    expect(section.questions.length, 2);
    expect(section.questions.first.questionType, QuestionType.timeWindow);
    expect(section.toJson(), json);
  });

  test('VisibilityRule.fromJson parses ageBandIn rules', () {
    const json = {
      'ageBandIn': ['adult18Plus'],
    };

    final rule = VisibilityRule.fromJson(json);

    expect(rule.ageBandIn, ['adult18Plus']);
    expect(rule.toJson(), json);
  });

  test('VisibilityRule.fromJson parses answerEquals clauses', () {
    const json = {
      'answerEquals': {'questionId': 'safety_q2', 'value': 'yes'},
    };

    final rule = VisibilityRule.fromJson(json);

    expect(rule.answerEquals, isNotNull);
    expect(rule.answerEquals!.questionId, 'safety_q2');
    expect(rule.answerEquals!.value, 'yes');
    expect(rule.toJson(), json);
  });
}
