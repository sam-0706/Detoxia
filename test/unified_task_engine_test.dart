import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/domain/tasks/task_tag.dart';
import 'package:detoxia/domain/tasks/unified_task_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = UnifiedTaskEngine();

  test(
    '1. high scrolling + anxiety returns scrolling and anxiety tagged tasks',
    () {
      final tasks = engine.selectTasks(
        profile: _profile(
          scores: const {'scrollingControl': 8.0, 'anxietyLoad': 7.0},
          pathways: const [
            PathwayScore(
              pathwayId: 'scrolling_anxiety',
              label: 'Scrolling anxiety pathway',
              mainProblemScore: 8,
              modifierScore: 7,
              routineRisk: 5,
              triggerWeight: 8,
              score0To10: 8,
              enabled: true,
              explanation: 'test',
            ),
          ],
        ),
        now: DateTime(2026, 1, 10, 13),
      );

      expect(tasks, isNotEmpty);
      expect(
        tasks.any((task) => task.tags.contains(TaskTag.scrolling)),
        isTrue,
      );
      expect(tasks.any((task) => task.tags.contains(TaskTag.anxiety)), isTrue);
    },
  );

  test('2. high sexual control + sleep leans toward sexual and sleep tags', () {
    final tasks = engine.selectTasks(
      profile: _profile(
        scores: const {'sexualControlRecovery': 9.0, 'sleepDisruption': 6.0},
        selectedGoals: const ['goal_sexualControl', 'goal_sleep'],
        pathways: const [
          PathwayScore(
            pathwayId: 'sexual_sleep',
            label: 'Sexual late night sleep pathway',
            mainProblemScore: 9,
            modifierScore: 6,
            routineRisk: 6,
            triggerWeight: 8,
            score0To10: 8,
            enabled: true,
            explanation: 'test',
          ),
        ],
      ),
      now: DateTime(2026, 1, 10, 20),
      count: 5,
    );

    expect(
      tasks.any((task) => task.tags.contains(TaskTag.sexualControl)),
      isTrue,
    );
    expect(
      tasks.any(
        (task) =>
            task.tags.contains(TaskTag.sleep) ||
            task.tags.contains(TaskTag.sleepShutdown) ||
            task.tags.contains(TaskTag.lateNightRisk),
      ),
      isTrue,
    );
  });

  test('3. compound tasks rank above single-domain tasks', () {
    final tasks = engine.selectTasks(
      profile: _profile(
        scores: const {
          'scrollingControl': 9.0,
          'sleepDisruption': 8.0,
          'anxietyLoad': 2.0,
        },
      ),
      now: DateTime(2026, 1, 10, 20),
      count: 20,
    );

    final first = tasks.first;
    expect(
      _highDomainFitCount(first.tags, const {
        'scrollingControl': 9.0,
        'sleepDisruption': 8.0,
      }),
      greaterThanOrEqualTo(2),
    );

    final singleDomainTask = tasks.firstWhere(
      (task) =>
          _highDomainFitCount(task.tags, const {
            'scrollingControl': 9.0,
            'sleepDisruption': 8.0,
          }) ==
          1,
    );
    expect(first.utility, greaterThan(singleDomainTask.utility));
  });

  test(
    '4. disabled physical reset preference excludes physical reset tasks',
    () {
      final tasks = engine.selectTasks(
        profile: _profile(
          scores: const {'physicalActivation': 9.0, 'anxietyLoad': 6.0},
          preferences: _preferences(physicalReset: false),
        ),
        now: DateTime(2026, 1, 10, 13),
        count: 8,
      );

      expect(
        tasks.any((task) => task.tags.contains(TaskTag.physicalReset)),
        isFalse,
      );
    },
  );

  test('5. returned list length is at most requested count', () {
    final tasks = engine.selectTasks(
      profile: _profile(scores: const {'scrollingControl': 8.0}),
      now: DateTime(2026, 1, 10, 13),
    );

    expect(tasks.length, lessThanOrEqualTo(4));
  });

  test('6. returned list contains at most one breathing reset task', () {
    final tasks = engine.selectTasks(
      profile: _profile(scores: const {'anxietyLoad': 10.0}),
      now: DateTime(2026, 1, 10, 13),
      count: 5,
    );

    expect(
      tasks.where((task) => task.tags.contains(TaskTag.breathingReset)).length,
      lessThanOrEqualTo(1),
    );
  });

  test('7. same profile and same date is deterministic', () {
    final profile = _profile(
      scores: const {
        'scrollingControl': 6.0,
        'anxietyLoad': 6.0,
        'focusSupport': 6.0,
      },
    );
    final first = engine.selectTasks(
      profile: profile,
      now: DateTime(2026, 1, 10, 13),
    );
    final second = engine.selectTasks(
      profile: profile,
      now: DateTime(2026, 1, 10, 13),
    );

    expect(_ids(first), _ids(second));
  });

  test('8. different day of year rotates selection', () {
    final profile = _profile(
      scores: const {
        'scrollingControl': 1.0,
        'anxietyLoad': 1.0,
        'focusSupport': 1.0,
        'lowMoodSupport': 1.0,
      },
    );
    final first = engine.selectTasks(
      profile: profile,
      now: DateTime(2026, 1, 10, 13),
      count: 5,
    );
    final second = engine.selectTasks(
      profile: profile,
      now: DateTime(2026, 1, 11, 13),
      count: 5,
    );

    expect(_ids(first), isNot(_ids(second)));
  });

  test('9. selected goals boost relevant families and suppress irrelevant sexual tasks', () {
    final tasks = engine.selectTasks(
      profile: _profile(
        scores: const {
          'sleepDisruption': 8.0,
          'anxietyLoad': 7.0,
          'sexualControlRecovery': 1.0,
        },
        selectedGoals: const ['goal_sleep', 'goal_anxiety'],
      ),
      now: DateTime(2026, 1, 10, 22),
      count: 6,
    );

    expect(
      tasks.any((task) => task.tags.contains(TaskTag.sexualControl)),
      isFalse,
    );
    expect(
      tasks.any(
        (task) =>
            task.tags.contains(TaskTag.sleep) ||
            task.tags.contains(TaskTag.anxiety),
      ),
      isTrue,
    );
  });

  test('10. task utility includes why, steps, target driver, tags, and feedback buttons', () {
    final tasks = engine.selectTasks(
      profile: _profile(
        scores: const {'focusSupport': 8.0, 'anxietyLoad': 6.0},
        selectedGoals: const ['goal_focus'],
      ),
      now: DateTime(2026, 1, 10, 10),
      count: 1,
    );

    final first = tasks.first;
    expect(first.whyChosen, isNotEmpty);
    expect(first.steps, isNotEmpty);
    expect(first.targetDriver, isNotEmpty);
    expect(first.domainTags, isNotEmpty);
    expect(first.feedbackButtons, hasLength(3));
  });
}

List<String> _ids(Iterable<dynamic> tasks) {
  return tasks.map((task) => task.task['id'] as String).toList();
}

int _highDomainFitCount(List<TaskTag> tags, Map<String, double> scores) {
  var count = 0;
  if ((scores['scrollingControl'] ?? 0) > 0 &&
      tags.any(
        const {
          TaskTag.scrolling,
          TaskTag.commuteScrolling,
          TaskTag.appFriction,
        }.contains,
      )) {
    count++;
  }
  if ((scores['sleepDisruption'] ?? 0) > 0 &&
      tags.any(
        const {
          TaskTag.sleep,
          TaskTag.sleepDebt,
          TaskTag.sleepShutdown,
          TaskTag.lateNightRisk,
        }.contains,
      )) {
    count++;
  }
  return count;
}

SupportProfile _profile({
  required Map<String, double> scores,
  List<PathwayScore> pathways = const [],
  InterventionPreferences? preferences,
  List<String> selectedGoals = const [],
}) {
  final now = DateTime(2026, 1, 1);
  return SupportProfile(
    registrationProfileId: 1,
    selectedGoals: selectedGoals,
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
    triggerWeights: const [],
    pathwayScores: pathways,
    interventionPreferences: preferences ?? _preferences(),
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

InterventionPreferences _preferences({bool physicalReset = true}) {
  return InterventionPreferences(
    physicalReset: physicalReset,
    breathingGrounding: true,
    appFrictionDelay: true,
    journalingThoughtDump: true,
    focusSprint: true,
    sleepShutdown: true,
    spiritualValuesReset: true,
    lowPressureTask: true,
    directnessLevel: 'balanced',
  );
}
