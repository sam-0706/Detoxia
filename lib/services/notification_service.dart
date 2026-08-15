import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/domain/prediction/risk_calculator.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/domain/tasks/daily_task_scheduler.dart';
import 'package:detoxia/services/unified_notification_scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  NotificationMode _mode = NotificationMode.balanced;
  int _scheduledToday = 0;
  bool _initialized = false;
  bool _quietHoursEnabled = false;
  int _quietStartMinutes = 22 * 60;
  int _quietEndMinutes = 7 * 60;

  NotificationService() : _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tzdata.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    try {
      await _plugin.initialize(settings: settings);
      _initialized = true;
    } catch (e) {
      _initialized = false;
    }
  }

  void setMode(NotificationMode mode) => _mode = mode;

  NotificationMode get mode => _mode;
  bool get quietHoursEnabled => _quietHoursEnabled;
  int get quietStartMinutes => _quietStartMinutes;
  int get quietEndMinutes => _quietEndMinutes;

  void setQuietHours({
    required bool enabled,
    required int startMinutes,
    required int endMinutes,
  }) {
    _quietHoursEnabled = enabled;
    _quietStartMinutes = startMinutes.clamp(0, 1439);
    _quietEndMinutes = endMinutes.clamp(0, 1439);
  }

  int get maxNotificationsPerDay => _maxNotifications;

  int get _maxNotifications {
    switch (_mode) {
      case NotificationMode.strict:
        return 8;
      case NotificationMode.balanced:
        return 5;
      case NotificationMode.gentle:
        return 3;
    }
  }

  // ─── Risk Notifications (Detox Recovery) ───

  Future<void> scheduleRiskNotifications(
    List<RiskBlock> blocks,
    DateTime forDate,
  ) async {
    if (!_initialized) return;
    await cancelAllScheduled();
    _scheduledToday = 0;

    final highRiskBlocks = blocks.where((b) => b.score >= 0.7).toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    for (final block in highRiskBlocks) {
      if (_scheduledToday >= _maxNotifications) break;

      final notifyMinute = block.startMinute - 15;
      if (notifyMinute < 0) continue;

      final scheduleTime = DateTime(
        forDate.year,
        forDate.month,
        forDate.day,
        notifyMinute ~/ 60,
        notifyMinute % 60,
      );

      if (scheduleTime.isBefore(DateTime.now())) continue;

      await _scheduleNotification(
        id: block.blockIndex,
        title: 'Stay focused',
        body: _bodyForScore(block.score),
        scheduledTime: scheduleTime,
      );
      _scheduledToday++;
    }
  }

  Future<void> scheduleSleepBoundary(DateTime sleepTime) async {
    if (!_initialized || _scheduledToday >= _maxNotifications) return;
    await _scheduleNotification(
      id: 900,
      title: 'Wind down',
      body: 'Protect tonight. Phone goes outside the room.',
      scheduledTime: sleepTime,
    );
    _scheduledToday++;
  }

  Future<void> scheduleMorningDefense(DateTime wakeTime) async {
    if (!_initialized || _scheduledToday >= _maxNotifications) return;
    await _scheduleNotification(
      id: 901,
      title: 'Start strong',
      body: 'Skip the phone for 10 minutes.',
      scheduledTime: wakeTime,
    );
    _scheduledToday++;
  }

  Future<void> scheduleCascadePrevention({
    required DateTime time,
    required String message,
  }) async {
    if (!_initialized || _scheduledToday >= _maxNotifications) return;
    await _scheduleNotification(
      id: 902,
      title: 'Break the chain',
      body: message,
      scheduledTime: time,
    );
    _scheduledToday++;
  }

  // ─── Wellness Task Notifications ───

  Future<void> scheduleWellnessNotifications({
    required List<String> activeConditions,
    required DateTime wakeTime,
    required DateTime sleepTime,
  }) async {
    if (!_initialized) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;

    final tasks = DailyTaskScheduler.selectTasks(
      activeConditions: activeConditions,
      dayOfYear: dayOfYear,
      count: 5,
    );

    // Morning task notification (30 min after wake)
    final morningTime = wakeTime.add(const Duration(minutes: 30));
    if (morningTime.isAfter(now)) {
      final morningTask = tasks.firstWhere(
        (t) => t['timeOfDay'] == 'morning',
        orElse: () => tasks.first,
      );
      await _scheduleNotification(
        id: 700,
        title: 'Morning task ready',
        body: morningTask['title'] as String,
        scheduledTime: morningTime,
        channelId: 'detoxia_wellness',
        channelName: 'Wellness Tasks',
      );
    }

    // Midday check-in (1 PM or 5 hours after wake)
    final middayTime = today.add(const Duration(hours: 13));
    if (middayTime.isAfter(now) && middayTime.isBefore(sleepTime)) {
      await _scheduleNotification(
        id: 701,
        title: 'Midday check-in',
        body: _middayMessage(activeConditions),
        scheduledTime: middayTime,
        channelId: 'detoxia_wellness',
        channelName: 'Wellness Tasks',
      );
    }

    // Afternoon task (3 PM)
    final afternoonTime = today.add(const Duration(hours: 15));
    if (afternoonTime.isAfter(now) && afternoonTime.isBefore(sleepTime)) {
      final afternoonTask = tasks.firstWhere(
        (t) => t['timeOfDay'] == 'afternoon',
        orElse: () => tasks.length > 1 ? tasks[1] : tasks.first,
      );
      await _scheduleNotification(
        id: 702,
        title: 'Afternoon activity',
        body:
            '${afternoonTask['title']} (${afternoonTask['durationMinutes']}min)',
        scheduledTime: afternoonTime,
        channelId: 'detoxia_wellness',
        channelName: 'Wellness Tasks',
      );
    }

    // Evening wind-down (2 hours before sleep)
    final eveningTime = sleepTime.subtract(const Duration(hours: 2));
    if (eveningTime.isAfter(now)) {
      final eveningTask = tasks.firstWhere(
        (t) => t['timeOfDay'] == 'evening',
        orElse: () => tasks.last,
      );
      await _scheduleNotification(
        id: 703,
        title: 'Evening wind-down',
        body: eveningTask['title'] as String,
        scheduledTime: eveningTime,
        channelId: 'detoxia_wellness',
        channelName: 'Wellness Tasks',
      );
    }

    // Random micro-task (pick a random time between noon and 6 PM)
    final microHour = 12 + (dayOfYear % 6);
    final microTime = today.add(Duration(hours: microHour, minutes: 15));
    if (microTime.isAfter(now) && microTime.isBefore(sleepTime)) {
      final microTask = tasks.firstWhere(
        (t) => (t['durationMinutes'] as int) <= 5,
        orElse: () => tasks.first,
      );
      await _scheduleNotification(
        id: 704,
        title: 'Quick task',
        body:
            '${microTask['title']} — just ${microTask['durationMinutes']} minutes',
        scheduledTime: microTime,
        channelId: 'detoxia_wellness',
        channelName: 'Wellness Tasks',
      );
    }
  }

  String _middayMessage(List<String> conditions) {
    if (conditions.contains('anxiety')) {
      return 'Take a moment to check your anxiety level. A quick breathing exercise can help.';
    }
    if (conditions.contains('depression')) {
      return 'How are you feeling? Consider logging your mood or scheduling an activity.';
    }
    if (conditions.contains('adhd')) {
      return 'Quick focus check — have you completed any of your top 3 tasks?';
    }
    if (conditions.contains('moodTracking')) {
      return 'How\'s your mood right now? A quick log takes 10 seconds.';
    }
    return 'How are you doing? Take a moment to check in with yourself.';
  }

  // ─── Condition-Specific Quick Notifications ───

  Future<void> scheduleConditionReminder({
    required String conditionType,
    required DateTime time,
  }) async {
    if (!_initialized) return;
    final messages = _conditionMessages(conditionType);
    if (messages.isEmpty) return;

    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    final message = messages[dayOfYear % messages.length];

    await _scheduleNotification(
      id: 710 + conditionType.hashCode % 50,
      title: _conditionTitle(conditionType),
      body: message,
      scheduledTime: time,
      channelId: 'detoxia_condition',
      channelName: 'Condition Reminders',
    );
  }

  String _conditionTitle(String condition) {
    switch (condition) {
      case 'anxiety':
        return 'Anxiety check';
      case 'depression':
        return 'Mood boost';
      case 'adhd':
        return 'Focus nudge';
      case 'periodTracking':
        return 'Cycle reminder';
      case 'moodTracking':
        return 'Mood log';
      default:
        return 'Wellness reminder';
    }
  }

  List<String> _conditionMessages(String condition) {
    switch (condition) {
      case 'anxiety':
        return [
          'Try 2 minutes of box breathing right now.',
          'Ground yourself: Name 5 things you can see.',
          'Shoulders down, jaw relaxed. You\'re safe.',
          'Anxiety is temporary. This feeling will pass.',
          'Take 3 slow, deep breaths right now.',
          'Try the 4-7-8 breathing technique.',
          'Notice your feet on the ground. You\'re here, you\'re okay.',
        ];
      case 'depression':
        return [
          'One small action can shift your mood. Try a 5-minute walk.',
          'Have you done something enjoyable today? You deserve it.',
          'Text someone you care about. Connection helps.',
          'Step outside for just 2 minutes of sunlight.',
          'You showed up today. That counts.',
          'Try scheduling one pleasant activity for this hour.',
          'Name one good thing that happened today.',
        ];
      case 'adhd':
        return [
          'Set a 5-minute timer and just start.',
          'What\'s the ONE thing you need to do right now?',
          'Body doubling: Tell someone what you\'re working on.',
          'Quick dopamine hit: 10 jumping jacks, then back to it.',
          'Break your current task into 3 tiny steps.',
          'Drink some water and set a 15-minute focus block.',
          'Park your distracting thoughts on paper, then refocus.',
        ];
      case 'periodTracking':
        return [
          'Don\'t forget to log today\'s symptoms.',
          'Drink extra water today — hydration helps with cramps.',
          'Be gentle with yourself today. Your body is doing a lot.',
          'A warm compress can help with discomfort.',
          'Consider some gentle stretching or yoga.',
          'Iron-rich foods can help with energy during your period.',
          'Track your mood today to spot cycle patterns.',
        ];
      case 'moodTracking':
        return [
          'How are you feeling right now? Quick-log your mood.',
          'Take a moment to name your emotions.',
          'Your mood data builds powerful insights over time.',
          'Notice your energy level. High? Low? Just right?',
          'Mood check: Rate yourself 1-10 right now.',
          'What activity affected your mood most today?',
          'Evening reflection: What was the highlight of your day?',
        ];
      default:
        return [];
    }
  }

  // ─── Immediate & Scheduled Core ───

  Future<void> scheduleUnifiedDailyPlan(
    SupportProfile profile, {
    DateTime? now,
  }) async {
    if (!_initialized) return;
    await cancelAllScheduled();
    await UnifiedNotificationScheduler(
      this,
    ).scheduleDailyForProfile(profile, now ?? DateTime.now());
  }

  Future<void> scheduleUnifiedNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    if (!_initialized || _scheduledToday >= _maxNotifications) return;
    await _scheduleNotification(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      channelId: 'detoxia_unified',
      channelName: 'Support Map Guidance',
    );
    _scheduledToday++;
  }

  Future<void> showImmediate({
    required String title,
    required String body,
  }) async {
    if (!_initialized) return;
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'detoxia_immediate',
        'Immediate',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(
      id: 999,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

  Future<void> cancelAllScheduled() async {
    if (!_initialized) return;
    await _plugin.cancelAll();
    _scheduledToday = 0;
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String channelId = 'detoxia_scheduled',
    String channelName = 'Scheduled',
  }) async {
    if (_isInQuietHours(scheduledTime)) return;

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.high,
        priority: Priority.high,
        visibility: NotificationVisibility.private,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  bool _isInQuietHours(DateTime time) {
    if (!_quietHoursEnabled) return false;
    final minuteOfDay = time.hour * 60 + time.minute;
    if (_quietStartMinutes == _quietEndMinutes) return true;
    if (_quietStartMinutes < _quietEndMinutes) {
      return minuteOfDay >= _quietStartMinutes &&
          minuteOfDay < _quietEndMinutes;
    }
    return minuteOfDay >= _quietStartMinutes ||
        minuteOfDay < _quietEndMinutes;
  }

  String _bodyForScore(double score) {
    if (score >= 0.85) {
      return 'Support window ahead. What is your plan?';
    }
    if (score >= 0.7) {
      return 'Difficult window approaching. Stay prepared.';
    }
    return 'Check in with yourself.';
  }

  void resetDailyCount() => _scheduledToday = 0;

  Future<void> scheduleCheckinReminders(DateTime sleepTime) async {
    if (!_initialized) return;

    final oneHourBefore = sleepTime.subtract(const Duration(hours: 1));
    if (oneHourBefore.isBefore(DateTime.now())) return;

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'detoxia_checkin',
        'Daily Check-in',
        importance: Importance.max,
        priority: Priority.max,
        visibility: NotificationVisibility.private,
        ongoing: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    );

    final messages = [
      'Time for your daily check-in. It takes under 2 minutes.',
      'Your check-in is waiting. This is what fuels your recovery.',
      'Don\'t skip tonight. Every check-in makes the plan smarter.',
      "Still haven't checked in. Your future self will thank you.",
      'Last reminder: Complete your check-in before bed.',
      'Your recovery depends on this. Check in now.',
      'Checking in keeps your streak alive. Tap to start.',
      'Almost bedtime. Complete your check-in to end the day strong.',
      'Your data drives your plan. 2 minutes is all it takes.',
      'Final call. Don\'t let today go untracked.',
      'You\'ve come this far. Finish today with a check-in.',
      'The app learns from your check-ins. Don\'t miss this one.',
    ];

    for (int i = 0; i < 12; i++) {
      final time = oneHourBefore.add(Duration(minutes: i * 5));
      if (time.isBefore(DateTime.now())) continue;

      try {
        await _plugin.zonedSchedule(
          id: 800 + i,
          title: 'Daily check-in',
          body: messages[i],
          scheduledDate: tz.TZDateTime.from(time, tz.local),
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      } catch (_) {}
    }
  }

  Future<void> cancelCheckinReminders() async {
    if (!_initialized) return;
    for (int i = 0; i < 12; i++) {
      await _plugin.cancel(id: 800 + i);
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
