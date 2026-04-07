import 'package:workmanager/workmanager.dart';

const _periodicRiskRecalc = 'periodic_risk_recalc';
const _dailyScoreSnapshot = 'daily_score_snapshot';

class BackgroundWorker {
  static Future<void> initialize() async {
    await Workmanager().initialize(
      _callbackDispatcher,
    );

    await Workmanager().registerPeriodicTask(
      _periodicRiskRecalc,
      _periodicRiskRecalc,
      frequency: const Duration(hours: 6),
      constraints: Constraints(
        networkType: NetworkType.notRequired,
      ),
    );

    await Workmanager().registerPeriodicTask(
      _dailyScoreSnapshot,
      _dailyScoreSnapshot,
      frequency: const Duration(hours: 24),
      constraints: Constraints(
        networkType: NetworkType.notRequired,
      ),
    );
  }
}

@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case _periodicRiskRecalc:
        // Recalculate risk windows and reschedule notifications
        // In production this would load the DB, run RiskCalculator,
        // and update NotificationService
        break;
      case _dailyScoreSnapshot:
        // Compute and persist DailyScore for trend analysis
        break;
    }
    return true;
  });
}
