import 'package:detoxia/domain/home/where_you_stand_metric_resolver.dart';
import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const resolver = WhereYouStandMetricResolver();

  test('selects anxiety metric family', () {
    final result = resolver.resolve(
      supportProfile: _profile(goals: const ['goal_anxiety']),
      recentCheckins: _checkins(),
    );

    expect(result.isLocked, isFalse);
    expect(result.metrics.map((metric) => metric.label), contains('Calm Recovery'));
    expect(result.metrics.map((metric) => metric.label), isNot(contains('Awareness')));
  });

  test('supports mixed goal combinations', () {
    final result = resolver.resolve(
      supportProfile: _profile(goals: const ['goal_sleep', 'goal_focus']),
      recentCheckins: _checkins(),
    );

    final labels = result.metrics.map((metric) => metric.label).toList();
    expect(labels.any((label) => label.contains('Sleep')), isTrue);
    expect(labels.any((label) => label.contains('Focus')), isTrue);
  });

  test('returns locked metrics when signal is insufficient', () {
    final result = resolver.resolve(
      supportProfile: _profile(goals: const ['goal_lowMood']),
      recentCheckins: const [],
    );

    expect(result.isLocked, isTrue);
    expect(result.metrics, isNotEmpty);
    expect(result.metrics.every((metric) => metric.isLocked), isTrue);
  });
}

SupportProfile _profile({required List<String> goals}) {
  final now = DateTime(2026, 1, 1);
  return SupportProfile(
    registrationProfileId: 1,
    selectedGoals: goals,
    domainScores: const [
      DomainScore(
        id: 'scrollingControl',
        label: 'Scrolling Control',
        rawScore: 5,
        maxRawScore: 10,
        visibleScore: 5,
        band: 'Mild',
        enabled: true,
        confidence: 0.8,
        explanation: 'test',
      ),
      DomainScore(
        id: 'sexualControlRecovery',
        label: 'Sexual Control Recovery',
        rawScore: 4,
        maxRawScore: 10,
        visibleScore: 4,
        band: 'Mild',
        enabled: true,
        confidence: 0.8,
        explanation: 'test',
      ),
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
        id: 'lowMoodSupport',
        label: 'Low Mood Support',
        rawScore: 6,
        maxRawScore: 10,
        visibleScore: 6,
        band: 'Moderate',
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

List<Map<String, dynamic>> _checkins() {
  return const [
    {'sleepQuality': 4, 'mood': 5, 'stress': 6, 'confidenceTomorrow': 6},
    {'sleepQuality': 5, 'mood': 6, 'stress': 5, 'confidenceTomorrow': 6},
    {'sleepQuality': 4, 'mood': 6, 'stress': 4, 'confidenceTomorrow': 7},
  ];
}
