import 'package:detoxia/core/constants/enums.dart';

class CycleCalculator {
  const CycleCalculator._();

  static double averageCycleLength(List<DateTime> periodStarts) {
    if (periodStarts.length < 2) return 28.0;

    final sorted = [...periodStarts]..sort();
    final gaps = <int>[];
    for (var i = 1; i < sorted.length; i++) {
      gaps.add(sorted[i].difference(sorted[i - 1]).inDays);
    }
    return gaps.reduce((a, b) => a + b) / gaps.length;
  }

  static DateTime predictNextPeriod(DateTime lastStart, double avgLength) {
    return lastStart.add(Duration(days: avgLength.round()));
  }

  static DateTime predictOvulation(
      DateTime predictedStart, double avgLength) {
    // Ovulation typically occurs ~14 days before the next period.
    final daysBeforeEnd = (avgLength - 14).round().clamp(0, avgLength.round());
    return predictedStart
        .subtract(Duration(days: avgLength.round()))
        .add(Duration(days: daysBeforeEnd));
  }

  static int currentCycleDay(DateTime lastPeriodStart) {
    final diff = DateTime.now().difference(_startOfDay(lastPeriodStart)).inDays;
    return (diff + 1).clamp(1, 99);
  }

  static CyclePhase currentPhase(int cycleDay, double avgLength) {
    if (cycleDay <= 5) return CyclePhase.menstrual;
    if (cycleDay <= (avgLength * 0.5).round()) return CyclePhase.follicular;
    if (cycleDay <= (avgLength * 0.5).round() + 3) return CyclePhase.ovulation;
    return CyclePhase.luteal;
  }

  static ({DateTime start, DateTime end}) fertileWindow(
      DateTime predictedOvulation) {
    return (
      start: predictedOvulation.subtract(const Duration(days: 5)),
      end: predictedOvulation.add(const Duration(days: 1)),
    );
  }

  static DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);
}
