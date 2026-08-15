import 'package:detoxia/domain/questionnaire/detoxia_question_bank.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'DetoxiaQuestionBank.loadFromAssets succeeds on the real JSON',
    () async {
      final bank = await DetoxiaQuestionBank.loadFromAssets();

      expect(bank.version, '1.0.0');
      expect(bank.sections, isNotEmpty);
    },
  );

  test('real question bank has the expected number of sections', () async {
    final bank = await DetoxiaQuestionBank.loadFromAssets();

    // 16 since the empty `sleep_debt` section was removed — sleep debt is
    // derived from the routine windows and never had questions of its own.
    expect(bank.sections.length, 16);
    expect(bank.sectionById('sleep_debt'), isNull);
  });

  test('scrolling_control returns 5 questions', () async {
    final bank = await DetoxiaQuestionBank.loadFromAssets();
    final section = bank.sectionById('scrolling_control');

    expect(section, isNotNull);
    expect(section!.questions.length, 5);
  });

  test('focus_support returns 6 questions with scaleMax 4', () async {
    final bank = await DetoxiaQuestionBank.loadFromAssets();
    final section = bank.sectionById('focus_support');

    expect(section, isNotNull);
    expect(section!.questions.length, 6);
    expect(
      section.questions.every((question) => question.scaleMax == 4),
      isTrue,
    );
  });

  test('anxiety_load returns 4 questions with scaleMax 3', () async {
    final bank = await DetoxiaQuestionBank.loadFromAssets();
    final section = bank.sectionById('anxiety_load');

    expect(section, isNotNull);
    expect(section!.questions.length, 4);
    expect(
      section.questions.every((question) => question.scaleMax == 3),
      isTrue,
    );
  });

  test('safety_gate exists with notScored true', () async {
    final bank = await DetoxiaQuestionBank.loadFromAssets();
    final section = bank.sectionById('safety_gate');

    expect(section, isNotNull);
    expect(section!.notScored, isTrue);
  });

  test('sexual_content_teen has teen16To17 visibility gate', () async {
    final bank = await DetoxiaQuestionBank.loadFromAssets();
    final section = bank.sectionById('sexual_content_teen');

    expect(section, isNotNull);
    expect(section!.visibleIf, isNotNull);
    expect(section.visibleIf!.ageBandIn, ['teen16To17']);
  });

  test('sexual_control_adult has adult18Plus visibility gate', () async {
    final bank = await DetoxiaQuestionBank.loadFromAssets();
    final section = bank.sectionById('sexual_control_adult');

    expect(section, isNotNull);
    expect(section!.visibleIf, isNotNull);
    expect(section.visibleIf!.ageBandIn, ['adult18Plus']);
  });

  test('questionById finds propagated section ids', () async {
    final bank = await DetoxiaQuestionBank.loadFromAssets();
    final question = bank.questionById('scroll_q1');

    expect(question, isNotNull);
    expect(question!.sectionId, 'scrolling_control');
  });
}
