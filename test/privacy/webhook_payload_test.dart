import 'dart:io';

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/services/registration_webhook_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Registration webhook payload privacy allowlist', () {
    late AppDatabase db;
    late RegistrationRepository registrationRepository;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      registrationRepository = RegistrationRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('buildPayload contains only registration profile fields', () async {
      final profile = await registrationRepository.saveLocalProfile(_input());
      final payload = const RegistrationWebhookService().buildPayload(profile);
      const allowedKeys = {
        'appInstallId',
        'displayName',
        'email',
        'phone',
        'ageBand',
        'gender',
        'countryCode',
        'regionName',
        'timezone',
        'privacyAcknowledged',
        'marketingConsent',
        'appVersion',
        'platform',
        'createdAt',
      };

      expect(payload.keys.toSet(), equals(allowedKeys));
      expect(payload['appVersion'], RegistrationWebhookService.appVersion);
      expect(payload['platform'], Platform.operatingSystem);
      expect(payload['createdAt'], profile.createdAt.toIso8601String());
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
