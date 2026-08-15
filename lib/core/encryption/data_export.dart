import 'dart:convert';
import 'dart:io';

import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/core/platform/safe_app_directories.dart';

class DataExport {
  final AppDatabase _db;

  DataExport(this._db);

  Future<String> exportAll() async {
    final users = await _db.select(_db.users).get();
    final peaks = await _db.select(_db.peakNodes).get();
    final checkins = await _db.select(_db.dailyCheckins).get();
    final urges = await _db.select(_db.urgeEvents).get();
    final slips = await _db.select(_db.slipEvents).get();
    final streaks = await _db.select(_db.streaks).get();
    final scores = await _db.select(_db.dailyScores).get();
    final achievements = await _db.select(_db.achievements).get();
    final reviews = await _db.select(_db.weeklyReviews).get();

    final data = {
      'exportDate': DateTime.now().toIso8601String(),
      'version': 1,
      'counts': {
        'users': users.length,
        'peaks': peaks.length,
        'checkins': checkins.length,
        'urgeEvents': urges.length,
        'slipEvents': slips.length,
        'streaks': streaks.length,
        'dailyScores': scores.length,
        'achievements': achievements.length,
        'weeklyReviews': reviews.length,
      },
    };

    final dir = await safeAppDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/detoxia_export_$timestamp.json');
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(data),
    );

    return file.path;
  }

  Future<void> deleteAll() async {
    await _db.delete(_db.users).go();
    await _db.delete(_db.peakNodes).go();
    await _db.delete(_db.riskWindows).go();
    await _db.delete(_db.dailyCheckins).go();
    await _db.delete(_db.urgeEvents).go();
    await _db.delete(_db.slipEvents).go();
    await _db.delete(_db.interventionLogs).go();
    await _db.delete(_db.triggerPosteriors).go();
    await _db.delete(_db.streaks).go();
    await _db.delete(_db.streakHistories).go();
    await _db.delete(_db.dailyScores).go();
    await _db.delete(_db.achievements).go();
    await _db.delete(_db.diversionTasks).go();
    await _db.delete(_db.weeklyReviews).go();
    await _db.delete(_db.progressiveProfiles).go();
    await _db.delete(_db.programProgresses).go();
    await _db.delete(_db.maintenanceStates).go();
    await _db.delete(_db.modelStates).go();
    await _db.delete(_db.passiveUsages).go();
    await _db.delete(_db.moodEntries).go();
    await _db.delete(_db.anxietyEvents).go();
    await _db.delete(_db.breathingLogs).go();
    await _db.delete(_db.exposureHierarchyItems).go();
    await _db.delete(_db.behavioralActivities).go();
    await _db.delete(_db.thoughtRecords).go();
    await _db.delete(_db.focusSessions).go();
    await _db.delete(_db.adhdDailyPlans).go();
    await _db.delete(_db.cycleEntries).go();
    await _db.delete(_db.cyclePredictions).go();
    await _db.delete(_db.dailyTaskAssignments).go();
    await _db.delete(_db.weeklyAssessments).go();
    await _db.delete(_db.questionnaireAnswers).go();
    await _db.delete(_db.questionnaireSessions).go();
    await _db.delete(_db.registrationProfiles).go();
  }
}
