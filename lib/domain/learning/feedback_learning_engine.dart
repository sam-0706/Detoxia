import 'models/intervention_feedback.dart';
import 'models/learning_state.dart';
import 'models/outcome.dart';

/// Stateless feedback learning engine for Detoxia.
///
/// All functions are pure and deterministic. No I/O, storage, wall-clock reads,
/// or Flutter dependencies are used. Formula source: `DETOXIA_V1_TASK_LIST.md`
/// Task 1.4 and `TASK_01_04_feedback_learning_engine.md`.
class FeedbackLearningEngine {
  FeedbackLearningEngine._();

  /// Updates recovery momentum using the Task 1.4 EMA formula.
  ///
  /// Outcome values come from [Outcome.value]:
  /// resisted = +1.0, slipped = -1.0, noUrge = +0.3, falseAlarm = 0.0.
  ///
  /// Formula:
  /// `dailyMomentum = 5 + outcome.value * 5`
  /// `newMomentum = 0.85 * oldMomentum + 0.15 * dailyMomentum`
  /// Result is clamped to 0..10.
  static double updateRecoveryMomentum(double oldMomentum, Outcome outcome) {
    final dailyMomentum = 5.0 + outcome.value * 5.0;
    return _clamp10(0.85 * oldMomentum + 0.15 * dailyMomentum);
  }

  /// Updates a trigger weight on the stored 0..10 scale.
  ///
  /// The spec target values are normalized 0..1 values:
  /// resisted = 1.0, slipped = 1.0, noUrge = 0.2, falseAlarm = 0.0.
  /// `TriggerWeight.weight0To10` and `LearningState.triggerReliabilityMap`
  /// store visible 0..10 values, so this method multiplies the target by 10
  /// before applying the EMA:
  /// `newWeight = oldWeight + 0.15 * (targetScaled - oldWeight)`.
  /// Result is clamped to 0..10.
  static double updateTriggerWeight(double oldWeight, Outcome outcome) {
    final targetScaled = _triggerTarget01(outcome) * 10.0;
    return _clamp10(oldWeight + 0.15 * (targetScaled - oldWeight));
  }

  /// Updates an intervention reward using the Task 1.4 EMA formula.
  ///
  /// Feedback rewards come from [InterventionFeedback.reward]:
  /// helped = +1.0, somewhat = +0.5, ignored = 0.0, didNotHelp = -0.5,
  /// slippedAfterTask = -1.0.
  ///
  /// Formula:
  /// `newReward = oldReward + 0.10 * (feedback.reward - oldReward)`.
  /// Result is clamped to -1.0..+1.0.
  static double updateInterventionReward(
    double oldReward,
    InterventionFeedback feedback,
  ) {
    return _clampReward(oldReward + 0.10 * (feedback.reward - oldReward));
  }

  /// Updates prediction accuracy using the Task 1.4 EMA formula.
  ///
  /// If `predicted == false`, accuracy is unchanged except for 0..10 clamping.
  /// If predicted and outcome is [Outcome.resisted] or [Outcome.slipped],
  /// accuracy moves toward 10. If predicted and outcome is [Outcome.noUrge] or
  /// [Outcome.falseAlarm], accuracy moves toward 0.
  ///
  /// Formula:
  /// `newAccuracy = oldAccuracy + 0.10 * (target - oldAccuracy)`.
  static double updatePredictionAccuracy(
    double oldAccuracy,
    bool predicted,
    Outcome outcome,
  ) {
    if (!predicted) {
      return _clamp10(oldAccuracy);
    }

    final target = outcome == Outcome.resisted || outcome == Outcome.slipped
        ? 10.0
        : 0.0;
    return _clamp10(oldAccuracy + 0.10 * (target - oldAccuracy));
  }

  /// Updates false-alarm rate using the Task 1.4 EMA formula.
  ///
  /// If predicted and outcome is [Outcome.noUrge] or [Outcome.falseAlarm], the
  /// false-alarm rate moves toward 10. Otherwise it moves toward 0.
  ///
  /// Formula:
  /// `newRate = oldRate + 0.10 * (target - oldRate)`.
  static double updateFalseAlarmRate(
    double oldRate,
    bool predicted,
    Outcome outcome,
  ) {
    final target =
        predicted &&
            (outcome == Outcome.noUrge || outcome == Outcome.falseAlarm)
        ? 10.0
        : 0.0;
    return _clamp10(oldRate + 0.10 * (target - oldRate));
  }

  /// Applies one feedback event to a [LearningState].
  ///
  /// Returns a new immutable [LearningState] with:
  /// - recovery momentum updated from [outcome]
  /// - prediction accuracy updated from [predicted] and [outcome]
  /// - false-alarm rate updated from [predicted] and [outcome]
  /// - `triggerReliabilityMap` entries updated from [triggerOutcomes]
  /// - `interventionRewardsMap` entries updated from [interventionFeedback]
  /// - `lastUpdatedAt` set to explicit [now]
  ///
  /// Missing map entries start from neutral values: trigger reliability 5.0 on
  /// the 0..10 scale, intervention reward 0.0 on the -1..+1 scale.
  static LearningState applyOutcome({
    required LearningState current,
    required Outcome outcome,
    required bool predicted,
    required Map<String, Outcome> triggerOutcomes,
    required Map<String, InterventionFeedback> interventionFeedback,
    required DateTime now,
  }) {
    final updatedTriggerMap = Map<String, double>.from(
      current.triggerReliabilityMap,
    );
    for (final entry in triggerOutcomes.entries) {
      final previous = updatedTriggerMap[entry.key] ?? 5.0;
      updatedTriggerMap[entry.key] = updateTriggerWeight(previous, entry.value);
    }

    final updatedInterventionMap = Map<String, double>.from(
      current.interventionRewardsMap,
    );
    for (final entry in interventionFeedback.entries) {
      final previous = updatedInterventionMap[entry.key] ?? 0.0;
      updatedInterventionMap[entry.key] = updateInterventionReward(
        previous,
        entry.value,
      );
    }

    return LearningState(
      recoveryMomentum: updateRecoveryMomentum(
        current.recoveryMomentum,
        outcome,
      ),
      predictionAccuracy: updatePredictionAccuracy(
        current.predictionAccuracy,
        predicted,
        outcome,
      ),
      falseAlarmRate: updateFalseAlarmRate(
        current.falseAlarmRate,
        predicted,
        outcome,
      ),
      triggerReliabilityMap: updatedTriggerMap,
      interventionRewardsMap: updatedInterventionMap,
      lastUpdatedAt: now,
    );
  }

  static double _triggerTarget01(Outcome outcome) {
    switch (outcome) {
      case Outcome.resisted:
      case Outcome.slipped:
        return 1.0;
      case Outcome.noUrge:
        return 0.2;
      case Outcome.falseAlarm:
        return 0.0;
    }
  }

  static double _clamp10(double value) {
    if (value < 0.0) return 0.0;
    if (value > 10.0) return 10.0;
    return value;
  }

  static double _clampReward(double value) {
    if (value < -1.0) return -1.0;
    if (value > 1.0) return 1.0;
    return value;
  }
}
