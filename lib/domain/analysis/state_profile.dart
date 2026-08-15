import 'dart:math';

class StateProfile {
  final double confidenceIndex;
  final double selfControlRating;
  final double vulnerabilityIndex;
  final Map<String, double> triggerSensitivity;
  final double recoveryMomentum;
  final DownstreamImpact downstreamImpact;

  const StateProfile({
    required this.confidenceIndex,
    required this.selfControlRating,
    required this.vulnerabilityIndex,
    required this.triggerSensitivity,
    required this.recoveryMomentum,
    required this.downstreamImpact,
  });

  factory StateProfile.compute({
    required double streakScore,
    required double rescueSuccessRate,
    required double selfReportedConfidenceAvg,
    required double improvementTrend,
    required int urgesResisted,
    required int totalUrges,
    required double sleepBoundaryCompliance,
    required double sleepQualityAvg,
    required double stressAvg,
    required double confidenceTomorrowAvg,
    required bool recentSlip,
    required Map<String, double> triggerSlipRates,
    required double slipFrequencyTrend,
    required DownstreamImpact impact,
  }) {
    final confidence = (0.30 * (streakScore / 100.0 * 100) +
            0.25 * (rescueSuccessRate * 100) +
            0.25 * (selfReportedConfidenceAvg * 10) +
            0.20 * (improvementTrend > 0 ? 70 : improvementTrend < 0 ? 30 : 50))
        .clamp(0.0, 100.0);

    final selfControl = totalUrges > 0
        ? ((urgesResisted / totalUrges) * 60 +
                sleepBoundaryCompliance * 20 +
                20)
            .clamp(0.0, 100.0)
        : 50.0;

    final vulnerability = (0.30 * ((10 - sleepQualityAvg) / 10 * 100) +
            0.25 * (stressAvg / 10 * 100) +
            0.25 * (recentSlip ? 80 : 0) +
            0.20 * ((10 - confidenceTomorrowAvg) / 10 * 100))
        .clamp(0.0, 100.0);

    final momentum = slipFrequencyTrend < -0.1
        ? min(80.0, -slipFrequencyTrend * 200)
        : slipFrequencyTrend > 0.1
            ? max(-80.0, -slipFrequencyTrend * 200)
            : 0.0;

    return StateProfile(
      confidenceIndex: confidence,
      selfControlRating: selfControl,
      vulnerabilityIndex: vulnerability,
      triggerSensitivity: triggerSlipRates,
      recoveryMomentum: momentum,
      downstreamImpact: impact,
    );
  }

  String get confidenceText {
    if (confidenceIndex >= 70) return 'Strong and growing';
    if (confidenceIndex >= 50) return 'Building steadily';
    if (confidenceIndex >= 30) return 'Developing';
    return 'Needs support';
  }

  String get momentumText {
    if (recoveryMomentum > 20) return 'Positive momentum';
    if (recoveryMomentum < -20) return 'Losing ground';
    return 'Holding steady';
  }
}

class DownstreamImpact {
  final double moodAfterSlip;
  final double moodAfterClean;
  final double sleepOnSlipNight;
  final double sleepOnCleanNight;
  final double confidenceAfterSlip;
  final double confidenceAfterClean;
  final double stressInSlipWeek;
  final double stressInCleanWeek;

  const DownstreamImpact({
    this.moodAfterSlip = 5.0,
    this.moodAfterClean = 5.0,
    this.sleepOnSlipNight = 3.0,
    this.sleepOnCleanNight = 3.0,
    this.confidenceAfterSlip = 5.0,
    this.confidenceAfterClean = 5.0,
    this.stressInSlipWeek = 5.0,
    this.stressInCleanWeek = 5.0,
  });

  double get moodDelta => moodAfterClean - moodAfterSlip;
  double get sleepDelta => sleepOnCleanNight - sleepOnSlipNight;
  double get confidenceDelta =>
      confidenceAfterClean - confidenceAfterSlip;

  String get moodInsight =>
      'Your mood averages ${moodAfterSlip.toStringAsFixed(1)}/10 '
      'the day after a slip vs '
      '${moodAfterClean.toStringAsFixed(1)}/10 after a steady day.';

  String get sleepInsight =>
      'You sleep ${sleepDelta.toStringAsFixed(1)} points better '
      'on steady nights.';
}
