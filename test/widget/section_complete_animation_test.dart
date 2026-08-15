import 'package:detoxia/presentation/questionnaire/widgets/section_complete_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('1. Renders the message', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SectionCompleteAnimation(
          message: 'Routine Map unlocked',
          onComplete: () {},
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Routine Map unlocked'), findsOneWidget);
    expect(find.text('Tap to continue'), findsOneWidget);
  });

  testWidgets('2. Calls onComplete after the duration', (tester) async {
    bool completed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: SectionCompleteAnimation(
          message: 'Test message',
          onComplete: () {
            completed = true;
          },
          duration: const Duration(milliseconds: 2500),
        ),
      ),
    );

    await tester.pump();
    expect(completed, false);

    await tester.pump(const Duration(milliseconds: 2600));
    expect(completed, true);
  });

  testWidgets('3. Tap dismisses early', (tester) async {
    bool completed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: SectionCompleteAnimation(
          message: 'Test message',
          onComplete: () {
            completed = true;
          },
          duration: const Duration(milliseconds: 5000),
        ),
      ),
    );

    await tester.pump();
    expect(completed, false);

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expect(completed, true);
  });

  testWidgets('4. Picks the right icon for known message keywords', (
    tester,
  ) async {
    final testCases = [
      ('Routine Map unlocked', Icons.schedule),
      ('Sleep Engine calibrated', Icons.nightlight_round),
      ('Focus Pattern mapped', Icons.center_focus_strong),
      ('Anxiety Engine calibrated', Icons.air),
      ('Mood Support mapped', Icons.wb_sunny_outlined),
      ('Trigger Engine calibrated', Icons.bolt),
      ('Pathway Detector online', Icons.timeline),
      ('Personal Feedback Learning ready', Icons.tune),
      ('Unknown message', Icons.check_circle_outline),
    ];

    for (final (message, expectedIcon) in testCases) {
      await tester.pumpWidget(
        MaterialApp(
          home: SectionCompleteAnimation(
            message: message,
            onComplete: () {},
          ),
        ),
      );

      await tester.pump();

      expect(
        find.byWidgetPredicate(
          (widget) => widget is Icon && widget.icon == expectedIcon,
        ),
        findsOneWidget,
        reason: 'Expected $expectedIcon for message "$message"',
      );

      await tester.pumpWidget(Container());
      await tester.pump();
    }
  });
}
