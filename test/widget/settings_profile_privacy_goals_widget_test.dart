import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/presentation/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('settings renders required sections and controls', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(
            registrationProfileOverride: _registration(),
            supportProfileOverride: _supportProfile(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsWidgets);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Update goals'), findsOneWidget);
    expect(find.text('Retake questionnaire'), findsOneWidget);
    // Sits below the fold now that Appearance is in the list.
    await tester.drag(
      find.byType(Scrollable).first,
      const Offset(0, -260),
    );
    await tester.pumpAndSettle();
    expect(find.text('Notifications'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('Quiet hours'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Quiet hours'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Privacy & Local Data'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Privacy & Local Data'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Delete local data'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Delete local data'), findsOneWidget);
    expect(find.text('Reset learning engine'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('Detoxia v1.0.0'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Detoxia v1.0.0'), findsOneWidget);
  });

  testWidgets('privacy explanation is visible', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(
            registrationProfileOverride: _registration(),
            supportProfileOverride: _supportProfile(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.textContaining('Sensitive wellness data stays local on this device.'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Sensitive wellness data stays local on this device.'),
      findsOneWidget,
    );
  });

  testWidgets('delete and reset actions require confirmation', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(
            registrationProfileOverride: _registration(),
            supportProfileOverride: _supportProfile(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Delete local data'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete local data'));
    await tester.pumpAndSettle();
    expect(find.text('Delete local data?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reset learning engine'));
    await tester.pumpAndSettle();
    expect(find.text('Reset learning engine?'), findsOneWidget);
  });
}

RegistrationProfile _registration() {
  final now = DateTime(2026, 1, 1);
  return RegistrationProfile(
    id: 1,
    appInstallId: 'install-1',
    displayName: 'Sam',
    email: 'sam@example.com',
    phone: '+1555000111',
    ageBand: 'adult',
    gender: 'male',
    countryCode: 'US',
    regionName: 'CA',
    timezone: 'America/Los_Angeles',
    privacyAcknowledged: true,
    marketingConsent: false,
    webhookSyncStatus: 'notAttempted',
    webhookLastAttemptAt: null,
    signupCompletedAt: now,
    createdAt: now,
    updatedAt: now,
  );
}

SupportProfile _supportProfile() {
  final now = DateTime(2026, 1, 1);
  return SupportProfile(
    registrationProfileId: 1,
    selectedGoals: const ['goal_sleep', 'goal_anxiety'],
    domainScores: const [
      DomainScore(
        id: 'sleepDisruption',
        label: 'Sleep Disruption',
        rawScore: 7,
        maxRawScore: 10,
        visibleScore: 7,
        band: 'High',
        enabled: true,
        confidence: 0.8,
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
      sleepDebtScore: 7,
      sleepDisruptionScore: 8,
      sleepRiskScore: 8,
      confidence: 0.8,
    ),
    triggerWeights: [
      TriggerWeight(
        triggerId: 'stress',
        label: 'Stress',
        strengthRaw: 7,
        weight0To10: 7,
        reliability: 0.8,
        lastUpdatedAt: now,
      ),
    ],
    pathwayScores: const [
      PathwayScore(
        pathwayId: 'sleep_anxiety',
        label: 'Sleep anxiety pathway',
        mainProblemScore: 7,
        modifierScore: 6,
        routineRisk: 7,
        triggerWeight: 7,
        score0To10: 7,
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
      spiritualValuesReset: false,
      lowPressureTask: true,
      directnessLevel: 'balanced',
    ),
    learningState: LearningState(
      recoveryMomentum: 6,
      predictionAccuracy: 6,
      falseAlarmRate: 0,
      triggerReliabilityMap: const {},
      interventionRewardsMap: const {},
      lastUpdatedAt: now,
    ),
    createdAt: now,
    updatedAt: now,
  );
}
