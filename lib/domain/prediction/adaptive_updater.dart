import 'dart:math';

import 'package:detoxia/core/constants/app_constants.dart';

class AdaptiveUpdater {
  int daysSinceOnboarding;
  final Map<String, _BlockStats> _blockStats = {};

  AdaptiveUpdater({this.daysSinceOnboarding = 0});

  double get currentAlpha {
    if (daysSinceOnboarding < 7) {
      return AppConstants.initialAlpha +
          (AppConstants.day7Alpha - AppConstants.initialAlpha) *
              (daysSinceOnboarding / 7.0);
    }
    if (daysSinceOnboarding < 14) {
      return AppConstants.day7Alpha +
          (AppConstants.day14Alpha - AppConstants.day7Alpha) *
              ((daysSinceOnboarding - 7) / 7.0);
    }
    if (daysSinceOnboarding < 21) {
      return AppConstants.day14Alpha +
          (AppConstants.day21Alpha - AppConstants.day14Alpha) *
              ((daysSinceOnboarding - 14) / 7.0);
    }
    if (daysSinceOnboarding < 30) {
      return AppConstants.day21Alpha +
          (AppConstants.day30Alpha - AppConstants.day21Alpha) *
              ((daysSinceOnboarding - 21) / 9.0);
    }
    return AppConstants.day30Alpha;
  }

  double blendScores(double heuristic, double empirical) {
    final alpha = currentAlpha;
    return alpha * empirical + (1 - alpha) * heuristic;
  }

  void recordBlockEvent(
    int dayOfWeek,
    int blockIndex, {
    required bool wasUrge,
    required bool wasSlip,
  }) {
    final key = '${dayOfWeek}_$blockIndex';
    final stats = _blockStats.putIfAbsent(
      key,
      () => _BlockStats(),
    );
    stats.observations++;
    if (wasUrge) stats.urges++;
    if (wasSlip) stats.slips++;
  }

  double empiricalRisk(int dayOfWeek, int blockIndex) {
    final key = '${dayOfWeek}_$blockIndex';
    final stats = _blockStats[key];
    if (stats == null || stats.observations == 0) return 0.0;
    return (stats.urges + 2 * stats.slips) / stats.observations;
  }

  void incrementDay() => daysSinceOnboarding++;

  bool detectDrift(
    Map<int, int> recent7DayBlockSlips,
    Map<int, int> allTimeBlockSlips,
  ) {
    if (recent7DayBlockSlips.isEmpty || allTimeBlockSlips.isEmpty) {
      return false;
    }
    double divergence = 0;
    for (final block in recent7DayBlockSlips.keys) {
      final recent = recent7DayBlockSlips[block] ?? 0;
      final allTime = allTimeBlockSlips[block] ?? 0;
      if (allTime > 0) {
        divergence += pow(recent - allTime, 2) / allTime;
      }
    }
    return divergence > 10.0;
  }

  Map<int, double> perDayOfWeekMultiplier(
    Map<int, int> slipsByDay,
    int totalSlips,
  ) {
    if (totalSlips == 0) return {};
    final avgPerDay = totalSlips / 7.0;
    return slipsByDay.map(
      (day, count) =>
          MapEntry(day, avgPerDay > 0 ? count / avgPerDay : 1.0),
    );
  }
}

class _BlockStats {
  int observations = 0;
  int urges = 0;
  int slips = 0;
}
