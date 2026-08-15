import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/questionnaire/detoxia_question_bank.dart';
import 'package:detoxia/domain/questionnaire/question_visibility_resolver.dart';
import 'package:detoxia/domain/routine/models/menstrual_phase.dart';
import 'package:detoxia/presentation/questionnaire/support_map_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SupportMapBuilder builder;

  setUpAll(() async {
    final bank = await DetoxiaQuestionBank.loadFromAssets();
    builder = SupportMapBuilder(
      bank: bank,
      resolver: QuestionVisibilityResolver(bank),
    );
  });

  test(
    'support map builder integrates scoring, cycle, pathways, and triggers',
    () {
      final profile = builder.build(
        registration: _registration(
          ageBand: RegistrationAgeBand.adult18Plus,
          gender: RegistrationGender.female,
        ),
        answers: _answers(),
        now: DateTime(2026, 5, 19),
      );

      expect(profile.domainScores, hasLength(9));
      expect(
        profile.scoreFor('anxietyLoad')!.visibleScore,
        closeTo(10.0, 0.01),
      );
      expect(
        profile.scoreFor('scrollingControl')!.visibleScore,
        closeTo(6.67, 0.01),
      );
      expect(
        profile.scoreFor('cycleSensitivity')!.visibleScore,
        closeTo(6.67, 0.01),
      );
      expect(profile.menstrualProfile, isNotNull);
      expect(profile.menstrualProfile!.currentPhase, MenstrualPhase.luteal);

      expect(
        profile.pathwayScores.any(
          (pathway) =>
              pathway.pathwayId == 'anxietyLoadPathway' &&
              pathway.score0To10 > 0,
        ),
        isTrue,
      );

      final topTriggers = profile.triggerWeights
          .take(3)
          .map((trigger) => trigger.triggerId)
          .toSet();
      expect(
        topTriggers,
        containsAll(<String>{
          'trig_stress',
          'trig_anxiety',
          'trig_late_night_phone',
        }),
      );
    },
  );
}

RegistrationProfile _registration({
  required RegistrationAgeBand ageBand,
  required RegistrationGender gender,
}) {
  final now = DateTime(2026, 5, 19);
  return RegistrationProfile(
    id: 1,
    appInstallId: 'test-install',
    displayName: 'Test User',
    email: 'test@example.com',
    phone: '+15555550100',
    ageBand: ageBand.name,
    gender: gender.name,
    countryCode: 'US',
    regionName: 'CA',
    timezone: 'UTC',
    privacyAcknowledged: true,
    marketingConsent: false,
    webhookSyncStatus: WebhookSyncStatus.notAttempted.name,
    signupCompletedAt: now,
    createdAt: now,
    updatedAt: now,
  );
}

Map<String, dynamic> _answers() {
  final answers = <String, dynamic>{
    'goal_q1': {
      'selectedOptionIds': [
        'goal_scrolling',
        'goal_anxiety',
        'goal_sleep',
        'goal_cycle',
      ],
    },
    'routine_wake': {'selectedOptionId': 'wake_6_7', 'midpointMinutes': 390},
    'routine_sleep_attempt': {
      'selectedOptionId': 'sleep_11_12am',
      'midpointMinutes': 1410,
    },
    'routine_sleep_latency': {
      'selectedOptionId': 'latency_15_30',
      'midpointDurationMinutes': 22,
    },
    'routine_arrival': {'selectedOptionId': 'arrival_9_10'},
    'routine_busy_start': {'selectedOptionId': 'busy_start_morning'},
    'routine_busy_end': {'selectedOptionId': 'busy_end_evening'},
    'routine_commute_to': {
      'selectedOptionId': 'commute_to_15_30',
      'midpointDurationMinutes': 22,
    },
    'routine_commute_back': {
      'selectedOptionId': 'commute_back_15_30',
      'midpointDurationMinutes': 22,
    },
    'routine_commute_mode': {'selectedOptionId': 'mode_bus_metro_train'},
    'routine_commute_phone': {'selectedOptionId': 'p2', 'numericValue': 2},
    'routine_free_windows': {
      'selectedOptionIds': ['free_after_school_work', 'free_late_night'],
    },
    'routine_alone_windows': {
      'selectedOptionIds': ['alone_evening', 'alone_late_night'],
    },
    'routine_phone_in_bed': {'selectedOptionId': 'p2', 'numericValue': 2},
    'routine_vulnerable_windows': {
      'selectedOptionIds': ['vuln_after_work', 'vuln_late_night'],
    },
    for (final id in [
      'scroll_q1',
      'scroll_q2',
      'scroll_q3',
      'scroll_q4',
      'scroll_q5',
      'sxadult_q1',
      'sxadult_q2',
      'sxadult_q3',
      'sxadult_q4',
      'sxadult_q5',
      'mood_q1',
      'mood_q2',
      'mood_q3',
      'mood_q4',
      'sleep_q1',
      'sleep_q2',
      'sleep_q3',
      'sleep_q4',
      'sleep_q5',
      'cycle_q1',
      'cycle_q2',
      'cycle_q3',
      'cycle_q4',
      'cycle_q5',
      'cycle_q6',
      'cycle_q7',
    ])
      id: {'numericValue': 2},
    for (final id in ['anx_q1', 'anx_q2', 'anx_q3', 'anx_q4'])
      id: {'numericValue': 3},
    for (final id in [
      'focus_q1',
      'focus_q2',
      'focus_q3',
      'focus_q4',
      'focus_q5',
      'focus_q6',
    ])
      id: {'numericValue': 3},
    'phys_q1': {'selectedOptionId': 'p1'},
    'phys_q2': {'selectedOptionId': 'p2'},
    'phys_q3': {'selectedOptionId': 'p1'},
    'safety_q1': {'selectedOptionId': 'no'},
    'safety_q2': {'selectedOptionId': 'no'},
    'cycle_menstruation_gate': {'selectedOptionId': 'yes_or_unsure'},
    'cycle_pattern_gate': {'selectedOptionId': 'yes'},
    'mens_last_period_start': {'date': DateTime(2026, 5, 1).toIso8601String()},
    'mens_avg_cycle_length': {'selectedOptionId': 'cyc_25_28'},
    'mens_avg_bleeding_length': {'selectedOptionId': 'bld_4_5'},
    'mens_regularity': {'selectedOptionId': 'reg_regular'},
    'trig_select': {
      'selectedOptionIds': [
        'trig_stress',
        'trig_anxiety',
        'trig_late_night_phone',
      ],
    },
    'trig_strength_trig_stress': {'numericValue': 3},
    'trig_strength_trig_anxiety': {'numericValue': 3},
    'trig_strength_trig_late_night_phone': {'numericValue': 2},
    'path_scrolling': {
      'selectedOptionIds': ['p_scroll_anxiety'],
    },
    'path_sexual_adult': {
      'selectedOptionIds': ['p_adult_stress'],
    },
    'path_anxiety': {
      'selectedOptionIds': ['p_anx_checking'],
    },
    'path_low_mood': {
      'selectedOptionIds': ['p_mood_sleep'],
    },
    'path_cycle': {
      'selectedOptionIds': ['p_cycle_sleep_control'],
    },
    'intv_select': {
      'selectedOptionIds': ['intv_physical', 'intv_sleep_shutdown'],
    },
    'intv_directness': {'selectedOptionId': 'dir_balanced'},
  };
  return answers;
}
