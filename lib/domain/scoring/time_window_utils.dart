/// Pure helpers for time-window arithmetic.
///
/// All times are expressed as minutes-since-midnight in `[0, 1440)`.
library;

/// Returns the midpoint (in minutes-since-midnight) of a window `[start, end]`.
///
/// Handles wrap-around midnight. If `end < start`, the window is assumed to
/// cross midnight (e.g. start = 23:00 = 1380, end = 01:00 = 60 → midpoint at
/// 00:00 = 0).
///
/// The result is always normalized into `[0, 1440)`.
int midpointMinutes(int start, int end) {
  if (end >= start) {
    return ((start + end) ~/ 2) % 1440;
  }
  final mid = ((start + end + 1440) ~/ 2) % 1440;
  return mid;
}

/// Returns the duration in hours between `startMin` and `endMin`, handling a
/// wrap across midnight.
///
/// If `endMin < startMin`, adds 1440 to `endMin` before subtracting, so a
/// sleep that starts at 23:00 (1380) and ends at 06:00 (360) returns 7.0.
double minutesBetweenAcrossMidnight(int startMin, int endMin) {
  final adjustedEnd = endMin < startMin ? endMin + 1440 : endMin;
  final diffMinutes = adjustedEnd - startMin;
  return diffMinutes / 60.0;
}

/// Clamps `x` to `[0.0, 1.0]`.
double clamp01(double x) {
  if (x < 0.0) return 0.0;
  if (x > 1.0) return 1.0;
  return x;
}

/// Clamps `x` to `[0.0, 10.0]`.
double clamp10(double x) {
  if (x < 0.0) return 0.0;
  if (x > 10.0) return 10.0;
  return x;
}
