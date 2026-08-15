import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/domain/questionnaire/detoxia_question_bank.dart';
import 'package:detoxia/domain/questionnaire/question_visibility_resolver.dart';
import 'package:detoxia/domain/questionnaire/resolver_context.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DetoxiaQuestionBank bank;
  late QuestionVisibilityResolver resolver;

  setUpAll(() async {
    bank = await DetoxiaQuestionBank.loadFromAssets();
    resolver = QuestionVisibilityResolver(bank);
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────────────────────────────────

  Set<String> visibleSectionIds(ResolverContext ctx) =>
      resolver.resolveVisibleSections(ctx).map((s) => s.sectionId).toSet();

  ResolverContext ctx({
    required RegistrationAgeBand ageBand,
    required RegistrationGender gender,
    List<String> goals = const [],
    Map<String, dynamic> answers = const {},
  }) => ResolverContext(
    ageBand: ageBand,
    gender: gender,
    selectedGoals: goals,
    answers: answers,
  );

  // ──────────────────────────────────────────────────────────────────────────
  // Persona tests
  // ──────────────────────────────────────────────────────────────────────────

  test('1. 13–15 male: no sexual or cycle sections visible', () {
    final ids = visibleSectionIds(
      ctx(
        ageBand: RegistrationAgeBand.teen13To15,
        gender: RegistrationGender.male,
        goals: const ['goal_sleep'],
      ),
    );

    expect(ids, isNot(contains('sexual_content_teen')));
    expect(ids, isNot(contains('sexual_control_adult')));
    expect(ids, isNot(contains('cycle_sensitivity')));
    expect(ids, isNot(contains('menstrual_phase')));
  });

  test(
    '2. 16–17 male: sexual_content_teen visible, sexual_control_adult hidden',
    () {
      final ids = visibleSectionIds(
        ctx(
          ageBand: RegistrationAgeBand.teen16To17,
          gender: RegistrationGender.male,
          goals: const ['goal_sexual_content'],
        ),
      );

      expect(ids, contains('sexual_content_teen'));
      expect(ids, isNot(contains('sexual_control_adult')));
    },
  );

  test(
    '3. 18+ male: sexual_control_adult visible, sexual_content_teen hidden',
    () {
      final ids = visibleSectionIds(
        ctx(
          ageBand: RegistrationAgeBand.adult18Plus,
          gender: RegistrationGender.male,
          goals: const ['goal_porn_masturbation'],
        ),
      );

      expect(ids, contains('sexual_control_adult'));
      expect(ids, isNot(contains('sexual_content_teen')));
    },
  );

  test(
    '4. 18+ female + cycle goal starts with cycle gate only before menstruation answer',
    () {
      final sections = resolver.resolveVisibleSections(
        ctx(
          ageBand: RegistrationAgeBand.adult18Plus,
          gender: RegistrationGender.female,
          goals: const ['goal_cycle'],
        ),
      );

      final cycleSection = sections.firstWhere(
        (section) => section.sectionId == 'cycle_sensitivity',
      );
      final cycleQuestionIds = cycleSection.questions
          .map((question) => question.questionId)
          .toList();

      expect(cycleQuestionIds, equals(const ['cycle_menstruation_gate']));
      expect(
        sections.map((section) => section.sectionId),
        isNot(contains('menstrual_phase')),
      );
    },
  );

  test('5. 18+ female, menstruation gate yes_or_unsure: '
      'cycle_sensitivity details and menstrual_phase visible', () {
    final ids = visibleSectionIds(
      ctx(
        ageBand: RegistrationAgeBand.adult18Plus,
        gender: RegistrationGender.female,
        goals: const ['goal_cycle'],
        answers: {'cycle_menstruation_gate': 'yes_or_unsure'},
      ),
    );

    expect(ids, contains('cycle_sensitivity'));
    expect(ids, contains('menstrual_phase'));
  });

  test('6. 18+ female, menstruation gate no: cycle detail hidden', () {
    final sections = resolver.resolveVisibleSections(
      ctx(
        ageBand: RegistrationAgeBand.adult18Plus,
        gender: RegistrationGender.female,
        goals: const ['goal_cycle'],
        answers: {'cycle_menstruation_gate': 'no'},
      ),
    );
    final ids = sections.map((section) => section.sectionId).toSet();
    final cycleSection = sections.firstWhere(
      (section) => section.sectionId == 'cycle_sensitivity',
    );

    expect(cycleSection.questions.map((q) => q.questionId), ['cycle_menstruation_gate']);
    expect(ids, isNot(contains('menstrual_phase')));
  });

  test('7. sleep-only excludes school/work commute and non-selected domains', () {
    final context = ctx(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      goals: const ['goal_sleep'],
    );
    final ids = visibleSectionIds(
      context,
    );
    final questionIds = resolver
        .resolveVisibleSections(context)
        .expand((section) => section.questions)
        .map((question) => question.questionId)
        .toSet();

    expect(ids, contains('sleep_disruption'));
    expect(ids, isNot(contains('focus_support')));
    expect(ids, isNot(contains('anxiety_load')));
    expect(ids, isNot(contains('low_mood_support')));
    expect(ids, isNot(contains('sexual_control_adult')));
    expect(ids, isNot(contains('cycle_sensitivity')));
    expect(questionIds, isNot(contains('routine_arrival')));
    expect(questionIds, isNot(contains('routine_busy_start')));
    expect(questionIds, isNot(contains('routine_commute_to')));
    expect(questionIds, isNot(contains('routine_commute_mode')));
  });

  test('8. sleep + anxiety includes anxiety section and more questions than sleep-only', () {
    final sleepOnly = ctx(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      goals: const ['goal_sleep'],
    );
    final ids = visibleSectionIds(
      ctx(
        ageBand: RegistrationAgeBand.adult18Plus,
        gender: RegistrationGender.male,
        goals: const ['goal_sleep', 'goal_anxiety'],
      ),
    );
    final sleepOnlyCount = resolver
        .resolveVisibleSections(sleepOnly)
        .expand((section) => section.questions)
        .length;
    final sleepAnxietyCount = resolver
        .resolveVisibleSections(
          ctx(
            ageBand: RegistrationAgeBand.adult18Plus,
            gender: RegistrationGender.male,
            goals: const ['goal_sleep', 'goal_anxiety'],
          ),
        )
        .expand((section) => section.questions)
        .length;

    expect(ids, contains('sleep_disruption'));
    expect(ids, contains('anxiety_load'));
    expect(ids, isNot(contains('focus_support')));
    expect(sleepAnxietyCount, greaterThan(sleepOnlyCount));
  });

  // Was "safety_gate is always visible regardless of persona". Changed by
  // product decision (2026-07-28): self-harm screening is now scoped to the
  // mood-adjacent goals (anxiety, low mood, cycle) so it does not appear in
  // e.g. a sleep-only or focus-only flow.
  //
  // Note the tradeoff this encodes: insomnia is an independent risk factor
  // for suicidal ideation, and users who are struggling often present with
  // sleep rather than selecting "low mood" — so those users are no longer
  // screened. Helpline resources currently have no other entry point in the
  // app; if that is still true, they need one outside this gate.
  test('9. safety_gate reaches every persona that selects a mood-adjacent goal',
      () {
    for (final goal in const ['goal_anxiety', 'goal_low_mood']) {
      for (final ageBand in RegistrationAgeBand.values) {
        for (final gender in RegistrationGender.values) {
          final ids = visibleSectionIds(
            ctx(ageBand: ageBand, gender: gender, goals: [goal]),
          );
          expect(
            ids,
            contains('safety_gate'),
            reason: '${ageBand.name}/${gender.name}/$goal should see it',
          );
        }
      }
    }
  });

  test('9b. safety_gate is absent for goals it is no longer scoped to', () {
    for (final goal in const ['goal_sleep', 'goal_focus', 'goal_energy']) {
      final ids = visibleSectionIds(
        ctx(
          ageBand: RegistrationAgeBand.adult18Plus,
          gender: RegistrationGender.male,
          goals: [goal],
        ),
      );
      expect(ids, isNot(contains('safety_gate')), reason: goal);
    }
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Navigation
  // ──────────────────────────────────────────────────────────────────────────

  test('10. resolveNextQuestion returns first unanswered visible question', () {
    final context = ctx(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
    );

    final first = resolver.resolveNextQuestion(
      ctx: context,
      completedSectionIds: const [],
    );

    expect(first, isNotNull);
    // The very first question in the ordered bank is goal_q1.
    expect(first!.questionId, 'goal_q1');
    expect(first.sectionId, 'goal_selection');
  });

  test(
    '11. resolveNextQuestion returns null when all visible questions answered',
    () {
      final visibleSections = resolver.resolveVisibleSections(
        ctx(
          ageBand: RegistrationAgeBand.adult18Plus,
          gender: RegistrationGender.male,
        ),
      );

      // Build a context with every visible question answered.
      final allAnswers = <String, dynamic>{};
      for (final section in visibleSections) {
        for (final question in section.questions) {
          allAnswers[question.questionId] = 'answered';
        }
      }

      final next = resolver.resolveNextQuestion(
        ctx: ctx(
          ageBand: RegistrationAgeBand.adult18Plus,
          gender: RegistrationGender.male,
          answers: allAnswers,
        ),
        completedSectionIds: const [],
      );

      expect(next, isNull);
    },
  );

  // ──────────────────────────────────────────────────────────────────────────
  // Edge cases
  // ──────────────────────────────────────────────────────────────────────────

  test('12. goal_q1 option-level ageGate is enforced in the UI layer, '
      'not by the resolver (documented behaviour)', () {
    // The resolver only handles section- and question-level visibility.
    // Option-level ageGate (e.g. goal_porn_masturbation has no ageGate;
    // goal_sexual_content has ageGate.include: [teen16To17, adult18Plus])
    // is NOT parsed into the QuestionOption model, so it is the UI layer's
    // responsibility to filter the option list before rendering.
    //
    // This test confirms that the resolver does NOT filter out goal_q1 for any
    // age band — the full question remains visible; only the displayed options
    // differ between ages.
    for (final ageBand in RegistrationAgeBand.values) {
      final context = ctx(ageBand: ageBand, gender: RegistrationGender.male);
      final question = resolver
          .resolveVisibleSections(context)
          .expand((s) => s.questions)
          .where((q) => q.questionId == 'goal_q1')
          .toList();
      expect(
        question,
        isNotEmpty,
        reason: 'goal_q1 should be visible for ${ageBand.name}',
      );
    }
  });

  test(
    '13. answerEquals with a missing answer evaluates to false (no crash)',
    () {
      final context = ctx(
        ageBand: RegistrationAgeBand.adult18Plus,
        gender: RegistrationGender.female,
        goals: const ['goal_cycle'],
        // deliberately omit cycle_menstruation_gate answer
        answers: {},
      );

      final ids = visibleSectionIds(context);

      // cycle_sensitivity requires answerEquals on cycle_menstruation_gate;
      // missing answer must evaluate to false, not throw.
      expect(ids, contains('cycle_sensitivity'));
      expect(ids, isNot(contains('menstrual_phase')));
    },
  );
}
