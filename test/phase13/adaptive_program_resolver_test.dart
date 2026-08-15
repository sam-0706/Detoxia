import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/program/adaptive_program_resolver.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const resolver = AdaptiveProgramResolver();

  test('keeps four-phase structure for all goal families', () {
    final plan = resolver.resolve(
      supportProfile: _profile(const ['goal_sleep']),
    );

    expect(plan.phases.length, 4);
    expect(plan.phases[0].title, contains('Baseline + Map'));
    expect(plan.phases[1].title, contains('Interrupt + Stabilize'));
    expect(plan.phases[2].title, contains('Rebuild Control'));
    expect(plan.phases[3].title, contains('Maintain + Prevent'));
  });

  test('sleep goals avoid detox-only program copy', () {
    final plan = resolver.resolve(
      supportProfile: _profile(const ['goal_sleep', 'goal_anxiety']),
    );
    final text = plan.phases
        .expand((phase) => phase.modules)
        .map((module) => '${module.title} ${module.description}')
        .join(' ');

    expect(text.toLowerCase().contains('urge'), isFalse);
    expect(text.toLowerCase().contains('setback'), isFalse);
    expect(text.toLowerCase().contains('sexual'), isFalse);
  });

  test('sexual-control goals include relevant urge language', () {
    final plan = resolver.resolve(
      supportProfile: _profile(const ['goal_sexualControl']),
    );
    final text = plan.phases
        .expand((phase) => phase.modules)
        .map((module) => '${module.title} ${module.description}')
        .join(' ');

    expect(text.toLowerCase().contains('urge'), isTrue);
  });

  test('null profile returns honest locked starter guidance', () {
    final plan = resolver.resolve(supportProfile: null);

    expect(plan.isLocked, isTrue);
    expect(plan.phases.length, 4);
    expect(plan.starterGuidance, contains('unlock'));
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
