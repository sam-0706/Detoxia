class LearningState {
  final double recoveryMomentum;
  final double predictionAccuracy;
  final double falseAlarmRate;
  final Map<String, double> triggerReliabilityMap;
  final Map<String, double> interventionRewardsMap;
  final DateTime lastUpdatedAt;

  const LearningState({
    this.recoveryMomentum = 5.0,
    required this.predictionAccuracy,
    required this.falseAlarmRate,
    required this.triggerReliabilityMap,
    required this.interventionRewardsMap,
    required this.lastUpdatedAt,
  });

  factory LearningState.fromJson(Map<String, dynamic> json) {
    return LearningState(
      recoveryMomentum: (json['recoveryMomentum'] as num).toDouble(),
      predictionAccuracy: (json['predictionAccuracy'] as num).toDouble(),
      falseAlarmRate: (json['falseAlarmRate'] as num).toDouble(),
      triggerReliabilityMap: Map<String, double>.from(
        (json['triggerReliabilityMap'] as Map).map(
          (k, v) => MapEntry(k as String, (v as num).toDouble()),
        ),
      ),
      interventionRewardsMap: Map<String, double>.from(
        (json['interventionRewardsMap'] as Map).map(
          (k, v) => MapEntry(k as String, (v as num).toDouble()),
        ),
      ),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'recoveryMomentum': recoveryMomentum,
      'predictionAccuracy': predictionAccuracy,
      'falseAlarmRate': falseAlarmRate,
      'triggerReliabilityMap': triggerReliabilityMap,
      'interventionRewardsMap': interventionRewardsMap,
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }
}
