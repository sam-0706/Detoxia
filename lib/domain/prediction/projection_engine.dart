import 'dart:math';

import 'package:detoxia/core/constants/app_constants.dart';

class ProjectionEngine {
  final double baselineSlipsPerWeek;
  final double habitStrength;
  final double regulationCapacity;
  double _adherenceFactor;

  ProjectionEngine({
    required this.baselineSlipsPerWeek,
    required this.habitStrength,
    required this.regulationCapacity,
    double adherenceFactor = 0.5,
  }) : _adherenceFactor = adherenceFactor;

  double get _decayRate =>
      AppConstants.baseDecayRate *
      regulationCapacity /
      max(habitStrength, 0.1);

  double projectedSlips(int weekNumber) {
    return baselineSlipsPerWeek *
        exp(-_decayRate * weekNumber * _adherenceFactor);
  }

  void updateAdherence({
    required double checkinRate,
    required double rescueUsageRate,
    required double boundaryCompliance,
  }) {
    _adherenceFactor = checkinRate * 0.4 +
        rescueUsageRate * 0.3 +
        boundaryCompliance * 0.3;
  }

  void recalibrate(double actualSlipsLastWeek, int weekNumber) {
    final projected = projectedSlips(weekNumber);
    if (projected > 0) {
      final ratio = actualSlipsLastWeek / projected;
      _adherenceFactor *= (1.0 / max(ratio, 0.5)).clamp(0.7, 1.3);
    }
  }

  Map<int, double> projectionCurve({int weeks = 12}) {
    return {
      for (int w = 1; w <= weeks; w++) w: projectedSlips(w),
    };
  }

  String weekProjectionText(int weekNumber) {
    final projected = projectedSlips(weekNumber);
    final reductionPct =
        ((1 - projected / max(baselineSlipsPerWeek, 0.1)) * 100)
            .round();
    return 'Week $weekNumber: $reductionPct% reduction in slips '
        '(~${projected.toStringAsFixed(1)}/week)';
  }
}
