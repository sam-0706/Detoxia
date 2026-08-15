import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/routine/models/menstrual_phase.dart';
import 'package:detoxia/domain/routine/models/menstrual_profile.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/services/notification_service.dart';
import 'package:detoxia/services/unified_notification_scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UnifiedNotificationScheduler', () {
    final now = DateTime(2026, 5, 19, 9);

    test(
      'with high routine risk and gentle mode, schedule count <= 3',
      () async {
        final notifications = _RecordingNotificationService(
          NotificationMode.gentle,
        );
        await UnifiedNotificationScheduler(
          notifications,
        ).scheduleDailyForProfile(_profile(), now);

        expect(notifications.scheduled.length, lessThanOrEqualTo(3));
        expect(notifications.scheduled, isNotEmpty);
      },
    );

    test(
      'with high sleep debt, a sleep notification appears in the schedule',
      () async {
        final notifications = _RecordingNotificationService(
          NotificationMode.balanced,
        );
        await UnifiedNotificationScheduler(
          notifications,
        ).scheduleDailyForProfile(_profile(sleepDebtScore: 8), now);

        expect(
          notifications.scheduled.any(
            (notification) => notification.body.contains('sleep debt is high'),
          ),
          isTrue,
        );
      },
    );

    test('with luteal phase, cycle modifier appears in the body', () async {
      final notifications = _RecordingNotificationService(
        NotificationMode.balanced,
      );
      await UnifiedNotificationScheduler(notifications).scheduleDailyForProfile(
        _profile(menstrualPhase: MenstrualPhase.luteal),
        now,
      );

      expect(
        notifications.scheduled.any(
          (notification) => notification.body.contains(
            'Luteal phase may be amplifying today.',
          ),
        ),
        isTrue,
      );
    });

    test('with low scores everywhere, schedule is minimal', () async {
      final notifications = _RecordingNotificationService(
        NotificationMode.strict,
      );
      await UnifiedNotificationScheduler(notifications).scheduleDailyForProfile(
        _profile(
          routineRisk: 1,
          sleepDebtScore: 1,
          phoneInBedScore: 0,
          commutePhoneUseScore: 0,
          anxietyScore: 1,
          aloneWindows: const [],
          vulnerableWindows: const [],
          pathwayId: 'low_general',
          pathwayLabel: 'Low General',
          pathwayExplanation: 'Low general support pathway',
        ),
        now,
      );

      expect(notifications.scheduled.length, lessThanOrEqualTo(1));
    });

    test('notification bodies include a why sentence', () async {
      final notifications = _RecordingNotificationService(
        NotificationMode.balanced,
      );
      await UnifiedNotificationScheduler(
        notifications,
      ).scheduleDailyForProfile(_profile(), now);

      expect(notifications.scheduled, isNotEmpty);
      for (final notification in notifications.scheduled) {
        expect(notification.body, isNot(equals(notification.title)));
        expect(notification.body, contains('Because'));
      }
    });
  });
}

class _RecordingNotificationService extends NotificationService {
  final List<_ScheduledNotification> scheduled = [];

  _RecordingNotificationService(NotificationMode mode) {
    setMode(mode);
  }

  @override
  Future<void> scheduleUnifiedNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    scheduled.add(
      _ScheduledNotification(
        id: id,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
      ),
    );
  }
}

class _ScheduledNotification {
  final int id;
  final String title;
  final String body;
  final DateTime scheduledTime;

  const _ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
  });
}

SupportProfile _profile({
  double routineRisk = 8,
  double sleepDebtScore = 8,
  int phoneInBedScore = 3,
  int commutePhoneUseScore = 3,
  double anxietyScore = 8,
  MenstrualPhase menstrualPhase = MenstrualPhase.follicular,
  List<String> aloneWindows = const ['Evening'],
  List<String> vulnerableWindows = const ['Late night'],
  String pathwayId = 'post_work_stress',
  String pathwayLabel = 'Post Work Stress',
  String pathwayExplanation = 'Post-work stress can lead into scrolling.',
}) {
  final baseTime = DateTime.parse('2026-05-01T00:00:00.000Z');
  return SupportProfile(
    registrationProfileId: 1,
    selectedGoals: const ['scrolling', 'sleep'],
    domainScores: [
      DomainScore(
        id: 'anxietyLoad',
        label: 'Anxiety Load',
        rawScore: anxietyScore,
        maxRawScore: 10,
        visibleScore: anxietyScore,
        band: anxietyScore >= 7 ? 'High' : 'Low',
        enabled: true,
        confidence: 1,
        explanation: 'Sample score',
      ),
    ],
    routineProfile: RoutineProfile(
      wakeWindow: '6-7 AM',
      sleepAttemptWindow: '10-11 PM',
      sleepLatencyRange: '15-30 min',
      schoolWorkArrivalWindow: '8-9 AM',
      busyStartWindow: 'Morning',
      busyEndWindow: 'Evening',
      commuteToDuration: 22,
      commuteBackDuration: 30,
      commuteMode: 'bus',
      commutePhoneUseScore: commutePhoneUseScore,
      freeWindows: const ['Evening'],
      aloneWindows: aloneWindows,
      phoneInBedScore: phoneInBedScore,
      vulnerableWindows: vulnerableWindows,
    ),
    sleepProfile: SleepProfile(
      sleepAttemptWindow: '10-11 PM',
      wakeWindow: '6-7 AM',
      sleepLatencyRange: '15-30 min',
      estimatedSleepStartMinutes: 1380,
      estimatedWakeTimeMinutes: 390,
      estimatedSleepDurationHours: 6.5,
      targetSleepHours: 8,
      dailySleepDebtHours: sleepDebtScore >= 7 ? 1.5 : 0.1,
      estimatedSevenDaySleepDebtHours: sleepDebtScore >= 7 ? 10.5 : 0.7,
      sleepDebtScore: sleepDebtScore,
      sleepDisruptionScore: sleepDebtScore,
      sleepRiskScore: sleepDebtScore,
      confidence: 0.6,
    ),
    menstrualProfile: MenstrualProfile(
      enabled: true,
      lastPeriodStartDate: DateTime.parse('2026-04-20T00:00:00.000Z'),
      averageCycleLength: 28,
      averageBleedingLength: 5,
      regularity: 'regular',
      currentCycleDay: 21,
      currentPhase: menstrualPhase,
      nextPeriodEstimate: DateTime.parse('2026-05-18T00:00:00.000Z'),
      confidence: 1,
      cycleSensitivityScore: 5,
    ),
    triggerWeights: [
      TriggerWeight(
        triggerId: 'trig_stress',
        label: 'Stress',
        strengthRaw: 3,
        weight0To10: 7.5,
        reliability: 0.8,
        lastUpdatedAt: baseTime,
      ),
    ],
    pathwayScores: [
      PathwayScore(
        pathwayId: pathwayId,
        label: pathwayLabel,
        mainProblemScore: 6,
        modifierScore: 2,
        routineRisk: routineRisk,
        triggerWeight: 7,
        score0To10: routineRisk,
        enabled: true,
        explanation: pathwayExplanation,
      ),
      PathwayScore(
        pathwayId: 'commute_scrolling',
        label: 'Commute Scrolling',
        mainProblemScore: 6,
        modifierScore: 2,
        routineRisk: routineRisk,
        triggerWeight: 7,
        score0To10: routineRisk,
        enabled: commutePhoneUseScore >= 2,
        explanation: 'Commute scrolling risk.',
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
      recoveryMomentum: 5,
      predictionAccuracy: 6,
      falseAlarmRate: 2,
      triggerReliabilityMap: const {'stress': 5},
      interventionRewardsMap: const {},
      lastUpdatedAt: baseTime,
    ),
    createdAt: baseTime,
    updatedAt: baseTime,
  );
}
