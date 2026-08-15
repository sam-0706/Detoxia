import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/support_profile_repository.dart';
import 'package:detoxia/domain/learning/feedback_learning_engine.dart';
import 'package:detoxia/domain/learning/models/intervention_feedback.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/learning/models/outcome.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LearningService {
  final SupportProfileRepository profileRepo;
  final RegistrationRepository registrationRepo;

  const LearningService({
    required this.profileRepo,
    required this.registrationRepo,
  });

  Future<String> applyRiskWindowOutcome({
    required Outcome outcome,
    required bool predicted,
    Map<String, Outcome> triggerOutcomes = const {},
  }) async {
    final profile = await _latestProfile();
    if (profile == null) {
      return _messageForRiskOutcome(outcome);
    }

    final updated = FeedbackLearningEngine.applyOutcome(
      current: profile.learningState,
      outcome: outcome,
      predicted: predicted,
      triggerOutcomes: triggerOutcomes,
      interventionFeedback: const {},
      now: DateTime.now(),
    );
    await profileRepo.updateLearningState(
      profile.registrationProfileId,
      updated,
    );

    return _messageForRiskOutcome(outcome);
  }

  Future<String> applyInterventionFeedback({
    required String interventionId,
    required InterventionFeedback feedback,
  }) async {
    final profile = await _latestProfile();
    if (profile == null) {
      return _messageForInterventionFeedback(feedback);
    }

    final current = profile.learningState;
    final rewards = Map<String, double>.from(current.interventionRewardsMap);
    final previous = rewards[interventionId] ?? 0.0;
    rewards[interventionId] = FeedbackLearningEngine.updateInterventionReward(
      previous,
      feedback,
    );

    final updated = LearningState(
      recoveryMomentum: current.recoveryMomentum,
      predictionAccuracy: current.predictionAccuracy,
      falseAlarmRate: current.falseAlarmRate,
      triggerReliabilityMap: Map<String, double>.from(
        current.triggerReliabilityMap,
      ),
      interventionRewardsMap: rewards,
      lastUpdatedAt: DateTime.now(),
    );
    await profileRepo.updateLearningState(
      profile.registrationProfileId,
      updated,
    );

    return _messageForInterventionFeedback(feedback);
  }

  Future<SupportProfile?> _latestProfile() async {
    final registration = await registrationRepo.getProfile();
    if (registration == null) return null;
    return profileRepo.getLatestProfile(registration.id);
  }

  String _messageForRiskOutcome(Outcome outcome) {
    switch (outcome) {
      case Outcome.resisted:
        return 'You moved through a real support window. Recovery momentum +';
      case Outcome.slipped:
        return 'Rough window — we adjust and continue.';
      case Outcome.noUrge:
        return 'No urge logged. Detoxia will recalibrate.';
      case Outcome.falseAlarm:
        return "Tonight's alert was a false alarm. Detoxia will reduce similar interruptions.";
    }
  }

  String _messageForInterventionFeedback(InterventionFeedback feedback) {
    switch (feedback) {
      case InterventionFeedback.helped:
        return 'Saved. Detoxia will favor this kind of reset.';
      case InterventionFeedback.somewhat:
      case InterventionFeedback.ignored:
        return 'Noted.';
      case InterventionFeedback.didNotHelp:
        return 'Saved. Detoxia will rotate to a different reset.';
      case InterventionFeedback.slippedAfterTask:
        return "Rough window — we'll learn from this.";
    }
  }
}

final learningServiceProvider = Provider<LearningService>((ref) {
  return LearningService(
    profileRepo: ref.watch(supportProfileRepositoryProvider),
    registrationRepo: ref.watch(registrationRepositoryProvider),
  );
});
