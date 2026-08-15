import 'dart:convert';

import 'package:detoxia/data/database/app_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionnaireRepository {
  final AppDatabase _db;

  QuestionnaireRepository(this._db);

  Future<QuestionnaireSession?> getActiveSession() async {
    final sessions =
        await (_db.select(_db.questionnaireSessions)
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.updatedAt,
                  mode: OrderingMode.desc,
                ),
              ])
              ..limit(1))
            .get();
    return sessions.isEmpty ? null : sessions.first;
  }

  Future<QuestionnaireSession> ensureSession(int registrationProfileId) async {
    final active = await getActiveSession();
    if (active != null && !active.isCompleted) return active;

    final id = await _db
        .into(_db.questionnaireSessions)
        .insert(
          QuestionnaireSessionsCompanion(
            registrationProfileId: Value(registrationProfileId),
            currentSectionId: const Value('phase0'),
            currentQuestionId: const Value('questionnaire_start'),
            completedSectionsJson: const Value('[]'),
            answersJson: const Value('{}'),
          ),
        );

    return (_db.select(
      _db.questionnaireSessions,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> savePlaceholderProgress(int sessionId) async {
    await (_db.update(
      _db.questionnaireSessions,
    )..where((t) => t.id.equals(sessionId))).write(
      QuestionnaireSessionsCompanion(
        currentSectionId: const Value('phase0'),
        currentQuestionId: const Value('placeholder_continue'),
        completedSectionsJson: const Value('["signup"]'),
        answerCount: const Value(1),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> completePlaceholder(int sessionId) async {
    await savePlaceholderProgress(sessionId);
    await (_db.update(
      _db.questionnaireSessions,
    )..where((t) => t.id.equals(sessionId))).write(
      QuestionnaireSessionsCompanion(
        isCompleted: const Value(true),
        currentSectionId: const Value('support_map_placeholder'),
        currentQuestionId: const Value('complete'),
        completedSectionsJson: const Value('["signup","phase0"]'),
        completedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> saveAnswer({
    required int sessionId,
    required String sectionId,
    required String questionId,
    required Map<String, dynamic> answerJson,
  }) async {
    final existing =
        await (_db.select(_db.questionnaireAnswers)..where(
              (t) =>
                  t.sessionId.equals(sessionId) &
                  t.questionId.equals(questionId),
            ))
            .getSingleOrNull();
    final now = DateTime.now();
    final encoded = jsonEncode(answerJson);

    if (existing == null) {
      await _db
          .into(_db.questionnaireAnswers)
          .insert(
            QuestionnaireAnswersCompanion(
              sessionId: Value(sessionId),
              sectionId: Value(sectionId),
              questionId: Value(questionId),
              answerJson: Value(encoded),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    } else {
      await (_db.update(
        _db.questionnaireAnswers,
      )..where((t) => t.id.equals(existing.id))).write(
        QuestionnaireAnswersCompanion(
          sectionId: Value(sectionId),
          answerJson: Value(encoded),
          updatedAt: Value(now),
        ),
      );
    }
  }

  Future<List<QuestionnaireAnswer>> getAnswersForSession(int sessionId) {
    return (_db.select(
      _db.questionnaireAnswers,
    )..where((t) => t.sessionId.equals(sessionId))).get();
  }

  Future<QuestionnaireAnswer?> getAnswerForQuestion(
    int sessionId,
    String questionId,
  ) {
    return (_db.select(_db.questionnaireAnswers)..where(
          (t) =>
              t.sessionId.equals(sessionId) & t.questionId.equals(questionId),
        ))
        .getSingleOrNull();
  }

  Future<Map<String, dynamic>> getAnswersMap(int sessionId) async {
    final answers = await getAnswersForSession(sessionId);
    final mapped = <String, dynamic>{};
    for (final answer in answers) {
      mapped[answer.questionId] = _decodeJsonMap(answer.answerJson);
    }
    return mapped;
  }

  Future<void> updateSessionProgress({
    required int sessionId,
    required String sectionId,
    required String questionId,
    required List<String> completedSectionIds,
    required int answerCount,
  }) async {
    await (_db.update(
      _db.questionnaireSessions,
    )..where((t) => t.id.equals(sessionId))).write(
      QuestionnaireSessionsCompanion(
        currentSectionId: Value(sectionId),
        currentQuestionId: Value(questionId),
        completedSectionsJson: Value(jsonEncode(completedSectionIds)),
        answerCount: Value(answerCount),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> markCompleted(int sessionId) async {
    await (_db.update(
      _db.questionnaireSessions,
    )..where((t) => t.id.equals(sessionId))).write(
      QuestionnaireSessionsCompanion(
        isCompleted: const Value(true),
        completedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> markSafetyGateTriggered(int sessionId) async {
    // Store the safety gate flag within the session answersJson metadata.
    final session = await (_db.select(
      _db.questionnaireSessions,
    )..where((t) => t.id.equals(sessionId))).getSingleOrNull();
    if (session == null) {
      throw StateError('No questionnaire session found for id $sessionId.');
    }

    final metadata = _decodeJsonMap(session.answersJson);
    metadata['safetyGateTriggered'] = true;

    await (_db.update(
      _db.questionnaireSessions,
    )..where((t) => t.id.equals(sessionId))).write(
      QuestionnaireSessionsCompanion(
        answersJson: Value(jsonEncode(metadata)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> clearAllProgressForRegistration(int registrationProfileId) async {
    final sessions = await (_db.select(_db.questionnaireSessions)
          ..where((t) => t.registrationProfileId.equals(registrationProfileId)))
        .get();
    final sessionIds = sessions.map((session) => session.id).toList(growable: false);

    if (sessionIds.isNotEmpty) {
      await (_db.delete(_db.questionnaireAnswers)
            ..where((t) => t.sessionId.isIn(sessionIds)))
          .go();
    }
    await (_db.delete(_db.questionnaireSessions)
          ..where((t) => t.registrationProfileId.equals(registrationProfileId)))
        .go();
  }

  static Map<String, dynamic> _decodeJsonMap(String source) {
    final decoded = jsonDecode(source);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    throw const FormatException('Expected JSON object.');
  }
}

final questionnaireRepositoryProvider = Provider<QuestionnaireRepository>((
  ref,
) {
  return QuestionnaireRepository(ref.watch(databaseProvider));
});
