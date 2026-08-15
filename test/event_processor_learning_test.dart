import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/event_bus/event_bus.dart';
import 'package:detoxia/core/event_bus/events.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/event_repository.dart';
import 'package:detoxia/data/repositories/peak_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/support_profile_repository.dart';
import 'package:detoxia/data/repositories/user_repository.dart';
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
import 'package:detoxia/services/event_processor.dart';
import 'package:detoxia/services/learning_service.dart';
import 'package:detoxia/services/notification_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EventProcessor learning events', () {
    late AppDatabase db;
    late EventBus eventBus;
    late RegistrationRepository registrationRepo;
    late SupportProfileRepository profileRepo;
    late EventProcessor processor;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      eventBus = EventBus();
      registrationRepo = RegistrationRepository(db);
      profileRepo = SupportProfileRepository(db);
      processor = EventProcessor(
        eventBus: eventBus,
        eventRepo: EventRepository(db),
        userRepo: UserRepository(db),
        peakRepo: PeakRepository(db),
        notifService: NotificationService(),
        learningService: LearningService(
          profileRepo: profileRepo,
          registrationRepo: registrationRepo,
        ),
      )..start();
    });

    tearDown(() async {
      processor.dispose();
      eventBus.dispose();
      await db.close();
    });

    test(
      'firing RiskWindowOutcomeEvent causes learningService.applyRiskWindowOutcome to be called',
      () async {
        final registration = await _saveRegistration(registrationRepo);
        await profileRepo.saveProfile(
          _sampleProfile(registrationProfileId: registration.id),
        );

        eventBus.fire(
          RiskWindowOutcomeEvent(outcome: Outcome.resisted, predicted: true),
        );

        await _waitFor(() async {
          final loaded = await profileRepo.getLatestProfile(registration.id);
          return (loaded?.learningState.recoveryMomentum ?? 0) > 5.0;
        });
        final loaded = await profileRepo.getLatestProfile(registration.id);
        expect(loaded!.learningState.recoveryMomentum, closeTo(5.75, 0.001));
      },
    );

    test(
      'firing InterventionFeedbackEvent causes intervention reward update',
      () async {
        final registration = await _saveRegistration(registrationRepo);
        await profileRepo.saveProfile(
          _sampleProfile(registrationProfileId: registration.id),
        );

        eventBus.fire(
          InterventionFeedbackEvent(
            interventionId: 'breathing_reset',
            feedback: InterventionFeedback.helped,
          ),
        );

        await _waitFor(() async {
          final loaded = await profileRepo.getLatestProfile(registration.id);
          return loaded
                  ?.learningState
                  .interventionRewardsMap['breathing_reset'] !=
              null;
        });
        final loaded = await profileRepo.getLatestProfile(registration.id);
        expect(
          loaded!.learningState.interventionRewardsMap['breathing_reset'],
          closeTo(0.1, 0.001),
        );
      },
    );

    test(
      'RescueCompletedEvent passed increases momentum and rewards intervention',
      () async {
        final registration = await _saveRegistration(registrationRepo);
        await profileRepo.saveProfile(
          _sampleProfile(registrationProfileId: registration.id),
        );

        eventBus.fire(
          RescueCompletedEvent(
            urgeEventId: 0,
            interventionType: 'breathing_reset',
            intensityAfter: 1,
            outcome: UrgeOutcome.passed,
          ),
        );

        await _waitFor(() async {
          final loaded = await profileRepo.getLatestProfile(registration.id);
          return (loaded?.learningState.recoveryMomentum ?? 0) > 5.0;
        });
        final loaded = await profileRepo.getLatestProfile(registration.id);
        expect(loaded!.learningState.recoveryMomentum, closeTo(5.75, 0.001));
        expect(
          loaded.learningState.interventionRewardsMap['breathing_reset'],
          closeTo(0.1, 0.001),
        );
      },
    );

    test(
      'RescueCompletedEvent slipped updates learning without crashing',
      () async {
        final registration = await _saveRegistration(registrationRepo);
        await profileRepo.saveProfile(
          _sampleProfile(registrationProfileId: registration.id),
        );

        eventBus.fire(
          RescueCompletedEvent(
            urgeEventId: 0,
            interventionType: 'breathing_reset',
            intensityAfter: 5,
            outcome: UrgeOutcome.slipped,
          ),
        );

        await _waitFor(() async {
          final loaded = await profileRepo.getLatestProfile(registration.id);
          return (loaded?.learningState.recoveryMomentum ?? 0) < 5.0;
        });
        final loaded = await profileRepo.getLatestProfile(registration.id);
        expect(loaded!.learningState.recoveryMomentum, closeTo(4.25, 0.001));
        expect(
          loaded.learningState.interventionRewardsMap['breathing_reset'],
          closeTo(-0.1, 0.001),
        );
      },
    );

    test(
      'RescueCompletedEvent with interventionType "none" updates momentum without reward',
      () async {
        final registration = await _saveRegistration(registrationRepo);
        await profileRepo.saveProfile(
          _sampleProfile(registrationProfileId: registration.id),
        );

        eventBus.fire(
          RescueCompletedEvent(
            urgeEventId: 0,
            interventionType: 'none',
            intensityAfter: 5,
            outcome: UrgeOutcome.passed,
          ),
        );

        await _waitFor(() async {
          final loaded = await profileRepo.getLatestProfile(registration.id);
          return (loaded?.learningState.recoveryMomentum ?? 0) > 5.0;
        });
        final loaded = await profileRepo.getLatestProfile(registration.id);
        expect(loaded!.learningState.recoveryMomentum, closeTo(5.75, 0.001));
        // "none" must not appear in the intervention rewards map
        expect(
          loaded.learningState.interventionRewardsMap['none'],
          isNull,
        );
      },
    );
  });
}

Future<void> _waitFor(Future<bool> Function() predicate) async {
  final stopwatch = Stopwatch()..start();
  while (stopwatch.elapsed < const Duration(seconds: 2)) {
    if (await predicate()) return;
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
  fail('Timed out waiting for event processor update.');
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

SupportProfile _sampleProfile({required int registrationProfileId}) {
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
    learningState: LearningState(
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
