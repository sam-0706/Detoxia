import 'dart:io';

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/domain/registration/signup_validation.dart';
import 'package:detoxia/services/registration_webhook_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Signup validation', () {
    test('1. name required', () {
      expect(SignupValidation.validateName(''), isNotNull);
      expect(SignupValidation.validateName('Sam'), isNull);
    });

    test('2. email required', () {
      expect(SignupValidation.validateEmail(''), isNotNull);
    });

    test('3. phone required', () {
      expect(SignupValidation.validatePhone(''), isNotNull);
    });

    test('4. valid email format', () {
      expect(SignupValidation.validateEmail('bad-email'), isNotNull);
      expect(SignupValidation.validateEmail('sam@example.com'), isNull);
    });

    test('5. age band required', () {
      expect(SignupValidation.validateRequired(null, 'Age band'), isNotNull);
      expect(
        SignupValidation.validateRequired(
          RegistrationAgeBand.adult18Plus,
          'Age band',
        ),
        isNull,
      );
    });

    test('6. gender required', () {
      expect(SignupValidation.validateRequired(null, 'Gender'), isNotNull);
      expect(
        SignupValidation.validateRequired(
          RegistrationGender.female,
          'Gender',
        ),
        isNull,
      );
    });

    test('7. privacy acknowledgement required', () {
      expect(SignupValidation.validatePrivacy(false), isNotNull);
      expect(SignupValidation.validatePrivacy(true), isNull);
    });
  });

  group('Registration persistence', () {
    late AppDatabase db;
    late RegistrationRepository registrationRepo;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      registrationRepo = RegistrationRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('8. appInstallId generated once and persisted', () async {
      final first = await registrationRepo.saveLocalProfile(_input());
      final second = await registrationRepo.saveLocalProfile(
        _input(displayName: 'Updated'),
      );

      expect(first.appInstallId, isNotEmpty);
      expect(second.appInstallId, first.appInstallId);
      expect(second.displayName, 'Updated');
    });

    test('9. signup completed state persists after repository restart', () async {
      await registrationRepo.saveLocalProfile(_input());
      final restartedRepo = RegistrationRepository(db);

      expect(await restartedRepo.isSignupCompleted(), isTrue);
    });
  });

  group('Webhook', () {
    late AppDatabase db;
    late RegistrationRepository registrationRepo;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      registrationRepo = RegistrationRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('10. local profile saved before webhook attempt', () async {
      final profile = await registrationRepo.saveLocalProfile(_input());
      expect(await registrationRepo.getProfile(), isNotNull);

      final status = await RegistrationWebhookService(
        url: 'https://example.com',
        httpPost: (uri, payload) async => 500,
      ).sync(profile);

      expect(status, WebhookSyncStatus.failed);
      expect(await registrationRepo.getProfile(), isNotNull);
    });

    test('11. empty webhook URL does not fail signup', () async {
      final profile = await registrationRepo.saveLocalProfile(_input());
      final status = await const RegistrationWebhookService().sync(profile);

      expect(status, WebhookSyncStatus.disabled);
    });

    test('12. failed webhook does not block questionnaire start', () async {
      final profile = await registrationRepo.saveLocalProfile(_input());
      final status = await RegistrationWebhookService(
        url: 'https://example.com',
        httpPost: (uri, payload) async => 503,
      ).sync(profile);
      await registrationRepo.updateWebhookStatus(profile.id, status);

      final questionnaireRepo = QuestionnaireRepository(db);
      final session = await questionnaireRepo.ensureSession(profile.id);

      expect(status, WebhookSyncStatus.failed);
      expect(session.isCompleted, isFalse);
    });

    test('13. successful webhook updates syncStatus', () async {
      final profile = await registrationRepo.saveLocalProfile(_input());
      final status = await RegistrationWebhookService(
        url: 'https://example.com',
        httpPost: (uri, payload) async => 200,
      ).sync(profile);
      await registrationRepo.updateWebhookStatus(profile.id, status);

      final updated = await registrationRepo.getProfile();
      expect(updated?.webhookSyncStatus, WebhookSyncStatus.success.name);
    });

    test('14. webhook payload excludes sensitive questionnaire fields', () async {
      final profile = await registrationRepo.saveLocalProfile(_input());
      final payload =
          const RegistrationWebhookService().buildPayload(profile);

      expect(payload.keys, isNot(contains('questionnaireAnswers')));
      expect(payload.keys, isNot(contains('adhdAnswers')));
      expect(payload.keys, isNot(contains('anxietyAnswers')));
      expect(payload.keys, isNot(contains('depressionAnswers')));
      expect(payload.keys, isNot(contains('sexualContentAnswers')));
      expect(payload.keys, isNot(contains('pornAnswers')));
      expect(payload.keys, isNot(contains('masturbationAnswers')));
      expect(payload.keys, isNot(contains('scrollingAnswers')));
      expect(payload.keys, isNot(contains('sleepAnswers')));
      expect(payload.keys, isNot(contains('menstrualCycleAnswers')));
      expect(payload.keys, isNot(contains('scores')));
      expect(payload.keys, isNot(contains('triggers')));
      expect(payload.keys, isNot(contains('pathwayScores')));
      expect(payload.keys, isNot(contains('dailyCheckins')));
      expect(payload.keys, isNot(contains('slips')));
      expect(payload.keys, isNot(contains('relapses')));
      expect(payload.keys, isNot(contains('appUsageLogs')));
    });
  });

  group('Questionnaire resume', () {
    late AppDatabase db;
    late RegistrationRepository registrationRepo;
    late QuestionnaireRepository questionnaireRepo;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      registrationRepo = RegistrationRepository(db);
      questionnaireRepo = QuestionnaireRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('15. signup done and questionnaire not complete resumes questionnaire',
        () async {
      final profile = await registrationRepo.saveLocalProfile(_input());
      final session = await questionnaireRepo.ensureSession(profile.id);

      expect(profile.signupCompletedAt, isNotNull);
      expect(session.isCompleted, isFalse);
      expect(session.currentSectionId, 'phase0');
    });

    test('16. signup done and questionnaire complete opens home state', () async {
      final profile = await registrationRepo.saveLocalProfile(_input());
      final session = await questionnaireRepo.ensureSession(profile.id);
      await questionnaireRepo.completePlaceholder(session.id);

      final completed = await questionnaireRepo.getActiveSession();
      expect(completed?.isCompleted, isTrue);
    });

    test('17. signup not done opens signup state', () async {
      expect(await registrationRepo.getProfile(), isNull);
      expect(await registrationRepo.isSignupCompleted(), isFalse);
    });

    test('18. partial questionnaire progress is saved', () async {
      final profile = await registrationRepo.saveLocalProfile(_input());
      final session = await questionnaireRepo.ensureSession(profile.id);
      await questionnaireRepo.savePlaceholderProgress(session.id);

      final updated = await questionnaireRepo.getActiveSession();
      expect(updated?.currentQuestionId, 'placeholder_continue');
      expect(updated?.answerCount, 1);
      expect(updated?.isCompleted, isFalse);
    });
  });

  group('Module hiding and preservation', () {
    test('19. condition select is not shown from app entry', () {
      final mainSource = File('lib/main.dart').readAsStringSync();
      expect(mainSource, isNot(contains('OnboardingScreen')));
      expect(mainSource, contains('SignupProfileScreen'));
    });

    test('20. old module cards are not shown on unified home', () {
      final homeSource =
          File('lib/presentation/home/home_screen.dart').readAsStringSync();
      expect(homeSource, isNot(contains('_buildActiveModuleCards')));
      expect(homeSource, isNot(contains('_navigateToModule')));
      expect(homeSource, contains('Map'));
      expect(homeSource, contains('Your trigger chain'));
    });

    test('21. old module files are not deleted', () {
      expect(Directory('lib/presentation/anxiety').existsSync(), isTrue);
      expect(Directory('lib/presentation/adhd').existsSync(), isTrue);
      expect(Directory('lib/presentation/depression').existsSync(), isTrue);
      expect(Directory('lib/presentation/mood').existsSync(), isTrue);
      expect(Directory('lib/presentation/period').existsSync(), isTrue);
    });

    test('22. Detox Recovery shell still works', () {
      final homeSource =
          File('lib/presentation/home/home_screen.dart').readAsStringSync();
      // The next-risky-window display moved out of a bespoke card and into
      // RightNowCard, which owns current level + what's ahead together.
      expect(homeSource, contains('RightNowCard'));
      expect(homeSource, contains('Daily Check-in'));
      expect(homeSource, contains('Rescue'));
    });
  });
}

SignupProfileInput _input({String displayName = 'Sam'}) {
  return SignupProfileInput(
    displayName: displayName,
    email: 'sam@example.com',
    phone: '+919999999999',
    ageBand: RegistrationAgeBand.adult18Plus,
    gender: RegistrationGender.female,
    countryCode: 'IN',
    regionName: 'India',
    timezone: 'Asia/Kolkata',
    privacyAcknowledged: true,
    marketingConsent: false,
  );
}
