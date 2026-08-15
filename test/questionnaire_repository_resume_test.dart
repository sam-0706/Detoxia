import 'dart:convert';

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuestionnaireRepository resume extension', () {
    late AppDatabase db;
    late RegistrationRepository registrationRepository;
    late QuestionnaireRepository questionnaireRepository;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      registrationRepository = RegistrationRepository(db);
      questionnaireRepository = QuestionnaireRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('saveAnswer inserts then updates existing answer', () async {
      final session = await _createSession(
        registrationRepository,
        questionnaireRepository,
      );

      await questionnaireRepository.saveAnswer(
        sessionId: session.id,
        sectionId: 'intro',
        questionId: 'q1',
        answerJson: const {'selectedOptionId': 'a'},
      );

      var answers = await questionnaireRepository.getAnswersForSession(
        session.id,
      );
      expect(answers.length, 1);
      expect(answers.first.questionId, 'q1');
      expect(
        (jsonDecode(answers.first.answerJson) as Map)['selectedOptionId'],
        'a',
      );

      await questionnaireRepository.saveAnswer(
        sessionId: session.id,
        sectionId: 'intro',
        questionId: 'q1',
        answerJson: const {'selectedOptionId': 'b'},
      );

      answers = await questionnaireRepository.getAnswersForSession(session.id);
      expect(answers.length, 1);
      expect(
        (jsonDecode(answers.first.answerJson) as Map)['selectedOptionId'],
        'b',
      );
    });

    test('getAnswersForSession returns all answers for session', () async {
      final session = await _createSession(
        registrationRepository,
        questionnaireRepository,
      );

      await _saveAnswer(questionnaireRepository, session.id, 'q1', const {
        'value': 1,
      });
      await _saveAnswer(questionnaireRepository, session.id, 'q2', const {
        'value': 2,
      });

      final answers = await questionnaireRepository.getAnswersForSession(
        session.id,
      );
      final questionIds = answers.map((answer) => answer.questionId).toList();

      expect(answers.length, 2);
      expect(questionIds, containsAll(<String>['q1', 'q2']));
    });

    test('getAnswerForQuestion returns null when missing', () async {
      final session = await _createSession(
        registrationRepository,
        questionnaireRepository,
      );
      final answer = await questionnaireRepository.getAnswerForQuestion(
        session.id,
        'missing',
      );

      expect(answer, isNull);
    });

    test('getAnswersMap returns decoded answers keyed by questionId', () async {
      final session = await _createSession(
        registrationRepository,
        questionnaireRepository,
      );

      await _saveAnswer(questionnaireRepository, session.id, 'q1', const {
        'value': 1,
      });
      await _saveAnswer(questionnaireRepository, session.id, 'q2', const {
        'value': 2,
      });

      final map = await questionnaireRepository.getAnswersMap(session.id);

      expect(map.keys, containsAll(<String>['q1', 'q2']));
      expect(map['q1'], const {'value': 1});
      expect(map['q2'], const {'value': 2});
    });

    test('updateSessionProgress updates session fields', () async {
      final session = await _createSession(
        registrationRepository,
        questionnaireRepository,
      );

      await questionnaireRepository.updateSessionProgress(
        sessionId: session.id,
        sectionId: 'section1',
        questionId: 'question1',
        completedSectionIds: const ['intro', 'section1'],
        answerCount: 3,
      );

      final updated = await _getSession(db, session.id);
      expect(updated.currentSectionId, 'section1');
      expect(updated.currentQuestionId, 'question1');
      expect(updated.answerCount, 3);
      expect(_decodeStringList(updated.completedSectionsJson), const [
        'intro',
        'section1',
      ]);
    });

    test('markCompleted sets completion flags', () async {
      final session = await _createSession(
        registrationRepository,
        questionnaireRepository,
      );

      await questionnaireRepository.markCompleted(session.id);

      final updated = await _getSession(db, session.id);
      expect(updated.isCompleted, isTrue);
      expect(updated.completedAt, isNotNull);
    });

    test('round-trip resume state persists answers and progress', () async {
      final session = await _createSession(
        registrationRepository,
        questionnaireRepository,
      );

      await _saveAnswer(questionnaireRepository, session.id, 'q1', const {
        'value': 1,
      });
      await _saveAnswer(questionnaireRepository, session.id, 'q2', const {
        'value': 2,
      });
      await _saveAnswer(questionnaireRepository, session.id, 'q3', const {
        'value': 3,
      });

      await questionnaireRepository.updateSessionProgress(
        sessionId: session.id,
        sectionId: 'section2',
        questionId: 'q3',
        completedSectionIds: const ['intro', 'section1'],
        answerCount: 3,
      );

      final updated = await _getSession(db, session.id);
      final answersMap = await questionnaireRepository.getAnswersMap(
        session.id,
      );

      expect(updated.currentSectionId, 'section2');
      expect(updated.currentQuestionId, 'q3');
      expect(updated.answerCount, 3);
      expect(answersMap.length, 3);
      expect(answersMap['q3'], const {'value': 3});
    });
  });
}

Future<QuestionnaireSession> _createSession(
  RegistrationRepository registrationRepository,
  QuestionnaireRepository questionnaireRepository,
) async {
  final profile = await registrationRepository.saveLocalProfile(_input());
  return questionnaireRepository.ensureSession(profile.id);
}

Future<void> _saveAnswer(
  QuestionnaireRepository questionnaireRepository,
  int sessionId,
  String questionId,
  Map<String, dynamic> answer,
) {
  return questionnaireRepository.saveAnswer(
    sessionId: sessionId,
    sectionId: 'intro',
    questionId: questionId,
    answerJson: answer,
  );
}

Future<QuestionnaireSession> _getSession(AppDatabase db, int sessionId) {
  return (db.select(
    db.questionnaireSessions,
  )..where((t) => t.id.equals(sessionId))).getSingle();
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

List<String> _decodeStringList(String source) {
  final decoded = jsonDecode(source);
  if (decoded is List) {
    return List<String>.from(decoded);
  }
  throw const FormatException('Expected JSON list.');
}
