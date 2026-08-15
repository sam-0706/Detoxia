class SleepProfile {
  final String sleepAttemptWindow;
  final String wakeWindow;
  final String sleepLatencyRange;
  final int estimatedSleepStartMinutes;
  final int estimatedWakeTimeMinutes;
  final double estimatedSleepDurationHours;
  final double targetSleepHours;
  final double dailySleepDebtHours;
  final double estimatedSevenDaySleepDebtHours;
  final double sleepDebtScore;
  final double sleepDisruptionScore;
  final double sleepRiskScore;
  final double confidence;

  const SleepProfile({
    required this.sleepAttemptWindow,
    required this.wakeWindow,
    required this.sleepLatencyRange,
    required this.estimatedSleepStartMinutes,
    required this.estimatedWakeTimeMinutes,
    required this.estimatedSleepDurationHours,
    required this.targetSleepHours,
    required this.dailySleepDebtHours,
    required this.estimatedSevenDaySleepDebtHours,
    required this.sleepDebtScore,
    required this.sleepDisruptionScore,
    required this.sleepRiskScore,
    required this.confidence,
  });

  factory SleepProfile.fromJson(Map<String, dynamic> json) {
    return SleepProfile(
      sleepAttemptWindow: json['sleepAttemptWindow'] as String,
      wakeWindow: json['wakeWindow'] as String,
      sleepLatencyRange: json['sleepLatencyRange'] as String,
      estimatedSleepStartMinutes: json['estimatedSleepStartMinutes'] as int,
      estimatedWakeTimeMinutes: json['estimatedWakeTimeMinutes'] as int,
      estimatedSleepDurationHours:
          (json['estimatedSleepDurationHours'] as num).toDouble(),
      targetSleepHours: (json['targetSleepHours'] as num).toDouble(),
      dailySleepDebtHours: (json['dailySleepDebtHours'] as num).toDouble(),
      estimatedSevenDaySleepDebtHours:
          (json['estimatedSevenDaySleepDebtHours'] as num).toDouble(),
      sleepDebtScore: (json['sleepDebtScore'] as num).toDouble(),
      sleepDisruptionScore: (json['sleepDisruptionScore'] as num).toDouble(),
      sleepRiskScore: (json['sleepRiskScore'] as num).toDouble(),
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sleepAttemptWindow': sleepAttemptWindow,
      'wakeWindow': wakeWindow,
      'sleepLatencyRange': sleepLatencyRange,
      'estimatedSleepStartMinutes': estimatedSleepStartMinutes,
      'estimatedWakeTimeMinutes': estimatedWakeTimeMinutes,
      'estimatedSleepDurationHours': estimatedSleepDurationHours,
      'targetSleepHours': targetSleepHours,
      'dailySleepDebtHours': dailySleepDebtHours,
      'estimatedSevenDaySleepDebtHours': estimatedSevenDaySleepDebtHours,
      'sleepDebtScore': sleepDebtScore,
      'sleepDisruptionScore': sleepDisruptionScore,
      'sleepRiskScore': sleepRiskScore,
      'confidence': confidence,
    };
  }
}
