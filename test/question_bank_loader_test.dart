import 'package:detoxia/domain/questionnaire/models/question_type.dart';
import 'package:detoxia/domain/questionnaire/question_bank_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parseSections with a minimal valid JSON map returns one section', () {
    final sections = parseSections({
      'version': '1.0.0',
      'sections': [_sectionJson(order: 1)],
    });

    expect(sections.length, 1);
    expect(sections.single.sectionId, 'sample_section');
  });

  test('parseSections throws FormatException if sections is missing', () {
    expect(
      () => parseSections({'version': '1.0.0'}),
      throwsA(isA<FormatException>()),
    );
  });

  test('parseSections throws if a section is missing sectionId', () {
    expect(
      () => parseSections({
        'version': '1.0.0',
        'sections': [
          {
            'sectionTitle': 'Sample',
            'engineTarget': 'riskScoring',
            'order': 1,
            'questions': <Map<String, dynamic>>[],
          },
        ],
      }),
      throwsA(isA<FormatException>()),
    );
  });

  test('parseSections sorts sections by order', () {
    final sections = parseSections({
      'version': '1.0.0',
      'sections': [
        _sectionJson(sectionId: 'second', order: 2),
        _sectionJson(sectionId: 'first', order: 1),
      ],
    });

    expect(sections.map((section) => section.sectionId), ['first', 'second']);
  });

  test('parseSections propagates sectionId into each question', () {
    final sections = parseSections({
      'version': '1.0.0',
      'sections': [
        _sectionJson(
          sectionId: 'routine_map',
          questions: [_scaleQuestionJson(questionId: 'routine_phone')],
        ),
      ],
    });

    expect(sections.single.questions.single.sectionId, 'routine_map');
  });

  test('parseSections parses a scale question with bounds and 4 options', () {
    final sections = parseSections({
      'version': '1.0.0',
      'sections': [
        _sectionJson(questions: [_scaleQuestionJson()]),
      ],
    });

    final question = sections.single.questions.single;
    expect(question.questionType, QuestionType.scale);
    expect(question.scaleMin, 0);
    expect(question.scaleMax, 3);
    expect(question.options, isNotNull);
    expect(question.options!.length, 4);
    expect(question.options!.last.numericValue, 3);
  });

  test('parseSections parses a multiChoice question', () {
    final sections = parseSections({
      'version': '1.0.0',
      'sections': [
        _sectionJson(
          questions: [
            {
              'questionId': 'goal_q1',
              'questionType': 'multiChoice',
              'text': 'Sample goal prompt',
              'options': [
                {'optionId': 'goal_a', 'label': 'Goal A', 'tag': 'a'},
                {'optionId': 'goal_b', 'label': 'Goal B', 'tag': 'b'},
              ],
            },
          ],
        ),
      ],
    });

    final question = sections.single.questions.single;
    expect(question.questionType, QuestionType.multiChoice);
    expect(question.options!.length, 2);
    expect(question.options!.first.tag, 'a');
  });

  test('parseSections parses a timeWindow question with midpointMinutes', () {
    final sections = parseSections({
      'version': '1.0.0',
      'sections': [
        _sectionJson(
          questions: [
            {
              'questionId': 'routine_wake',
              'questionType': 'timeWindow',
              'text': 'Sample wake prompt',
              'options': [
                {
                  'optionId': 'wake_6_7',
                  'label': '6-7 AM',
                  'midpointMinutes': 390,
                },
              ],
            },
          ],
        ),
      ],
    });

    final question = sections.single.questions.single;
    expect(question.questionType, QuestionType.timeWindow);
    expect(question.options!.single.midpointMinutes, 390);
  });

  test('parseSections parses a section with visibleIf.ageBandIn', () {
    final sections = parseSections({
      'version': '1.0.0',
      'sections': [
        _sectionJson(
          visibleIf: {
            'ageBandIn': ['adult18Plus'],
          },
        ),
      ],
    });

    expect(sections.single.visibleIf, isNotNull);
    expect(sections.single.visibleIf!.ageBandIn, ['adult18Plus']);
  });

  test('parseSections parses a section with visibleIf.answerEquals', () {
    final sections = parseSections({
      'version': '1.0.0',
      'sections': [
        _sectionJson(
          visibleIf: {
            'answerEquals': {'questionId': 'safety_q2', 'value': 'yes'},
          },
        ),
      ],
    });

    final answerEquals = sections.single.visibleIf!.answerEquals;
    expect(answerEquals, isNotNull);
    expect(answerEquals!.questionId, 'safety_q2');
    expect(answerEquals.value, 'yes');
  });
}

Map<String, dynamic> _sectionJson({
  String sectionId = 'sample_section',
  int order = 1,
  Map<String, dynamic>? visibleIf,
  List<Map<String, dynamic>> questions = const [],
}) {
  return {
    'sectionId': sectionId,
    'sectionTitle': 'Sample section',
    'engineTarget': 'riskScoring',
    'order': order,
    'visibleIf': ?visibleIf,
    'questions': questions,
  };
}

Map<String, dynamic> _scaleQuestionJson({String questionId = 'scale_q1'}) {
  return {
    'questionId': questionId,
    'questionType': 'scale',
    'text': 'Sample scale prompt',
    'scaleMin': 0,
    'scaleMax': 3,
    'options': [
      {'optionId': 'p0', 'label': 'Zero', 'numericValue': 0},
      {'optionId': 'p1', 'label': 'One', 'numericValue': 1},
      {'optionId': 'p2', 'label': 'Two', 'numericValue': 2},
      {'optionId': 'p3', 'label': 'Three', 'numericValue': 3},
    ],
  };
}
