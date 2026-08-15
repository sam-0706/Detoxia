import 'package:detoxia/domain/journey/recovery_journey_projection_resolver.dart';
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
  const resolver = RecoveryJourneyProjectionResolver();

  test('builds direction items when enough local data exists', () {
    final projection = resolver.resolve(
      supportProfile: _profile(const ['goal_sleep', 'goal_anxiety']),
      checkins: _checkins(10),
      slipsLast28Days: 8,
      completedTasksLast14Days: 9,
    );

    expect(projection.isLocked, isFalse);
    expect(projection.points.length, 12);
    expect(projection.title, 'Your Recovery Path');
    expect(projection.caption, 'Local data only. This is direction, not prediction.');
    expect(projection.directionItems, isNotEmpty);
  });

  test('returns locked state when local history is insufficient', () {
    final projection = resolver.resolve(
      supportProfile: _profile(const ['goal_sleep']),
      checkins: _checkins(3),
      slipsLast28Days: 2,
      completedTasksLast14Days: 2,
    );

    expect(projection.isLocked, isTrue);
    expect(projection.points, isEmpty);
    expect(projection.directionItems, isEmpty);
    expect(projection.lockedReason, contains('protected moments'));
  });

  test('direction items use qualitative language without fake precision', () {
    final projection = resolver.resolve(
      supportProfile: _profile(const ['goal_anxiety']),
      checkins: _checkins(9),
      slipsLast28Days: 6,
      completedTasksLast14Days: 7,
    );

    final text = [
      projection.summary,
      projection.caption,
      ...projection.directionItems,
    ].join(' ');

    // No fake precision
    expect(text.contains('70-80%'), isFalse);
    expect(text.contains('70–80%'), isFalse);
    expect(text.contains('Week 4'), isFalse);
    expect(text.contains('Week 12'), isFalse);
    expect(text.contains('/week'), isFalse);
    // Direction language present
    expect(text.contains('direction'), isTrue);
  });
}

SupportProfile _profile(List<String> goals) {
  final now = DateTime(2026, 1, 1);
  return SupportProfile(
    registrationProfileId: 1,
    selectedGoals: goals,
    domainScores: const [
      DomainScore(
        id: 'focusSupport',
        label: 'Focus Support',
        rawScore: 7,
        maxRawScore: 10,
        visibleScore: 7,
        band: 'High',
        enabled: true,
        confidence: 0.8,
        explanation: 'test',
      ),
      DomainScore(
        id: 'anxietyLoad',
        label: 'Anxiety Load',
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

List<Map<String, dynamic>> _checkins(int count) {
  return List.generate(
    count,
    (index) => <String, dynamic>{
      'date': DateTime(2026, 1, index + 1),
      'slipped': index.isEven,
      'stress': 5,
      'mood': 6,
      'sleepQuality': 4,
    },
  );
}
