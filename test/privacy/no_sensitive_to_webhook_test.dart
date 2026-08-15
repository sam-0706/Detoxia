import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/services/registration_webhook_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Registration webhook sensitive-data denylist', () {
    late AppDatabase db;
    late RegistrationRepository registrationRepository;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      registrationRepository = RegistrationRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('forbidden wellness and behavioral keys are not in payload', () async {
      final profile = await registrationRepository.saveLocalProfile(_input());
      final payload = const RegistrationWebhookService().buildPayload(profile);
      const forbiddenKeys = [
        'questionnaireAnswers',
        'adhdAnswers',
        'anxietyAnswers',
        'depressionAnswers',
        'sexualContentAnswers',
        'pornAnswers',
        'masturbationAnswers',
        'scrollingAnswers',
        'sleepAnswers',
        'menstrualCycleAnswers',
        'scores',
        'triggers',
        'pathwayScores',
        'dailyCheckins',
        'slips',
        'relapses',
        'resistedEvents',
        'noUrgeEvents',
        'falseAlarmEvents',
        'appUsageLogs',
        'riskWindows',
        'notificationDeliveries',
        'taskCompletions',
        'interventionPreferences',
      ];

      for (final key in forbiddenKeys) {
        expect(payload.keys, isNot(contains(key)), reason: key);
      }
    });
  });
}

SignupProfileInput _input() {
  return const SignupProfileInput(
    displayName: 'Test User',
    email: 'test@example.com',
    phone: '+15555551234',
    ageBand: RegistrationAgeBand.adult18Plus,
    gender: RegistrationGender.female,
    countryCode: 'US',
    regionName: 'CA',
    timezone: 'America/Los_Angeles',
    privacyAcknowledged: true,
    marketingConsent: false,
  );
}
