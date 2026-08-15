class PathwayScore {
  final String pathwayId;
  final String label;
  final double mainProblemScore;
  final double modifierScore;
  final double routineRisk;
  final double triggerWeight;
  final double score0To10;
  final bool enabled;
  final String explanation;

  const PathwayScore({
    required this.pathwayId,
    required this.label,
    required this.mainProblemScore,
    required this.modifierScore,
    required this.routineRisk,
    required this.triggerWeight,
    required this.score0To10,
    required this.enabled,
    required this.explanation,
  });

  factory PathwayScore.fromJson(Map<String, dynamic> json) {
    return PathwayScore(
      pathwayId: json['pathwayId'] as String,
      label: json['label'] as String,
      mainProblemScore: (json['mainProblemScore'] as num).toDouble(),
      modifierScore: (json['modifierScore'] as num).toDouble(),
      routineRisk: (json['routineRisk'] as num).toDouble(),
      triggerWeight: (json['triggerWeight'] as num).toDouble(),
      score0To10: (json['score0To10'] as num).toDouble(),
      enabled: json['enabled'] as bool,
      explanation: json['explanation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pathwayId': pathwayId,
      'label': label,
      'mainProblemScore': mainProblemScore,
      'modifierScore': modifierScore,
      'routineRisk': routineRisk,
      'triggerWeight': triggerWeight,
      'score0To10': score0To10,
      'enabled': enabled,
      'explanation': explanation,
    };
  }
}
