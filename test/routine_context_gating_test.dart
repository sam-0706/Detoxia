import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/domain/questionnaire/detoxia_question_bank.dart';
import 'package:detoxia/domain/questionnaire/question_visibility_resolver.dart';
import 'package:detoxia/domain/questionnaire/resolver_context.dart';
import 'package:flutter_test/flutter_test.dart';

/// Covers the life-context gating: nobody should be asked about a commute
/// they don't have, and nobody should be asked to name an arrival time for a
/// place they don't go to.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DetoxiaQuestionBank bank;
  late QuestionVisibilityResolver resolver;

  setUpAll(() async {
    bank = await DetoxiaQuestionBank.loadFromAssets();
    resolver = QuestionVisibilityResolver(bank);
  });

  Set<String> visibleQuestionIds(ResolverContext ctx) => resolver
      .resolveVisibleSections(ctx)
      .expand((section) => section.questions)
      .map((question) => question.questionId)
      .toSet();

  ResolverContext ctx(Map<String, dynamic> answers) => ResolverContext(
    ageBand: RegistrationAgeBand.adult18Plus,
    gender: RegistrationGender.male,
    selectedGoals: const ['goal_scrolling'],
    answers: answers,
  );

  const commuteChain = {
    'routine_commute_mode',
    'routine_commute_to',
    'routine_commute_back',
    'routine_commute_phone',
  };

  test('life context is asked of everyone, before anything schedule-shaped', () {
    final ids = visibleQuestionIds(ctx(const {}));
    expect(ids, contains('routine_context'));

    final routine = resolver
        .resolveVisibleSections(ctx(const {}))
        .firstWhere((section) => section.sectionId == 'routine_map');
    expect(routine.questions.first.questionId, 'routine_context');
  });

  test('works from home: no commute questions, no arrival time', () {
    final ids = visibleQuestionIds(
      ctx(const {
        'routine_context': {'selectedOptionId': 'ctx_work_home'},
      }),
    );

    for (final id in commuteChain) {
      expect(ids, isNot(contains(id)), reason: '$id must be hidden for WFH');
    }
    expect(ids, isNot(contains('routine_arrival')));
    // Still needs the parts of the routine that apply to everyone.
    expect(ids, contains('routine_wake'));
    expect(ids, contains('routine_busy_start'));
    expect(ids, contains('routine_free_windows'));
  });

  test('not working / at home: no commute questions, no arrival time', () {
    for (final context in const ['ctx_between', 'ctx_home_duties']) {
      final ids = visibleQuestionIds(
        ctx({
          'routine_context': {'selectedOptionId': context},
        }),
      );
      for (final id in commuteChain) {
        expect(ids, isNot(contains(id)), reason: '$id must be hidden ($context)');
      }
      expect(ids, isNot(contains('routine_arrival')), reason: context);
      expect(ids, contains('routine_wake'), reason: context);
    }
  });

  test('remote student: no commute, but keeps the rest of the routine', () {
    final ids = visibleQuestionIds(
      ctx(const {
        'routine_context': {'selectedOptionId': 'ctx_student_remote'},
      }),
    );

    expect(ids.intersection(commuteChain), isEmpty);
    expect(ids, isNot(contains('routine_arrival')));
    expect(ids, contains('routine_vulnerable_windows'));
  });

  test('on-site worker: mode is asked, duration only after a mode is picked', () {
    final beforeMode = visibleQuestionIds(
      ctx(const {
        'routine_context': {'selectedOptionId': 'ctx_work_onsite'},
      }),
    );

    expect(beforeMode, contains('routine_arrival'));
    expect(beforeMode, contains('routine_commute_mode'));
    // Follow-ups wait for the mode answer rather than appearing pre-emptively.
    expect(beforeMode, isNot(contains('routine_commute_to')));
    expect(beforeMode, isNot(contains('routine_commute_phone')));

    final afterMode = visibleQuestionIds(
      ctx(const {
        'routine_context': {'selectedOptionId': 'ctx_work_onsite'},
        'routine_commute_mode': {'selectedOptionId': 'mode_bus_metro_train'},
      }),
    );

    expect(afterMode, containsAll(commuteChain));
  });

  test('shift worker commutes but has no fixed arrival time', () {
    final ids = visibleQuestionIds(
      ctx(const {
        'routine_context': {'selectedOptionId': 'ctx_shift'},
      }),
    );

    expect(ids, contains('routine_commute_mode'));
    expect(ids, isNot(contains('routine_arrival')));
  });

  test('no commute-shaped option survives anywhere for a non-commuter', () {
    // Every option mentioning a commute, across every section, must disappear
    // together — a WFH user seeing "Commute → idle scrolling" in the pathway
    // list is the same bug as being asked their commute duration.
    final options = resolver
        .resolveVisibleSections(
          ResolverContext(
            ageBand: RegistrationAgeBand.adult18Plus,
            gender: RegistrationGender.male,
            selectedGoals: const ['goal_scrolling', 'goal_anxiety'],
            answers: const {
              'routine_context': {'selectedOptionId': 'ctx_work_home'},
            },
          ),
        )
        .expand((section) => section.questions)
        .expand((question) => question.options ?? const [])
        .toList();

    for (final option in options) {
      expect(
        '${option.optionId} ${option.label}'.toLowerCase(),
        isNot(contains('commut')),
        reason: '${option.optionId} should be hidden from a non-commuter',
      );
    }
  });

  test('"during commute" is not offered to someone who never commutes', () {
    List<String> vulnerableOptions(Map<String, dynamic> answers) => resolver
        .resolveVisibleSections(ctx(answers))
        .expand((section) => section.questions)
        .firstWhere((q) => q.questionId == 'routine_vulnerable_windows')
        .options!
        .map((option) => option.optionId)
        .toList();

    expect(
      vulnerableOptions(const {
        'routine_context': {'selectedOptionId': 'ctx_work_home'},
      }),
      isNot(contains('vuln_commute')),
    );

    expect(
      vulnerableOptions(const {
        'routine_context': {'selectedOptionId': 'ctx_work_onsite'},
        'routine_commute_mode': {'selectedOptionId': 'mode_walk'},
      }),
      contains('vuln_commute'),
    );
  });

  group('adult-only options stay hidden from minors', () {
    List<String> goalOptions(RegistrationAgeBand ageBand) {
      final context = ResolverContext(
        ageBand: ageBand,
        gender: RegistrationGender.male,
        selectedGoals: const [],
        answers: const {},
      );
      return resolver
          .resolveVisibleSections(context)
          .expand((section) => section.questions)
          .firstWhere((q) => q.questionId == 'goal_q1')
          .options!
          .map((option) => option.optionId)
          .toList();
    }

    test('13–15 sees neither sexual-content nor porn/masturbation goals', () {
      final options = goalOptions(RegistrationAgeBand.teen13To15);
      expect(options, isNot(contains('goal_sexual_content')));
      expect(options, isNot(contains('goal_porn_masturbation')));
      expect(options, contains('goal_scrolling'));
    });

    test('16–17 sees the content goal but not the porn/masturbation goal', () {
      final options = goalOptions(RegistrationAgeBand.teen16To17);
      expect(options, contains('goal_sexual_content'));
      expect(options, isNot(contains('goal_porn_masturbation')));
    });

    test('18+ sees both', () {
      final options = goalOptions(RegistrationAgeBand.adult18Plus);
      expect(options, contains('goal_sexual_content'));
      expect(options, contains('goal_porn_masturbation'));
    });

    test('adult-only trigger options are hidden from 13–15', () {
      final context = ResolverContext(
        ageBand: RegistrationAgeBand.teen13To15,
        gender: RegistrationGender.male,
        selectedGoals: const ['goal_scrolling'],
        answers: const {},
      );
      final options = resolver
          .resolveVisibleSections(context)
          .expand((section) => section.questions)
          .firstWhere((q) => q.questionId == 'trig_select')
          .options!
          .map((option) => option.optionId)
          .toList();

      expect(options, isNot(contains('trig_sexual_content')));
      expect(options, isNot(contains('trig_thirst_traps')));
      expect(options, contains('trig_boredom'));
    });
  });
}
