import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/support_profile_repository.dart';
import 'package:detoxia/domain/learning/models/intervention_feedback.dart';
import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/learning/models/outcome.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/routine/models/menstrual_phase.dart';
import 'package:detoxia/domain/routine/models/menstrual_profile.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/services/learning_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LearningService', () {
    late AppDatabase db;
    late RegistrationRepository registrationRepo;
    late SupportProfileRepository profileRepo;
    late LearningService service;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      registrationRepo = RegistrationRepository(db);
      profileRepo = SupportProfileRepository(db);
      service = LearningService(
        profileRepo: profileRepo,
        registrationRepo: registrationRepo,
      );
    });

    tearDown(() async {
      await db.close();
    });

    test(
      'applyRiskWindowOutcome(Outcome.resisted, predicted: true) increases recovery momentum and persists',
      () async {
        final registration = await _saveRegistration(registrationRepo);
        await profileRepo.saveProfile(
          _sampleProfile(registrationProfileId: registration.id),
        );

        final message = await service.applyRiskWindowOutcome(
          outcome: Outcome.resisted,
          predicted: true,
        );

        final loaded = await profileRepo.getLatestProfile(registration.id);
        expect(loaded, isNotNull);
        expect(loaded!.learningState.recoveryMomentum, closeTo(5.75, 0.001));
        expect(loaded.learningState.predictionAccuracy, closeTo(6.4, 0.001));
        expect(
          message,
          'You moved through a real support window. Recovery momentum +',
        );
      },
    );

    test(
      'applyRiskWindowOutcome(Outcome.slipped) decreases recovery momentum',
      () async {
        final registration = await _saveRegistration(registrationRepo);
        await profileRepo.saveProfile(
          _sampleProfile(registrationProfileId: registration.id),
        );

        final message = await service.applyRiskWindowOutcome(
          outcome: Outcome.slipped,
          predicted: true,
        );

        final loaded = await profileRepo.getLatestProfile(registration.id);
        expect(loaded!.learningState.recoveryMomentum, closeTo(4.25, 0.001));
        expect(message, 'Rough window — we adjust and continue.');
      },
    );

    test(
      'applyRiskWindowOutcome(Outcome.falseAlarm, predicted: true) increases false alarm rate',
      () async {
        final registration = await _saveRegistration(registrationRepo);
        await profileRepo.saveProfile(
          _sampleProfile(registrationProfileId: registration.id),
        );

        final message = await service.applyRiskWindowOutcome(
          outcome: Outcome.falseAlarm,
          predicted: true,
        );

        final loaded = await profileRepo.getLatestProfile(registration.id);
        expect(loaded!.learningState.falseAlarmRate, closeTo(2.8, 0.001));
        expect(
          message,
          "Tonight's alert was a false alarm. Detoxia will reduce similar interruptions.",
        );
      },
    );

    test(
      'applyInterventionFeedback(helped) increases intervention reward',
      () async {
        final registration = await _saveRegistration(registrationRepo);
        await profileRepo.saveProfile(
          _sampleProfile(registrationProfileId: registration.id),
        );

        final message = await service.applyInterventionFeedback(
          interventionId: 'breathing_reset',
          feedback: InterventionFeedback.helped,
        );

        final loaded = await profileRepo.getLatestProfile(registration.id);
        expect(
          loaded!.learningState.interventionRewardsMap['breathing_reset'],
          closeTo(0.1, 0.001),
        );
        expect(message, 'Saved. Detoxia will favor this kind of reset.');
      },
    );

    test(
      'multiple calls drift values correctly over time (EMA behavior)',
      () async {
        final registration = await _saveRegistration(registrationRepo);
        await profileRepo.saveProfile(
          _sampleProfile(registrationProfileId: registration.id),
        );

        await service.applyRiskWindowOutcome(
          outcome: Outcome.resisted,
          predicted: true,
        );
        await service.applyRiskWindowOutcome(
          outcome: Outcome.resisted,
          predicted: true,
        );
        await service.applyInterventionFeedback(
          interventionId: 'breathing_reset',
          feedback: InterventionFeedback.helped,
        );
        await service.applyInterventionFeedback(
          interventionId: 'breathing_reset',
          feedback: InterventionFeedback.helped,
        );

        final loaded = await profileRepo.getLatestProfile(registration.id);
        expect(loaded!.learningState.recoveryMomentum, closeTo(6.3875, 0.001));
        expect(
          loaded.learningState.interventionRewardsMap['breathing_reset'],
          closeTo(0.19, 0.001),
        );
      },
    );

    test('returned messages match expected strings', () async {
      expect(
        await service.applyRiskWindowOutcome(
          outcome: Outcome.noUrge,
          predicted: true,
        ),
        'No urge logged. Detoxia will recalibrate.',
      );
      expect(
        await service.applyInterventionFeedback(
          interventionId: 'breathing_reset',
          feedback: InterventionFeedback.somewhat,
        ),
        'Noted.',
      );
      expect(
        await service.applyInterventionFeedback(
          interventionId: 'breathing_reset',
          feedback: InterventionFeedback.didNotHelp,
        ),
        'Saved. Detoxia will rotate to a different reset.',
      );
      expect(
        await service.applyInterventionFeedback(
          interventionId: 'breathing_reset',
          feedback: InterventionFeedback.slippedAfterTask,
        ),
        "Rough window — we'll learn from this.",
      );
    });
  });
}

Future<RegistrationProfile> _saveRegistration(
  RegistrationRepository repository,
) {
  return repository.saveLocalProfile(
    const SignupProfileInput(
      displayName: 'Sam',
      email: 'sam@example.com',
      phone: '+15550000000',
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.preferNotToSay,
      countryCode: 'US',
      regionName: 'CA',
      timezone: 'America/Los_Angeles',
      privacyAcknowledged: true,
      marketingConsent: false,
    ),
  );
}

SupportProfile _sampleProfile({
  required int registrationProfileId,
  LearningState? learningState,
}) {
  final baseTime = DateTime.parse('2026-05-01T00:00:00.000Z');
  return SupportProfile(
    registrationProfileId: registrationProfileId,
    selectedGoals: const ['scrolling', 'sleep'],
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
        lastUpdatedAt: baseTime,
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
          interventionRewardsMap: const {},
          lastUpdatedAt: baseTime,
        ),
    createdAt: baseTime,
    updatedAt: baseTime,
  );
}
