import 'dart:convert';

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventRepository {
  final AppDatabase _db;

  EventRepository(this._db);

  // ─── Urge Events ───

  Future<int> insertUrge({
    required DateTime timestamp,
    required TriggerType trigger,
    required int intensityBefore,
    String? contextTag,
    String? location,
    EventSource source = EventSource.realtime,
  }) async {
    return await _db.into(_db.urgeEvents).insert(UrgeEventsCompanion(
          timestamp: Value(timestamp),
          source: Value(source.name),
          trigger: Value(trigger.name),
          contextTag: Value(contextTag),
          location: Value(location),
          intensityBefore: Value(intensityBefore),
        ));
  }

  Future<void> updateUrgeOutcome(
    int urgeId, {
    required String chosenRescue,
    required int intensityAfter,
    required bool slipFollowed,
    int? durationSeconds,
    List<String>? rescueTasksUsed,
  }) async {
    await (_db.update(_db.urgeEvents)
          ..where((t) => t.id.equals(urgeId)))
        .write(UrgeEventsCompanion(
      chosenRescue: Value(chosenRescue),
      intensityAfter: Value(intensityAfter),
      slipFollowed: Value(slipFollowed),
      durationSeconds:
          durationSeconds != null ? Value(durationSeconds) : const Value.absent(),
      rescueTasksUsed: rescueTasksUsed != null
          ? Value(jsonEncode(rescueTasksUsed))
          : const Value.absent(),
    ));
  }

  Future<List<UrgeEvent>> getUrgesForDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (_db.select(_db.urgeEvents)
          ..where(
              (t) => t.timestamp.isBetweenValues(start, end)))
        .get();
  }

  Future<List<UrgeEvent>> getUrgesLastDays(int days) async {
    final since = DateTime.now().subtract(Duration(days: days));
    return (_db.select(_db.urgeEvents)
          ..where((t) => t.timestamp.isBiggerOrEqualValue(since)))
        .get();
  }

  // ─── Slip Events ───

  Future<int> insertSlip({
    required DateTime timestamp,
    required BehaviorType behaviorType,
    required List<TriggerType> triggerChain,
    required bool precededByScrolling,
    String? locationContext,
    String? reflectionNote,
    EventSource source = EventSource.realtime,
  }) async {
    return await _db.into(_db.slipEvents).insert(SlipEventsCompanion(
          timestamp: Value(timestamp),
          source: Value(source.name),
          behaviorType: Value(behaviorType.name),
          triggerChain: Value(
              jsonEncode(triggerChain.map((t) => t.name).toList())),
          precededByScrolling: Value(precededByScrolling),
          locationContext: Value(locationContext),
          reflectionNote: Value(reflectionNote),
        ));
  }

  Future<List<SlipEvent>> getSlipsForDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (_db.select(_db.slipEvents)
          ..where(
              (t) => t.timestamp.isBetweenValues(start, end)))
        .get();
  }

  Future<List<SlipEvent>> getSlipsLastDays(int days) async {
    final since = DateTime.now().subtract(Duration(days: days));
    return (_db.select(_db.slipEvents)
          ..where((t) => t.timestamp.isBiggerOrEqualValue(since)))
        .get();
  }

  Future<int> countSlipsInRange(DateTime start, DateTime end) async {
    final query = _db.select(_db.slipEvents)
      ..where((t) => t.timestamp.isBetweenValues(start, end));
    final results = await query.get();
    return results.length;
  }

  // ─── Daily Check-ins ───

  Future<int> insertCheckin({
    required DateTime date,
    required bool hadUrge,
    int? urgeMax,
    TriggerType? mainTrigger,
    required bool slipped,
    int slipCount = 0,
    required int sleepQuality,
    required int mood,
    required int stress,
    required int confidenceTomorrow,
    String? notes,
  }) async {
    return await _db
        .into(_db.dailyCheckins)
        .insert(DailyCheckinsCompanion(
          date: Value(date),
          hadUrge: Value(hadUrge),
          urgeMax: Value(urgeMax),
          mainTrigger: Value(mainTrigger?.name),
          slipped: Value(slipped),
          slipCount: Value(slipCount),
          sleepQuality: Value(sleepQuality),
          mood: Value(mood),
          stress: Value(stress),
          confidenceTomorrow: Value(confidenceTomorrow),
          notes: Value(notes),
        ));
  }

  Future<DailyCheckin?> getCheckinForDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (_db.select(_db.dailyCheckins)
          ..where((t) => t.date.isBetweenValues(start, end)))
        .getSingleOrNull();
  }

  Future<List<DailyCheckin>> getCheckinsLastDays(int days) async {
    final since = DateTime.now().subtract(Duration(days: days));
    return (_db.select(_db.dailyCheckins)
          ..where((t) => t.date.isBiggerOrEqualValue(since))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  // ─── Intervention Log ───

  Future<void> logIntervention({
    int? urgeEventId,
    required String interventionType,
    required bool success,
    int? intensityDrop,
  }) async {
    await _db
        .into(_db.interventionLogs)
        .insert(InterventionLogsCompanion(
          urgeEventId: Value(urgeEventId),
          interventionType: Value(interventionType),
          success: Value(success),
          intensityDrop: Value(intensityDrop),
        ));
  }
}

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository(ref.watch(databaseProvider));
});
