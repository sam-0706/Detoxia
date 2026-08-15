import 'package:detoxia/domain/scoring/time_window_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('midpointMinutes', () {
    test('returns midpoint for a same-day one-hour window', () {
      expect(midpointMinutes(360, 420), 390);
    });

    test('returns midpoint for same-day morning window', () {
      expect(midpointMinutes(480, 600), 540);
    });

    test('handles wrap-around midnight using forward window convention', () {
      // 23:00 to 00:30 spans 90 minutes, so midpoint is 23:45 = 1425.
      expect(midpointMinutes(1380, 30), 1425);
    });

    test('wrap-around result is normalized into the day', () {
      expect(midpointMinutes(1380, 60), 0);
    });
  });

  group('minutesBetweenAcrossMidnight', () {
    test('returns same-day duration in hours', () {
      expect(minutesBetweenAcrossMidnight(360, 420), closeTo(1.0, 0.001));
    });

    test('returns cross-midnight sleep duration in hours', () {
      expect(minutesBetweenAcrossMidnight(1380, 390), closeTo(7.5, 0.001));
    });

    test('returns zero for equal start and end', () {
      expect(minutesBetweenAcrossMidnight(600, 600), closeTo(0.0, 0.001));
    });
  });

  group('clamps', () {
    test('clamp01 bounds values to 0..1', () {
      expect(clamp01(-0.5), closeTo(0.0, 0.001));
      expect(clamp01(0.5), closeTo(0.5, 0.001));
      expect(clamp01(1.5), closeTo(1.0, 0.001));
    });

    test('clamp10 bounds values to 0..10', () {
      expect(clamp10(-1.0), closeTo(0.0, 0.001));
      expect(clamp10(4.5), closeTo(4.5, 0.001));
      expect(clamp10(11.0), closeTo(10.0, 0.001));
    });
  });
}
