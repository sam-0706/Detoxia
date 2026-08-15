import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/domain/tasks/task_tag.dart';
import 'package:detoxia/domain/tasks/unified_task_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = UnifiedTaskEngine();

  test('goal families return relevant tasks: sleep, anxiety, focus, low mood, scrolling, sexual', () {
    final profiles = <SupportProfile>[
      _profile(scores: const {'sleepDisruption': 8}, goals: const ['goal_sleep']),
      _profile(scores: const {'anxietyLoad': 8}, goals: const ['goal_anxiety']),
      _profile(scores: const {'focusSupport': 8}, goals: const ['goal_focus']),
      _profile(scores: const {'lowMoodSupport': 8}, goals: const ['goal_lowMood']),
      _profile(scores: const {'scrollingControl': 8}, goals: const ['goal_scrolling']),
      _profile(scores: const {'sexualControlRecovery': 8}, goals: const ['goal_sexualControl']),
    ];

    final expectedTagGroups = <Set<TaskTag>>[
      const {TaskTag.sleep, TaskTag.sleepShutdown, TaskTag.lateNightRisk},
      const {TaskTag.anxiety, TaskTag.breathingReset},
      const {TaskTag.focus, TaskTag.focusSprint},
      const {TaskTag.lowMood, TaskTag.lowPressure},
      const {TaskTag.scrolling, TaskTag.commuteScrolling},
      const {TaskTag.sexualControl},
    ];

    for (var i = 0; i < profiles.length; i++) {
      final tasks = engine.selectTasks(
        profile: profiles[i],
        now: DateTime(2026, 1, 10, 20),
        count: 4,
      );
      expect(
        tasks.any((task) => task.tags.any(expectedTagGroups[i].contains)),
        isTrue,
      );
    }
  });

  test('why chosen references domain or pathway signals', () {
    final tasks = engine.selectTasks(
      profile: _profile(
        goals: const ['goal_scrolling', 'goal_anxiety'],
        scores: const {'scrollingControl': 9, 'anxietyLoad': 8},
        pathways: const [
          PathwayScore(
            pathwayId: 'scrolling_anxiety',
            label: 'Scrolling anxiety pathway',
            mainProblemScore: 9,
            modifierScore: 8,
            routineRisk: 7,
            triggerWeight: 8,
            score0To10: 8,
            enabled: true,
            explanation: 'test',
          ),
        ],
      ),
      now: DateTime(2026, 1, 10, 19),
      count: 1,
    );

    final why = tasks.first.whyChosen.toLowerCase();
    expect(
      why.contains('support') || why.contains('pathway signal'),
      isTrue,
    );
  });

  test('steps and duration are always present in selected tasks', () {
    final tasks = engine.selectTasks(
      profile: _profile(scores: const {'focusSupport': 7}, goals: const ['goal_focus']),
      now: DateTime(2026, 1, 10, 9),
      count: 4,
    );

    expect(tasks, isNotEmpty);
    for (final task in tasks) {
      expect(task.task['durationMinutes'], isA<int>());
      expect(task.steps, isNotEmpty);
    }
  });

  test('same day ordering remains deterministic', () {
    final profile = _profile(
      goals: const ['goal_sleep', 'goal_anxiety'],
      scores: const {'sleepDisruption': 6, 'anxietyLoad': 6, 'focusSupport': 5},
    );
    final first = engine.selectTasks(
      profile: profile,
      now: DateTime(2026, 1, 10, 21),
      count: 5,
    );
    final second = engine.selectTasks(
      profile: profile,
      now: DateTime(2026, 1, 10, 21),
      count: 5,
    );

    expect(
      first.map((task) => task.task['id']).toList(),
      second.map((task) => task.task['id']).toList(),
    );
  });

  test('sleep and anxiety goals exclude sexual-control tasks', () {
    final tasks = engine.selectTasks(
      profile: _profile(
        goals: const ['goal_sleep', 'goal_anxiety'],
        scores: const {
          'sleepDisruption': 9,
          'anxietyLoad': 8,
          'sexualControlRecovery': 3,
        },
      ),
      now: DateTime(2026, 1, 10, 22),
      count: 6,
    );

    expect(
      tasks.any((task) => task.tags.contains(TaskTag.sexualControl)),
      isFalse,
    );
  });
}

SupportProfile _profile({
  required Map<String, double> scores,
  required List<String> goals,
  List<PathwayScore> pathways = const [],
}) {
  final now = DateTime(2026, 1, 1);
  return SupportProfile(
    registrationProfileId: 1,
    selectedGoals: goals,
    domainScores: [
      _score('scrollingControl', scores),
      _score('sexualContentControl', scores),
      _score('sexualControlRecovery', scores),
      _score('focusSupport', scores),
      _score('anxietyLoad', scores),
      _score('lowMoodSupport', scores),
      _score('sleepDisruption', scores),
      _score('physicalActivation', scores),
      _score('cycleSensitivity', scores),
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
      confidence: 0.8,
    ),
    triggerWeights: [
      TriggerWeight(
        triggerId: 'stress_peak',
        label: 'Stress peak',
        strengthRaw: 8,
        weight0To10: 8,
        reliability: 0.8,
        lastUpdatedAt: DateTime(2026, 1, 1),
      ),
    ],
    pathwayScores: pathways,
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
      interventionRewardsMap: const {'breathingReset': 0.4},
      lastUpdatedAt: now,
    ),
    createdAt: now,
    updatedAt: now,
  );
}

DomainScore _score(String id, Map<String, double> scores) {
  final value = scores[id] ?? 0.0;
  return DomainScore(
    id: id,
    label: id,
    rawScore: value,
    maxRawScore: 10,
    visibleScore: value,
    band: value >= 7 ? 'High' : 'Low',
    enabled: true,
    confidence: 1,
    explanation: 'test',
  );
}
