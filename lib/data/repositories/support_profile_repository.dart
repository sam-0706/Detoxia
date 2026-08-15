import 'dart:convert';

import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/routine/models/menstrual_profile.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupportProfileRepository {
  final AppDatabase _db;

  const SupportProfileRepository(this._db);

  Future<SupportProfile?> getLatestProfile(int registrationProfileId) async {
    final snapshot = await _getLatestSnapshotRow(registrationProfileId);
    if (snapshot == null) return null;
    return _mapSnapshot(snapshot);
  }

  Future<SupportProfile> saveProfile(SupportProfile profile) async {
    final now = DateTime.now();
    final existing = await _getLatestSnapshotRow(profile.registrationProfileId);

    final companion = _buildCompanion(
      profile,
      createdAt: existing?.createdAt ?? profile.createdAt,
      updatedAt: now,
    );

    if (existing == null) {
      await _db.into(_db.supportProfileSnapshots).insert(companion);
    } else {
      await (_db.update(
        _db.supportProfileSnapshots,
      )..where((t) => t.id.equals(existing.id))).write(companion);
    }

    final refreshed = await getLatestProfile(profile.registrationProfileId);
    if (refreshed == null) {
      throw StateError('Failed to read back support profile after save.');
    }
    return refreshed;
  }

  Future<void> updateLearningState(
    int registrationProfileId,
    LearningState state,
  ) async {
    final existing = await _getLatestSnapshotRow(registrationProfileId);
    if (existing == null) {
      throw StateError('No support profile found for registrationProfileId.');
    }

    await (_db.update(
      _db.supportProfileSnapshots,
    )..where((t) => t.id.equals(existing.id))).write(
      SupportProfileSnapshotsCompanion(
        learningStateJson: Value(jsonEncode(state.toJson())),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteAllForRegistration(int registrationProfileId) async {
    await (_db.delete(_db.supportProfileSnapshots)
          ..where((t) => t.registrationProfileId.equals(registrationProfileId)))
        .go();
  }

  Future<SupportProfileSnapshot?> _getLatestSnapshotRow(
    int registrationProfileId,
  ) {
    return (_db.select(_db.supportProfileSnapshots)
          ..where((t) => t.registrationProfileId.equals(registrationProfileId))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  SupportProfile _mapSnapshot(SupportProfileSnapshot snapshot) {
    return SupportProfile(
      registrationProfileId: snapshot.registrationProfileId,
      selectedGoals: _decodeStringList(snapshot.selectedGoalsJson),
      domainScores: _decodeList(
        snapshot.domainScoresJson,
        (json) => DomainScore.fromJson(json),
      ),
      routineProfile: RoutineProfile.fromJson(
        _decodeMap(snapshot.routineProfileJson),
      ),
      sleepProfile: SleepProfile.fromJson(
        _decodeMap(snapshot.sleepProfileJson),
      ),
      menstrualProfile: snapshot.menstrualProfileJson == null
          ? null
          : MenstrualProfile.fromJson(
              _decodeMap(snapshot.menstrualProfileJson!),
            ),
      triggerWeights: _decodeList(
        snapshot.triggerWeightsJson,
        (json) => TriggerWeight.fromJson(json),
      ),
      pathwayScores: _decodeList(
        snapshot.pathwayScoresJson,
        (json) => PathwayScore.fromJson(json),
      ),
      interventionPreferences: InterventionPreferences.fromJson(
        _decodeMap(snapshot.interventionPreferencesJson),
      ),
      learningState: LearningState.fromJson(
        _decodeMap(snapshot.learningStateJson),
      ),
      createdAt: snapshot.createdAt,
      updatedAt: snapshot.updatedAt,
    );
  }

  SupportProfileSnapshotsCompanion _buildCompanion(
    SupportProfile profile, {
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    return SupportProfileSnapshotsCompanion(
      registrationProfileId: Value(profile.registrationProfileId),
      selectedGoalsJson: Value(jsonEncode(profile.selectedGoals)),
      domainScoresJson: Value(
        jsonEncode(
          profile.domainScores.map((score) => score.toJson()).toList(),
        ),
      ),
      routineProfileJson: Value(jsonEncode(profile.routineProfile.toJson())),
      sleepProfileJson: Value(jsonEncode(profile.sleepProfile.toJson())),
      menstrualProfileJson: Value(
        profile.menstrualProfile == null
            ? null
            : jsonEncode(profile.menstrualProfile!.toJson()),
      ),
      triggerWeightsJson: Value(
        jsonEncode(
          profile.triggerWeights.map((weight) => weight.toJson()).toList(),
        ),
      ),
      pathwayScoresJson: Value(
        jsonEncode(
          profile.pathwayScores.map((score) => score.toJson()).toList(),
        ),
      ),
      interventionPreferencesJson: Value(
        jsonEncode(profile.interventionPreferences.toJson()),
      ),
      learningStateJson: Value(jsonEncode(profile.learningState.toJson())),
      supportMapCompletedAt: const Value(null),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  static Map<String, dynamic> _decodeMap(String json) {
    final decoded = jsonDecode(json);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }
    throw const FormatException('Expected JSON object.');
  }

  static List<String> _decodeStringList(String json) {
    final decoded = jsonDecode(json);
    if (decoded is List) {
      return List<String>.from(decoded);
    }
    throw const FormatException('Expected JSON list of strings.');
  }

  static List<T> _decodeList<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final decoded = jsonDecode(json);
    if (decoded is! List) {
      throw const FormatException('Expected JSON list.');
    }
    return decoded
        .map((item) => fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
}

final supportProfileRepositoryProvider = Provider<SupportProfileRepository>(
  (ref) => SupportProfileRepository(ref.watch(databaseProvider)),
);
