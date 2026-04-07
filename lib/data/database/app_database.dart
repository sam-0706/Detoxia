import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ─── Users ───
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get country => text().withDefault(const Constant(''))();
  BoolColumn get checkedInToday =>
      boolean().withDefault(const Constant(false))();
  TextColumn get roleType => text()();
  TextColumn get workDays => text().withDefault(const Constant('[]'))();
  TextColumn get workStart => text().nullable()();
  TextColumn get workEnd => text().nullable()();
  TextColumn get weekdayWakeTime => text()();
  TextColumn get weekdaySleepTime => text()();
  TextColumn get offdayWakeTime => text()();
  TextColumn get offdaySleepTime => text()();
  TextColumn get struggles => text().withDefault(const Constant('[]'))();
  TextColumn get scrollingTriggersSexual =>
      text().withDefault(const Constant('never'))();
  TextColumn get triggers => text().withDefault(const Constant('[]'))();
  TextColumn get struggleDuration => text()();
  TextColumn get resistAbility => text()();
  TextColumn get goalType => text()();
  TextColumn get motivations => text().withDefault(const Constant('[]'))();
  BoolColumn get weekendDifferent =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─── Peak Nodes ───
class PeakNodes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
  TextColumn get centerTime => text()();
  IntColumn get windowRadiusMinutes =>
      integer().withDefault(const Constant(45))();
  TextColumn get frequency =>
      text().withDefault(const Constant('almostDaily'))();
  TextColumn get dayTypes =>
      text().withDefault(const Constant('["both"]'))();
  BoolColumn get isHardest =>
      boolean().withDefault(const Constant(false))();
  TextColumn get triggers => text().withDefault(const Constant('[]'))();
  TextColumn get emotionalState =>
      text().withDefault(const Constant('[]'))();
  TextColumn get preContext =>
      text().withDefault(const Constant('[]'))();
  RealColumn get empiricalFrequency =>
      real().withDefault(const Constant(0.0))();
  RealColumn get avgIntensity =>
      real().withDefault(const Constant(5.0))();
  RealColumn get slipRate =>
      real().withDefault(const Constant(0.5))();
  TextColumn get triggerPosteriors =>
      text().withDefault(const Constant('{}'))();
  TextColumn get topInterventions =>
      text().withDefault(const Constant('[]'))();
  IntColumn get currentPeakStreak =>
      integer().withDefault(const Constant(0))();
  IntColumn get bestPeakStreak =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─── Risk Windows ───
class RiskWindows extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dayType => text()();
  IntColumn get dayOfWeek => integer()();
  TextColumn get blockStart => text()();
  TextColumn get blockEnd => text()();
  IntColumn get nearestPeakId => integer().nullable()();
  RealColumn get heuristicScore =>
      real().withDefault(const Constant(0.0))();
  RealColumn get empiricalScore =>
      real().withDefault(const Constant(0.0))();
  RealColumn get blendedScore =>
      real().withDefault(const Constant(0.0))();
  RealColumn get alpha => real().withDefault(const Constant(0.0))();
  TextColumn get dominantTrigger => text().nullable()();
  TextColumn get topInterventions =>
      text().withDefault(const Constant('[]'))();
  IntColumn get observationCount =>
      integer().withDefault(const Constant(0))();
  IntColumn get urgeCount => integer().withDefault(const Constant(0))();
  IntColumn get slipCount => integer().withDefault(const Constant(0))();
  RealColumn get cascadeMultiplier =>
      real().withDefault(const Constant(1.0))();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─── Daily Check-ins ───
class DailyCheckins extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get hadUrge => boolean()();
  IntColumn get urgeMax => integer().nullable()();
  TextColumn get mainTrigger => text().nullable()();
  BoolColumn get slipped => boolean()();
  IntColumn get slipCount => integer().withDefault(const Constant(0))();
  IntColumn get sleepQuality => integer()();
  IntColumn get mood => integer()();
  IntColumn get stress => integer()();
  IntColumn get confidenceTomorrow => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─── Urge Events ───
class UrgeEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get source =>
      text().withDefault(const Constant('realtime'))();
  TextColumn get trigger => text()();
  TextColumn get contextTag => text().nullable()();
  TextColumn get location => text().nullable()();
  IntColumn get intensityBefore => integer()();
  TextColumn get chosenRescue => text().nullable()();
  IntColumn get intensityAfter => integer().nullable()();
  BoolColumn get slipFollowed =>
      boolean().withDefault(const Constant(false))();
  IntColumn get durationSeconds => integer().nullable()();
  TextColumn get rescueTasksUsed =>
      text().withDefault(const Constant('[]'))();
}

// ─── Slip Events ───
class SlipEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get source =>
      text().withDefault(const Constant('realtime'))();
  TextColumn get behaviorType => text()();
  TextColumn get triggerChain =>
      text().withDefault(const Constant('[]'))();
  TextColumn get locationContext => text().nullable()();
  BoolColumn get precededByScrolling =>
      boolean().withDefault(const Constant(false))();
  TextColumn get reflectionTag => text().nullable()();
  TextColumn get reflectionNote => text().nullable()();
}

// ─── Intervention Log ───
class InterventionLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get urgeEventId => integer().nullable()();
  TextColumn get interventionType => text()();
  BoolColumn get success => boolean()();
  IntColumn get intensityDrop => integer().nullable()();
  TextColumn get contextTimeOfDay => text().nullable()();
  TextColumn get contextLocation => text().nullable()();
  DateTimeColumn get timestamp =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─── Trigger Posteriors ───
class TriggerPosteriors extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get triggerName => text().unique()();
  IntColumn get urgeCount => integer().withDefault(const Constant(0))();
  IntColumn get slipCount => integer().withDefault(const Constant(0))();
  IntColumn get resistCount =>
      integer().withDefault(const Constant(0))();
  RealColumn get pSlipGivenTrigger =>
      real().withDefault(const Constant(0.5))();
  DateTimeColumn get lastUpdated =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─── Streaks ───
class Streaks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get streakType => text()();
  IntColumn get peakId => integer().nullable()();
  IntColumn get currentCount =>
      integer().withDefault(const Constant(0))();
  IntColumn get bestCount => integer().withDefault(const Constant(0))();
  IntColumn get lifetimeTotal =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get startedAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get brokenAt => dateTime().nullable()();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─── Streak History ───
class StreakHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get streakType => text()();
  IntColumn get peakId => integer().nullable()();
  IntColumn get length => integer()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();
  IntColumn get brokenBy => integer().nullable()();
}

// ─── Daily Scores ───
class DailyScores extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get dayOfWeek => integer()();
  RealColumn get streakScore =>
      real().withDefault(const Constant(0.0))();
  RealColumn get confidenceIndex =>
      real().withDefault(const Constant(0.0))();
  RealColumn get selfControlRating =>
      real().withDefault(const Constant(0.0))();
  RealColumn get vulnerabilityIndex =>
      real().withDefault(const Constant(0.0))();
  TextColumn get triggerSensitivity =>
      text().withDefault(const Constant('{}'))();
  RealColumn get recoveryMomentum =>
      real().withDefault(const Constant(0.0))();
  TextColumn get downstreamImpact =>
      text().withDefault(const Constant('{}'))();
  TextColumn get riskProfileHash => text().nullable()();
  TextColumn get dayType => text()();
  IntColumn get slipsToday =>
      integer().withDefault(const Constant(0))();
  IntColumn get urgesToday =>
      integer().withDefault(const Constant(0))();
  BoolColumn get hadSlipYesterday =>
      boolean().withDefault(const Constant(false))();
}

// ─── Achievements ───
class Achievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get achievementKey => text().unique()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get tier => text()();
  BoolColumn get unlocked =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get unlockedAt => dateTime().nullable()();
  BoolColumn get paused =>
      boolean().withDefault(const Constant(false))();
  IntColumn get timesEarned =>
      integer().withDefault(const Constant(0))();
}

// ─── Diversion Tasks ───
class DiversionTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get taskName => text()();
  TextColumn get category => text()();
  IntColumn get minDurationSeconds => integer()();
  IntColumn get maxDurationSeconds => integer()();
  TextColumn get contextFit =>
      text().withDefault(const Constant('{}'))();
  IntColumn get timesUsed => integer().withDefault(const Constant(0))();
  IntColumn get timesSucceeded =>
      integer().withDefault(const Constant(0))();
  RealColumn get effectivenessRate =>
      real().withDefault(const Constant(0.0))();
}

// ─── Weekly Reviews ───
class WeeklyReviews extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get weekStart => dateTime()();
  IntColumn get urgeCount => integer().withDefault(const Constant(0))();
  IntColumn get slipCount => integer().withDefault(const Constant(0))();
  RealColumn get avgSleep =>
      real().withDefault(const Constant(0.0))();
  RealColumn get avgStress =>
      real().withDefault(const Constant(0.0))();
  RealColumn get streakScoreStart =>
      real().withDefault(const Constant(0.0))();
  RealColumn get streakScoreEnd =>
      real().withDefault(const Constant(0.0))();
  RealColumn get confidenceStart =>
      real().withDefault(const Constant(0.0))();
  RealColumn get confidenceEnd =>
      real().withDefault(const Constant(0.0))();
  TextColumn get topTriggers =>
      text().withDefault(const Constant('[]'))();
  TextColumn get topInterventions =>
      text().withDefault(const Constant('[]'))();
  TextColumn get riskWindowsChanged =>
      text().withDefault(const Constant('[]'))();
  TextColumn get planAdjustments =>
      text().withDefault(const Constant('{}'))();
  TextColumn get planText => text().nullable()();
  TextColumn get momentum =>
      text().withDefault(const Constant('flat'))();
}

// ─── Progressive Profile ───
class ProgressiveProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get relationshipStatus => text().nullable()();
  TextColumn get mentalHealthFlag => text().nullable()();
  TextColumn get exerciseLevel => text().nullable()();
  TextColumn get previousQuitMethods =>
      text().withDefault(const Constant('[]'))();
  TextColumn get collectedAt =>
      text().withDefault(const Constant('{}'))();
}

// ─── Program Progress ───
class ProgramProgresses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get currentWeek => integer().withDefault(const Constant(1))();
  TextColumn get currentPhase =>
      text().withDefault(const Constant('baseline'))();
  TextColumn get programType =>
      text().withDefault(const Constant('initial12Week'))();
  TextColumn get modulesCompleted =>
      text().withDefault(const Constant('[]'))();
  TextColumn get boundariesSet =>
      text().withDefault(const Constant('[]'))();
  RealColumn get adherenceRate =>
      real().withDefault(const Constant(0.0))();
  RealColumn get paceModifier =>
      real().withDefault(const Constant(1.0))();
  TextColumn get adjustmentsLog =>
      text().withDefault(const Constant('[]'))();
  DateTimeColumn get graduatedAt => dateTime().nullable()();
  TextColumn get graduationOutcome => text().nullable()();
}

// ─── Maintenance State ───
class MaintenanceStates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get mode =>
      text().withDefault(const Constant('fullMaintenance'))();
  TextColumn get checkinCadence =>
      text().withDefault(const Constant('daily'))();
  TextColumn get notificationLevel =>
      text().withDefault(const Constant('moderate'))();
  TextColumn get regressionFlags =>
      text().withDefault(const Constant('[]'))();
  DateTimeColumn get lastQuarterlyReview => dateTime().nullable()();
  IntColumn get lifetimeCleanDays =>
      integer().withDefault(const Constant(0))();
  IntColumn get lifetimeUrgesResisted =>
      integer().withDefault(const Constant(0))();
  IntColumn get lifetimeRescuesCompleted =>
      integer().withDefault(const Constant(0))();
  RealColumn get recoveryScore =>
      real().withDefault(const Constant(0.0))();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─── Model State ───
class ModelStates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─── Passive Usage ───
class PassiveUsages extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get targetAppMinutes =>
      integer().withDefault(const Constant(0))();
  IntColumn get lateNightMinutes =>
      integer().withDefault(const Constant(0))();
  IntColumn get firstPickupDelayMinutes =>
      integer().withDefault(const Constant(0))();
  IntColumn get sessionCount =>
      integer().withDefault(const Constant(0))();
  RealColumn get reopenRate =>
      real().withDefault(const Constant(0.0))();
}

@DriftDatabase(tables: [
  Users,
  PeakNodes,
  RiskWindows,
  DailyCheckins,
  UrgeEvents,
  SlipEvents,
  InterventionLogs,
  TriggerPosteriors,
  Streaks,
  StreakHistories,
  DailyScores,
  Achievements,
  DiversionTasks,
  WeeklyReviews,
  ProgressiveProfiles,
  ProgramProgresses,
  MaintenanceStates,
  ModelStates,
  PassiveUsages,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(users, users.name);
            await migrator.addColumn(users, users.email);
            await migrator.addColumn(users, users.phone);
            await migrator.addColumn(users, users.country);
            await migrator.addColumn(users, users.checkedInToday);
          }
        },
      );

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'detoxia.db'));
      return NativeDatabase.createInBackground(file);
    });
  }
}

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
