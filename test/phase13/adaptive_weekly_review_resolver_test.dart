import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/domain/weekly_review/adaptive_weekly_review_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const resolver = AdaptiveWeeklyReviewResolver();

  test('anxiety goal returns anxiety weekly sections', () {
    final review = resolver.resolve(
      supportProfile: _profile(const ['goal_anxiety']),
      checkins: _checkins(7),
      urgesLast7Days: 3,
      slipsLast7Days: 1,
      completedTasksLast7Days: 5,
    );

    expect(review.isLocked, isFalse);
    expect(review.metrics.first.label, 'Calm recovery');
    expect(review.impactTitle, contains('support windows'));
  });

  test('mixed goals prioritize non-sexual labels when sexual goal absent', () {
    final review = resolver.resolve(
      supportProfile: _profile(const ['goal_sleep', 'goal_focus']),
      checkins: _checkins(7),
      urgesLast7Days: 4,
      slipsLast7Days: 2,
      completedTasksLast7Days: 4,
    );

    final labels = review.metrics.map((metric) => metric.label).join(' ');
    expect(labels.contains('Urges'), isFalse);
    expect(labels.contains('Setbacks'), isFalse);
  });

  test('locked state when insufficient local history', () {
    final review = resolver.resolve(
      supportProfile: _profile(const ['goal_sleep']),
      checkins: _checkins(2),
      urgesLast7Days: 0,
      slipsLast7Days: 0,
      completedTasksLast7Days: 0,
    );

    expect(review.isLocked, isTrue);
    expect(review.metrics, isEmpty);
    expect(review.impactBody, contains('at least 4 check-ins'));
  });

  test('metrics derive from local records', () {
    final review = resolver.resolve(
      supportProfile: _profile(const ['goal_sleep']),
      checkins: const [
        {'date': null, 'sleepQuality': 3, 'mood': 4, 'stress': 8, 'confidenceTomorrow': 4, 'hadUrge': true, 'slipped': false},
        {'date': null, 'sleepQuality': 5, 'mood': 6, 'stress': 6, 'confidenceTomorrow': 6, 'hadUrge': false, 'slipped': false},
        {'date': null, 'sleepQuality': 4, 'mood': 5, 'stress': 7, 'confidenceTomorrow': 5, 'hadUrge': true, 'slipped': true},
        {'date': null, 'sleepQuality': 6, 'mood': 6, 'stress': 5, 'confidenceTomorrow': 7, 'hadUrge': false, 'slipped': false},
      ],
      urgesLast7Days: 2,
      slipsLast7Days: 1,
      completedTasksLast7Days: 3,
    );

    expect(review.isLocked, isFalse);
    expect(review.metrics[0].value, '4.5');
    expect(review.metrics[1].label, 'Sleep interruptions');
  });
}

SupportProfile _profile(List<String> goals) {
  final now = DateTime(2026, 1, 1);
  return SupportProfile(
    registrationProfileId: 1,
    selectedGoals: goals,
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

List<Map<String, dynamic>> _checkins(int count) {
  return List.generate(
    count,
    (i) => <String, dynamic>{
      'date': DateTime(2026, 1, i + 1),
      'hadUrge': i.isEven,
      'slipped': i % 3 == 0,
      'sleepQuality': 4 + (i % 3),
      'mood': 5 + (i % 2),
      'stress': 5 + (i % 3),
      'confidenceTomorrow': 5 + (i % 2),
    },
  );
}
