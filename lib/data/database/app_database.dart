import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:detoxia/core/platform/safe_app_directories.dart';

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
  TextColumn get conditions =>
      text().withDefault(const Constant('["detoxRecovery"]'))();
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

// ─── Mood Entries ───
class MoodEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get moodLevel => integer()();
  IntColumn get energy => integer()();
  TextColumn get emotions => text().withDefault(const Constant('[]'))();
  TextColumn get activities => text().withDefault(const Constant('[]'))();
  TextColumn get socialContext => text().nullable()();
  TextColumn get note => text().nullable()();
}

// ─── Anxiety Events ───
class AnxietyEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get triggerSituation => text().nullable()();
  IntColumn get anxietyLevel => integer()();
  TextColumn get physicalSymptoms => text().withDefault(const Constant('[]'))();
  TextColumn get copingUsed => text().nullable()();
  IntColumn get anxietyAfter => integer().nullable()();
  BoolColumn get avoidanceBehavior =>
      boolean().withDefault(const Constant(false))();
}

// ─── Breathing Logs ───
class BreathingLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get technique => text()();
  IntColumn get durationSeconds => integer()();
  IntColumn get anxietyBefore => integer().nullable()();
  IntColumn get anxietyAfter => integer().nullable()();
}

// ─── Exposure Hierarchy ───
class ExposureHierarchyItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get situation => text()();
  IntColumn get fearRating => integer()();
  IntColumn get timesExposed => integer().withDefault(const Constant(0))();
  IntColumn get currentFearRating => integer().nullable()();
  BoolColumn get mastered => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─── Behavioral Activities (Depression) ───
class BehavioralActivities extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get activityType => text()();
  TextColumn get category => text()();
  IntColumn get pleasureRating => integer()();
  IntColumn get masteryRating => integer()();
  IntColumn get durationMinutes => integer()();
  BoolColumn get wasScheduled =>
      boolean().withDefault(const Constant(false))();
}

// ─── Thought Records (Depression CBT) ───
class ThoughtRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get situation => text()();
  TextColumn get automaticThought => text()();
  TextColumn get emotion => text()();
  IntColumn get emotionIntensity => integer()();
  TextColumn get evidenceFor => text().nullable()();
  TextColumn get evidenceAgainst => text().nullable()();
  TextColumn get balancedThought => text().nullable()();
  IntColumn get newIntensity => integer().nullable()();
  TextColumn get distortionType => text().nullable()();
}

// ─── Focus Sessions (ADHD) ───
class FocusSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  TextColumn get taskDescription => text()();
  IntColumn get focusRating => integer().nullable()();
  IntColumn get distractions => integer().withDefault(const Constant(0))();
  TextColumn get technique => text()();
}

// ─── ADHD Daily Plans ───
class AdhdDailyPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get top3Tasks => text().withDefault(const Constant('[]'))();
  TextColumn get completedTasks => text().withDefault(const Constant('[]'))();
  TextColumn get energyPattern => text().nullable()();
  TextColumn get bestFocusTime => text().nullable()();
}

// ─── Cycle Entries (Period Tracker) ───
class CycleEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get flowIntensity => integer().nullable()();
  TextColumn get symptoms => text().withDefault(const Constant('[]'))();
  IntColumn get mood => integer().nullable()();
  IntColumn get energy => integer().nullable()();
  IntColumn get cycleDay => integer().nullable()();
  TextColumn get phase => text().nullable()();
  TextColumn get notes => text().nullable()();
}

// ─── Cycle Predictions ───
class CyclePredictions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get predictedStart => dateTime()();
  DateTimeColumn get predictedEnd => dateTime()();
  DateTimeColumn get predictedOvulation => dateTime().nullable()();
  RealColumn get confidence => real().withDefault(const Constant(0.5))();
  IntColumn get basedOnCycles => integer().withDefault(const Constant(1))();
}

// ─── Daily Task Assignments ───
class DailyTaskAssignments extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get taskId => text()();
  TextColumn get taskTitle => text()();
  TextColumn get taskDescription => text()();
  TextColumn get conditionType => text()();
  TextColumn get category => text()();
  IntColumn get durationMinutes => integer()();
  TextColumn get scheduledTime => text()();
  BoolColumn get completed =>
      boolean().withDefault(const Constant(false))();
  IntColumn get effectivenessRating => integer().nullable()();
  BoolColumn get skipped =>
      boolean().withDefault(const Constant(false))();
}

// ─── Weekly Assessments (Depression PHQ-style) ───
class WeeklyAssessments extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get assessmentType => text()();
  IntColumn get totalScore => integer()();
  TextColumn get answers => text().withDefault(const Constant('[]'))();
  TextColumn get trend => text().nullable()();
}

class SupportProfileSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get registrationProfileId => integer()();
  TextColumn get selectedGoalsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get domainScoresJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get routineProfileJson =>
      text().withDefault(const Constant('{}'))();
  TextColumn get sleepProfileJson =>
      text().withDefault(const Constant('{}'))();
  TextColumn get menstrualProfileJson => text().nullable()();
  TextColumn get triggerWeightsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get pathwayScoresJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get interventionPreferencesJson =>
      text().withDefault(const Constant('{}'))();
  TextColumn get learningStateJson =>
      text().withDefault(const Constant('{}'))();
  DateTimeColumn get supportMapCompletedAt => dateTime().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─── Phase 0 Registration Profile ───
class RegistrationProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get appInstallId => text().unique()();
  TextColumn get displayName => text()();
  TextColumn get email => text()();
  TextColumn get phone => text()();
  TextColumn get ageBand => text()();
  TextColumn get gender => text()();
  TextColumn get countryCode => text()();
  TextColumn get regionName => text()();
  TextColumn get timezone => text()();
  BoolColumn get privacyAcknowledged => boolean()();
  BoolColumn get marketingConsent =>
      boolean().withDefault(const Constant(false))();
  TextColumn get webhookSyncStatus =>
      text().withDefault(const Constant('notAttempted'))();
  DateTimeColumn get webhookLastAttemptAt => dateTime().nullable()();
  DateTimeColumn get signupCompletedAt => dateTime().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─── Phase 0 Questionnaire Resume Shell ───
class QuestionnaireSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get registrationProfileId => integer()();
  TextColumn get currentSectionId =>
      text().withDefault(const Constant('intro'))();
  TextColumn get currentQuestionId =>
      text().withDefault(const Constant('start'))();
  TextColumn get completedSectionsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get answersJson =>
      text().withDefault(const Constant('{}'))();
  IntColumn get answerCount =>
      integer().withDefault(const Constant(0))();
  BoolColumn get isCompleted =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get startedAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

class QuestionnaireAnswers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer()();
  TextColumn get sectionId => text()();
  TextColumn get questionId => text()();
  TextColumn get answerJson => text()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
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
  MoodEntries,
  AnxietyEvents,
  BreathingLogs,
  ExposureHierarchyItems,
  BehavioralActivities,
  ThoughtRecords,
  FocusSessions,
  AdhdDailyPlans,
  CycleEntries,
  CyclePredictions,
  DailyTaskAssignments,
  WeeklyAssessments,
  SupportProfileSnapshots,
  RegistrationProfiles,
  QuestionnaireSessions,
  QuestionnaireAnswers,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

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
          if (from < 3) {
            await migrator.addColumn(users, users.conditions);
            await migrator.createTable(moodEntries);
            await migrator.createTable(anxietyEvents);
            await migrator.createTable(breathingLogs);
            await migrator.createTable(exposureHierarchyItems);
            await migrator.createTable(behavioralActivities);
            await migrator.createTable(thoughtRecords);
            await migrator.createTable(focusSessions);
            await migrator.createTable(adhdDailyPlans);
            await migrator.createTable(cycleEntries);
            await migrator.createTable(cyclePredictions);
            await migrator.createTable(dailyTaskAssignments);
            await migrator.createTable(weeklyAssessments);
          }
          if (from < 4) {
            await migrator.createTable(registrationProfiles);
            await migrator.createTable(questionnaireSessions);
            await migrator.createTable(questionnaireAnswers);
          }
          if (from < 5) {
            await migrator.createTable(supportProfileSnapshots);
          }
        },
      );

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await safeAppDocumentsDirectory();
      final file = File(p.join(dir.path, 'detoxia.db'));
      final parent = file.parent;
      if (!await parent.exists()) {
        await parent.create(recursive: true);
      }
      return NativeDatabase(file);
    });
  }
}

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
