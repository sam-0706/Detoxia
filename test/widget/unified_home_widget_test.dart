import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/event_repository.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/support_profile_repository.dart';
import 'package:detoxia/data/repositories/user_repository.dart';
import 'package:detoxia/domain/entities/user_profile.dart';
import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/routine/models/menstrual_phase.dart';
import 'package:detoxia/domain/routine/models/menstrual_profile.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/presentation/home/home_screen.dart';
import 'package:detoxia/presentation/questionnaire/support_map_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('1. trigger chain preview shows pathway insight', (
    tester,
  ) async {
    final setup = await _setup();
    addTearDown(setup.db.close);
    await _saveSupportProfile(setup.db, setup.registration.id);

    await tester.pumpWidget(_home(setup.db));
    await _pumpHome(tester);
    await _scrollToText(tester, 'Your trigger chain');

    expect(find.text('Your trigger chain'), findsOneWidget);
    expect(
      find.textContaining('stress'),
      findsWidgets,
    );
    expect(
      find.textContaining('anxiety'),
      findsWidgets,
    );
  });

  testWidgets('2. trigger chain shows strongest driver pattern', (tester) async {
    final setup = await _setup();
    addTearDown(setup.db.close);
    await _saveSupportProfile(setup.db, setup.registration.id);

    await tester.pumpWidget(_home(setup.db));
    await _pumpHome(tester);
    await _scrollToText(tester, 'Your trigger chain');

    expect(
      find.textContaining('stress → anxiety'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Recognising the chain'),
      findsOneWidget,
    );
  });

  testWidgets('3. recovery momentum card displays momentum value', (
    tester,
  ) async {
    final setup = await _setup();
    addTearDown(setup.db.close);
    await _saveSupportProfile(setup.db, setup.registration.id);

    await tester.pumpWidget(_home(setup.db));
    await _pumpHome(tester);
    await _scrollToText(tester, 'Recovery Momentum');

    expect(find.text('Recovery Momentum'), findsOneWidget);
    expect(find.text('6.8/10'), findsOneWidget);
    expect(
      find.text("Today's outcomes will adjust this."),
      findsOneWidget,
    );
  });

  testWidgets('4. luteal cycle context note appears for eligible female', (
    tester,
  ) async {
    final setup = await _setup(gender: RegistrationGender.female);
    addTearDown(setup.db.close);
    await _saveSupportProfile(
      setup.db,
      setup.registration.id,
      menstrualProfile: _menstrualProfile(MenstrualPhase.luteal),
    );

    await tester.pumpWidget(_home(setup.db));
    await _pumpHome(tester);
    await _scrollToText(tester, 'Luteal phase may be increasing');

    expect(
      find.text('Luteal phase may be increasing sleep/mood sensitivity today.'),
      findsOneWidget,
    );
  });

  testWidgets('5. male persona does not show cycle context note', (
    tester,
  ) async {
    final setup = await _setup(gender: RegistrationGender.male);
    addTearDown(setup.db.close);
    await _saveSupportProfile(setup.db, setup.registration.id);

    await tester.pumpWidget(_home(setup.db));
    await _pumpHome(tester);

    expect(find.textContaining('phase may be increasing'), findsNothing);
    expect(find.textContaining('Menstruation phase'), findsNothing);
  });

  testWidgets('6. no legacy module card labels appear', (tester) async {
    final setup = await _setup();
    addTearDown(setup.db.close);
    await _saveSupportProfile(setup.db, setup.registration.id);

    await tester.pumpWidget(_home(setup.db));
    await _pumpHome(tester);

    expect(find.text('Condition Select'), findsNothing);
    expect(find.text('Period Tracker'), findsNothing);
    expect(find.text('Depression'), findsNothing);
    expect(find.text('ADHD'), findsNothing);
    expect(find.text('Mood Tracker'), findsNothing);
  });

  testWidgets('7. fallback placeholders render with no support profile', (
    tester,
  ) async {
    final setup = await _setup();
    addTearDown(setup.db.close);

    await tester.pumpWidget(_home(setup.db));
    await _pumpHome(tester);

    // Current state card shows not-checked-in
    expect(find.text('Not checked in yet'), findsOneWidget);

    // Reset Plan title is visible (fallback tasks from DailyTaskScheduler).
    // Sits below the fold now that the live "right now" card leads the
    // dashboard, so scroll to it first.
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -320));
    await tester.pumpAndSettle();
    expect(find.text("Today's Reset Plan"), findsOneWidget);

    // Map tab visible in bottom nav (not secondary chip)
    expect(find.text('Map'), findsOneWidget);
  });

  testWidgets('8. shows clear Daily Check-in state button', (tester) async {
    final setup = await _setup();
    addTearDown(setup.db.close);
    await _saveSupportProfile(setup.db, setup.registration.id);

    await tester.pumpWidget(_home(setup.db));
    await _pumpHome(tester);

    expect(find.text('Daily Check-in'), findsOneWidget);
    expect(find.byIcon(Icons.nightlight_round), findsWidgets);
  });

  testWidgets('9. checked-in state shows "Check-in Done"', (tester) async {
    final setup = await _setup();
    addTearDown(setup.db.close);
    await _saveSupportProfile(setup.db, setup.registration.id);
    await EventRepository(setup.db).insertCheckin(
      date: DateTime.now(),
      hadUrge: false,
      slipped: false,
      sleepQuality: 4,
      mood: 4,
      stress: 3,
      confidenceTomorrow: 4,
      notes: '{"source":"test"}',
    );

    await tester.pumpWidget(_home(setup.db));
    await _pumpHome(tester);

    expect(find.text('Check-in Done'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsWidgets);
  });

  testWidgets('10. Reset CTA replaces old Report label', (tester) async {
    final setup = await _setup();
    addTearDown(setup.db.close);
    await _saveSupportProfile(setup.db, setup.registration.id);

    await tester.pumpWidget(_home(setup.db));
    await _pumpHome(tester);

    expect(find.text('Report'), findsNothing);
    expect(find.text('Help me through this rough window'), findsOneWidget);
  });

  testWidgets('11. Map bottom nav navigates to Support Map screen', (tester) async {
    final setup = await _setup();
    addTearDown(setup.db.close);
    await _saveSupportProfile(setup.db, setup.registration.id);

    await tester.pumpWidget(_home(setup.db));
    await _pumpHome(tester);
    await tester.tap(find.text('Map'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(SupportMapScreen), findsOneWidget);
  });

  testWidgets('12. trigger chain includes pattern explanation', (tester) async {
    final setup = await _setup();
    addTearDown(setup.db.close);
    await _saveSupportProfile(setup.db, setup.registration.id);
    await _seedCheckins(setup.db);

    await tester.pumpWidget(_home(setup.db));
    await _pumpHome(tester);
    await _scrollToText(tester, 'Your trigger chain');

    expect(find.textContaining('→'), findsOneWidget);
    expect(
      find.textContaining('Recognising the chain'),
      findsOneWidget,
    );
  });
}

Future<({AppDatabase db, RegistrationProfile registration})> _setup({
  RegistrationGender gender = RegistrationGender.male,
}) async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await UserRepository(db).saveUser(_userProfile());
  final registration = await RegistrationRepository(db).saveLocalProfile(
    SignupProfileInput(
      displayName: 'Sam',
      email: 'sam@example.com',
      phone: '+15555550100',
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: gender,
      countryCode: 'US',
      regionName: 'CA',
      timezone: 'UTC',
      privacyAcknowledged: true,
      marketingConsent: false,
    ),
  );
  await QuestionnaireRepository(db).ensureSession(registration.id);
  return (db: db, registration: registration);
}

Future<void> _seedCheckins(AppDatabase db) async {
  final repo = EventRepository(db);
  final now = DateTime.now();
  for (var i = 1; i <= 3; i++) {
    await repo.insertCheckin(
      date: now.subtract(Duration(days: i)),
      hadUrge: i.isEven,
      slipped: false,
      sleepQuality: 3,
      mood: 3,
      stress: 4,
      confidenceTomorrow: 3,
      notes: '{"source":"test"}',
    );
  }
}

Widget _home(AppDatabase db) {
  return ProviderScope(
    overrides: [databaseProvider.overrideWithValue(db)],
    child: MaterialApp(theme: AppTheme.darkTheme, home: const HomeScreen()),
  );
}

Future<void> _pumpHome(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (find.textContaining('Good ').evaluate().isNotEmpty) {
      return;
    }
  }
  fail('HomeScreen did not load.');
}

Future<void> _scrollToText(WidgetTester tester, String text) async {
  await tester.scrollUntilVisible(
    find.textContaining(text),
    180,
    scrollable: find.byType(Scrollable).first,
    maxScrolls: 20,
  );
  await tester.pump();
}

Future<void> _scrollToExactText(WidgetTester tester, String text) async {
  await tester.scrollUntilVisible(
    find.text(text),
    180,
    scrollable: find.byType(Scrollable).first,
    maxScrolls: 20,
  );
  await tester.pump();
}

Future<void> _saveSupportProfile(
  AppDatabase db,
  int registrationProfileId, {
  MenstrualProfile? menstrualProfile,
}) async {
  await SupportProfileRepository(db).saveProfile(
    _supportProfile(
      registrationProfileId: registrationProfileId,
      menstrualProfile: menstrualProfile,
    ),
  );
}

UserProfile _userProfile() {
  return const UserProfile(
    name: 'Sam',
    email: 'sam@example.com',
    phone: '+15555550100',
    country: 'US',
    roleType: RoleType.working,
    workDays: [1, 2, 3, 4, 5],
    workStart: TimeOfDay(hour: 9, minute: 0),
    workEnd: TimeOfDay(hour: 17, minute: 0),
    weekdayWakeTime: TimeOfDay(hour: 7, minute: 0),
    weekdaySleepTime: TimeOfDay(hour: 23, minute: 0),
    offdayWakeTime: TimeOfDay(hour: 8, minute: 0),
    offdaySleepTime: TimeOfDay(hour: 23, minute: 30),
    struggles: [BehaviorType.scrolling],
    triggers: [TriggerType.stress, TriggerType.boredom],
    conditions: [ConditionType.detoxRecovery],
  );
}

SupportProfile _supportProfile({
  required int registrationProfileId,
  MenstrualProfile? menstrualProfile,
}) {
  final now = DateTime(2026, 5, 19);
  return SupportProfile(
    registrationProfileId: registrationProfileId,
    selectedGoals: const ['goal_scrolling', 'goal_anxiety'],
    domainScores: const [
      DomainScore(
        id: 'scrollingControl',
        label: 'Scrolling Control',
        rawScore: 13,
        maxRawScore: 15,
        visibleScore: 8.8,
        band: 'High',
        enabled: true,
        confidence: 1.0,
        explanation: 'High scrolling support need.',
      ),
      DomainScore(
        id: 'anxietyLoad',
        label: 'Anxiety Load',
        rawScore: 10,
        maxRawScore: 12,
        visibleScore: 8.1,
        band: 'High',
        enabled: true,
        confidence: 1.0,
        explanation: 'High anxiety support need.',
      ),
      DomainScore(
        id: 'sleepDisruption',
        label: 'Sleep Disruption',
        rawScore: 8,
        maxRawScore: 15,
        visibleScore: 5.3,
        band: 'Moderate',
        enabled: true,
        confidence: 0.8,
        explanation: 'Sleep support need.',
      ),
      DomainScore(
        id: 'cycleSensitivity',
        label: 'Cycle Sensitivity',
        rawScore: 0,
        maxRawScore: 21,
        visibleScore: 0,
        band: 'Low',
        enabled: false,
        confidence: 0,
        explanation: 'Disabled for this persona.',
      ),
    ],
    routineProfile: const RoutineProfile(
      wakeWindow: '7-8 AM',
      sleepAttemptWindow: '11 PM-12 AM',
      sleepLatencyRange: '15-30 min',
      commutePhoneUseScore: 2,
      freeWindows: ['Evening'],
      aloneWindows: ['Late night'],
      phoneInBedScore: 2,
      vulnerableWindows: ['After work'],
    ),
    sleepProfile: const SleepProfile(
      sleepAttemptWindow: '11 PM-12 AM',
      wakeWindow: '7-8 AM',
      sleepLatencyRange: '15-30 min',
      estimatedSleepStartMinutes: 1410,
      estimatedWakeTimeMinutes: 420,
      estimatedSleepDurationHours: 7,
      targetSleepHours: 8,
      dailySleepDebtHours: 1,
      estimatedSevenDaySleepDebtHours: 7,
      sleepDebtScore: 5,
      sleepDisruptionScore: 5.3,
      sleepRiskScore: 5.2,
      confidence: 0.7,
    ),
    menstrualProfile: menstrualProfile,
    triggerWeights: [
      TriggerWeight(
        triggerId: 'trig_stress',
        label: 'Stress',
        strengthRaw: 3,
        weight0To10: 9.5,
        reliability: 0.8,
        lastUpdatedAt: now,
      ),
      TriggerWeight(
        triggerId: 'trig_anxiety',
        label: 'Anxiety',
        strengthRaw: 3,
        weight0To10: 8.8,
        reliability: 0.8,
        lastUpdatedAt: now,
      ),
      TriggerWeight(
        triggerId: 'trig_boredom',
        label: 'Boredom',
        strengthRaw: 2,
        weight0To10: 6,
        reliability: 0.7,
        lastUpdatedAt: now,
      ),
    ],
    pathwayScores: const [
      PathwayScore(
        pathwayId: 'scrollingControlPathway',
        label: 'Scrolling pathway',
        mainProblemScore: 8.8,
        modifierScore: 8.1,
        routineRisk: 5,
        triggerWeight: 9.5,
        score0To10: 8.4,
        enabled: true,
        explanation: 'Scrolling + anxiety + stress.',
      ),
    ],
    interventionPreferences: const InterventionPreferences(
      physicalReset: true,
      breathingGrounding: true,
      appFrictionDelay: false,
      journalingThoughtDump: true,
      focusSprint: false,
      sleepShutdown: true,
      spiritualValuesReset: false,
      lowPressureTask: true,
      directnessLevel: 'balanced',
    ),
    learningState: LearningState(
      recoveryMomentum: 6.8,
      predictionAccuracy: 5.0,
      falseAlarmRate: 0.0,
      triggerReliabilityMap: const {},
      interventionRewardsMap: const {},
      lastUpdatedAt: now,
    ),
    createdAt: now,
    updatedAt: now,
  );
}

MenstrualProfile _menstrualProfile(MenstrualPhase phase) {
  return MenstrualProfile(
    enabled: true,
    lastPeriodStartDate: DateTime(2026, 5, 1),
    averageCycleLength: 28,
    averageBleedingLength: 5,
    regularity: 'regular',
    currentCycleDay: 20,
    currentPhase: phase,
    nextPeriodEstimate: DateTime(2026, 5, 29),
    confidence: 0.8,
    cycleSensitivityScore: 7.0,
  );
}
