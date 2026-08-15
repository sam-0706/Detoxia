import 'dart:convert';

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/event_repository.dart';
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
import 'package:detoxia/presentation/daily_checkin/checkin_screen.dart';
import 'package:detoxia/services/notification_service.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('1. cycle disabled hides cycle symptom picker', (tester) async {
    final setup = await _setup(cycleEnabled: false);
    addTearDown(setup.db.close);

    await tester.pumpWidget(_screen(setup.db, setup.eventRepository));
    await _pumpLoaded(tester);

    expect(find.text('Stress today'), findsOneWidget);
    expect(find.text('Cycle context today'), findsNothing);
  });

  testWidgets('2. cycle enabled shows cycle symptom picker', (tester) async {
    final setup = await _setup(cycleEnabled: true);
    addTearDown(setup.db.close);

    await tester.pumpWidget(_screen(setup.db, setup.eventRepository));
    await _pumpLoaded(tester);

    expect(find.text('Cycle context today'), findsOneWidget);
    expect(find.text('Cramps / pain'), findsOneWidget);
  });

  testWidgets('3. submitting saves unified check-in fields in notes', (
    tester,
  ) async {
    final setup = await _setup(cycleEnabled: true);
    addTearDown(setup.db.close);

    await tester.pumpWidget(_screen(setup.db, setup.eventRepository));
    await _pumpLoaded(tester);

    await tester.ensureVisible(find.text('Did you feel a strong urge today?'));
    await tester.tap(find.byType(Switch));
    await tester.ensureVisible(find.text('Fatigue'));
    await tester.tap(find.text('Fatigue'));
    await tester.ensureVisible(find.text('Complete Check-in'));
    await tester.tap(find.text('Complete Check-in'));
    await tester.pump();

    expect(setup.eventRepository.calls.length, 1);
    final call = setup.eventRepository.calls.single;
    expect(call['sleepQuality'], 5);
    expect(call['mood'], 5);
    expect(call['stress'], 5);
    expect(call['confidenceTomorrow'], 5);
    expect(call['hadUrge'], isTrue);

    final notes = jsonDecode(call['notes'] as String) as Map<String, dynamic>;
    expect(notes['anxiety'], 5);
    expect(notes['energy'], 5);
    expect(notes['strongUrgeToday'], isTrue);
    expect(notes['cycleSymptoms'], contains('fatigue'));
  });

  testWidgets('4. already done branch blocks duplicate submission', (
    tester,
  ) async {
    final setup = await _setup(cycleEnabled: false);
    addTearDown(setup.db.close);
    await UserRepository(setup.db).markCheckedIn(true);

    await tester.pumpWidget(_screen(setup.db, setup.eventRepository));
    await _pumpLoaded(tester, text: 'Check-in already done');

    expect(find.text('Check-in already done'), findsOneWidget);
    expect(find.text('Complete Check-in'), findsNothing);
    expect(setup.eventRepository.calls, isEmpty);
  });
}

Future<({AppDatabase db, _RecordingEventRepository eventRepository})> _setup({
  required bool cycleEnabled,
}) async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await UserRepository(db).saveUser(_userProfile());

  final registration = await RegistrationRepository(db).saveLocalProfile(
    const SignupProfileInput(
      displayName: 'Sam',
      email: 'sam@example.com',
      phone: '+15555550100',
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.female,
      countryCode: 'US',
      regionName: 'CA',
      timezone: 'UTC',
      privacyAcknowledged: true,
      marketingConsent: false,
    ),
  );

  await SupportProfileRepository(db).saveProfile(
    _supportProfile(
      registrationProfileId: registration.id,
      cycleEnabled: cycleEnabled,
    ),
  );

  return (db: db, eventRepository: _RecordingEventRepository(db));
}

Widget _screen(AppDatabase db, _RecordingEventRepository eventRepository) {
  return ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      eventRepositoryProvider.overrideWithValue(eventRepository),
      notificationServiceProvider.overrideWithValue(_NoopNotificationService()),
    ],
    child: MaterialApp(theme: AppTheme.darkTheme, home: const CheckinScreen()),
  );
}

Future<void> _pumpLoaded(
  WidgetTester tester, {
  String text = 'How was today?',
}) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (find.text(text).evaluate().isNotEmpty) return;
  }
  fail('CheckinScreen did not load "$text".');
}

class _RecordingEventRepository extends EventRepository {
  final List<Map<String, dynamic>> calls = [];

  _RecordingEventRepository(super.db);

  @override
  Future<int> insertCheckin({
    required DateTime date,
    required bool hadUrge,
    int? urgeMax,
    TriggerType? mainTrigger,
    required bool slipped,
    int slipCount = 0,
    required int sleepQuality,
    required int mood,
    required int stress,
    required int confidenceTomorrow,
    String? notes,
  }) async {
    calls.add({
      'date': date,
      'hadUrge': hadUrge,
      'urgeMax': urgeMax,
      'mainTrigger': mainTrigger,
      'slipped': slipped,
      'slipCount': slipCount,
      'sleepQuality': sleepQuality,
      'mood': mood,
      'stress': stress,
      'confidenceTomorrow': confidenceTomorrow,
      'notes': notes,
    });
    return calls.length;
  }
}

class _NoopNotificationService extends NotificationService {
  @override
  Future<void> cancelCheckinReminders() async {}
}

UserProfile _userProfile() {
  return const UserProfile(
    name: 'Sam',
    email: 'sam@example.com',
    phone: '+15555550100',
    country: 'US',
    roleType: RoleType.working,
    weekdayWakeTime: TimeOfDay(hour: 7, minute: 0),
    weekdaySleepTime: TimeOfDay(hour: 23, minute: 0),
    offdayWakeTime: TimeOfDay(hour: 8, minute: 0),
    offdaySleepTime: TimeOfDay(hour: 23, minute: 30),
    conditions: [ConditionType.detoxRecovery],
  );
}

SupportProfile _supportProfile({
  required int registrationProfileId,
  required bool cycleEnabled,
}) {
  final now = DateTime(2026, 5, 19);
  return SupportProfile(
    registrationProfileId: registrationProfileId,
    selectedGoals: const [],
    domainScores: const [
      DomainScore(
        id: 'cycleSensitivity',
        label: 'Cycle Sensitivity',
        rawScore: 5,
        maxRawScore: 10,
        visibleScore: 5,
        band: 'Mild',
        enabled: true,
        confidence: 1,
        explanation: 'test',
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
      sleepDisruptionScore: 5,
      sleepRiskScore: 5,
      confidence: 0.7,
    ),
    menstrualProfile: MenstrualProfile(
      enabled: cycleEnabled,
      lastPeriodStartDate: DateTime(2026, 5),
      averageCycleLength: 28,
      averageBleedingLength: 5,
      currentCycleDay: 19,
      currentPhase: MenstrualPhase.luteal,
      nextPeriodEstimate: DateTime(2026, 5, 29),
      confidence: 0.8,
      cycleSensitivityScore: 5,
    ),
    triggerWeights: [
      TriggerWeight(
        triggerId: 'stress',
        label: 'Stress',
        strengthRaw: 2,
        weight0To10: 5,
        reliability: 0.5,
        lastUpdatedAt: now,
      ),
    ],
    pathwayScores: const [
      PathwayScore(
        pathwayId: 'scrolling',
        label: 'Scrolling',
        mainProblemScore: 5,
        modifierScore: 5,
        routineRisk: 5,
        triggerWeight: 5,
        score0To10: 5,
        enabled: true,
        explanation: 'test',
      ),
    ],
    interventionPreferences: const InterventionPreferences(
      physicalReset: true,
      breathingGrounding: true,
      appFrictionDelay: true,
      journalingThoughtDump: true,
      focusSprint: true,
      sleepShutdown: true,
      spiritualValuesReset: true,
      lowPressureTask: true,
      directnessLevel: 'balanced',
    ),
    learningState: LearningState(
      recoveryMomentum: 5,
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
