import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/presentation/dashboard/confidence_analysis/confidence_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('anxiety/sleep/focus users see agency labels, not old clinical labels', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ConfidenceScreen(
          supportProfileOverride: _profile(),
          checkinsOverride: const [
            {'sleepQuality': 4, 'mood': 6, 'stress': 6, 'confidenceTomorrow': 5},
            {'sleepQuality': 5, 'mood': 6, 'stress': 5, 'confidenceTomorrow': 6},
            {'sleepQuality': 4, 'mood': 7, 'stress': 4, 'confidenceTomorrow': 7},
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    // New agency-centered labels present
    expect(find.text('Where You Stand'), findsOneWidget);
    expect(find.text('Calm Recovery'), findsWidgets);
    expect(find.textContaining('Sleep'), findsWidgets);
    expect(find.textContaining('Focus'), findsWidgets);
    expect(find.text('Growth areas'), findsOneWidget);
    expect(
      find.text('These are not failures. They are places where a small reset or clearer routine may help.'),
      findsOneWidget,
    );

    // Old clinical labels absent
    expect(find.text('Self-Control'), findsNothing);
    expect(find.text('Urge Resilience'), findsNothing);
    expect(find.text('Trigger Exposure'), findsNothing);
    expect(find.text('Anxiety Load'), findsNothing);
    expect(find.text('Worry Control'), findsNothing);
    expect(find.text('Avoidance Risk'), findsNothing);
    expect(find.text('Night Risk'), findsNothing);
    expect(find.text('Insights'), findsNothing);
  });
}

SupportProfile _profile() {
  final now = DateTime(2026, 1, 1);
  return SupportProfile(
    registrationProfileId: 1,
    selectedGoals: const ['goal_anxiety', 'goal_sleep', 'goal_focus'],
    domainScores: const [
      DomainScore(
        id: 'focusSupport',
        label: 'Focus Support',
        rawScore: 8,
        maxRawScore: 10,
        visibleScore: 8,
        band: 'High',
        enabled: true,
        confidence: 0.8,
        explanation: 'test',
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
        explanation: 'test',
      ),
      DomainScore(
        id: 'sleepDisruption',
        label: 'Sleep Disruption',
        rawScore: 8,
        maxRawScore: 10,
        visibleScore: 8,
        band: 'High',
        enabled: true,
        confidence: 0.8,
        explanation: 'test',
      ),
      DomainScore(
        id: 'sexualControlRecovery',
        label: 'Sexual Control Recovery',
        rawScore: 2,
        maxRawScore: 10,
        visibleScore: 2,
        band: 'Low',
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
        strengthRaw: 8,
        weight0To10: 8,
        reliability: 0.8,
        lastUpdatedAt: now,
      ),
    ],
    pathwayScores: const [
      PathwayScore(
        pathwayId: 'sleep_anxiety',
        label: 'Sleep anxiety pathway',
        mainProblemScore: 8,
        modifierScore: 7,
        routineRisk: 7,
        triggerWeight: 8,
        score0To10: 8,
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
