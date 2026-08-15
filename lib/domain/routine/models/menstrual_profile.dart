import 'menstrual_phase.dart';

class MenstrualProfile {
  final bool enabled;
  final DateTime? lastPeriodStartDate;
  final int? averageCycleLength;
  final int? averageBleedingLength;
  final String? regularity;
  final int? currentCycleDay;
  final MenstrualPhase currentPhase;
  final DateTime? nextPeriodEstimate;
  final double confidence;
  final double cycleSensitivityScore;

  const MenstrualProfile({
    required this.enabled,
    this.lastPeriodStartDate,
    this.averageCycleLength,
    this.averageBleedingLength,
    this.regularity,
    this.currentCycleDay,
    required this.currentPhase,
    this.nextPeriodEstimate,
    required this.confidence,
    required this.cycleSensitivityScore,
  });

  factory MenstrualProfile.fromJson(Map<String, dynamic> json) {
    return MenstrualProfile(
      enabled: json['enabled'] as bool,
      lastPeriodStartDate: json['lastPeriodStartDate'] != null
          ? DateTime.parse(json['lastPeriodStartDate'] as String)
          : null,
      averageCycleLength: json['averageCycleLength'] as int?,
      averageBleedingLength: json['averageBleedingLength'] as int?,
      regularity: json['regularity'] as String?,
      currentCycleDay: json['currentCycleDay'] as int?,
      currentPhase: menstrualPhaseFromJson(
        json['currentPhase'] as String? ?? 'unknown',
      ),
      nextPeriodEstimate: json['nextPeriodEstimate'] != null
          ? DateTime.parse(json['nextPeriodEstimate'] as String)
          : null,
      confidence: (json['confidence'] as num).toDouble(),
      cycleSensitivityScore:
          (json['cycleSensitivityScore'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'enabled': enabled,
      'lastPeriodStartDate': lastPeriodStartDate?.toIso8601String(),
      'averageCycleLength': averageCycleLength,
      'averageBleedingLength': averageBleedingLength,
      'regularity': regularity,
      'currentCycleDay': currentCycleDay,
      'currentPhase': currentPhase.name,
      'nextPeriodEstimate': nextPeriodEstimate?.toIso8601String(),
      'confidence': confidence,
      'cycleSensitivityScore': cycleSensitivityScore,
    };
  }
}
