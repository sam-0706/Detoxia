import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/presentation/questionnaire/support_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('strongest drivers show gentle explanations for each trigger', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SupportMapScreen(
          profileId: 1,
          sessionId: 1,
          profileOverride: _profileWithData(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Strongest drivers'), findsOneWidget);
    expect(find.textContaining('Late-night phone use'), findsWidgets);
    expect(find.textContaining('often leads to late-night vulnerability'), findsOneWidget);
  });

  testWidgets('locked or learning state appears when drivers/pathways are unavailable', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SupportMapScreen(
          profileId: 1,
          sessionId: 1,
          profileOverride: _profileLocked(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('still learning'), findsWidgets);
  });
}

SupportProfile _profileWithData() {
  final now = DateTime(2026, 1, 1);
  return SupportProfile(
    registrationProfileId: 1,
    selectedGoals: const ['goal_sleep', 'goal_anxiety'],
    domainScores: const [
      DomainScore(
        id: 'sleepDisruption',
        label: 'Sleep Disruption',
        rawScore: 8,
        maxRawScore: 10,
        visibleScore: 8,
        band: 'High',
        enabled: true,
        confidence: 0.82,
        explanation: 'Late-night windows are increasing sleep risk.',
      ),
      DomainScore(
        id: 'anxietyLoad',
        label: 'Anxiety Load',
        rawScore: 7,
        maxRawScore: 10,
        visibleScore: 7,
        band: 'High',
        enabled: true,
        confidence: 0.8,
        explanation: 'Stress spikes are increasing rough windows.',
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
        triggerId: 'late_night_phone',
        label: 'Late-night phone use',
        strengthRaw: 8,
        weight0To10: 8,
        reliability: 0.86,
        lastUpdatedAt: now,
      ),
    ],
    pathwayScores: const [
      PathwayScore(
        pathwayId: 'sleep_stress_pathway',
        label: 'Sleep-stress pathway',
        mainProblemScore: 8,
        modifierScore: 7,
        routineRisk: 7,
        triggerWeight: 8,
        score0To10: 8.1,
        enabled: true,
        explanation: 'Late-night stimulation is reinforcing stress and sleep disruption.',
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

SupportProfile _profileLocked() {
  final now = DateTime(2026, 1, 1);
  return SupportProfile(
    registrationProfileId: 1,
    selectedGoals: const ['goal_sleep'],
    domainScores: const [
      DomainScore(
        id: 'sleepDisruption',
        label: 'Sleep Disruption',
        rawScore: 0,
        maxRawScore: 10,
        visibleScore: 0,
        band: 'Low',
        enabled: true,
        confidence: 0.2,
        explanation: 'More local data is needed to unlock deeper interpretation.',
      ),
    ],
    routineProfile: const RoutineProfile(
      wakeWindow: '7-8 AM',
      sleepAttemptWindow: '11 PM-12 AM',
      sleepLatencyRange: '15-30 min',
      commutePhoneUseScore: 0,
      freeWindows: [],
      aloneWindows: [],
      phoneInBedScore: 0,
      vulnerableWindows: [],
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
      sleepDebtScore: 0,
      sleepDisruptionScore: 0,
      sleepRiskScore: 0,
      confidence: 0.2,
    ),
    triggerWeights: const [],
    pathwayScores: const [],
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
      recoveryMomentum: 0,
      predictionAccuracy: 0,
      falseAlarmRate: 0,
      triggerReliabilityMap: const {},
      interventionRewardsMap: const {},
      lastUpdatedAt: now,
    ),
    createdAt: now,
    updatedAt: now,
  );
}
