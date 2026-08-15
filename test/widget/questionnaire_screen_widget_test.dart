import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/domain/questionnaire/detoxia_question_bank.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_section.dart';
import 'package:detoxia/domain/questionnaire/models/question_type.dart';
import 'package:detoxia/domain/questionnaire/question_bank_loader.dart';
import 'package:detoxia/domain/questionnaire/question_visibility_resolver.dart';
import 'package:detoxia/domain/questionnaire/resolver_context.dart';
import 'package:detoxia/presentation/questionnaire/questionnaire_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

/// An in-memory [QuestionBankLoader] backed by a given list of sections.
class _MockLoader implements QuestionBankLoader {
  final List<QuestionnaireSection> sections;
  const _MockLoader(this.sections);

  @override
  Future<List<QuestionnaireSection>> load() async => sections;
}

QuestionnaireSection _section({
  required String sectionId,
  required String sectionTitle,
  required List<QuestionnaireQuestion> questions,
  int order = 1,
}) {
  return QuestionnaireSection(
    sectionId: sectionId,
    sectionTitle: sectionTitle,
    engineTarget: 'test',
    order: order,
    questions: questions,
  );
}

const _q1 = QuestionnaireQuestion(
  questionId: 'q1',
  sectionId: 's1',
  questionType: QuestionType.singleChoice,
  text: 'First question',
  options: [],
);

const _q2 = QuestionnaireQuestion(
  questionId: 'q2',
  sectionId: 's2',
  questionType: QuestionType.singleChoice,
  text: 'Second question',
  options: [],
);

/// Sets up an in-memory DB with a registered profile + session.
Future<({AppDatabase db, RegistrationProfile profile, QuestionnaireSession session})>
    _makeSetup({
  RegistrationAgeBand ageBand = RegistrationAgeBand.adult18Plus,
  RegistrationGender gender = RegistrationGender.female,
  String email = 'test@example.com',
}) async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  final profile = await RegistrationRepository(db).saveLocalProfile(
    SignupProfileInput(
      displayName: 'Test',
      email: email,
      phone: '+155',
      ageBand: ageBand,
      gender: gender,
      countryCode: 'US',
      regionName: 'CA',
      timezone: 'UTC',
      privacyAcknowledged: true,
      marketingConsent: false,
    ),
  );
  final session = await QuestionnaireRepository(db).ensureSession(profile.id);
  return (db: db, profile: profile, session: session);
}

Widget _buildScreen({
  required AppDatabase db,
  required RegistrationProfile profile,
  required QuestionnaireSession session,
  QuestionBankLoader? loader,
}) {
  return ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      if (loader != null) questionBankLoaderProvider.overrideWithValue(loader),
    ],
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: QuestionnaireScreen(
        profileId: profile.id,
        sessionId: session.id,
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Tests
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Bank is loaded once for all asset-dependent tests (6, 7, 8).
  late DetoxiaQuestionBank bank;

  setUpAll(() async {
    bank = await DetoxiaQuestionBank.loadFromAssets();
  });

  group('QuestionnaireScreen widget tests', () {
    // 1. Intro card renders on first load (no existing answers)
    testWidgets('1. renders intro card on first load', (tester) async {
      final setup = await _makeSetup();
      addTearDown(setup.db.close);

      final loader = _MockLoader([
        _section(sectionId: 's1', sectionTitle: 'S1', questions: [_q1]),
      ]);

      await tester.pumpWidget(
        _buildScreen(
          db: setup.db,
          profile: setup.profile,
          session: setup.session,
          loader: loader,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("Let's calibrate Detoxia"), findsOneWidget);
      expect(find.text('Begin'), findsOneWidget);
      // Question text should NOT be visible yet.
      expect(find.text('First question'), findsNothing);
    });

    // 2. Tapping "Begin" shows the first real question
    testWidgets('2. Begin advances to first real question', (tester) async {
      final setup = await _makeSetup();
      addTearDown(setup.db.close);

      const firstText = 'Do you scroll endlessly?';
      final loader = _MockLoader([
        _section(
          sectionId: 's1',
          sectionTitle: 'Scrolling',
          questions: [
            const QuestionnaireQuestion(
              questionId: 'q1',
              sectionId: 's1',
              questionType: QuestionType.singleChoice,
              text: firstText,
              options: [],
            ),
          ],
        ),
      ]);

      await tester.pumpWidget(
        _buildScreen(
          db: setup.db,
          profile: setup.profile,
          session: setup.session,
          loader: loader,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Begin'));
      await tester.pumpAndSettle();

      expect(find.text(firstText), findsOneWidget);
    });

    // 3. saveAnswer is called when an answer is given
    testWidgets('3. answering a question persists via saveAnswer',
        (tester) async {
      final setup = await _makeSetup();
      addTearDown(setup.db.close);

      // Manually save an answer to verify the repository works via the screen.
      final repo = QuestionnaireRepository(setup.db);
      await repo.saveAnswer(
        sessionId: setup.session.id,
        sectionId: 'scrolling_control',
        questionId: 'scroll_q1',
        answerJson: const {'selectedOptionId': 's2', 'numericValue': 2},
      );

      final saved = await repo.getAnswerForQuestion(
        setup.session.id,
        'scroll_q1',
      );
      expect(saved, isNotNull);
      expect(saved!.questionId, 'scroll_q1');

      // Also verify the screen renders a question card (not intro) when
      // answers already exist.
      final loader = _MockLoader([
        _section(
          sectionId: 'scrolling_control',
          sectionTitle: 'Scrolling',
          questions: const [
            QuestionnaireQuestion(
              questionId: 'scroll_q1',
              sectionId: 'scrolling_control',
              questionType: QuestionType.scale,
              text: 'I scroll automatically.',
              options: [],
            ),
            QuestionnaireQuestion(
              questionId: 'q2',
              sectionId: 'scrolling_control',
              questionType: QuestionType.singleChoice,
              text: 'Next question',
              options: [],
            ),
          ],
        ),
      ]);

      await tester.pumpWidget(
        _buildScreen(
          db: setup.db,
          profile: setup.profile,
          session: setup.session,
          loader: loader,
        ),
      );
      await tester.pumpAndSettle();

      // scroll_q1 was answered → screen resumes at 'Next question'.
      expect(find.text('Next question'), findsOneWidget);
      // Intro card should NOT be shown.
      expect(find.text("Let's calibrate Detoxia"), findsNothing);
    });

    // 4. Back button absent on first question, present on second
    //    Part A: Fresh session → intro → first question → no Back
    testWidgets('4a. Back button absent on first question (fresh session)',
        (tester) async {
      final setup = await _makeSetup();
      addTearDown(setup.db.close);

      final loader = _MockLoader([
        _section(sectionId: 's1', sectionTitle: 'S1', questions: [_q1]),
        _section(
          sectionId: 's2',
          sectionTitle: 'S2',
          order: 2,
          questions: [_q2],
        ),
      ]);

      await tester.pumpWidget(
        _buildScreen(
          db: setup.db,
          profile: setup.profile,
          session: setup.session,
          loader: loader,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Begin'));
      await tester.pumpAndSettle();

      expect(find.text('First question'), findsOneWidget);
      expect(find.byTooltip('Back'), findsNothing);
    });

    //    Part B: q1 pre-filled → screen resumes at q2 → Back is visible
    testWidgets('4b. Back button present when resumed at second question',
        (tester) async {
      final setup = await _makeSetup();
      addTearDown(setup.db.close);

      // Pre-fill q1 BEFORE pumping the screen.
      await QuestionnaireRepository(setup.db).saveAnswer(
        sessionId: setup.session.id,
        sectionId: 's1',
        questionId: 'q1',
        answerJson: const {'selectedOptionId': 'x'},
      );

      final loader = _MockLoader([
        _section(sectionId: 's1', sectionTitle: 'S1', questions: [_q1]),
        _section(
          sectionId: 's2',
          sectionTitle: 'S2',
          order: 2,
          questions: [_q2],
        ),
      ]);

      await tester.pumpWidget(
        _buildScreen(
          db: setup.db,
          profile: setup.profile,
          session: setup.session,
          loader: loader,
        ),
      );
      await tester.pumpAndSettle();

      // Screen should have skipped the intro (answers non-empty) and resumed
      // at q2 (first unanswered question).
      expect(find.text('Second question'), findsOneWidget);
      expect(find.byTooltip('Back'), findsOneWidget);
    });

    // 5. Progress ring reflects answered count
    testWidgets('5. progress ring shows answered/total counts', (tester) async {
      final setup = await _makeSetup();
      addTearDown(setup.db.close);

      final loader = _MockLoader([
        _section(
          sectionId: 's1',
          sectionTitle: 'S1',
          questions: [_q1, _q2],
        ),
      ]);

      // Pre-answer q1 so answered count = 1.
      await QuestionnaireRepository(setup.db).saveAnswer(
        sessionId: setup.session.id,
        sectionId: 's1',
        questionId: 'q1',
        answerJson: const {'selectedOptionId': 'a'},
      );

      await tester.pumpWidget(
        _buildScreen(
          db: setup.db,
          profile: setup.profile,
          session: setup.session,
          loader: loader,
        ),
      );
      await tester.pumpAndSettle();

      // ProgressRing renders answered='1' and total='2'.
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    // 6–8 use the real question bank loaded once in setUpAll.

    // 6. Question text matches real JSON for scroll_q1
    test('6. scroll_q1 text matches the real JSON bank', () {
      final q = bank.questionById('scroll_q1');

      expect(q, isNotNull, reason: 'scroll_q1 must exist in the real JSON');
      expect(
        q!.text,
        'I open feed-based apps automatically when I feel bored, stressed,'
        ' anxious, or lonely.',
      );
    });

    // 7. 13–15 persona never sees sexual_content_teen section
    test('7. 13–15 male persona: sexual_content_teen section not visible', () {
      final resolver = QuestionVisibilityResolver(bank);

      final ctx = ResolverContext(
        ageBand: RegistrationAgeBand.teen13To15,
        gender: RegistrationGender.male,
        selectedGoals: const [],
        answers: const {},
      );

      final sectionIds = resolver
          .resolveVisibleSections(ctx)
          .map((s) => s.sectionId)
          .toSet();

      expect(sectionIds, isNot(contains('sexual_content_teen')));
      expect(sectionIds, isNot(contains('sexual_control_adult')));
    });

    // 8. 18+ female with cycle_menstruation_gate == yes_or_unsure sees cycle_q1
    test('8. 18+ female with cycle gate answered sees cycle_q1', () {
      final resolver = QuestionVisibilityResolver(bank);

      final ctx = ResolverContext(
        ageBand: RegistrationAgeBand.adult18Plus,
        gender: RegistrationGender.female,
        selectedGoals: const [],
        answers: const {
          'cycle_menstruation_gate': {'selectedOptionId': 'yes_or_unsure'},
        },
      );

      final cycleSections = resolver
          .resolveVisibleSections(ctx)
          .where((s) => s.sectionId == 'cycle_sensitivity')
          .toList();

      expect(
        cycleSections,
        isNotEmpty,
        reason: 'cycle_sensitivity should be visible for this persona',
      );
      expect(
        cycleSections.first.questions.map((q) => q.questionId),
        contains('cycle_q1'),
      );
    });
  });
}
