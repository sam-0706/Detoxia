import 'package:detoxia/data/database/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SupportProfileSnapshots table', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('table exists and starts empty', () async {
      final rows = await db.select(db.supportProfileSnapshots).get();
      expect(rows, isEmpty);
    });

    test('in-memory AppDatabase.forTesting opens and responds', () async {
      final result = await db.customSelect('SELECT 1 AS value').getSingle();
      expect(result.read<int>('value'), 1);
    });

    test('insert minimal companion and round-trip row', () async {
      final id = await db.into(db.supportProfileSnapshots).insert(
            SupportProfileSnapshotsCompanion.insert(
              registrationProfileId: 101,
            ),
          );

      final loaded = await (db.select(db.supportProfileSnapshots)
            ..where((tbl) => tbl.id.equals(id)))
          .getSingle();

      expect(loaded.id, id);
      expect(loaded.registrationProfileId, 101);
      expect(loaded.selectedGoalsJson, '[]');
      expect(loaded.domainScoresJson, '[]');
      expect(loaded.routineProfileJson, '{}');
      expect(loaded.sleepProfileJson, '{}');
      expect(loaded.triggerWeightsJson, '[]');
      expect(loaded.pathwayScoresJson, '[]');
      expect(loaded.interventionPreferencesJson, '{}');
      expect(loaded.learningStateJson, '{}');
      expect(loaded.menstrualProfileJson, isNull);
      expect(loaded.supportMapCompletedAt, isNull);
    });

    test('two rows support getSingleOrNull and full list reads', () async {
      final firstId = await db.into(db.supportProfileSnapshots).insert(
            SupportProfileSnapshotsCompanion.insert(
              registrationProfileId: 200,
            ),
          );

      final secondId = await db.into(db.supportProfileSnapshots).insert(
            SupportProfileSnapshotsCompanion.insert(
              registrationProfileId: 201,
              menstrualProfileJson: const Value('{"enabled":true}'),
            ),
          );

      final second = await (db.select(db.supportProfileSnapshots)
            ..where((tbl) => tbl.id.equals(secondId)))
          .getSingleOrNull();

      final allRows = await db.select(db.supportProfileSnapshots).get();

      expect(second, isNotNull);
      expect(second!.id, secondId);
      expect(second.registrationProfileId, 201);
      expect(second.menstrualProfileJson, '{"enabled":true}');

      expect(allRows.length, 2);
      expect(allRows.map((row) => row.id).toSet(), {firstId, secondId});
    });

    test('fresh schema v5 database opens without migration exceptions', () async {
      final rows = await db.select(db.supportProfileSnapshots).get();
      expect(rows, isEmpty);
    });
  });
}
