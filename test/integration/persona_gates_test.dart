import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/domain/questionnaire/detoxia_question_bank.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:detoxia/domain/questionnaire/question_visibility_resolver.dart';
import 'package:detoxia/domain/questionnaire/resolver_context.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late QuestionVisibilityResolver resolver;

  setUpAll(() async {
    final bank = await DetoxiaQuestionBank.loadFromAssets();
    resolver = QuestionVisibilityResolver(bank);
  });

  ResolverContext ctx({
    required RegistrationAgeBand ageBand,
    required RegistrationGender gender,
    List<String> goals = const [],
    Map<String, dynamic> answers = const {},
  }) {
    return ResolverContext(
      ageBand: ageBand,
      gender: gender,
      selectedGoals: goals,
      answers: answers,
    );
  }

  List<QuestionnaireQuestion> visibleQuestions(ResolverContext ctx) {
    return resolver
        .resolveVisibleSections(ctx)
        .expand((section) => section.questions)
        .toList();
  }

  Set<String> visibleSectionIds(ResolverContext ctx) {
    return resolver
        .resolveVisibleSections(ctx)
        .map((section) => section.sectionId)
        .toSet();
  }

  bool hasQuestionId(ResolverContext ctx, String id) {
    return visibleQuestions(ctx).any((question) => question.questionId == id);
  }

  test('sleep only: only sleep + core routine are visible', () {
    final context = ctx(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      goals: const ['goal_sleep'],
    );
    final sections = visibleSectionIds(context);
    final questionIds = visibleQuestions(context)
        .map((question) => question.questionId)
        .toSet();

    expect(sections, contains('sleep_disruption'));
    expect(sections, isNot(contains('focus_support')));
    expect(sections, isNot(contains('anxiety_load')));
    expect(sections, isNot(contains('low_mood_support')));
    expect(sections, isNot(contains('scrolling_control')));
    expect(sections, isNot(contains('sexual_content_teen')));
    expect(sections, isNot(contains('sexual_control_adult')));
    expect(sections, isNot(contains('cycle_sensitivity')));
    expect(questionIds, contains('routine_wake'));
    expect(questionIds, contains('routine_sleep_attempt'));
    expect(questionIds, isNot(contains('routine_arrival')));
    expect(questionIds, isNot(contains('routine_busy_start')));
    expect(questionIds, isNot(contains('routine_commute_to')));
    expect(questionIds, isNot(contains('routine_commute_mode')));
    expect(questionIds, isNot(contains('focus_q1')));
    expect(questionIds, isNot(contains('anx_q1')));
    expect(questionIds, isNot(contains('mood_q1')));
    expect(questionIds, isNot(contains('sxadult_q1')));
    expect(questionIds, isNot(contains('cycle_q1')));
  });

  test('sleep + anxiety: includes both and expands question count', () {
    final sleepOnly = ctx(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      goals: const ['goal_sleep'],
    );
    final context = ctx(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      goals: const ['goal_sleep', 'goal_anxiety'],
    );
    final sections = visibleSectionIds(context);
    final sleepOnlyCount = visibleQuestions(sleepOnly).length;
    final sleepAnxietyCount = visibleQuestions(context).length;

    expect(sections, contains('sleep_disruption'));
    expect(sections, contains('anxiety_load'));
    expect(sections, isNot(contains('focus_support')));
    expect(sections, isNot(contains('sexual_control_adult')));
    expect(sleepAnxietyCount, greaterThan(sleepOnlyCount));
  });

  test('anxiety + focus: includes anxiety and focus only', () {
    final context = ctx(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      goals: const ['goal_anxiety', 'goal_focus'],
    );
    final sections = visibleSectionIds(context);

    expect(sections, contains('anxiety_load'));
    expect(sections, contains('focus_support'));
    expect(sections, isNot(contains('sleep_disruption')));
    expect(sections, isNot(contains('sexual_control_adult')));
    expect(sections, isNot(contains('cycle_sensitivity')));
    expect(hasQuestionId(context, 'anx_q1'), isTrue);
    expect(hasQuestionId(context, 'focus_q1'), isTrue);
    expect(hasQuestionId(context, 'sxadult_q1'), isFalse);
  });

  test('scrolling + sleep: includes scrolling and sleep, excludes others', () {
    final context = ctx(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      goals: const ['goal_scrolling', 'goal_sleep'],
    );
    final sections = visibleSectionIds(context);

    expect(sections, contains('scrolling_control'));
    expect(sections, contains('sleep_disruption'));
    expect(sections, isNot(contains('anxiety_load')));
    expect(sections, isNot(contains('focus_support')));
    expect(sections, isNot(contains('sexual_control_adult')));
    expect(sections, isNot(contains('cycle_sensitivity')));
  });

  test('adult sexual-control only: sexual section visible, cycle hidden', () {
    final context = ctx(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      goals: const ['goal_porn_masturbation'],
    );
    final sections = visibleSectionIds(context);

    expect(sections, contains('sexual_control_adult'));
    expect(sections, isNot(contains('sexual_content_teen')));
    expect(sections, isNot(contains('cycle_sensitivity')));
    expect(hasQuestionId(context, 'sxadult_q1'), isTrue);
  });

  test('female + cycle: gate first, then cycle details after yes', () {
    final beforeGate = ctx(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.female,
      goals: const ['goal_cycle'],
    );
    final context = ctx(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.female,
      goals: const ['goal_cycle'],
      answers: const {
        'cycle_menstruation_gate': {'selectedOptionId': 'yes_or_unsure'},
      },
    );

    expect(hasQuestionId(beforeGate, 'cycle_menstruation_gate'), isTrue);
    expect(hasQuestionId(beforeGate, 'cycle_q1'), isFalse);
    expect(visibleSectionIds(beforeGate), isNot(contains('menstrual_phase')));

    final sections = visibleSectionIds(context);
    expect(sections, contains('cycle_sensitivity'));
    expect(sections, contains('menstrual_phase'));
    expect(hasQuestionId(context, 'cycle_q1'), isTrue);
    expect(hasQuestionId(context, 'mens_last_period_start'), isTrue);
  });

  test('male without cycle: cycle sections hidden', () {
    final context = ctx(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      goals: const ['goal_sleep', 'goal_anxiety'],
    );
    final sections = visibleSectionIds(context);

    expect(sections, isNot(contains('cycle_sensitivity')));
    expect(sections, isNot(contains('menstrual_phase')));
    expect(hasQuestionId(context, 'cycle_q1'), isFalse);
  });
}
