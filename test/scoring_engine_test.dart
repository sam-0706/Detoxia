import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/domain/routine/models/menstrual_phase.dart';
import 'package:detoxia/domain/scoring/detoxia_scoring_engine.dart';
import 'package:detoxia/domain/scoring/score_band.dart';
import 'package:detoxia/domain/scoring/time_window_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizeScore', () {
    test('normalizes zero', () {
      expect(DetoxiaScoringEngine.normalizeScore(0, 15), closeTo(0.0, 0.01));
    });

    test('normalizes max to 10', () {
      expect(DetoxiaScoringEngine.normalizeScore(15, 15), closeTo(10.0, 0.01));
    });

    test('normalizes half max to 5', () {
      expect(DetoxiaScoringEngine.normalizeScore(7.5, 15), closeTo(5.0, 0.01));
    });

    test('returns zero when max is zero', () {
      expect(DetoxiaScoringEngine.normalizeScore(5, 0), closeTo(0.0, 0.01));
    });
  });

  group('scoreBand', () {
    test('maps low band boundaries', () {
      expect(scoreBand(0.0), 'Low');
      expect(scoreBand(2.4), 'Low');
    });

    test('maps mild band boundaries', () {
      expect(scoreBand(2.5), 'Mild');
      expect(scoreBand(4.9), 'Mild');
    });

    test('maps moderate band boundaries', () {
      expect(scoreBand(5.0), 'Moderate');
      expect(scoreBand(7.4), 'Moderate');
    });

    test('maps high band boundaries', () {
      expect(scoreBand(7.5), 'High');
      expect(scoreBand(10.0), 'High');
    });
  });

  group('domain scores', () {
    test('scrolling control min, max, and mixed scores', () {
      expect(
        DetoxiaScoringEngine.scoreScrollingControl([
          0,
          0,
          0,
          0,
          0,
        ]).visibleScore,
        closeTo(0.0, 0.01),
      );
      expect(
        DetoxiaScoringEngine.scoreScrollingControl([
          3,
          3,
          3,
          3,
          3,
        ]).visibleScore,
        closeTo(10.0, 0.01),
      );

      final mixed = DetoxiaScoringEngine.scoreScrollingControl([1, 2, 1, 2, 1]);
      expect(mixed.rawScore, closeTo(7.0, 0.01));
      expect(mixed.visibleScore, closeTo(4.67, 0.01));
      expect(mixed.band, 'Mild');
    });

    test('teen sexual-content control follows 5 item 0..3 shape', () {
      final score = DetoxiaScoringEngine.scoreSexualContentControl([
        1,
        2,
        1,
        2,
        1,
      ]);
      expect(score.id, 'sexualContentControl');
      expect(score.label, 'Sexual Content Control');
      expect(score.rawScore, closeTo(7.0, 0.01));
      expect(score.visibleScore, closeTo(4.67, 0.01));
    });

    test('adult sexual-control recovery follows 5 item 0..3 shape', () {
      final score = DetoxiaScoringEngine.scoreSexualControlRecovery([
        1,
        2,
        1,
        2,
        1,
      ]);
      expect(score.id, 'sexualControlRecovery');
      expect(score.label, 'Sexual Control Recovery');
      expect(score.rawScore, closeTo(7.0, 0.01));
      expect(score.visibleScore, closeTo(4.67, 0.01));
    });

    test('focus support min, max, and mixed scores', () {
      expect(
        DetoxiaScoringEngine.scoreFocusSupport([0, 0, 0, 0, 0, 0]).visibleScore,
        closeTo(0.0, 0.01),
      );
      expect(
        DetoxiaScoringEngine.scoreFocusSupport([4, 4, 4, 4, 4, 4]).visibleScore,
        closeTo(10.0, 0.01),
      );

      final mixed = DetoxiaScoringEngine.scoreFocusSupport([2, 3, 1, 2, 4, 0]);
      expect(mixed.rawScore, closeTo(12.0, 0.01));
      expect(mixed.visibleScore, closeTo(5.0, 0.01));
      expect(mixed.band, 'Moderate');
    });

    test('anxiety load max score', () {
      final score = DetoxiaScoringEngine.scoreAnxietyLoad([3, 3, 3, 3]);
      expect(score.rawScore, closeTo(12.0, 0.01));
      expect(score.visibleScore, closeTo(10.0, 0.01));
    });

    test('low mood support min score', () {
      final score = DetoxiaScoringEngine.scoreLowMoodSupport([0, 0, 0, 0]);
      expect(score.rawScore, closeTo(0.0, 0.01));
      expect(score.visibleScore, closeTo(0.0, 0.01));
    });

    test('sleep disruption min, max, and mixed scores', () {
      expect(
        DetoxiaScoringEngine.scoreSleepDisruption([0, 0, 0, 0, 0]).visibleScore,
        closeTo(0.0, 0.01),
      );
      expect(
        DetoxiaScoringEngine.scoreSleepDisruption([3, 3, 3, 3, 3]).visibleScore,
        closeTo(10.0, 0.01),
      );

      final mixed = DetoxiaScoringEngine.scoreSleepDisruption([1, 2, 1, 2, 1]);
      expect(mixed.rawScore, closeTo(7.0, 0.01));
      expect(mixed.visibleScore, closeTo(4.67, 0.01));
    });

    test('physical activation is inverted', () {
      expect(
        DetoxiaScoringEngine.scorePhysicalActivation([3, 4, 3]).visibleScore,
        closeTo(0.0, 0.01),
      );
      expect(
        DetoxiaScoringEngine.scorePhysicalActivation([0, 0, 0]).visibleScore,
        closeTo(10.0, 0.01),
      );
      expect(
        DetoxiaScoringEngine.scorePhysicalActivation([1, 2, 2]).visibleScore,
        closeTo(5.0, 0.01),
      );
    });

    test('cycle sensitivity min, max, and mixed scores', () {
      expect(
        DetoxiaScoringEngine.scoreCycleSensitivity([
          0,
          0,
          0,
          0,
          0,
          0,
          0,
        ]).visibleScore,
        closeTo(0.0, 0.01),
      );
      expect(
        DetoxiaScoringEngine.scoreCycleSensitivity([
          3,
          3,
          3,
          3,
          3,
          3,
          3,
        ]).visibleScore,
        closeTo(10.0, 0.01),
      );

      final mixed = DetoxiaScoringEngine.scoreCycleSensitivity([
        1,
        2,
        3,
        1,
        2,
        3,
        0,
      ]);
      expect(mixed.rawScore, closeTo(12.0, 0.01));
      expect(mixed.visibleScore, closeTo(5.71, 0.01));
    });

    test('invalid domain answer length throws', () {
      expect(
        () => DetoxiaScoringEngine.scoreScrollingControl([1, 2, 3]),
        throwsArgumentError,
      );
    });

    test('answer values are clamped to domain ranges', () {
      final score = DetoxiaScoringEngine.scoreScrollingControl([
        -1,
        4,
        3,
        0,
        2,
      ]);
      expect(score.rawScore, closeTo(8.0, 0.01));
      expect(score.visibleScore, closeTo(5.33, 0.01));
    });
  });

  group('sleep profile', () {
    test('adult sleep debt from windows matches golden value', () {
      final profile = DetoxiaScoringEngine.computeSleepProfile(
        wakeWindow: '6-7 AM',
        sleepAttemptWindow: '11 PM-12 AM',
        sleepLatencyRange: '15-30 min',
        wakeMidpointMinutes: 390,
        sleepAttemptMidpointMinutes: 1410,
        latencyMidpointMinutes: 22,
        sleepDisruptionScore: 4.0,
        ageBand: RegistrationAgeBand.adult18Plus,
      );

      expect(profile.estimatedSleepStartMinutes, 1432);
      expect(profile.estimatedSleepDurationHours, closeTo(6.633, 0.01));
      expect(profile.targetSleepHours, closeTo(8.0, 0.01));
      expect(profile.dailySleepDebtHours, closeTo(1.367, 0.01));
      expect(profile.estimatedSevenDaySleepDebtHours, closeTo(9.567, 0.01));
      expect(profile.sleepDebtScore, closeTo(6.83, 0.01));
      expect(profile.sleepRiskScore, closeTo(5.13, 0.01));
    });

    test('teen sleep debt clamps to 10 for same short sleep window', () {
      final profile = DetoxiaScoringEngine.computeSleepProfile(
        wakeWindow: '6-7 AM',
        sleepAttemptWindow: '11 PM-12 AM',
        sleepLatencyRange: '15-30 min',
        wakeMidpointMinutes: 390,
        sleepAttemptMidpointMinutes: 1410,
        latencyMidpointMinutes: 22,
        sleepDisruptionScore: 4.0,
        ageBand: RegistrationAgeBand.teen13To15,
      );

      expect(profile.targetSleepHours, closeTo(9.0, 0.01));
      expect(profile.dailySleepDebtHours, closeTo(2.367, 0.01));
      expect(profile.sleepDebtScore, closeTo(10.0, 0.01));
      expect(profile.sleepRiskScore, closeTo(6.4, 0.01));
    });

    test('sleep duration uses cross-midnight subtraction', () {
      expect(minutesBetweenAcrossMidnight(1432, 390), closeTo(6.633, 0.01));
      expect(minutesBetweenAcrossMidnight(1320, 360), closeTo(8.0, 0.01));
      expect(minutesBetweenAcrossMidnight(60, 180), closeTo(2.0, 0.01));
    });

    test('sleep confidence is low for flexible windows', () {
      final profile = DetoxiaScoringEngine.computeSleepProfile(
        wakeWindow: 'Flexible',
        sleepAttemptWindow: 'Flexible / changes daily',
        sleepLatencyRange: 'Variable',
        wakeMidpointMinutes: 480,
        sleepAttemptMidpointMinutes: 1380,
        latencyMidpointMinutes: 60,
        sleepDisruptionScore: 3.0,
        ageBand: RegistrationAgeBand.adult18Plus,
      );

      expect(profile.confidence, closeTo(0.3, 0.01));
    });
  });

  group('menstrual phase', () {
    final lastPeriod = DateTime(2026, 5, 1);

    test('28-day cycle day 15 is ovulation', () {
      final profile = DetoxiaScoringEngine.computeMenstrualPhase(
        enabled: true,
        today: lastPeriod.add(const Duration(days: 14)),
        lastPeriodStart: lastPeriod,
        averageCycleLength: 28,
        averageBleedingLength: 5,
        regularity: 'regular',
        cycleSensitivityScore: 6.0,
      );

      expect(profile.currentCycleDay, 15);
      expect(profile.currentPhase, MenstrualPhase.ovulation);
      expect(profile.confidence, closeTo(1.0, 0.01));
    });

    test('28-day cycle day 21 is luteal', () {
      final profile = DetoxiaScoringEngine.computeMenstrualPhase(
        enabled: true,
        today: lastPeriod.add(const Duration(days: 20)),
        lastPeriodStart: lastPeriod,
        averageCycleLength: 28,
        averageBleedingLength: 5,
        regularity: 'slightly',
        cycleSensitivityScore: 6.0,
      );

      expect(profile.currentCycleDay, 21);
      expect(profile.currentPhase, MenstrualPhase.luteal);
      expect(profile.confidence, closeTo(0.7, 0.01));
    });

    test('28-day cycle day 3 is menstruation', () {
      final profile = DetoxiaScoringEngine.computeMenstrualPhase(
        enabled: true,
        today: lastPeriod.add(const Duration(days: 2)),
        lastPeriodStart: lastPeriod,
        averageCycleLength: 28,
        averageBleedingLength: 5,
        regularity: 'very',
        cycleSensitivityScore: 6.0,
      );

      expect(profile.currentCycleDay, 3);
      expect(profile.currentPhase, MenstrualPhase.menstruation);
      expect(profile.confidence, closeTo(0.4, 0.01));
    });

    test('28-day cycle day 9 is follicular', () {
      final profile = DetoxiaScoringEngine.computeMenstrualPhase(
        enabled: true,
        today: lastPeriod.add(const Duration(days: 8)),
        lastPeriodStart: lastPeriod,
        averageCycleLength: 28,
        averageBleedingLength: 5,
        regularity: 'unsure',
        cycleSensitivityScore: 6.0,
      );

      expect(profile.currentCycleDay, 9);
      expect(profile.currentPhase, MenstrualPhase.follicular);
      expect(profile.confidence, closeTo(0.3, 0.01));
    });

    test('35-day cycle day 11 is follicular', () {
      final profile = DetoxiaScoringEngine.computeMenstrualPhase(
        enabled: true,
        today: lastPeriod.add(const Duration(days: 10)),
        lastPeriodStart: lastPeriod,
        averageCycleLength: 35,
        averageBleedingLength: 5,
        regularity: 'regular',
        cycleSensitivityScore: 6.0,
      );

      expect(profile.currentCycleDay, 11);
      expect(profile.currentPhase, MenstrualPhase.follicular);
    });

    test('disabled menstrual profile returns unknown phase', () {
      final profile = DetoxiaScoringEngine.computeMenstrualPhase(
        enabled: false,
        today: lastPeriod,
        lastPeriodStart: lastPeriod,
        averageCycleLength: 28,
        averageBleedingLength: 5,
        regularity: 'regular',
        cycleSensitivityScore: 6.0,
      );

      expect(profile.enabled, isFalse);
      expect(profile.currentPhase, MenstrualPhase.unknown);
      expect(profile.cycleSensitivityScore, closeTo(6.0, 0.01));
    });

    test('missing last period returns unknown phase', () {
      final profile = DetoxiaScoringEngine.computeMenstrualPhase(
        enabled: true,
        today: lastPeriod,
        lastPeriodStart: null,
        averageCycleLength: 28,
        averageBleedingLength: 5,
        regularity: 'regular',
        cycleSensitivityScore: 3.5,
      );

      expect(profile.enabled, isFalse);
      expect(profile.currentPhase, MenstrualPhase.unknown);
      expect(profile.cycleSensitivityScore, closeTo(3.5, 0.01));
    });
  });

  group('routine risk', () {
    test('all zero inputs produce zero risk', () {
      final risk = DetoxiaScoringEngine.computeRoutineRisk(
        freeTime: 0,
        aloneTime: 0,
        lateNight: 0,
        phoneAccess: 0,
        commuteIdle: 0,
        transitionStress: 0,
        pastRiskWindow: 0,
      );
      expect(risk, closeTo(0.0, 0.01));
    });

    test('all one inputs produce max risk', () {
      final risk = DetoxiaScoringEngine.computeRoutineRisk(
        freeTime: 1,
        aloneTime: 1,
        lateNight: 1,
        phoneAccess: 1,
        commuteIdle: 1,
        transitionStress: 1,
        pastRiskWindow: 1,
      );
      expect(risk, closeTo(10.0, 0.01));
    });

    test('free plus alone weighted check produces 4.0', () {
      final risk = DetoxiaScoringEngine.computeRoutineRisk(
        freeTime: 1,
        aloneTime: 1,
        lateNight: 0,
        phoneAccess: 0,
        commuteIdle: 0,
        transitionStress: 0,
        pastRiskWindow: 0,
      );
      expect(risk, closeTo(4.0, 0.01));
    });
  });

  group('pathway score', () {
    test('all max inputs produce max pathway score', () {
      final score = DetoxiaScoringEngine.computePathwayScore(
        pathwayId: 'p',
        label: 'Pathway',
        mainProblemScore: 10,
        modifierScore: 10,
        routineRisk: 10,
        triggerWeight: 10,
        explanation: 'golden',
      );
      expect(score.score0To10, closeTo(10.0, 0.01));
    });

    test('main problem only contributes 4.5', () {
      final score = DetoxiaScoringEngine.computePathwayScore(
        pathwayId: 'p',
        label: 'Pathway',
        mainProblemScore: 10,
        modifierScore: 0,
        routineRisk: 0,
        triggerWeight: 0,
        explanation: 'golden',
      );
      expect(score.score0To10, closeTo(4.5, 0.01));
    });

    test('mixed equal inputs preserve the same score', () {
      final score = DetoxiaScoringEngine.computePathwayScore(
        pathwayId: 'p',
        label: 'Pathway',
        mainProblemScore: 5,
        modifierScore: 5,
        routineRisk: 5,
        triggerWeight: 5,
        explanation: 'golden',
      );
      expect(score.score0To10, closeTo(5.0, 0.01));
    });
  });

  group('age gate sanity', () {
    test('scrolling score can be produced for all age bands', () {
      for (final ageBand in RegistrationAgeBand.values) {
        final score = DetoxiaScoringEngine.scoreScrollingControl([
          1,
          1,
          1,
          1,
          1,
        ]);
        expect(score.enabled, isTrue, reason: ageBand.name);
      }
    });

    test('sexual-content engine accepts answers when resolver allows them', () {
      final score = DetoxiaScoringEngine.scoreSexualContentControl([
        1,
        1,
        1,
        1,
        1,
      ]);
      expect(score.enabled, isTrue);
      expect(score.visibleScore, closeTo(3.33, 0.01));
    });
  });
}
