import 'package:detoxia/domain/learning/models/intervention_feedback.dart';
import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/learning/models/outcome.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/routine/models/menstrual_profile.dart';
import 'package:detoxia/domain/routine/models/menstrual_phase.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

RoutineProfile _routineProfile({
  int? commuteToDuration,
  int? commuteBackDuration,
  String? commuteMode,
}) {
  return RoutineProfile(
    wakeWindow: '6–7 AM',
    sleepAttemptWindow: '10–11 PM',
    sleepLatencyRange: '15–30 min',
    schoolWorkArrivalWindow: commuteToDuration != null ? '8–9 AM' : null,
    busyStartWindow: commuteToDuration != null ? 'Morning' : null,
    busyEndWindow: commuteToDuration != null ? 'Evening' : null,
    commuteToDuration: commuteToDuration,
    commuteBackDuration: commuteBackDuration,
    commuteMode: commuteMode,
    commutePhoneUseScore: 2,
    freeWindows: ['Evening', 'Weekends'],
    aloneWindows: ['Late night', 'Bedroom time'],
    phoneInBedScore: 3,
    vulnerableWindows: ['Before sleep', 'Late night'],
  );
}

SleepProfile _sleepProfile() {
  return const SleepProfile(
    sleepAttemptWindow: '10–11 PM',
    wakeWindow: '6–7 AM',
    sleepLatencyRange: '15–30 min',
    estimatedSleepStartMinutes: 1380,
    estimatedWakeTimeMinutes: 390,
    estimatedSleepDurationHours: 6.8,
    targetSleepHours: 8.0,
    dailySleepDebtHours: 1.2,
    estimatedSevenDaySleepDebtHours: 8.4,
    sleepDebtScore: 4.2,
    sleepDisruptionScore: 5.0,
    sleepRiskScore: 4.6,
    confidence: 0.85,
  );
}

InterventionPreferences _interventionPreferences() {
  return const InterventionPreferences(
    physicalReset: true,
    breathingGrounding: true,
    appFrictionDelay: false,
    journalingThoughtDump: false,
    focusSprint: true,
    sleepShutdown: false,
    spiritualValuesReset: false,
    lowPressureTask: true,
    directnessLevel: 'balanced',
  );
}

LearningState _learningState() {
  return LearningState(
    recoveryMomentum: 5.0,
    predictionAccuracy: 7.0,
    falseAlarmRate: 2.5,
    triggerReliabilityMap: {'stress': 0.8, 'boredom': 0.6},
    interventionRewardsMap: {'physicalReset': 0.9, 'focusSprint': 0.7},
    lastUpdatedAt: DateTime.parse('2026-05-19T10:00:00.000Z'),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // 1. DomainScore JSON round-trip
  group('DomainScore', () {
    test('JSON round-trip', () {
      const score = DomainScore(
        id: 'scrollingControl',
        label: 'Scrolling Control',
        rawScore: 9.0,
        maxRawScore: 15.0,
        visibleScore: 6.0,
        band: 'Moderate',
        enabled: true,
        confidence: 0.9,
        explanation: 'Moderate difficulty controlling scrolling urges.',
      );

      final json = score.toJson();
      final restored = DomainScore.fromJson(json);

      expect(restored, equals(score));
    });

    test('bands constant contains expected values', () {
      expect(DomainScore.bands, ['Low', 'Mild', 'Moderate', 'High']);
    });
  });

  // 2. RoutineProfile round-trip — with and without commute
  group('RoutineProfile', () {
    test('round-trip with commute fields', () {
      final profile = _routineProfile(
        commuteToDuration: 30,
        commuteBackDuration: 45,
        commuteMode: 'bus_metro_train',
      );
      final restored = RoutineProfile.fromJson(profile.toJson());

      expect(restored.wakeWindow, profile.wakeWindow);
      expect(restored.commuteToDuration, 30);
      expect(restored.commuteBackDuration, 45);
      expect(restored.commuteMode, 'bus_metro_train');
      expect(restored.freeWindows, profile.freeWindows);
      expect(restored.vulnerableWindows, profile.vulnerableWindows);
    });

    test('round-trip with null commute fields', () {
      final profile = _routineProfile();
      final restored = RoutineProfile.fromJson(profile.toJson());

      expect(restored.commuteToDuration, isNull);
      expect(restored.commuteBackDuration, isNull);
      expect(restored.commuteMode, isNull);
      expect(restored.schoolWorkArrivalWindow, isNull);
      expect(restored.busyStartWindow, isNull);
      expect(restored.busyEndWindow, isNull);
    });
  });

  // 3. SleepProfile round-trip
  test('SleepProfile JSON round-trip', () {
    final profile = _sleepProfile();
    final restored = SleepProfile.fromJson(profile.toJson());

    expect(restored.estimatedSleepDurationHours,
        closeTo(profile.estimatedSleepDurationHours, 0.001));
    expect(restored.sleepDebtScore, closeTo(profile.sleepDebtScore, 0.001));
    expect(restored.confidence, closeTo(profile.confidence, 0.001));
    expect(restored.estimatedSleepStartMinutes,
        profile.estimatedSleepStartMinutes);
  });

  // 4. MenstrualProfile round-trip — enabled true and false
  group('MenstrualProfile', () {
    test('round-trip enabled: true', () {
      final profile = MenstrualProfile(
        enabled: true,
        lastPeriodStartDate: DateTime.parse('2026-05-01T00:00:00.000Z'),
        averageCycleLength: 28,
        averageBleedingLength: 5,
        regularity: 'regular',
        currentCycleDay: 18,
        currentPhase: MenstrualPhase.luteal,
        nextPeriodEstimate: DateTime.parse('2026-05-29T00:00:00.000Z'),
        confidence: 0.8,
        cycleSensitivityScore: 6.5,
      );

      final json = profile.toJson();
      final restored = MenstrualProfile.fromJson(json);

      expect(restored.enabled, isTrue);
      expect(restored.averageCycleLength, 28);
      expect(restored.currentPhase, MenstrualPhase.luteal);
      expect(
          restored.cycleSensitivityScore,
          closeTo(profile.cycleSensitivityScore, 0.001));
      expect(restored.lastPeriodStartDate?.toIso8601String(),
          profile.lastPeriodStartDate?.toIso8601String());
    });

    test('round-trip enabled: false (nullable fields null)', () {
      const profile = MenstrualProfile(
        enabled: false,
        currentPhase: MenstrualPhase.unknown,
        confidence: 0.0,
        cycleSensitivityScore: 0.0,
      );

      final restored = MenstrualProfile.fromJson(profile.toJson());

      expect(restored.enabled, isFalse);
      expect(restored.lastPeriodStartDate, isNull);
      expect(restored.nextPeriodEstimate, isNull);
      expect(restored.currentPhase, MenstrualPhase.unknown);
    });
  });

  // 5. TriggerWeight round-trip
  test('TriggerWeight JSON round-trip', () {
    final weight = TriggerWeight(
      triggerId: 'trig_stress',
      label: 'Stress',
      strengthRaw: 3,
      weight0To10: 7.5,
      reliability: 0.85,
      lastUpdatedAt: DateTime.parse('2026-05-19T08:00:00.000Z'),
    );

    final restored = TriggerWeight.fromJson(weight.toJson());

    expect(restored.triggerId, weight.triggerId);
    expect(restored.strengthRaw, weight.strengthRaw);
    expect(restored.weight0To10, closeTo(weight.weight0To10, 0.001));
    expect(restored.reliability, closeTo(weight.reliability, 0.001));
    expect(
        restored.lastUpdatedAt.toIso8601String(),
        weight.lastUpdatedAt.toIso8601String());
  });

  // 6. PathwayScore round-trip
  test('PathwayScore JSON round-trip', () {
    const pathway = PathwayScore(
      pathwayId: 'scrollingControl',
      label: 'Scrolling Control Pathway',
      mainProblemScore: 7.0,
      modifierScore: 2.0,
      routineRisk: 3.5,
      triggerWeight: 6.0,
      score0To10: 7.2,
      enabled: true,
      explanation: 'High scrolling tendency amplified by routine risk.',
    );

    final restored = PathwayScore.fromJson(pathway.toJson());

    expect(restored.pathwayId, pathway.pathwayId);
    expect(restored.score0To10, closeTo(pathway.score0To10, 0.001));
    expect(restored.enabled, isTrue);
  });

  // 7. InterventionPreferences round-trip
  test('InterventionPreferences JSON round-trip', () {
    final prefs = _interventionPreferences();
    final restored = InterventionPreferences.fromJson(prefs.toJson());

    expect(restored.physicalReset, isTrue);
    expect(restored.appFrictionDelay, isFalse);
    expect(restored.directnessLevel, 'balanced');
    expect(restored.focusSprint, isTrue);
  });

  // 8. LearningState round-trip with non-empty maps
  test('LearningState JSON round-trip with non-empty maps', () {
    final state = _learningState();
    final restored = LearningState.fromJson(state.toJson());

    expect(restored.recoveryMomentum, closeTo(5.0, 0.001));
    expect(restored.predictionAccuracy, closeTo(7.0, 0.001));
    expect(restored.triggerReliabilityMap['stress'], closeTo(0.8, 0.001));
    expect(restored.interventionRewardsMap['physicalReset'],
        closeTo(0.9, 0.001));
    expect(
        restored.lastUpdatedAt.toIso8601String(),
        state.lastUpdatedAt.toIso8601String());
  });

  // 9. SupportProfile full round-trip
  test('SupportProfile full JSON round-trip', () {
    final at = DateTime.parse('2026-05-19T09:00:00.000Z');

    final profile = SupportProfile(
      registrationProfileId: 1,
      selectedGoals: ['scrolling', 'sleep'],
      domainScores: [
        const DomainScore(
          id: 'scrollingControl',
          label: 'Scrolling Control',
          rawScore: 9.0,
          maxRawScore: 15.0,
          visibleScore: 6.0,
          band: 'Moderate',
          enabled: true,
          confidence: 0.9,
          explanation: 'Moderate.',
        ),
      ],
      routineProfile: _routineProfile(
        commuteToDuration: 22,
        commuteBackDuration: 22,
        commuteMode: 'walk',
      ),
      sleepProfile: _sleepProfile(),
      menstrualProfile: null,
      triggerWeights: [
        TriggerWeight(
          triggerId: 'trig_boredom',
          label: 'Boredom',
          strengthRaw: 2,
          weight0To10: 5.0,
          reliability: 0.7,
          lastUpdatedAt: at,
        ),
      ],
      pathwayScores: [
        const PathwayScore(
          pathwayId: 'scrollingControl',
          label: 'Scrolling',
          mainProblemScore: 6.0,
          modifierScore: 1.5,
          routineRisk: 3.0,
          triggerWeight: 5.0,
          score0To10: 6.5,
          enabled: true,
          explanation: 'High.',
        ),
      ],
      interventionPreferences: _interventionPreferences(),
      learningState: _learningState(),
      createdAt: at,
      updatedAt: at,
    );

    final json = profile.toJson();
    final restored = SupportProfile.fromJson(json);

    expect(restored.registrationProfileId, 1);
    expect(restored.selectedGoals, ['scrolling', 'sleep']);
    expect(restored.domainScores.length, 1);
    expect(restored.domainScores.first.id, 'scrollingControl');
    expect(restored.menstrualProfile, isNull);
    expect(restored.triggerWeights.length, 1);
    expect(restored.pathwayScores.first.score0To10, closeTo(6.5, 0.001));
    expect(restored.createdAt.toIso8601String(), at.toIso8601String());

    // scoreFor helper
    final found = restored.scoreFor('scrollingControl');
    expect(found, isNotNull);
    expect(found!.band, 'Moderate');
    expect(restored.scoreFor('doesNotExist'), isNull);
  });

  // 10. Outcome.value helpers
  group('Outcome.value', () {
    test('resisted returns +1.0', () {
      expect(Outcome.resisted.value, closeTo(1.0, 0.001));
    });

    test('slipped returns -1.0', () {
      expect(Outcome.slipped.value, closeTo(-1.0, 0.001));
    });

    test('noUrge returns +0.3', () {
      expect(Outcome.noUrge.value, closeTo(0.3, 0.001));
    });

    test('falseAlarm returns 0.0', () {
      expect(Outcome.falseAlarm.value, closeTo(0.0, 0.001));
    });
  });

  // 11. InterventionFeedback.reward helpers
  group('InterventionFeedback.reward', () {
    test('helped returns +1.0', () {
      expect(InterventionFeedback.helped.reward, closeTo(1.0, 0.001));
    });

    test('somewhat returns +0.5', () {
      expect(InterventionFeedback.somewhat.reward, closeTo(0.5, 0.001));
    });

    test('ignored returns 0.0', () {
      expect(InterventionFeedback.ignored.reward, closeTo(0.0, 0.001));
    });

    test('didNotHelp returns -0.5', () {
      expect(InterventionFeedback.didNotHelp.reward, closeTo(-0.5, 0.001));
    });

    test('slippedAfterTask returns -1.0', () {
      expect(
          InterventionFeedback.slippedAfterTask.reward, closeTo(-1.0, 0.001));
    });
  });
}
