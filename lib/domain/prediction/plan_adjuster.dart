import 'package:detoxia/core/constants/enums.dart';

class PlanAdjustment {
  final String type;
  final String reason;
  final Map<String, dynamic> changes;
  final DateTime timestamp;

  const PlanAdjustment({
    required this.type,
    required this.reason,
    required this.changes,
    required this.timestamp,
  });
}

class PlanAdjuster {
  ProgramPhase currentPhase;
  int currentWeek;
  double paceModifier;
  final List<PlanAdjustment> adjustmentHistory = [];

  PlanAdjuster({
    this.currentPhase = ProgramPhase.baseline,
    this.currentWeek = 1,
    this.paceModifier = 1.0,
  });

  PlanAdjustment? evaluate({
    required double avgSlipsLast7Days,
    required double baselineSlips,
    required double avgUrgeIntensity,
    required double streakScoreThisWeek,
    required double streakScore2WeeksAgo,
    required double avgSleepLast5,
    required double avgSleepLast30,
    required Map<String, int> newTriggerCounts,
    required int totalEvents,
  }) {
    // Ahead of schedule
    if (currentPhase == ProgramPhase.baseline &&
        avgSlipsLast7Days < baselineSlips * 0.5 &&
        avgUrgeIntensity < 5) {
      return _adjust(
        type: 'accelerate',
        reason: 'You are ahead of schedule. Moving to Phase 2 early.',
        changes: {'phase': ProgramPhase.interrupt.name},
      );
    }

    // Falling behind
    if (avgSlipsLast7Days > baselineSlips * 0.8) {
      return _adjust(
        type: 'decelerate',
        reason: 'This week was tough. Slowing the pace to '
            'reinforce current skills.',
        changes: {'paceModifier': paceModifier * 0.8},
      );
    }

    // Plateau
    if ((streakScoreThisWeek - streakScore2WeeksAgo).abs() < 5 &&
        currentWeek > 4) {
      return _adjust(
        type: 'challenge',
        reason: 'You have plateaued. Introducing a new challenge '
            'to break through.',
        changes: {'addModule': 'plateau_breaker'},
      );
    }

    // Sleep regression
    if (avgSleepLast5 < avgSleepLast30 - 1.0) {
      return _adjust(
        type: 'sleep_focus',
        reason: 'Your sleep has been declining. Re-emphasizing '
            'sleep boundary modules.',
        changes: {'priorityModule': 'sleep_boundary'},
      );
    }

    // New trigger emergence
    for (final entry in newTriggerCounts.entries) {
      if (totalEvents > 0 && entry.value / totalEvents > 0.3) {
        return _adjust(
          type: 'new_trigger',
          reason: '${entry.key} has become a significant trigger. '
              'Adding a targeted module.',
          changes: {'addModule': 'trigger_${entry.key}'},
        );
      }
    }

    return null;
  }

  PlanAdjustment _adjust({
    required String type,
    required String reason,
    required Map<String, dynamic> changes,
  }) {
    final adj = PlanAdjustment(
      type: type,
      reason: reason,
      changes: changes,
      timestamp: DateTime.now(),
    );
    adjustmentHistory.add(adj);
    return adj;
  }

  ProgramPhase phaseForWeek(int week) {
    final adjusted = (week / paceModifier).ceil();
    if (adjusted <= 2) return ProgramPhase.baseline;
    if (adjusted <= 5) return ProgramPhase.interrupt;
    if (adjusted <= 8) return ProgramPhase.rebuild;
    return ProgramPhase.maintain;
  }

  GraduationOutcome evaluateGraduation({
    required double improvementPct,
  }) {
    if (improvementPct >= 60) return GraduationOutcome.strong;
    if (improvementPct >= 30) return GraduationOutcome.moderate;
    return GraduationOutcome.struggling;
  }
}
