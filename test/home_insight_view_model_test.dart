import 'package:detoxia/domain/home/home_insight_view_model.dart';
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
  const builder = HomeInsightViewModelBuilder();
  final now = DateTime(2026, 5, 19, 20, 30);

  test('goal-aware reset CTA labels map to language families', () {
    HomeInsightViewModel modelFor(List<String> goals) {
      return builder.build(
        now: now,
        displayName: 'Sam',
        checkedInToday: false,
        supportProfile: _profile(goals: goals),
        dailyCheckins: const [
          {'stress': 6},
          {'stress': 7},
          {'stress': 5},
        ],
      );
    }

    expect(
      modelFor(const ['goal_anxiety']).primaryResetCta.label,
      'Help me through this rough window',
    );
    expect(
      modelFor(const ['goal_focus']).primaryResetCta.label,
      'Reset missed focus block',
    );
    expect(
      modelFor(const ['goal_sleep']).primaryResetCta.label,
      'Reset sleep disruption',
    );
    expect(
      modelFor(const ['goal_scrolling']).primaryResetCta.label,
      'Break scrolling loop',
    );
    expect(
      modelFor(const ['goal_porn_masturbation']).primaryResetCta.label,
      'Help me reset',
    );
  });

  test('insufficient data emits locked insight and risk window states', () {
    final model = builder.build(
      now: now,
      displayName: 'Sam',
      checkedInToday: false,
      supportProfile: null,
      dailyCheckins: const [],
    );

    expect(model.todayInsight.isLocked, isTrue);
    expect(model.riskWindow.isLocked, isTrue);
    expect(model.supportMapPreview.isLocked, isTrue);
    expect(
      model.todayInsight.body.toLowerCase(),
      contains('learning'),
    );
  });

  test('daily check-in state reflects completion', () {
    final doneModel = builder.build(
      now: now,
      displayName: 'Sam',
      checkedInToday: true,
      supportProfile: _profile(goals: const ['goal_sleep']),
      dailyCheckins: const [
        {'stress': 3},
        {'stress': 4},
        {'stress': 5},
      ],
    );
    final pendingModel = builder.build(
      now: now,
      displayName: 'Sam',
      checkedInToday: false,
      supportProfile: _profile(goals: const ['goal_sleep']),
      dailyCheckins: const [
        {'stress': 3},
        {'stress': 4},
        {'stress': 5},
      ],
    );

    expect(doneModel.dailyCheckin.isDoneToday, isTrue);
    expect(doneModel.dailyCheckin.ctaLabel, 'Daily check-in complete');
    expect(pendingModel.dailyCheckin.isDoneToday, isFalse);
    expect(pendingModel.dailyCheckin.ctaLabel, 'Daily check-in');
  });

  test('top drivers include confidence and suggested action', () {
    final model = builder.build(
      now: now,
      displayName: 'Sam',
      checkedInToday: false,
      supportProfile: _profile(goals: const ['goal_anxiety']),
      dailyCheckins: const [
        {'stress': 6},
        {'stress': 7},
        {'stress': 5},
      ],
    );

    expect(model.topDrivers, isNotEmpty);
    expect(model.topDrivers.first.confidence0To1, inInclusiveRange(0.0, 1.0));
    expect(model.topDrivers.first.suggestedAction, isNotEmpty);
    expect(model.topDrivers.first.affectedDomains, isNotEmpty);
  });

  test('no fake insight appears without support profile data', () {
    final model = builder.build(
      now: now,
      displayName: 'Sam',
      checkedInToday: false,
      supportProfile: null,
      dailyCheckins: const [],
    );

    expect(model.todayInsight.isLocked, isTrue);
    expect(
      model.todayInsight.body.toLowerCase(),
      isNot(contains('8.8/10')),
    );
  });

  test('risk window uses routine vulnerable windows instead of fixed time labels', () {
    final model = builder.build(
      now: now,
      displayName: 'Sam',
      checkedInToday: false,
      supportProfile: _profile(goals: const ['goal_anxiety']),
      dailyCheckins: const [
        {'stress': 7},
        {'stress': 8},
        {'stress': 6},
      ],
    );

    expect(model.riskWindow.isLocked, isFalse);
    expect(model.riskWindow.nextWindowLabel, contains('After work'));
    expect(model.riskWindow.nextWindowLabel, isNot(contains('Evening')));
  });
}

SupportProfile _profile({required List<String> goals}) {
  final now = DateTime(2026, 5, 19);
  return SupportProfile(
    registrationProfileId: 1,
    selectedGoals: goals,
    domainScores: const [
      DomainScore(
        id: 'anxietyLoad',
        label: 'Anxiety Load',
        rawScore: 9,
        maxRawScore: 12,
        visibleScore: 7.5,
        band: 'High',
        enabled: true,
        confidence: 0.9,
        explanation: 'Anxiety support need.',
      ),
      DomainScore(
        id: 'sleepDisruption',
        label: 'Sleep Disruption',
        rawScore: 8,
        maxRawScore: 15,
        visibleScore: 5.4,
        band: 'Moderate',
        enabled: true,
        confidence: 0.8,
        explanation: 'Sleep support need.',
      ),
      DomainScore(
        id: 'scrollingControl',
        label: 'Scrolling Control',
        rawScore: 12,
        maxRawScore: 15,
        visibleScore: 8.0,
        band: 'High',
        enabled: true,
        confidence: 0.9,
        explanation: 'Scrolling support need.',
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
      sleepDisruptionScore: 5.4,
      sleepRiskScore: 5.3,
      confidence: 0.8,
    ),
    menstrualProfile: null,
    triggerWeights: [
      TriggerWeight(
        triggerId: 'trig_stress',
        label: 'Stress',
        strengthRaw: 3,
        weight0To10: 8.5,
        reliability: 0.8,
        lastUpdatedAt: now,
      ),
      TriggerWeight(
        triggerId: 'trig_anxiety',
        label: 'Anxiety',
        strengthRaw: 2,
        weight0To10: 7.0,
        reliability: 0.7,
        lastUpdatedAt: now,
      ),
    ],
    pathwayScores: const [
      PathwayScore(
        pathwayId: 'anxietyToScroll',
        label: 'Anxiety to scrolling',
        mainProblemScore: 7.5,
        modifierScore: 8.0,
        routineRisk: 5,
        triggerWeight: 8,
        score0To10: 7.2,
        enabled: true,
        explanation: 'Anxiety increases scrolling risk.',
      ),
    ],
    interventionPreferences: const InterventionPreferences(
      physicalReset: true,
      breathingGrounding: true,
      appFrictionDelay: false,
      journalingThoughtDump: true,
      focusSprint: true,
      sleepShutdown: true,
      spiritualValuesReset: false,
      lowPressureTask: true,
      directnessLevel: 'balanced',
    ),
    learningState: LearningState(
      recoveryMomentum: 6.2,
      predictionAccuracy: 0.5,
      falseAlarmRate: 0.1,
      triggerReliabilityMap: const {},
      interventionRewardsMap: const {},
      lastUpdatedAt: now,
    ),
    createdAt: now,
    updatedAt: now,
  );
}
