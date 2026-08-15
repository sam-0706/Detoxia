import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/support_profile_repository.dart';
import 'package:detoxia/data/repositories/user_repository.dart';
import 'package:detoxia/domain/entities/user_profile.dart';
import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/presentation/home/home_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomeScreen does not render legacy module cards', (tester) async {
    final setup = await _setup();
    addTearDown(setup.db.close);
    await SupportProfileRepository(
      setup.db,
    ).saveProfile(_supportProfile(setup.registration.id));

    await tester.pumpWidget(_home(setup.db));
    await _pumpHome(tester);

    // Legacy module cards must not appear
    for (final label in [
      'Anxiety Home',
      'Open Anxiety',
      'ADHD Home',
      'Open ADHD',
      'Depression Home',
      'Mood Home',
      'Period Home',
      'Your Modules',
    ]) {
      expect(find.text(label), findsNothing, reason: label);
    }

    // New bottom nav shows Map tab (not old secondary chip)
    expect(find.text('Map'), findsOneWidget);

    // Trigger chain renders with profile data
    await _scrollToText(tester, 'Your trigger chain');
    expect(find.text('Your trigger chain'), findsOneWidget);
  });
}

Future<({AppDatabase db, RegistrationProfile registration})> _setup() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await UserRepository(db).saveUser(_userProfile());
  final registration = await RegistrationRepository(db).saveLocalProfile(
    const SignupProfileInput(
      displayName: 'Sam',
      email: 'sam@example.com',
      phone: '+15555550100',
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.male,
      countryCode: 'US',
      regionName: 'CA',
      timezone: 'UTC',
      privacyAcknowledged: true,
      marketingConsent: false,
    ),
  );
  return (db: db, registration: registration);
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

SupportProfile _supportProfile(int registrationProfileId) {
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
        confidence: 1,
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
        confidence: 1,
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
      predictionAccuracy: 5,
      falseAlarmRate: 0,
      triggerReliabilityMap: const {},
      interventionRewardsMap: const {},
      lastUpdatedAt: now,
    ),
    createdAt: now,
    updatedAt: now,
  );
}
