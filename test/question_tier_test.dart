import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/domain/questionnaire/detoxia_question_bank.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:detoxia/domain/questionnaire/question_visibility_resolver.dart';
import 'package:detoxia/domain/questionnaire/resolver_context.dart';
import 'package:flutter_test/flutter_test.dart';

/// Onboarding asks the core tier only; the rest is finished later from home.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DetoxiaQuestionBank bank;
  late QuestionVisibilityResolver resolver;

  setUpAll(() async {
    bank = await DetoxiaQuestionBank.loadFromAssets();
    resolver = QuestionVisibilityResolver(bank);
  });

  List<String> walk({
    required List<String> goals,
    QuestionTier? tier,
    RegistrationAgeBand ageBand = RegistrationAgeBand.adult18Plus,
    RegistrationGender gender = RegistrationGender.female,
    Map<String, String> pick = const {},
  }) {
    final answers = <String, dynamic>{};
    final asked = <String>[];

    for (var guard = 0; guard < 400; guard++) {
      final sections = resolver.resolveVisibleSections(
        ResolverContext(
          ageBand: ageBand,
          gender: gender,
          selectedGoals: goals,
          answers: answers,
        ),
        tier: tier,
      );
      final next = sections
          .expand((s) => s.questions)
          .where((q) => !answers.containsKey(q.questionId))
          .firstOrNull;
      if (next == null) return asked;

      asked.add(next.questionId);
      final options = next.options;
      final chosen = pick[next.questionId] ??
          (options != null && options.isNotEmpty
              ? options.first.optionId
              : null);
      answers[next.questionId] = chosen == null
          ? {'acknowledged': true}
          : {
              'selectedOptionId': chosen,
              'selectedOptionIds': [chosen],
            };
    }
    fail('questionnaire did not terminate');
  }

  const allGoals = [
    'goal_scrolling',
    'goal_focus',
    'goal_anxiety',
    'goal_low_mood',
    'goal_sleep',
    'goal_energy',
  ];

  test('onboarding stays short even when every goal is selected', () {
    final core = walk(
      goals: allGoals,
      tier: QuestionTier.core,
      pick: const {'routine_context': 'ctx_work_onsite'},
    );
    final full = walk(
      goals: allGoals,
      pick: const {'routine_context': 'ctx_work_onsite'},
    );

    // ignore: avoid_print
    print('all goals — core: ${core.length}  full: ${full.length}');
    expect(core.length, lessThan(full.length));
    expect(
      core.length,
      lessThanOrEqualTo(20),
      reason: 'onboarding must stay under ~20 questions; got ${core.length}',
    );
  });

  test('a single-goal user gets a very short onboarding', () {
    for (final goal in allGoals) {
      final core = walk(
        goals: [goal],
        tier: QuestionTier.core,
        pick: const {'routine_context': 'ctx_work_home'},
      );
      // ignore: avoid_print
      print('$goal — core: ${core.length}');
      expect(
        core.length,
        lessThanOrEqualTo(12),
        reason: '$goal onboarding is ${core.length} questions',
      );
      expect(core, contains('goal_q1'));
      expect(core, contains('routine_context'));
    }
  });

  test('core tier still covers what the engine needs to build a plan', () {
    final core = walk(
      goals: const ['goal_sleep', 'goal_anxiety'],
      tier: QuestionTier.core,
      pick: const {'routine_context': 'ctx_work_home'},
    );

    // Goals, day shape, when support should fire, and what kind of support.
    expect(core, contains('goal_q1'));
    expect(core, contains('routine_context'));
    expect(core, contains('routine_wake'));
    expect(core, contains('routine_sleep_attempt'));
    expect(core, contains('routine_vulnerable_windows'));
    expect(core, contains('intv_select'));
    // A severity baseline for each selected domain.
    expect(core, contains('sleep_q1'));
    expect(core, contains('anx_q1'));
    // Safety routing is not deferred for the goals it applies to.
    expect(core, contains('safety_q1'));
  });

  test('deferred questions are exactly the full set minus the core set', () {
    final core = walk(
      goals: allGoals,
      tier: QuestionTier.core,
      pick: const {'routine_context': 'ctx_work_onsite'},
    ).toSet();
    final full = walk(
      goals: allGoals,
      pick: const {'routine_context': 'ctx_work_onsite'},
    ).toSet();

    expect(core.difference(full), isEmpty,
        reason: 'core must be a subset of the full questionnaire');
    expect(full.difference(core), isNotEmpty,
        reason: 'there should be deferred questions left to finish later');
  });

  test('every core question is reachable — none stranded behind a deep gate',
      () {
    // A core question whose visibleIf depends on a deep question would never
    // appear during onboarding, silently shrinking it.
    final coreIds = <String>{};
    for (final section in bank.sections) {
      for (final q in section.questions) {
        if (q.tier == QuestionTier.core) coreIds.add(q.questionId);
      }
    }

    final reachable = <String>{};
    for (final goals in [
      allGoals,
      ['goal_cycle'],
      ['goal_sexual_content'],
      ['goal_porn_masturbation'],
    ]) {
      for (final context in ['ctx_work_onsite', 'ctx_work_home']) {
        // Sweep every age band: some core questions are band-specific (the
        // teen content items, and the explainer for why adult goals are
        // missing from a minor's list).
        for (final ageBand in RegistrationAgeBand.values) {
          reachable.addAll(
            walk(
              goals: goals,
              tier: QuestionTier.core,
              ageBand: ageBand,
              pick: {
                'routine_context': context,
                'cycle_menstruation_gate': 'yes_or_unsure',
                'safety_q2': 'yes',
              },
            ),
          );
        }
      }
    }

    expect(
      coreIds.difference(reachable),
      isEmpty,
      reason: 'unreachable core questions: ${coreIds.difference(reachable)}',
    );
  });
}
