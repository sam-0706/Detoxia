import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/routine/models/menstrual_profile.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';

import 'domain_score.dart';

class SupportProfile {
  final int registrationProfileId;
  final List<String> selectedGoals;
  final List<DomainScore> domainScores;
  final RoutineProfile routineProfile;
  final SleepProfile sleepProfile;
  final MenstrualProfile? menstrualProfile;
  final List<TriggerWeight> triggerWeights;
  final List<PathwayScore> pathwayScores;
  final InterventionPreferences interventionPreferences;
  final LearningState learningState;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SupportProfile({
    required this.registrationProfileId,
    required this.selectedGoals,
    required this.domainScores,
    required this.routineProfile,
    required this.sleepProfile,
    this.menstrualProfile,
    required this.triggerWeights,
    required this.pathwayScores,
    required this.interventionPreferences,
    required this.learningState,
    required this.createdAt,
    required this.updatedAt,
  });

  DomainScore? scoreFor(String id) {
    for (final score in domainScores) {
      if (score.id == id) return score;
    }
    return null;
  }

  factory SupportProfile.fromJson(Map<String, dynamic> json) {
    return SupportProfile(
      registrationProfileId: json['registrationProfileId'] as int,
      selectedGoals: List<String>.from(json['selectedGoals'] as List),
      domainScores: (json['domainScores'] as List)
          .map(
            (e) => DomainScore.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      routineProfile: RoutineProfile.fromJson(
        json['routineProfile'] as Map<String, dynamic>,
      ),
      sleepProfile: SleepProfile.fromJson(
        json['sleepProfile'] as Map<String, dynamic>,
      ),
      menstrualProfile: json['menstrualProfile'] != null
          ? MenstrualProfile.fromJson(
              json['menstrualProfile'] as Map<String, dynamic>,
            )
          : null,
      triggerWeights: (json['triggerWeights'] as List)
          .map(
            (e) => TriggerWeight.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      pathwayScores: (json['pathwayScores'] as List)
          .map(
            (e) => PathwayScore.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      interventionPreferences: InterventionPreferences.fromJson(
        json['interventionPreferences'] as Map<String, dynamic>,
      ),
      learningState: LearningState.fromJson(
        json['learningState'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'registrationProfileId': registrationProfileId,
      'selectedGoals': selectedGoals,
      'domainScores': domainScores.map((s) => s.toJson()).toList(),
      'routineProfile': routineProfile.toJson(),
      'sleepProfile': sleepProfile.toJson(),
      'menstrualProfile': menstrualProfile?.toJson(),
      'triggerWeights': triggerWeights.map((t) => t.toJson()).toList(),
      'pathwayScores': pathwayScores.map((p) => p.toJson()).toList(),
      'interventionPreferences': interventionPreferences.toJson(),
      'learningState': learningState.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
