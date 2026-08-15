import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/domain/questionnaire/detoxia_question_bank.dart';
import 'package:detoxia/domain/questionnaire/question_visibility_resolver.dart';
import 'package:detoxia/domain/questionnaire/resolver_context.dart';
import 'package:flutter_test/flutter_test.dart';

/// Nobody should be asked about a problem they didn't ask for help with.
///
/// This is deliberately written as a property over *all* visible content
/// rather than a list of known-bad question ids: the original bug was that
/// `pathway_map` and `trigger_inventory` fell through the resolver's goal
/// switch to `default: return true`, so a sleep-only user was shown the
/// sexual-control pathways. A per-question allowlist would not have caught
/// that, and would not catch the next section added without a gate.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DetoxiaQuestionBank bank;
  late QuestionVisibilityResolver resolver;

  setUpAll(() async {
    bank = await DetoxiaQuestionBank.loadFromAssets();
    resolver = QuestionVisibilityResolver(bank);
  });

  /// Everything a persona would see, played to completion.
  ({Set<String> sections, List<String> text}) walk({
    required RegistrationAgeBand ageBand,
    required RegistrationGender gender,
    required List<String> goals,
    Map<String, String> pick = const {},
  }) {
    final answers = <String, dynamic>{};
    final seenSections = <String>{};
    final text = <String>[];

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
          .expand((s) => s.questions)
          .where((q) => !answers.containsKey(q.questionId))
          .firstOrNull;
      if (next == null) {
        return (sections: seenSections, text: text);
      }

      seenSections.add(next.sectionId);
      text.add(next.text);
      final options = next.options;
      for (final option in options ?? const []) {
        text.add(option.label);
      }

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

  /// Asked of everyone regardless of goals — routine shape, what sets things
  /// off, and which resets feel realistic.
  const universalSections = {
    'goal_selection',
    'routine_map',
    'trigger_inventory',
    'intervention_preference',
  };

  const sectionsByGoal = {
    'goal_scrolling': {'scrolling_control', 'pathway_map'},
    'goal_sexual_content': {
      'sexual_content_teen',
      'sexual_control_adult',
      'pathway_map',
    },
    'goal_porn_masturbation': {'sexual_control_adult', 'pathway_map'},
    'goal_focus': {'focus_support'},
    'goal_anxiety': {'anxiety_load', 'pathway_map', 'safety_gate'},
    'goal_low_mood': {'low_mood_support', 'pathway_map', 'safety_gate'},
    'goal_sleep': {'sleep_disruption'},
    'goal_energy': {'physical_activation'},
    'goal_cycle': {
      'cycle_sensitivity',
      'menstrual_phase',
      'pathway_map',
      'safety_gate',
    },
  };

  group('single-goal personas see only their own category', () {
    for (final entry in sectionsByGoal.entries) {
      test('${entry.key} pulls in no unrelated section', () {
        final result = walk(
          ageBand: RegistrationAgeBand.adult18Plus,
          gender: RegistrationGender.female,
          goals: [entry.key],
          pick: const {'routine_context': 'ctx_work_home'},
        );

        final allowed = {...universalSections, ...entry.value};
        expect(
          result.sections.difference(allowed),
          isEmpty,
          reason:
              '${entry.key} should not surface '
              '${result.sections.difference(allowed)}',
        );
      });
    }
  });

  group('sleep-only user is never shown other categories', () {
    // The exact complaint: goal = sleep, yet "Sexual control pathways that
    // feel familiar." appeared.
    late ({Set<String> sections, List<String> text}) sleepOnly;

    setUp(() {
      sleepOnly = walk(
        ageBand: RegistrationAgeBand.adult18Plus,
        gender: RegistrationGender.male,
        goals: const ['goal_sleep'],
        pick: const {'routine_context': 'ctx_work_home'},
      );
    });

    test('no sexual content reaches them, in any question or option', () {
      const banned = [
        'sexual',
        'porn',
        'masturb',
        'thirst trap',
        'arousal',
        'fantasy',
      ];
      for (final line in sleepOnly.text) {
        // The goal picker itself legitimately lists every goal.
        if (line.startsWith('What do you want Detoxia') ||
            line.contains('Sexual content or unwanted urges') ||
            line.contains('Porn / masturbation control')) {
          continue;
        }
        for (final word in banned) {
          expect(
            line.toLowerCase(),
            isNot(contains(word)),
            reason: 'sleep-only user should never see: "$line"',
          );
        }
      }
    });

    test('no cycle or period content reaches them', () {
      for (final line in sleepOnly.text) {
        if (line.contains('Period or cycle-related changes')) continue;
        expect(line.toLowerCase(), isNot(contains('menstrua')));
        expect(line.toLowerCase(), isNot(contains('cycle-related')));
      }
    });

    test('pathway and scrolling sections drop out entirely', () {
      expect(sleepOnly.sections, isNot(contains('pathway_map')));
      expect(sleepOnly.sections, isNot(contains('scrolling_control')));
      expect(sleepOnly.sections, isNot(contains('sexual_control_adult')));
      expect(sleepOnly.sections, isNot(contains('anxiety_load')));
      expect(sleepOnly.sections, isNot(contains('low_mood_support')));
      // ...but the sleep work itself, and the universal parts, remain.
      expect(sleepOnly.sections, contains('sleep_disruption'));
      expect(sleepOnly.sections, contains('trigger_inventory'));
      // Safety screening is scoped to the mood-adjacent goals by
      // product decision — see the helpline-access note in settings.
      expect(sleepOnly.sections, isNot(contains('safety_gate')));
    });
  });

  test('universal questions are not framed as addiction recovery', () {
    // Questions everyone sees must read sensibly for a sleep or focus goal.
    // "When do you usually lose control or feel most vulnerable?" was written
    // for the porn/scrolling personas but asked of every user.
    const urgeFraming = [
      'lose control',
      'vulnerab',
      'your loop',
      'pull at you',
      'relapse',
      'craving',
    ];

    for (final goals in const [
      ['goal_sleep'],
      ['goal_focus'],
      ['goal_energy'],
    ]) {
      final result = walk(
        ageBand: RegistrationAgeBand.adult18Plus,
        gender: RegistrationGender.male,
        goals: goals,
        pick: const {'routine_context': 'ctx_work_home'},
      );

      for (final line in result.text) {
        // The goal picker legitimately names every goal, urges included.
        if (line.contains('Sexual content or unwanted urges')) continue;
        for (final phrase in urgeFraming) {
          expect(
            line.toLowerCase(),
            isNot(contains(phrase)),
            reason: '$goals should not be asked: "$line"',
          );
        }
      }
    }
  });

  test('bathroom/privacy windows are only offered to the urge goals', () {
    List<String> labelsFor(List<String> goals) => walk(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      goals: goals,
      pick: const {'routine_context': 'ctx_work_home'},
    ).text;

    expect(labelsFor(const ['goal_sleep']), isNot(contains('Bathroom time')));
    expect(
      labelsFor(const ['goal_sleep']),
      isNot(contains('Bedroom/bathroom privacy')),
    );
    expect(labelsFor(const ['goal_scrolling']), contains('Bathroom time'));
  });

  test('pathway questions appear only for the goal that owns them', () {
    ({Set<String> sections, List<String> text}) forGoal(String g) => walk(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      goals: [g],
      pick: const {'routine_context': 'ctx_work_home'},
    );

    expect(
      forGoal('goal_scrolling').text,
      contains('Scrolling pathways that feel familiar.'),
    );
    expect(
      forGoal('goal_anxiety').text,
      contains('Anxiety pathways that feel familiar.'),
    );
    expect(
      forGoal('goal_porn_masturbation').text,
      contains('Sexual control pathways that feel familiar.'),
    );

    // ...and not for anyone else.
    for (final g in ['goal_sleep', 'goal_focus', 'goal_energy']) {
      expect(
        forGoal(g).text,
        isNot(contains('Sexual control pathways that feel familiar.')),
        reason: '$g must not surface sexual pathways',
      );
      expect(
        forGoal(g).text,
        isNot(contains('Scrolling pathways that feel familiar.')),
        reason: '$g must not surface scrolling pathways',
      );
    }
  });
}
