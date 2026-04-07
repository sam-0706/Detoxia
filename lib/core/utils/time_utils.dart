import 'package:flutter/material.dart';

class TimeUtils {
  TimeUtils._();

  static String formatTimeOfDay(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';

  static TimeOfDay parseTimeOfDay(String str) {
    final parts = str.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  static int timeToMinutes(TimeOfDay time) =>
      time.hour * 60 + time.minute;

  static TimeOfDay minutesToTime(int minutes) {
    final normalized = minutes % 1440;
    return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
  }

  static String blockLabel(int startMinute) {
    final h = startMinute ~/ 60;
    final m = startMinute % 60;
    final period = h < 12 ? 'AM' : 'PM';
    final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$hour12:${m.toString().padLeft(2, '0')} $period';
  }

  static String formatDuration(Duration d) {
    if (d.inHours > 0) {
      return '${d.inHours}h ${d.inMinutes % 60}m';
    }
    return '${d.inMinutes}m';
  }

  static int dayOfWeekFromDateTime(DateTime dt) => dt.weekday;

  static String dayName(int dayOfWeek) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[(dayOfWeek - 1) % 7];
  }
}
