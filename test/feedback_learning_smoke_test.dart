import 'package:detoxia/domain/learning/feedback_learning_engine.dart';
import 'package:detoxia/domain/learning/models/intervention_feedback.dart';
import 'package:detoxia/domain/learning/models/outcome.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeedbackLearningEngine smoke', () {
    test('updateRecoveryMomentum resisted moves from 5.0 to 5.75', () {
      final updated = FeedbackLearningEngine.updateRecoveryMomentum(
        5.0,
        Outcome.resisted,
      );

      expect(updated, closeTo(5.75, 0.001));
    });

    test('updateRecoveryMomentum slipped moves from 5.0 to 4.25', () {
      final updated = FeedbackLearningEngine.updateRecoveryMomentum(
        5.0,
        Outcome.slipped,
      );

      expect(updated, closeTo(4.25, 0.001));
    });

    test('updateInterventionReward helped moves from 0.0 to 0.1', () {
      final updated = FeedbackLearningEngine.updateInterventionReward(
        0.0,
        InterventionFeedback.helped,
      );

      expect(updated, closeTo(0.1, 0.001));
    });

    test(
      'updateInterventionReward slippedAfterTask moves from 0.0 to -0.1',
      () {
        final updated = FeedbackLearningEngine.updateInterventionReward(
          0.0,
          InterventionFeedback.slippedAfterTask,
        );

        expect(updated, closeTo(-0.1, 0.001));
      },
    );

    test('updateTriggerWeight resisted uses 0..10 target scale', () {
      // Spec target resisted=1.0 is normalized 0..1; engine scales it to 10.0
      // before EMA: 5 + 0.15 * (10 - 5) = 5.75.
      final updated = FeedbackLearningEngine.updateTriggerWeight(
        5.0,
        Outcome.resisted,
      );

      expect(updated, closeTo(5.75, 0.001));
    });
  });
}
