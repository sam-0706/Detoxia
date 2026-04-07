import 'dart:math';

import 'package:detoxia/core/constants/enums.dart';

class StreakData {
  final StreakType type;
  final int? peakId;
  int currentCount;
  int bestCount;
  int lifetimeTotal;
  DateTime startedAt;
  DateTime? brokenAt;

  StreakData({
    required this.type,
    this.peakId,
    this.currentCount = 0,
    this.bestCount = 0,
    this.lifetimeTotal = 0,
    DateTime? startedAt,
    this.brokenAt,
  }) : startedAt = startedAt ?? DateTime.now();

  void increment() {
    currentCount++;
    lifetimeTotal++;
    bestCount = max(bestCount, currentCount);
  }

  int breakStreak() {
    final length = currentCount;
    brokenAt = DateTime.now();
    currentCount = 0;
    startedAt = DateTime.now();
    return length;
  }
}

class StreakManager {
  final Map<String, StreakData> _streaks = {};

  StreakManager();

  void initializeStreaks(List<int> peakIds) {
    _getOrCreate(StreakType.clean);
    _getOrCreate(StreakType.scrollingControl);
    _getOrCreate(StreakType.sleepBoundary);
    _getOrCreate(StreakType.checkin);
    for (final id in peakIds) {
      _getOrCreate(StreakType.perPeak, peakId: id);
    }
  }

  String _key(StreakType type, {int? peakId}) =>
      peakId != null ? '${type.name}_$peakId' : type.name;

  StreakData _getOrCreate(StreakType type, {int? peakId}) {
    final key = _key(type, peakId: peakId);
    return _streaks.putIfAbsent(
      key,
      () => StreakData(type: type, peakId: peakId),
    );
  }

  StreakData getStreak(StreakType type, {int? peakId}) =>
      _getOrCreate(type, peakId: peakId);

  void incrementDay({
    required bool clean,
    required bool scrollingUnderTarget,
    required bool sleepBoundaryRespected,
    required bool checkedIn,
    required Set<int> cleanPeakIds,
    required Set<int> allPeakIds,
  }) {
    if (clean) {
      _getOrCreate(StreakType.clean).increment();
    }
    if (scrollingUnderTarget) {
      _getOrCreate(StreakType.scrollingControl).increment();
    }
    if (sleepBoundaryRespected) {
      _getOrCreate(StreakType.sleepBoundary).increment();
    }
    if (checkedIn) {
      _getOrCreate(StreakType.checkin).increment();
    }
    for (final id in cleanPeakIds) {
      _getOrCreate(StreakType.perPeak, peakId: id).increment();
    }
  }

  int breakOnSlip({int? peakId}) {
    final cleanLength =
        _getOrCreate(StreakType.clean).breakStreak();
    if (peakId != null) {
      _getOrCreate(StreakType.perPeak, peakId: peakId)
          .breakStreak();
    }
    return cleanLength;
  }

  double computeStreakScore() {
    final cleanStreak = _getOrCreate(StreakType.clean);
    final scrolling = _getOrCreate(StreakType.scrollingControl);
    final sleep = _getOrCreate(StreakType.sleepBoundary);
    final checkin = _getOrCreate(StreakType.checkin);

    final cleanFactor =
        100 * (1 - exp(-0.1 * cleanStreak.currentCount));
    final scrollingFactor =
        _last7Factor(scrolling.currentCount);
    final sleepFactor = _last7Factor(sleep.currentCount);
    final checkinFactor = _last7Factor(checkin.currentCount);
    const rescueFactor = 50.0;

    return (0.40 * cleanFactor +
            0.20 * scrollingFactor +
            0.20 * sleepFactor +
            0.10 * checkinFactor +
            0.10 * rescueFactor)
        .clamp(0.0, 100.0);
  }

  double _last7Factor(int count) =>
      (min(count, 7) / 7.0 * 100).clamp(0.0, 100.0);

  int get lifetimeCleanDays =>
      _getOrCreate(StreakType.clean).lifetimeTotal;

  int get currentCleanStreak =>
      _getOrCreate(StreakType.clean).currentCount;

  int get bestCleanStreak =>
      _getOrCreate(StreakType.clean).bestCount;

  String get recoveryMessage {
    final best = bestCleanStreak;
    final lifetime = lifetimeCleanDays;
    return 'You held for $currentCleanStreak days. '
        'Your personal best is $best. '
        'Lifetime clean days: $lifetime. '
        'That progress is real.';
  }
}
