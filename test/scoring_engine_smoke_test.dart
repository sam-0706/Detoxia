import 'package:detoxia/domain/scoring/detoxia_scoring_engine.dart';
import 'package:detoxia/domain/scoring/score_band.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DetoxiaScoringEngine smoke', () {
    test('normalizeScore(0, 15) → 0.0', () {
      expect(DetoxiaScoringEngine.normalizeScore(0, 15), closeTo(0.0, 0.001));
    });

    test('normalizeScore(15, 15) → 10.0', () {
      expect(
        DetoxiaScoringEngine.normalizeScore(15, 15),
        closeTo(10.0, 0.001),
      );
    });

    test('normalizeScore(7.5, 15) → 5.0', () {
      expect(
        DetoxiaScoringEngine.normalizeScore(7.5, 15),
        closeTo(5.0, 0.001),
      );
    });

    test('scoreBand boundaries: 2.4 → Low, 2.5 → Mild', () {
      expect(scoreBand(2.4), 'Low');
      expect(scoreBand(2.5), 'Mild');
    });

    test('scoreScrollingControl all-zero answers → visibleScore 0.0', () {
      final score =
          DetoxiaScoringEngine.scoreScrollingControl([0, 0, 0, 0, 0]);
      expect(score.visibleScore, closeTo(0.0, 0.001));
    });

    test('scoreScrollingControl all-max answers → visibleScore 10.0', () {
      final score =
          DetoxiaScoringEngine.scoreScrollingControl([3, 3, 3, 3, 3]);
      expect(score.visibleScore, closeTo(10.0, 0.001));
    });
  });
}
