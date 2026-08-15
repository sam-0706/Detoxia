import 'dart:async';

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/motion/app_motion.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/core/utils/time_utils.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/event_repository.dart';
import 'package:detoxia/data/repositories/peak_repository.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/support_profile_repository.dart';
import 'package:detoxia/data/repositories/user_repository.dart';
import 'package:detoxia/domain/entities/peak_node.dart';
import 'package:detoxia/domain/entities/user_profile.dart';
import 'package:detoxia/domain/home/home_insight_view_model.dart';
import 'package:detoxia/domain/prediction/risk_calculator.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/domain/tasks/daily_task_scheduler.dart';
import 'package:detoxia/domain/tasks/task_utility_score.dart';
import 'package:detoxia/domain/tasks/unified_task_engine.dart';
import 'package:detoxia/presentation/daily_checkin/checkin_screen.dart';
import 'package:detoxia/presentation/dashboard/weekly_review/weekly_review_screen.dart';
import 'package:detoxia/presentation/dashboard/recovery_projection/projection_screen.dart';
import 'package:detoxia/presentation/dashboard/confidence_analysis/confidence_screen.dart';
import 'package:detoxia/presentation/dashboard/achievements/achievements_screen.dart';
import 'package:detoxia/presentation/program/program_screen.dart';
import 'package:detoxia/presentation/settings/settings_screen.dart';
import 'package:detoxia/presentation/urge_rescue/rescue_screen.dart';
import 'package:detoxia/domain/questionnaire/detoxia_question_bank.dart';
import 'package:detoxia/domain/questionnaire/question_visibility_resolver.dart';
import 'package:detoxia/domain/questionnaire/resolver_context.dart';
import 'package:detoxia/presentation/home/widgets/finish_setup_card.dart';
import 'package:detoxia/presentation/home/widgets/cycle_context_note.dart';
import 'package:detoxia/presentation/home/widgets/recovery_momentum_card.dart';
import 'package:detoxia/presentation/home/widgets/right_now_card.dart';
import 'package:detoxia/presentation/questionnaire/questionnaire_screen.dart';
import 'package:detoxia/presentation/questionnaire/support_map_screen.dart';
import 'package:detoxia/services/notification_service.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  UserProfile? _profile;
  SupportProfile? _supportProfile;
  List<RiskBlock> _todayBlocks = [];
  int _slipsToday = 0;
  int _urgesToday = 0;
  List<Map<String, dynamic>> _todayTasks = [];
  Set<String> _completedTaskIds = {};
  Map<String, String> _taskFeedbackById = {};
  bool _checkedInToday = false;
  HomeInsightViewModel? _homeInsights;

  /// Progress through the questions onboarding deferred.
  int _setupAnswered = 0;
  int _setupTotal = 0;
  int? _questionnaireSessionId;

  /// Drives the live parts of the dashboard — the "right now" level, the
  /// position of the now-marker on the timeline, and the countdown to the
  /// next hard window. Half-minute cadence is enough for minute-resolution
  /// copy and costs nothing.
  Timer? _ticker;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    final profile = await ref.read(userRepositoryProvider).getUser();
    if (profile == null) return;
    final registrationProfile = await ref
        .read(registrationRepositoryProvider)
        .getProfile();
    final supportProfile = registrationProfile == null
        ? null
        : await ref
              .read(supportProfileRepositoryProvider)
              .getLatestProfile(registrationProfile.id);

    List<PeakNodeEntity> peaks = [];
    int slipCount = 0;
    int urgeCount = 0;
    List<RiskBlock> blocks = [];
    final now = DateTime.now();

    if (profile.hasDetox) {
      peaks = await ref.read(peakRepositoryProvider).getAllPeaks();
      final slips = await ref
          .read(eventRepositoryProvider)
          .getSlipsForDate(now);
      final urges = await ref
          .read(eventRepositoryProvider)
          .getUrgesForDate(now);
      slipCount = slips.length;
      urgeCount = urges.length;

      final calculator = RiskCalculator(profile: profile, peaks: peaks);
      final state = RecentState(
        slipsToday: slipCount,
        recentSlip: slipCount > 0,
      );
      blocks = calculator.calculateDay(now.weekday, state);
    }

    final checkins = await ref.read(eventRepositoryProvider).getCheckinsLastDays(7);
    final checkinMaps = checkins
        .map(
          (row) => <String, dynamic>{
            'date': row.date,
            'slipped': row.slipped,
            'stress': row.stress,
            'mood': row.mood,
          },
        )
        .toList(growable: false);

    List<Map<String, dynamic>> tasks = [];
    List<TaskUtility> rankedTaskUtilities = const [];
    Set<String> completedIds = {};
    final conditions = profile.conditions.map((c) => c.name).toList();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    if (supportProfile != null) {
      rankedTaskUtilities = const UnifiedTaskEngine().selectTasks(
        profile: supportProfile,
        now: now,
        count: 5,
      );
      tasks = rankedTaskUtilities.map((utility) => utility.task).toList();
    } else {
      tasks = DailyTaskScheduler.selectTasks(
        activeConditions: conditions,
        dayOfYear: dayOfYear,
      );
    }

    final db = ref.read(databaseProvider);
    final today = DateTime(now.year, now.month, now.day);
    final completedRows =
        await (db.select(db.dailyTaskAssignments)
              ..where(
                (t) => t.date.isBetweenValues(
                  today,
                  today.add(const Duration(days: 1)),
                ),
              )
              ..where((t) => t.completed.equals(true)))
            .get();
    completedIds = completedRows.map((r) => r.taskId).toSet();

    final checkedIn = await ref
        .read(userRepositoryProvider)
        .hasCheckedInToday();
    final insights = const HomeInsightViewModelBuilder().build(
      now: now,
      displayName: profile.name,
      checkedInToday: checkedIn,
      supportProfile: supportProfile,
      dailyCheckins: checkinMaps,
      rankedTasks: rankedTaskUtilities,
    );

    if (mounted) {
      setState(() {
        _profile = profile;
        _supportProfile = supportProfile;
        _todayBlocks = blocks;
        _slipsToday = slipCount;
        _urgesToday = urgeCount;
        _todayTasks = tasks;
        _completedTaskIds = completedIds;
        _checkedInToday = checkedIn;
        _homeInsights = insights;
      });
    }

    await _loadSetupProgress(registrationProfile);

    if (supportProfile != null) {
      try {
        await ref
            .read(notificationServiceProvider)
            .scheduleUnifiedDailyPlan(supportProfile);
      } catch (_) {}
    }

    if (profile.hasDetox) {
      try {
        _scheduleCheckinReminders(profile);
      } catch (_) {}
    }
  }

  /// Counts how much of the *full* questionnaire this user still has ahead,
  /// resolved through the same visibility rules as the questionnaire itself —
  /// so the total only ever counts questions they'd actually be asked.
  Future<void> _loadSetupProgress(RegistrationProfile? registration) async {
    if (registration == null) return;
    try {
      final repo = ref.read(questionnaireRepositoryProvider);
      // Deliberately NOT ensureSession: that starts a fresh, empty session
      // once onboarding has been marked complete, which would read back zero
      // answers and re-ask everything the user already finished.
      final session = await repo.getActiveSession();
      if (session == null) return;
      final answers = await repo.getAnswersMap(session.id);
      final bank = await DetoxiaQuestionBank.loadFromAssets();

      final ctx = ResolverContext(
        ageBand: _ageBandFromString(registration.ageBand),
        gender: _genderFromString(registration.gender),
        selectedGoals: _goalsFromAnswers(answers),
        answers: answers,
      );
      final visible = QuestionVisibilityResolver(bank)
          .resolveVisibleSections(ctx)
          .expand((section) => section.questions)
          .toList(growable: false);

      if (!mounted) return;
      setState(() {
        _questionnaireSessionId = session.id;
        _setupTotal = visible.length;
        _setupAnswered = visible
            .where((q) => answers.containsKey(q.questionId))
            .length;
      });
    } catch (_) {
      // Progress is a nicety — never let it break the dashboard.
    }
  }

  List<String> _goalsFromAnswers(Map<String, dynamic> answers) {
    final goal = answers['goal_q1'];
    if (goal is Map) {
      final ids = goal['selectedOptionIds'];
      if (ids is List) return ids.map((e) => '$e').toList(growable: false);
      final one = goal['selectedOptionId'];
      if (one is String) return [one];
    }
    return const [];
  }

  RegistrationAgeBand _ageBandFromString(String value) => switch (value) {
    'teen13To15' => RegistrationAgeBand.teen13To15,
    'teen16To17' => RegistrationAgeBand.teen16To17,
    _ => RegistrationAgeBand.adult18Plus,
  };

  RegistrationGender _genderFromString(String value) => switch (value) {
    'male' => RegistrationGender.male,
    'female' => RegistrationGender.female,
    _ => RegistrationGender.preferNotToSay,
  };

  Future<void> _openDeferredQuestions() async {
    final sessionId = _questionnaireSessionId;
    final profileId = _profile == null ? null : await _registrationId();
    if (sessionId == null || profileId == null) return;
    if (!mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuestionnaireScreen(
          profileId: profileId,
          sessionId: sessionId,
          // No tier: pick up everything that was deferred.
        ),
      ),
    );
    await _loadData();
  }

  Future<int?> _registrationId() async {
    final registration =
        await ref.read(registrationRepositoryProvider).getProfile();
    return registration?.id;
  }

  Future<void> _openCheckIn() async {
    if (_checkedInToday) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check-in already done for today.')),
      );
      return;
    }
    final completed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const CheckinScreen()),
    );
    if (completed == true) {
      setState(() => _checkedInToday = true);
    }
  }

  Future<void> _openFullSupportMap() async {
    final registration = await ref.read(registrationRepositoryProvider).getProfile();
    final session = await ref.read(questionnaireRepositoryProvider).getActiveSession();
    if (!mounted) return;

    if (registration == null || session == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Support Map is not ready yet.')),
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SupportMapScreen(
          profileId: registration.id,
          sessionId: session.id,
        ),
      ),
    );
  }

  void _scheduleCheckinReminders(UserProfile profile) {
    final now = DateTime.now();
    final isOffDay = profile.isOffDay(now.weekday);
    final sleepTime = isOffDay
        ? profile.offdaySleepTime
        : profile.weekdaySleepTime;
    var sleepDT = DateTime(
      now.year,
      now.month,
      now.day,
      sleepTime.hour,
      sleepTime.minute,
    );
    if (sleepDT.isBefore(now.subtract(const Duration(hours: 6)))) {
      sleepDT = sleepDT.add(const Duration(days: 1));
    }
    ref.read(notificationServiceProvider).scheduleCheckinReminders(sleepDT);
  }

  Future<void> _completeTask(Map<String, dynamic> task) async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    await db
        .into(db.dailyTaskAssignments)
        .insert(
          DailyTaskAssignmentsCompanion(
            date: Value(today),
            taskId: Value(task['id'] as String),
            taskTitle: Value(task['title'] as String),
            taskDescription: Value(task['description'] as String),
            conditionType: Value(task['conditionType'] as String),
            category: Value(task['category'] as String),
            durationMinutes: Value(task['durationMinutes'] as int),
            scheduledTime: Value(task['timeOfDay'] as String),
            completed: const Value(true),
          ),
        );

    setState(() {
      _completedTaskIds.add(task['id'] as String);
    });
  }

  void _recordTaskFeedback(String taskId, String feedback) {
    setState(() {
      _taskFeedbackById = {..._taskFeedbackById, taskId: feedback};
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saved locally. Tomorrow\'s plan will adapt.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The "next hard window" search moved into RightNowCard, which owns both
    // the current level and what's ahead.
    final hasDetox = _profile?.hasDetox ?? false;

    return Scaffold(
      body: SafeArea(
        child: _profile == null
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadData,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: [
                    for (final (i, block) in _dashboardBlocks(hasDetox).indexed)
                      FadeSlideIn(index: i, child: block),
                  ],
                ),
              ),
      ),
      floatingActionButton: hasDetox
          ? FloatingActionButton.extended(
              onPressed: () => _openResetFlow(context),
              icon: const Icon(Icons.restart_alt),
              label: Text(_homeInsights?.primaryResetCta.label ?? 'Help me reset'),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: AppTheme.palette(context).textTertiary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'Rescue'),
          BottomNavigationBarItem(icon: Icon(Icons.radar), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'Review'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RescueScreen()),
              );
            case 2:
              _openFullSupportMap();
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WeeklyReviewScreen()),
              );
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
          }
        },
      ),
    );
  }

  /// The dashboard, as an ordered list of blocks.
  ///
  /// Built as a list rather than inline so each block can be staggered in, and
  /// so the running order is readable in one place instead of buried in a
  /// hundred lines of nested `if` spreads.
  List<Widget> _dashboardBlocks(bool hasDetox) {
    final showsSetup = _setupTotal > _setupAnswered;
    final showsCycle = _supportProfile?.menstrualProfile?.enabled ?? false;

    return [
      _buildHeader(),
      const SizedBox(height: 26),

      // Live state leads: the reason to open this app at 11pm is "what is
      // happening to me right now", not a menu.
      if (hasDetox && _todayBlocks.isNotEmpty) ...[
        RightNowCard(
          blocks: _todayBlocks,
          now: _now,
          onAct: () => _openResetFlow(context),
        ),
        const SizedBox(height: 14),
      ],
      if (hasDetox) ...[
        _buildTodaySoFar(),
        const SizedBox(height: 28),
      ],

      if (showsSetup) ...[
        FinishSetupCard(
          answered: _setupAnswered,
          total: _setupTotal,
          onContinue: _openDeferredQuestions,
        ),
        const SizedBox(height: 28),
      ],

      _sectionLabel('Today'),
      _buildCurrentStateCard(),
      const SizedBox(height: 12),
      _buildTodayResetPlan(),
      const SizedBox(height: 28),

      if (hasDetox || showsCycle) ...[
        _sectionLabel('Your patterns'),
        if (hasDetox) ...[
          _buildTriggerChainPreview(),
          const SizedBox(height: 12),
        ],
        _buildRecoveryMomentum(),
        if (showsCycle) ...[
          const SizedBox(height: 12),
          CycleContextNote(profile: _supportProfile!),
        ],
        const SizedBox(height: 28),
      ],

      _sectionLabel('More'),
      _buildSecondaryNav(),
    ];
  }

  /// Hero header: greeting, date, and the one line of framing.
  ///
  /// The check-in control used to live here *and* in its own card below —
  /// two buttons for the same action, which is a large part of why the
  /// dashboard read as noise. It now lives only in the check-in card.
  Widget _buildHeader() {
    final p = AppTheme.palette(context);
    final greeting = _homeInsights?.greeting;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            p.accent.withValues(alpha: p.isDark ? 0.20 : 0.13),
            p.calm.withValues(alpha: p.isDark ? 0.10 : 0.07),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (greeting?.dateLabel ??
                    '${TimeUtils.dayName(DateTime.now().weekday)}, ${_formatDate(DateTime.now())}')
                .toUpperCase(),
            style: TextStyle(
              color: p.textTertiary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            greeting?.title ?? 'Welcome',
            style: TextStyle(
              color: p.textPrimary,
              fontSize: 29,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.6,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'You do not need to fix the whole day. Just protect the next '
            'choice.',
            style: TextStyle(
              color: p.textSecondary,
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  /// Small caps divider between groups of cards.
  ///
  /// Eight cards of identical weight is what made this screen tiring; naming
  /// the groups gives the eye somewhere to rest and something to skip.
  Widget _sectionLabel(String label) {
    final p = AppTheme.palette(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: p.textTertiary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildTodayResetPlan() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.task_alt,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Today's Reset Plan",
                    style: TextStyle(
                      color: AppTheme.palette(context).textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${_completedTaskIds.length}/${_todayTasks.length}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_todayTasks.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Your reset plan will appear after your support profile is ready. '
                  'Complete your check-in to get started.',
                  style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 13, height: 1.4),
                ),
              )
            else
              ..._todayTasks.take(5).map((task) {
              final taskId = task['id'] as String;
              final done = _completedTaskIds.contains(taskId);
              final insight = _taskInsight(taskId);
              final feedback = _taskFeedbackById[taskId];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: done ? null : () => _completeTask(task),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: done
                          ? AppTheme.palette(context).success.withValues(alpha: 0.08)
                          : AppTheme.palette(context).textPrimary.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: done
                            ? AppTheme.palette(context).success.withValues(alpha: 0.3)
                            : AppTheme.palette(context).borderSubtle,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          done
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: done ? AppTheme.palette(context).success : AppTheme.palette(context).textTertiary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task['title'] as String,
                                style: TextStyle(
                                  color: done ? AppTheme.palette(context).textSecondary : AppTheme.palette(context).textPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  decoration: done
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              Text(
                                '${task['durationMinutes']}min'
                                ' - ${insight?.whyChosen ?? 'Chosen for today'}',
                                style: TextStyle(
                                  color: AppTheme.palette(context).textTertiary,
                                  fontSize: 11,
                                ),
                              ),
                              if (insight != null) ...[
                                Text(
                                  'Target driver: ${insight.targetDriver}',
                                  style: TextStyle(
                                    color: AppTheme.palette(context).textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                                if (insight.steps.isNotEmpty)
                                  Text(
                                    'Step 1: ${insight.steps.first}',
                                    style: TextStyle(
                                      color: AppTheme.palette(context).textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                if (insight.domainTags.isNotEmpty)
                                  Wrap(
                                    spacing: 4,
                                    children: insight.domainTags
                                        .take(3)
                                        .map(
                                          (tag) => Chip(
                                            label: Text(
                                              tag,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: AppTheme.palette(context).textSecondary,
                                              ),
                                            ),
                                            visualDensity: VisualDensity.compact,
                                            padding: EdgeInsets.zero,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                            backgroundColor: AppTheme.palette(context).textPrimary
                                                .withValues(alpha: 0.08),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: insight.feedbackButtons
                                      .map(
                                        (label) => OutlinedButton(
                                          onPressed: () =>
                                              _recordTaskFeedback(taskId, label),
                                          style: OutlinedButton.styleFrom(
                                            minimumSize: const Size(0, 28),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                          ),
                                          child: Text(
                                            label,
                                            style: const TextStyle(fontSize: 11),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                                if (feedback != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      'Feedback saved locally: $feedback',
                                      style: TextStyle(
                                        color: AppTheme.palette(context).textSecondary,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                        _conditionBadge(
                          task['conditionType'] as String? ?? 'recovery',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _conditionBadge(String condition) {
    final config = _conditionConfig(condition);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        config.shortLabel,
        style: TextStyle(
          color: config.color,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRecoveryMomentum() {
    final supportProfile = _supportProfile;
    if (supportProfile != null) {
      return RecoveryMomentumCard(profile: supportProfile);
    }
    final momentum = _homeInsights?.recoveryMomentum;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(Icons.trending_up, color: AppTheme.palette(context).success, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                momentum?.explanation ??
                    'Momentum adjusts from your daily outcomes, check-ins, '
                        'and completed support actions.',
                style:  TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.35),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Today's counters, at a glance.
  ///
  /// Urges and slips were already being loaded on every refresh and then
  /// discarded — surfacing them is the cheapest real-time signal the app has,
  /// and "3 urges, 0 slips" is a far better read on the day than any score.
  Widget _buildTodaySoFar() {
    final p = AppTheme.palette(context);
    final tasksDone = _completedTaskIds.length;
    final tasksTotal = _todayTasks.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: p.borderSubtle),
      ),
      child: Row(
        children: [
          _StatCell(
            value: '$_urgesToday',
            label: _urgesToday == 1 ? 'urge logged' : 'urges logged',
            tone: p.textPrimary,
          ),
          _StatDivider(color: p.borderSubtle),
          _StatCell(
            value: '$_slipsToday',
            label: _slipsToday == 1 ? 'slip' : 'slips',
            tone: _slipsToday == 0 ? p.success : p.supportNeeded,
          ),
          _StatDivider(color: p.borderSubtle),
          _StatCell(
            value: tasksTotal == 0 ? '—' : '$tasksDone/$tasksTotal',
            label: 'resets done',
            tone: tasksTotal > 0 && tasksDone >= tasksTotal
                ? p.success
                : p.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStateCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _checkedInToday ? Icons.check_circle : Icons.nightlight_round,
                  color: _checkedInToday ? AppTheme.palette(context).success : AppTheme.palette(context).textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _checkedInToday ? 'Checked in today' : 'Not checked in yet',
                    style: TextStyle(
                      color: AppTheme.palette(context).textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: _openCheckIn,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 34),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  child: Text(
                    _checkedInToday ? 'Update' : 'Check in',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _checkedInToday
                  ? 'Your check-in helps Detoxia calibrate today\'s support.'
                  : 'A quick check-in improves today\'s plan.',
              style: TextStyle(
                color: AppTheme.palette(context).textSecondary,
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTriggerChainPreview() {
    final profile = _supportProfile;
    if (profile == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Icons.account_tree_outlined, color: AppTheme.palette(context).textTertiary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your trigger chain will appear as Detoxia learns your patterns.',
                  style: TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.35),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final triggers = profile.triggerWeights.toList()
      ..sort((a, b) => b.weight0To10.compareTo(a.weight0To10));
    final pathways = profile.pathwayScores
        .where((p) => p.enabled && p.score0To10 > 0)
        .toList()
      ..sort((a, b) => b.score0To10.compareTo(a.score0To10));

    final chainLabels = triggers
        .take(4)
        .map((t) => t.label.toLowerCase())
        .toList();

    if (chainLabels.isEmpty) {
      return const SizedBox.shrink();
    }

    final topPathway = pathways.isNotEmpty ? pathways.first.label.toLowerCase() : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_tree_outlined,
                    color: AppTheme.palette(context).accent, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Your trigger chain',
                  style: TextStyle(
                    color: AppTheme.palette(context).textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              _buildChainSentence(chainLabels, topPathway),
              style: TextStyle(
                color: AppTheme.palette(context).textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Recognising the chain early is your strongest protection.',
              style: TextStyle(
                color: AppTheme.palette(context).textSecondary,
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildChainSentence(List<String> triggers, String? topPathway) {
    if (triggers.length >= 4) {
      return '${triggers[0]} → ${triggers[1]} → ${triggers[2]} → ${triggers[3]}${topPathway != null ? ' — this pattern often leads to $topPathway sensitivity' : ''}.';
    }
    if (triggers.length >= 2) {
      final chain = triggers.join(' → ');
      return '$chain${topPathway != null ? ' — these tend to increase $topPathway sensitivity' : ''}.';
    }
    return '${triggers.first} is your strongest current driver.${topPathway != null ? ' It most affects your $topPathway.' : ''}';
  }

  Widget _buildSecondaryNav() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: [
        _navTile(Icons.trending_up_rounded, 'Recovery path',
            () => const ProjectionScreen()),
        _navTile(Icons.insights_rounded, 'Where you stand',
            () => const ConfidenceScreen()),
        _navTile(Icons.emoji_events_rounded, 'Wins',
            () => const AchievementsScreen()),
        _navTile(Icons.school_rounded, '12-week program',
            () => const ProgramScreen()),
        _navTileAction(
            Icons.radar_rounded, 'Support map', _openFullSupportMap),
        _navTile(Icons.auto_graph_rounded, 'Weekly review',
            () => const WeeklyReviewScreen()),
      ],
    );
  }

  /// One destination tile. Icon-led and evenly sized so the block reads as a
  /// calm grid rather than a ragged row of chips.
  Widget _navTile(IconData icon, String label, Widget Function() destination) =>
      _navTileAction(
        icon,
        label,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => destination()),
        ),
      );

  Widget _navTileAction(IconData icon, String label, VoidCallback onTap) {
    final p = AppTheme.palette(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: p.borderSubtle),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: p.accentSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 17, color: p.accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: p.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _secondaryNavChip(IconData icon, String label, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: AppTheme.palette(context).accent),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: onTap,
      backgroundColor: AppTheme.palette(context).textPrimary.withValues(alpha: 0.06),
      side: BorderSide(color: AppTheme.palette(context).textPrimary.withValues(alpha: 0.08)),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  void _openResetFlow(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RescueScreen()),
    ).then((_) => _loadData());
  }

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';

  HomeTaskInsight? _taskInsight(String taskId) {
    final tasks = _homeInsights?.todayTasks;
    if (tasks == null) return null;
    for (final task in tasks) {
      if (task.id == taskId) return task;
    }
    return null;
  }
}

class _ConditionConfig {
  final String label;
  final String shortLabel;
  final IconData icon;
  final Color color;
  const _ConditionConfig(this.label, this.shortLabel, this.icon, this.color);
}

_ConditionConfig _conditionConfig(String condition) {
  switch (condition) {
    case 'anxiety':
      return const _ConditionConfig(
        'Anxiety',
        'ANX',
        Icons.air,
        Color(0xFF4ECDC4),
      );
    case 'depression':
      return const _ConditionConfig(
        'Depression',
        'DEP',
        Icons.wb_sunny_outlined,
        Color(0xFFFFB347),
      );
    case 'adhd':
      return const _ConditionConfig(
        'ADHD',
        'ADHD',
        Icons.psychology,
        Color(0xFFFF6B6B),
      );
    case 'periodTracking':
      return const _ConditionConfig(
        'Period Tracker',
        'PER',
        Icons.favorite,
        Color(0xFFFF6B9D),
      );
    case 'moodTracking':
      return const _ConditionConfig(
        'Mood Tracker',
        'MOOD',
        Icons.emoji_emotions,
        Color(0xFF9B59B6),
      );
    default:
      return const _ConditionConfig(
        'Recovery',
        'REC',
        Icons.shield,
        Color(0xFF6C63FF),
      );
  }
}

/// One figure in the "today so far" row.
class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  final Color tone;

  const _StatCell({
    required this.value,
    required this.label,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppTheme.palette(context);
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: tone,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: p.textTertiary, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  final Color color;

  const _StatDivider({required this.color});

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 30, color: color);
}
