import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/domain/prediction/risk_calculator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  NotificationMode _mode = NotificationMode.balanced;
  int _scheduledToday = 0;
  bool _initialized = false;

  NotificationService() : _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tzdata.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
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

  int get _maxNotifications {
    switch (_mode) {
      case NotificationMode.strict:
        return 5;
      case NotificationMode.balanced:
        return 3;
      case NotificationMode.gentle:
        return 1;
    }
  }

  Future<void> scheduleRiskNotifications(
    List<RiskBlock> blocks,
    DateTime forDate,
  ) async {
    if (!_initialized) return;
    await cancelAllScheduled();
    _scheduledToday = 0;

    final highRiskBlocks = blocks
        .where((b) => b.score >= 0.7)
        .toList()
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
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'detoxia_scheduled',
        'Scheduled',
        importance: Importance.high,
        priority: Priority.high,
        visibility: NotificationVisibility.private,
      ),
      iOS: DarwinNotificationDetails(),
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

  String _bodyForScore(double score) {
    if (score >= 0.85) {
      return 'High-risk window ahead. What is your plan?';
    }
    if (score >= 0.7) {
      return 'Difficult window approaching. Stay prepared.';
    }
    return 'Check in with yourself.';
  }

  void resetDailyCount() => _scheduledToday = 0;

  /// Schedules persistent check-in reminders starting 1 hour before
  /// sleepTime, repeating every 5 minutes for up to 1 hour.
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
