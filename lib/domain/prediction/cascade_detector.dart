import 'package:detoxia/core/constants/app_constants.dart';

class CascadeDetector {
  double calculateMultiplier(int slipsEarlierToday) {
    return 1.0 + AppConstants.cascadeMultiplierStep * slipsEarlierToday;
  }

  bool isBingeDay(int slipsToday) => slipsToday >= 3;

  bool isBurstPattern(List<DateTime> slipTimestamps) {
    if (slipTimestamps.length < 2) return false;
    final sorted = [...slipTimestamps]..sort();
    for (int i = 0; i < sorted.length - 1; i++) {
      if (sorted[i + 1].difference(sorted[i]).inHours < 4) {
        return true;
      }
    }
    return false;
  }

  String? generateCascadeInsight(
    int slipsToday,
    List<String> triggersToday,
  ) {
    if (slipsToday < 2) return null;
    final triggerCounts = <String, int>{};
    for (final t in triggersToday) {
      triggerCounts[t] = (triggerCounts[t] ?? 0) + 1;
    }
    final dominant = triggerCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (dominant.isNotEmpty) {
      return 'Today was a multi-slip day. The dominant trigger was '
          '${dominant.first.key}.';
    }
    return null;
  }
}
