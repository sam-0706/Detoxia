import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/support_profile_repository.dart';
import 'package:detoxia/domain/questionnaire/detoxia_question_bank.dart';
import 'package:detoxia/presentation/home/home_screen.dart';
import 'package:detoxia/presentation/questionnaire/support_map_screen.dart';
import 'package:detoxia/presentation/questionnaire/widgets/score_card.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DetoxiaQuestionBank bank;

  setUpAll(() async {
    bank = await DetoxiaQuestionBank.loadFromAssets();
  });

  testWidgets(
    '1. 18+ male renders the right number of ScoreCards and saves profile',
    (tester) async {
      final setup = await _setup(
        ageBand: RegistrationAgeBand.adult18Plus,
        gender: RegistrationGender.male,
      );
      addTearDown(setup.db.close);
      await _saveAnswers(setup.db, setup.session.id, _answers());

      await tester.pumpWidget(_screen(setup, bank));
      await _pumpLoaded(tester);

      expect(find.byType(ScoreCard), findsNWidgets(3));
      expect(find.text('Sexual Control Recovery'), findsOneWidget);

      final saved = await SupportProfileRepository(
        setup.db,
      ).getLatestProfile(setup.profile.id);
      expect(saved, isNotNull);
      final session = await QuestionnaireRepository(
        setup.db,
      ).getActiveSession();
      expect(session?.isCompleted, isTrue);
    },
  );

  testWidgets('2. 13–15 male hides sexual and cycle cards', (tester) async {
    final setup = await _setup(
      ageBand: RegistrationAgeBand.teen13To15,
      gender: RegistrationGender.male,
    );
    addTearDown(setup.db.close);
    await _saveAnswers(setup.db, setup.session.id, _answers());

    await tester.pumpWidget(_screen(setup, bank));
    await _pumpLoaded(tester);

    expect(find.text('Sexual Content Control'), findsNothing);
    expect(find.text('Sexual Control Recovery'), findsNothing);
    expect(find.text('Cycle Sensitivity'), findsNothing);
  });

  testWidgets('3. 18+ female with cycle answers renders support map', (
    tester,
  ) async {
    final setup = await _setup(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.female,
    );
    addTearDown(setup.db.close);
    await _saveAnswers(
      setup.db,
      setup.session.id,
      _answers(includeCycle: true),
    );

    await tester.pumpWidget(_screen(setup, bank));
    await _pumpLoaded(tester);

    expect(find.text('Your Support Map'), findsOneWidget);
    expect(find.byType(ScoreCard), findsNWidgets(3));
    // Cycle data is included in the profile; verify it loaded correctly
    final saved = await SupportProfileRepository(
      setup.db,
    ).getLatestProfile(setup.profile.id);
    expect(saved?.menstrualProfile, isNotNull);
    expect(saved?.scoreFor('cycleSensitivity')?.enabled, isTrue);
  });

  testWidgets('4. No combined overall score is shown', (tester) async {
    final setup = await _setup(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
    );
    addTearDown(setup.db.close);
    await _saveAnswers(setup.db, setup.session.id, _answers());

    await tester.pumpWidget(_screen(setup, bank));
    await _pumpLoaded(tester);

    expect(
      find.textContaining('overall score', findRichText: true),
      findsNothing,
    );
  });

  testWidgets('5. Start my plan navigates to HomeScreen', (tester) async {
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final setup = await _setup(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
    );
    addTearDown(setup.db.close);
    await _saveAnswers(setup.db, setup.session.id, _answers());

    await tester.pumpWidget(_screen(setup, bank));
    await _pumpLoaded(tester);

    final cta = find.widgetWithText(ElevatedButton, "Start today's reset plan");
    final button = tester.widget<ElevatedButton>(cta);
    button.onPressed?.call();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}

Future<void> _pumpLoaded(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (find.text('Your Support Map').evaluate().isNotEmpty) {
      return;
    }
    if (find.text('Support map could not load.').evaluate().isNotEmpty) {
      final texts = tester
          .widgetList<Text>(find.byType(Text))
          .map((text) => text.data ?? text.textSpan?.toPlainText() ?? '')
          .where((text) => text.isNotEmpty)
          .join(' | ');
      fail('Support map failed to load: $texts');
    }
  }
  final texts = tester
      .widgetList<Text>(find.byType(Text))
      .map((text) => text.data ?? text.textSpan?.toPlainText() ?? '')
      .where((text) => text.isNotEmpty)
      .join(' | ');
  fail('Support map did not load. Texts: $texts');
}

Future<
  ({AppDatabase db, RegistrationProfile profile, QuestionnaireSession session})
>
_setup({
  required RegistrationAgeBand ageBand,
  required RegistrationGender gender,
}) async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  final profile = await RegistrationRepository(db).saveLocalProfile(
    SignupProfileInput(
      displayName: 'Test',
      email: 'test@example.com',
      phone: '+15555550100',
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

Widget _screen(
  ({AppDatabase db, RegistrationProfile profile, QuestionnaireSession session})
  setup,
  DetoxiaQuestionBank bank,
) {
  return ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(setup.db),
      supportMapQuestionBankProvider.overrideWithValue(() async => bank),
    ],
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: SupportMapScreen(
        profileId: setup.profile.id,
        sessionId: setup.session.id,
      ),
    ),
  );
}

Future<void> _saveAnswers(
  AppDatabase db,
  int sessionId,
  Map<String, Map<String, dynamic>> answers,
) async {
  final repo = QuestionnaireRepository(db);
  for (final entry in answers.entries) {
    await repo.saveAnswer(
      sessionId: sessionId,
      sectionId: _sectionFor(entry.key),
      questionId: entry.key,
      answerJson: entry.value,
    );
  }
}

Map<String, Map<String, dynamic>> _answers({bool includeCycle = false}) {
  final answers = <String, Map<String, dynamic>>{
    'goal_q1': {
      'selectedOptionIds': ['goal_scrolling', 'goal_focus', 'goal_sleep'],
    },
    'routine_wake': {'selectedOptionId': 'wake_6_7', 'midpointMinutes': 390},
    'routine_sleep_attempt': {
      'selectedOptionId': 'sleep_11_12am',
      'midpointMinutes': 1410,
    },
    'routine_sleep_latency': {
      'selectedOptionId': 'latency_15_30',
      'midpointDurationMinutes': 22,
    },
    'routine_free_windows': {
      'selectedOptionIds': ['free_after_school_work', 'free_late_night'],
    },
    'routine_alone_windows': {
      'selectedOptionIds': ['alone_evening', 'alone_late_night'],
    },
    'routine_phone_in_bed': {'numericValue': 2},
    'routine_commute_phone': {'numericValue': 2},
    'trig_select': {
      'selectedOptionIds': ['trig_stress', 'trig_late_night_phone'],
    },
    'trig_strength_trig_stress': {'numericValue': 3},
    'intv_select': {
      'selectedOptionIds': ['intv_physical', 'intv_sleep_shutdown'],
    },
    'intv_directness': {'selectedOptionId': 'dir_balanced'},
    for (final id in [
      'scroll_q1',
      'scroll_q2',
      'scroll_q3',
      'scroll_q4',
      'scroll_q5',
      'sxadult_q1',
      'sxadult_q2',
      'sxadult_q3',
      'sxadult_q4',
      'sxadult_q5',
      'focus_q1',
      'focus_q2',
      'focus_q3',
      'focus_q4',
      'focus_q5',
      'focus_q6',
      'anx_q1',
      'anx_q2',
      'anx_q3',
      'anx_q4',
      'mood_q1',
      'mood_q2',
      'mood_q3',
      'mood_q4',
      'sleep_q1',
      'sleep_q2',
      'sleep_q3',
      'sleep_q4',
      'sleep_q5',
    ])
      id: {'numericValue': 2},
  };

  if (includeCycle) {
    answers.addAll({
      'cycle_menstruation_gate': {'selectedOptionId': 'yes_or_unsure'},
      for (final id in [
        'cycle_q1',
        'cycle_q2',
        'cycle_q3',
        'cycle_q4',
        'cycle_q5',
        'cycle_q6',
        'cycle_q7',
      ])
        id: {'numericValue': 2},
      'mens_last_period_start': {
        'date': DateTime(2026, 5, 1).toIso8601String(),
      },
      'mens_avg_cycle_length': {'selectedOptionId': 'cyc_25_28'},
      'mens_avg_bleeding_length': {'selectedOptionId': 'bld_4_5'},
      'mens_regularity': {'selectedOptionId': 'reg_regular'},
    });
  }

  return answers;
}

String _sectionFor(String questionId) {
  if (questionId.startsWith('routine_')) return 'routine_map';
  if (questionId.startsWith('scroll_')) return 'scrolling_control';
  if (questionId.startsWith('sxadult_')) return 'sexual_control_adult';
  if (questionId.startsWith('focus_')) return 'focus_support';
  if (questionId.startsWith('anx_')) return 'anxiety_load';
  if (questionId.startsWith('mood_')) return 'low_mood_support';
  if (questionId.startsWith('sleep_')) return 'sleep_disruption';
  if (questionId.startsWith('cycle_')) return 'cycle_sensitivity';
  if (questionId.startsWith('mens_')) return 'menstrual_phase';
  if (questionId.startsWith('trig_')) return 'trigger_inventory';
  if (questionId.startsWith('intv_')) return 'intervention_preference';
  return 'goal_selection';
}
