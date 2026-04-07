import 'package:detoxia/core/constants/enums.dart';

class RegressionSignal {
  final String type;
  final String message;
  final MaintenanceMode suggestedAction;

  const RegressionSignal({
    required this.type,
    required this.message,
    required this.suggestedAction,
  });
}

class RegressionDetector {
  RegressionSignal? check({
    required int cleanStreak,
    required int slipsThisWeek,
    required bool wasStable,
    required double avgSleepLast5,
    required double avgSleepLast30,
    required double streakScoreThisWeek,
    required double streakScore2WeeksAgo,
  }) {
    // Single slip after long streak
    if (cleanStreak == 0 && wasStable && slipsThisWeek == 1) {
      return const RegressionSignal(
        type: 'isolated_slip',
        message: 'One slip after a long streak. This is normal. '
            "Let's make sure it stays isolated.",
        suggestedAction: MaintenanceMode.fullMaintenance,
      );
    }

    // Multiple slips returning
    if (slipsThisWeek >= 2 && wasStable) {
      return const RegressionSignal(
        type: 'moderate_regression',
        message: "Your pattern is shifting. Let's investigate "
            'and reinforce your defenses.',
        suggestedAction: MaintenanceMode.booster,
      );
    }

    // Sleep declining
    if (avgSleepLast5 < avgSleepLast30 - 1.5) {
      return const RegressionSignal(
        type: 'sleep_regression',
        message: 'Your sleep has been declining. This often '
            'precedes harder weeks.',
        suggestedAction: MaintenanceMode.fullMaintenance,
      );
    }

    // Streak score dropping
    if (streakScoreThisWeek < streakScore2WeeksAgo - 15) {
      return const RegressionSignal(
        type: 'score_decline',
        message: 'Your scores have been dropping steadily. '
            'Consider a focused booster program.',
        suggestedAction: MaintenanceMode.booster,
      );
    }

    return null;
  }
}
