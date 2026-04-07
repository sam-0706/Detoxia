import 'dart:math';

class MoodAnalyzer {
  MoodAnalyzer._();

  /// Returns 'improving', 'declining', or 'stable' based on a linear trend.
  static String computeTrend(List<int> recentMoods) {
    if (recentMoods.length < 3) return 'stable';

    final n = recentMoods.length;
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    for (var i = 0; i < n; i++) {
      sumX += i;
      sumY += recentMoods[i];
      sumXY += i * recentMoods[i];
      sumX2 += i * i;
    }
    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);

    if (slope > 0.15) return 'improving';
    if (slope < -0.15) return 'declining';
    return 'stable';
  }

  /// Maps each activity tag to the average mood delta when that activity is
  /// present vs absent.
  static Map<String, double> activityCorrelation(
      List<Map<String, dynamic>> entries) {
    if (entries.isEmpty) return {};

    final allActivities = <String>{};
    for (final e in entries) {
      final acts = e['activities'];
      if (acts is List) allActivities.addAll(acts.cast<String>());
    }

    final overallAvg =
        entries.fold<double>(0, (s, e) => s + (e['moodLevel'] as int)) /
            entries.length;

    final result = <String, double>{};
    for (final activity in allActivities) {
      final withActivity = entries.where((e) {
        final a = e['activities'];
        return a is List && a.contains(activity);
      }).toList();
      if (withActivity.isEmpty) continue;

      final avg =
          withActivity.fold<double>(0, (s, e) => s + (e['moodLevel'] as int)) /
              withActivity.length;
      result[activity] = double.parse((avg - overallAvg).toStringAsFixed(2));
    }
    return result;
  }

  /// Returns the time-of-day label with the highest average mood.
  static String bestTimeOfDay(List<Map<String, dynamic>> entries) {
    if (entries.isEmpty) return 'N/A';

    final buckets = <String, List<int>>{
      'Morning': [],
      'Afternoon': [],
      'Evening': [],
      'Night': [],
    };

    for (final e in entries) {
      final ts = e['timestamp'];
      final hour = ts is DateTime ? ts.hour : 12;
      final mood = e['moodLevel'] as int;
      if (hour < 6) {
        buckets['Night']!.add(mood);
      } else if (hour < 12) {
        buckets['Morning']!.add(mood);
      } else if (hour < 18) {
        buckets['Afternoon']!.add(mood);
      } else {
        buckets['Evening']!.add(mood);
      }
    }

    String best = 'Morning';
    double bestAvg = 0;
    for (final entry in buckets.entries) {
      if (entry.value.isEmpty) continue;
      final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
      if (avg > bestAvg) {
        bestAvg = avg;
        best = entry.key;
      }
    }
    return best;
  }

  /// Returns avg mood per day-of-week (1=Mon … 7=Sun).
  static Map<int, double> dayOfWeekPattern(
      List<Map<String, dynamic>> entries) {
    final sums = <int, double>{};
    final counts = <int, int>{};
    for (final e in entries) {
      final ts = e['timestamp'];
      if (ts is! DateTime) continue;
      final dow = ts.weekday;
      sums[dow] = (sums[dow] ?? 0) + (e['moodLevel'] as int);
      counts[dow] = (counts[dow] ?? 0) + 1;
    }
    return {
      for (final dow in sums.keys)
        dow: double.parse(
            ((sums[dow] ?? 0) / max(1, counts[dow] ?? 1)).toStringAsFixed(1)),
    };
  }
}
