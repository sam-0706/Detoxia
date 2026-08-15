import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/support_profile_repository.dart';
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
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SupportProfileRepository', () {
    late AppDatabase db;
    late SupportProfileRepository repository;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repository = SupportProfileRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('saveProfile then getLatestProfile round-trips all fields', () async {
      final profile = _sampleProfile(
        registrationProfileId: 1,
        updatedAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
      );

      final saved = await repository.saveProfile(profile);
      final loaded = await repository.getLatestProfile(1);

      expect(loaded, isNotNull);
      expect(saved.toJson(), loaded!.toJson());

      final savedNoUpdated = _withoutKeys(saved.toJson(), const {
        'updatedAt',
        'createdAt',
      });
      final originalNoUpdated = _withoutKeys(profile.toJson(), const {
        'updatedAt',
        'createdAt',
      });
      expect(savedNoUpdated, originalNoUpdated);
      expect(saved.createdAt.isAtSameMomentAs(profile.createdAt), isTrue);
      expect(saved.updatedAt.isAfter(profile.updatedAt), isTrue);
    });

    test('saveProfile upserts by registrationProfileId', () async {
      final first = _sampleProfile(
        registrationProfileId: 2,
        selectedGoals: const ['scrolling'],
      );
      final second = _sampleProfile(
        registrationProfileId: 2,
        selectedGoals: const ['sleep'],
      );

      await repository.saveProfile(first);
      await repository.saveProfile(second);

      final rows = await (db.select(
        db.supportProfileSnapshots,
      )..where((t) => t.registrationProfileId.equals(2))).get();
      expect(rows.length, 1);

      final latest = await repository.getLatestProfile(2);
      expect(latest, isNotNull);
      expect(latest!.selectedGoals, const ['sleep']);
    });

    test('updateLearningState updates only learning state', () async {
      final profile = _sampleProfile(registrationProfileId: 3);
      await repository.saveProfile(profile);

      final updatedState = LearningState(
        recoveryMomentum: 6.0,
        predictionAccuracy: 7.0,
        falseAlarmRate: 3.0,
        triggerReliabilityMap: const {'stress': 6.0},
        interventionRewardsMap: const {'walk': 0.5},
        lastUpdatedAt: DateTime.parse('2026-05-19T12:00:00.000Z'),
      );

      await repository.updateLearningState(3, updatedState);

      final loaded = await repository.getLatestProfile(3);
      expect(loaded, isNotNull);
      expect(loaded!.learningState.toJson(), updatedState.toJson());

      final originalWithout = _withoutKeys(profile.toJson(), const {
        'updatedAt',
        'learningState',
        'createdAt',
      });
      final updatedWithout = _withoutKeys(loaded.toJson(), const {
        'updatedAt',
        'learningState',
        'createdAt',
      });
      expect(updatedWithout, originalWithout);
      expect(loaded.createdAt.isAtSameMomentAs(profile.createdAt), isTrue);
    });

    test('deleteAllForRegistration removes only targeted rows', () async {
      await repository.saveProfile(_sampleProfile(registrationProfileId: 10));
      await repository.saveProfile(_sampleProfile(registrationProfileId: 11));

      await repository.deleteAllForRegistration(10);

      final first = await repository.getLatestProfile(10);
      final second = await repository.getLatestProfile(11);

      expect(first, isNull);
      expect(second, isNotNull);
    });

    test('getLatestProfile returns null when no rows exist', () async {
      final profile = await repository.getLatestProfile(999);
      expect(profile, isNull);
    });
  });
}

SupportProfile _sampleProfile({
  required int registrationProfileId,
  List<String> selectedGoals = const ['scrolling', 'sleep'],
  DateTime? createdAt,
  DateTime? updatedAt,
  LearningState? learningState,
}) {
  final baseTime = createdAt ?? DateTime.parse('2026-05-01T00:00:00.000Z');
  final updatedTime = updatedAt ?? baseTime;

  return SupportProfile(
    registrationProfileId: registrationProfileId,
    selectedGoals: selectedGoals,
    domainScores: const [
      DomainScore(
        id: 'scrollingControl',
        label: 'Scrolling Control',
        rawScore: 6.0,
        maxRawScore: 15.0,
        visibleScore: 4.0,
        band: 'Mild',
        enabled: true,
        confidence: 1.0,
        explanation: 'Sample score',
      ),
    ],
    routineProfile: const RoutineProfile(
      wakeWindow: '6-7 AM',
      sleepAttemptWindow: '10-11 PM',
      sleepLatencyRange: '15-30 min',
      schoolWorkArrivalWindow: '8-9 AM',
      busyStartWindow: 'Morning',
      busyEndWindow: 'Evening',
      commuteToDuration: 22,
      commuteBackDuration: 30,
      commuteMode: 'bus',
      commutePhoneUseScore: 2,
      freeWindows: ['Evening'],
      aloneWindows: ['Late night'],
      phoneInBedScore: 3,
      vulnerableWindows: ['Before sleep'],
    ),
    sleepProfile: const SleepProfile(
      sleepAttemptWindow: '10-11 PM',
      wakeWindow: '6-7 AM',
      sleepLatencyRange: '15-30 min',
      estimatedSleepStartMinutes: 1380,
      estimatedWakeTimeMinutes: 390,
      estimatedSleepDurationHours: 6.5,
      targetSleepHours: 8.0,
      dailySleepDebtHours: 1.5,
      estimatedSevenDaySleepDebtHours: 10.5,
      sleepDebtScore: 7.5,
      sleepDisruptionScore: 4.0,
      sleepRiskScore: 5.4,
      confidence: 0.6,
    ),
    menstrualProfile: MenstrualProfile(
      enabled: true,
      lastPeriodStartDate: DateTime.parse('2026-04-20T00:00:00.000Z'),
      averageCycleLength: 28,
      averageBleedingLength: 5,
      regularity: 'regular',
      currentCycleDay: 12,
      currentPhase: MenstrualPhase.follicular,
      nextPeriodEstimate: DateTime.parse('2026-05-18T00:00:00.000Z'),
      confidence: 1.0,
      cycleSensitivityScore: 5.0,
    ),
    triggerWeights: [
      TriggerWeight(
        triggerId: 'trig_stress',
        label: 'Stress',
        strengthRaw: 3,
        weight0To10: 7.5,
        reliability: 0.8,
        lastUpdatedAt: DateTime.parse('2026-05-01T00:00:00.000Z'),
      ),
    ],
    pathwayScores: const [
      PathwayScore(
        pathwayId: 'scrolling',
        label: 'Scrolling',
        mainProblemScore: 6.0,
        modifierScore: 2.0,
        routineRisk: 5.0,
        triggerWeight: 7.0,
        score0To10: 6.1,
        enabled: true,
        explanation: 'Sample pathway',
      ),
    ],
    interventionPreferences: const InterventionPreferences(
      physicalReset: true,
      breathingGrounding: false,
      appFrictionDelay: false,
      journalingThoughtDump: true,
      focusSprint: true,
      sleepShutdown: false,
      spiritualValuesReset: false,
      lowPressureTask: true,
      directnessLevel: 'balanced',
    ),
    learningState:
        learningState ??
        LearningState(
          recoveryMomentum: 5.0,
          predictionAccuracy: 6.0,
          falseAlarmRate: 2.0,
          triggerReliabilityMap: const {'stress': 5.0},
          interventionRewardsMap: const {'walk': 0.1},
          lastUpdatedAt: DateTime.parse('2026-05-01T00:00:00.000Z'),
        ),
    createdAt: baseTime,
    updatedAt: updatedTime,
  );
}

Map<String, dynamic> _withoutKeys(Map<String, dynamic> json, Set<String> keys) {
  final copy = Map<String, dynamic>.from(json);
  for (final key in keys) {
    copy.remove(key);
  }
  return copy;
}
