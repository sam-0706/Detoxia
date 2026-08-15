import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/domain/questionnaire/detoxia_question_bank.dart';
import 'package:detoxia/domain/questionnaire/question_visibility_resolver.dart';
import 'package:detoxia/domain/questionnaire/resolver_context.dart';
import 'package:flutter_test/flutter_test.dart';

/// Walks each persona through the questionnaire the way the screen does —
/// answering the first unanswered question, re-resolving, repeating — and
/// asserts nobody is asked something that cannot apply to them.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DetoxiaQuestionBank bank;
  late QuestionVisibilityResolver resolver;

  setUpAll(() async {
    bank = await DetoxiaQuestionBank.loadFromAssets();
    resolver = QuestionVisibilityResolver(bank);
  });

  /// Plays the questionnaire to completion, choosing [pick] for each question
  /// (defaulting to the first option). Returns every question actually shown.
  List<String> walk({
    required RegistrationAgeBand ageBand,
    required RegistrationGender gender,
    required List<String> goals,
    Map<String, String> pick = const {},
  }) {
    final answers = <String, dynamic>{};
    final asked = <String>[];

    for (var guard = 0; guard < 500; guard++) {
      final sections = resolver.resolveVisibleSections(
        ResolverContext(
          ageBand: ageBand,
          gender: gender,
          selectedGoals: goals,
          answers: answers,
        ),
      );

      final next = sections
          .expand((section) => section.questions)
          .where((q) => !answers.containsKey(q.questionId))
          .firstOrNull;
      if (next == null) return asked;

      asked.add(next.questionId);
      final options = next.options;
      final chosen =
          pick[next.questionId] ??
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
    fail('questionnaire did not terminate — possible visibility loop');
  }

  const commuteChain = {
    'routine_commute_mode',
    'routine_commute_to',
    'routine_commute_back',
    'routine_commute_phone',
  };

  test('every persona terminates and asks each question at most once', () {
    for (final ageBand in RegistrationAgeBand.values) {
      for (final gender in RegistrationGender.values) {
        final asked = walk(
          ageBand: ageBand,
          gender: gender,
          goals: const ['goal_scrolling', 'goal_sleep', 'goal_anxiety'],
        );
        expect(
          asked.length,
          asked.toSet().length,
          reason: 'duplicate question for $ageBand/$gender',
        );
        expect(asked, isNotEmpty);
      }
    }
  });

  test('jobless adult is never asked about commuting or arrival', () {
    final asked = walk(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      goals: const ['goal_scrolling', 'goal_focus'],
      pick: const {'routine_context': 'ctx_between'},
    );

    expect(asked.toSet().intersection(commuteChain), isEmpty);
    expect(asked, isNot(contains('routine_arrival')));
    expect(asked, contains('routine_context'));
  });

  test('work-from-home adult is never asked about commuting', () {
    final asked = walk(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.female,
      goals: const ['goal_scrolling'],
      pick: const {'routine_context': 'ctx_work_home'},
    );

    expect(asked.toSet().intersection(commuteChain), isEmpty);
    expect(asked, isNot(contains('routine_arrival')));
  });

  test('on-site worker gets the whole commute chain, in order', () {
    final asked = walk(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      goals: const ['goal_scrolling'],
      pick: const {
        'routine_context': 'ctx_work_onsite',
        'routine_commute_mode': 'mode_bus_metro_train',
      },
    );

    expect(asked, containsAll(commuteChain));
    expect(asked, contains('routine_arrival'));
    // Mode must be established before anything that depends on it.
    expect(
      asked.indexOf('routine_commute_mode'),
      lessThan(asked.indexOf('routine_commute_to')),
    );
    expect(
      asked.indexOf('routine_commute_mode'),
      lessThan(asked.indexOf('routine_commute_phone')),
    );
  });

  test('a 13–15 year old is never shown adult sexual-content questions', () {
    final asked = walk(
      ageBand: RegistrationAgeBand.teen13To15,
      gender: RegistrationGender.male,
      goals: const ['goal_scrolling', 'goal_anxiety', 'goal_sleep'],
    );

    for (final id in asked) {
      expect(
        id.startsWith('sxadult_') || id.startsWith('sxteen_'),
        isFalse,
        reason: '$id must not reach a 13–15 year old',
      );
    }
  });

  test('sexual pathways need both the right age band and the goal', () {
    // Without the goal, no band sees them — this is the sleep-only bug.
    for (final ageBand in RegistrationAgeBand.values) {
      final withoutGoal = walk(
        ageBand: ageBand,
        gender: RegistrationGender.male,
        goals: const ['goal_scrolling', 'goal_anxiety', 'goal_sleep'],
      );
      expect(withoutGoal, isNot(contains('path_sexual_teen')), reason: '$ageBand');
      expect(withoutGoal, isNot(contains('path_sexual_adult')), reason: '$ageBand');
    }

    // With the goal, each band gets its own age-appropriate version.
    const sexualGoal = ['goal_sexual_content'];

    final young = walk(
      ageBand: RegistrationAgeBand.teen13To15,
      gender: RegistrationGender.male,
      goals: sexualGoal,
    );
    final older = walk(
      ageBand: RegistrationAgeBand.teen16To17,
      gender: RegistrationGender.male,
      goals: sexualGoal,
    );
    final adult = walk(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      goals: sexualGoal,
    );

    // 13–15 gets neither version even if the goal is somehow set, and is
    // told why the adult-only goals were missing from the list.
    expect(young, isNot(contains('path_sexual_teen')));
    expect(young, isNot(contains('path_sexual_adult')));
    expect(young, contains('goal_q1_adult_only_option'));

    expect(older, contains('path_sexual_teen'));
    expect(older, isNot(contains('path_sexual_adult')));

    expect(adult, contains('path_sexual_adult'));
    expect(adult, isNot(contains('path_sexual_teen')));
    expect(adult, isNot(contains('goal_q1_adult_only_option')));
  });

  test('choosing fewer goals meaningfully shortens the questionnaire', () {
    final focused = walk(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      goals: const ['goal_sleep'],
      pick: const {'routine_context': 'ctx_work_home'},
    );
    final everything = walk(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      goals: const [
        'goal_scrolling',
        'goal_focus',
        'goal_anxiety',
        'goal_low_mood',
        'goal_sleep',
        'goal_energy',
      ],
      pick: const {'routine_context': 'ctx_work_onsite'},
    );

    expect(focused.length, lessThan(everything.length));
    // ignore: avoid_print
    print(
      'sleep-only WFH: ${focused.length} questions · '
      'all-goals on-site: ${everything.length} questions',
    );
  });
}
