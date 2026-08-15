import 'package:detoxia/domain/learning/feedback_learning_engine.dart';
import 'package:detoxia/domain/learning/models/intervention_feedback.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/learning/models/outcome.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('recovery momentum', () {
    test('resisted moves 5.0 to 5.75', () {
      expect(
        FeedbackLearningEngine.updateRecoveryMomentum(5.0, Outcome.resisted),
        closeTo(5.75, 0.001),
      );
    });

    test('slipped moves 5.0 to 4.25', () {
      expect(
        FeedbackLearningEngine.updateRecoveryMomentum(5.0, Outcome.slipped),
        closeTo(4.25, 0.001),
      );
    });

    test('noUrge moves 5.0 to 5.225', () {
      expect(
        FeedbackLearningEngine.updateRecoveryMomentum(5.0, Outcome.noUrge),
        closeTo(5.225, 0.001),
      );
    });

    test('falseAlarm leaves 5.0 unchanged', () {
      expect(
        FeedbackLearningEngine.updateRecoveryMomentum(5.0, Outcome.falseAlarm),
        closeTo(5.0, 0.001),
      );
    });

    test('repeated resists trend upward', () {
      var momentum = 5.0;
      for (var i = 0; i < 10; i++) {
        momentum = FeedbackLearningEngine.updateRecoveryMomentum(
          momentum,
          Outcome.resisted,
        );
      }
      expect(momentum, greaterThan(7.0));
    });

    test('repeated slips trend downward', () {
      var momentum = 5.0;
      for (var i = 0; i < 10; i++) {
        momentum = FeedbackLearningEngine.updateRecoveryMomentum(
          momentum,
          Outcome.slipped,
        );
      }
      expect(momentum, lessThan(3.0));
    });

    test('momentum clamps to 0..10', () {
      expect(
        FeedbackLearningEngine.updateRecoveryMomentum(100.0, Outcome.resisted),
        closeTo(10.0, 0.001),
      );
      expect(
        FeedbackLearningEngine.updateRecoveryMomentum(-100.0, Outcome.slipped),
        closeTo(0.0, 0.001),
      );
    });
  });

  group('trigger weight', () {
    test('resisted uses 0..10 target scale', () {
      expect(
        FeedbackLearningEngine.updateTriggerWeight(5.0, Outcome.resisted),
        closeTo(5.75, 0.001),
      );
    });

    test('slipped uses same 10 target as resisted', () {
      expect(
        FeedbackLearningEngine.updateTriggerWeight(5.0, Outcome.slipped),
        closeTo(5.75, 0.001),
      );
    });

    test('noUrge uses target 2.0 on the 0..10 scale', () {
      expect(
        FeedbackLearningEngine.updateTriggerWeight(5.0, Outcome.noUrge),
        closeTo(4.55, 0.001),
      );
    });

    test('falseAlarm uses target 0.0', () {
      expect(
        FeedbackLearningEngine.updateTriggerWeight(5.0, Outcome.falseAlarm),
        closeTo(4.25, 0.001),
      );
    });

    test('twenty consecutive resists settle near target', () {
      var weight = 5.0;
      for (var i = 0; i < 20; i++) {
        weight = FeedbackLearningEngine.updateTriggerWeight(
          weight,
          Outcome.resisted,
        );
      }
      expect(weight, closeTo(9.81, 0.05));
    });

    test('trigger weight clamps 0..10', () {
      expect(
        FeedbackLearningEngine.updateTriggerWeight(100.0, Outcome.resisted),
        closeTo(10.0, 0.001),
      );
      expect(
        FeedbackLearningEngine.updateTriggerWeight(-100.0, Outcome.falseAlarm),
        closeTo(0.0, 0.001),
      );
    });
  });

  group('intervention reward', () {
    test('helped moves 0.0 to 0.1', () {
      expect(
        FeedbackLearningEngine.updateInterventionReward(
          0.0,
          InterventionFeedback.helped,
        ),
        closeTo(0.1, 0.001),
      );
    });

    test('somewhat moves 0.0 to 0.05', () {
      expect(
        FeedbackLearningEngine.updateInterventionReward(
          0.0,
          InterventionFeedback.somewhat,
        ),
        closeTo(0.05, 0.001),
      );
    });

    test('ignored leaves 0.0 unchanged', () {
      expect(
        FeedbackLearningEngine.updateInterventionReward(
          0.0,
          InterventionFeedback.ignored,
        ),
        closeTo(0.0, 0.001),
      );
    });

    test('didNotHelp moves 0.0 to -0.05', () {
      expect(
        FeedbackLearningEngine.updateInterventionReward(
          0.0,
          InterventionFeedback.didNotHelp,
        ),
        closeTo(-0.05, 0.001),
      );
    });

    test('slippedAfterTask moves 0.0 to -0.1', () {
      expect(
        FeedbackLearningEngine.updateInterventionReward(
          0.0,
          InterventionFeedback.slippedAfterTask,
        ),
        closeTo(-0.1, 0.001),
      );
    });

    test('repeated helped trends toward plus one', () {
      var reward = 0.0;
      for (var i = 0; i < 20; i++) {
        reward = FeedbackLearningEngine.updateInterventionReward(
          reward,
          InterventionFeedback.helped,
        );
      }
      expect(reward, closeTo(0.88, 0.02));
    });

    test('repeated slippedAfterTask trends toward minus one', () {
      var reward = 0.0;
      for (var i = 0; i < 20; i++) {
        reward = FeedbackLearningEngine.updateInterventionReward(
          reward,
          InterventionFeedback.slippedAfterTask,
        );
      }
      expect(reward, closeTo(-0.88, 0.02));
    });

    test('intervention reward clamps -1..1', () {
      expect(
        FeedbackLearningEngine.updateInterventionReward(
          100.0,
          InterventionFeedback.helped,
        ),
        closeTo(1.0, 0.001),
      );
      expect(
        FeedbackLearningEngine.updateInterventionReward(
          -100.0,
          InterventionFeedback.slippedAfterTask,
        ),
        closeTo(-1.0, 0.001),
      );
    });
  });

  group('prediction accuracy', () {
    test('predicted resisted moves toward 10', () {
      expect(
        FeedbackLearningEngine.updatePredictionAccuracy(
          5.0,
          true,
          Outcome.resisted,
        ),
        closeTo(5.5, 0.001),
      );
    });

    test('predicted slipped moves toward 10', () {
      expect(
        FeedbackLearningEngine.updatePredictionAccuracy(
          5.0,
          true,
          Outcome.slipped,
        ),
        closeTo(5.5, 0.001),
      );
    });

    test('predicted noUrge moves toward 0', () {
      expect(
        FeedbackLearningEngine.updatePredictionAccuracy(
          5.0,
          true,
          Outcome.noUrge,
        ),
        closeTo(4.5, 0.001),
      );
    });

    test('predicted falseAlarm moves toward 0', () {
      expect(
        FeedbackLearningEngine.updatePredictionAccuracy(
          5.0,
          true,
          Outcome.falseAlarm,
        ),
        closeTo(4.5, 0.001),
      );
    });

    test('not predicted leaves accuracy unchanged', () {
      expect(
        FeedbackLearningEngine.updatePredictionAccuracy(
          5.0,
          false,
          Outcome.resisted,
        ),
        closeTo(5.0, 0.001),
      );
    });
  });

  group('false alarm rate', () {
    test('predicted falseAlarm moves toward 10', () {
      expect(
        FeedbackLearningEngine.updateFalseAlarmRate(
          5.0,
          true,
          Outcome.falseAlarm,
        ),
        closeTo(5.5, 0.001),
      );
    });

    test('predicted noUrge moves toward 10', () {
      expect(
        FeedbackLearningEngine.updateFalseAlarmRate(5.0, true, Outcome.noUrge),
        closeTo(5.5, 0.001),
      );
    });

    test('predicted resisted moves toward 0', () {
      expect(
        FeedbackLearningEngine.updateFalseAlarmRate(
          5.0,
          true,
          Outcome.resisted,
        ),
        closeTo(4.5, 0.001),
      );
    });

    test('not predicted moves toward 0', () {
      expect(
        FeedbackLearningEngine.updateFalseAlarmRate(
          5.0,
          false,
          Outcome.falseAlarm,
        ),
        closeTo(4.5, 0.001),
      );
    });
  });

  group('applyOutcome', () {
    test('updates scalar learning fields and timestamp', () {
      final now = DateTime.parse('2026-05-19T12:00:00.000Z');
      final current = LearningState(
        recoveryMomentum: 5.0,
        predictionAccuracy: 5.0,
        falseAlarmRate: 5.0,
        triggerReliabilityMap: const {},
        interventionRewardsMap: const {},
        lastUpdatedAt: DateTime.parse('2026-05-18T12:00:00.000Z'),
      );

      final updated = FeedbackLearningEngine.applyOutcome(
        current: current,
        outcome: Outcome.resisted,
        predicted: true,
        triggerOutcomes: const {},
        interventionFeedback: const {},
        now: now,
      );

      expect(updated.recoveryMomentum, closeTo(5.75, 0.001));
      expect(updated.predictionAccuracy, closeTo(5.5, 0.001));
      expect(updated.falseAlarmRate, closeTo(4.5, 0.001));
      expect(updated.lastUpdatedAt, now);
    });

    test('updates existing trigger and intervention entries', () {
      final current = LearningState(
        recoveryMomentum: 5.0,
        predictionAccuracy: 5.0,
        falseAlarmRate: 5.0,
        triggerReliabilityMap: const {'stress': 5.0},
        interventionRewardsMap: const {'walk': 0.0},
        lastUpdatedAt: DateTime.parse('2026-05-18T12:00:00.000Z'),
      );

      final updated = FeedbackLearningEngine.applyOutcome(
        current: current,
        outcome: Outcome.resisted,
        predicted: true,
        triggerOutcomes: const {'stress': Outcome.resisted},
        interventionFeedback: const {'walk': InterventionFeedback.helped},
        now: DateTime.parse('2026-05-19T12:00:00.000Z'),
      );

      expect(updated.triggerReliabilityMap['stress'], closeTo(5.75, 0.001));
      expect(updated.interventionRewardsMap['walk'], closeTo(0.1, 0.001));
    });

    test('starts missing map entries from documented neutral defaults', () {
      final current = LearningState(
        recoveryMomentum: 5.0,
        predictionAccuracy: 5.0,
        falseAlarmRate: 5.0,
        triggerReliabilityMap: const {},
        interventionRewardsMap: const {},
        lastUpdatedAt: DateTime.parse('2026-05-18T12:00:00.000Z'),
      );

      final updated = FeedbackLearningEngine.applyOutcome(
        current: current,
        outcome: Outcome.falseAlarm,
        predicted: true,
        triggerOutcomes: const {'boredom': Outcome.falseAlarm},
        interventionFeedback: const {
          'breathing': InterventionFeedback.slippedAfterTask,
        },
        now: DateTime.parse('2026-05-19T12:00:00.000Z'),
      );

      expect(updated.triggerReliabilityMap['boredom'], closeTo(4.25, 0.001));
      expect(updated.interventionRewardsMap['breathing'], closeTo(-0.1, 0.001));
    });
  });
}
