import 'dart:convert';

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/utils/time_utils.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/entities/peak_node.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeakRepository {
  final AppDatabase _db;

  PeakRepository(this._db);

  Future<List<PeakNodeEntity>> getAllPeaks() async {
    final rows = await _db.select(_db.peakNodes).get();
    return rows.map(_fromRow).toList();
  }

  Future<int> insertPeak(PeakNodeEntity peak) async {
    return await _db.into(_db.peakNodes).insert(PeakNodesCompanion(
          label: Value(peak.label),
          centerTime: Value(TimeUtils.formatTimeOfDay(peak.centerTime)),
          windowRadiusMinutes: Value(peak.windowRadiusMinutes),
          frequency: Value(peak.frequency.name),
          dayTypes: Value(jsonEncode(peak.dayTypes)),
          isHardest: Value(peak.isHardest),
          triggers: Value(
              jsonEncode(peak.triggers.map((t) => t.name).toList())),
          emotionalState: Value(jsonEncode(peak.emotionalState)),
          preContext: Value(jsonEncode(peak.preContext)),
        ));
  }

  Future<void> updatePeakStats(
    int peakId, {
    double? empiricalFrequency,
    double? avgIntensity,
    double? slipRate,
    int? currentPeakStreak,
    int? bestPeakStreak,
  }) async {
    await (_db.update(_db.peakNodes)
          ..where((t) => t.id.equals(peakId)))
        .write(PeakNodesCompanion(
      empiricalFrequency: empiricalFrequency != null
          ? Value(empiricalFrequency)
          : const Value.absent(),
      avgIntensity: avgIntensity != null
          ? Value(avgIntensity)
          : const Value.absent(),
      slipRate:
          slipRate != null ? Value(slipRate) : const Value.absent(),
      currentPeakStreak: currentPeakStreak != null
          ? Value(currentPeakStreak)
          : const Value.absent(),
      bestPeakStreak: bestPeakStreak != null
          ? Value(bestPeakStreak)
          : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> deleteAllPeaks() async {
    await _db.delete(_db.peakNodes).go();
  }

  PeakNodeEntity _fromRow(PeakNode row) {
    return PeakNodeEntity(
      id: row.id,
      label: row.label,
      centerTime: TimeUtils.parseTimeOfDay(row.centerTime),
      windowRadiusMinutes: row.windowRadiusMinutes,
      frequency: Frequency.values.firstWhere(
        (e) => e.name == row.frequency,
        orElse: () => Frequency.almostDaily,
      ),
      dayTypes:
          (jsonDecode(row.dayTypes) as List).cast<String>(),
      isHardest: row.isHardest,
      triggers: (jsonDecode(row.triggers) as List)
          .map((t) => TriggerType.values.firstWhere(
                (e) => e.name == t,
                orElse: () => TriggerType.other,
              ))
          .toList(),
      emotionalState:
          (jsonDecode(row.emotionalState) as List).cast<String>(),
      preContext:
          (jsonDecode(row.preContext) as List).cast<String>(),
      empiricalFrequency: row.empiricalFrequency,
      avgIntensity: row.avgIntensity,
      slipRate: row.slipRate,
      triggerPosteriors:
          (jsonDecode(row.triggerPosteriors) as Map<String, dynamic>)
              .map((k, v) => MapEntry(k, (v as num).toDouble())),
      topInterventions:
          (jsonDecode(row.topInterventions) as List).cast<String>(),
      currentPeakStreak: row.currentPeakStreak,
      bestPeakStreak: row.bestPeakStreak,
    );
  }
}

final peakRepositoryProvider = Provider<PeakRepository>((ref) {
  return PeakRepository(ref.watch(databaseProvider));
});
