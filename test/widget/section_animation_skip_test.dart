import 'package:detoxia/presentation/questionnaire/widgets/section_complete_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('tap skips SectionCompleteAnimation before full duration', (
    tester,
  ) async {
    var completed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: SectionCompleteAnimation(
          message: 'Routine Map unlocked',
          duration: const Duration(seconds: 5),
          onComplete: () => completed = true,
        ),
      ),
    );
    await tester.pump();

    expect(completed, isFalse);
    expect(find.text('Tap to continue'), findsOneWidget);

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expect(completed, isTrue);
  });
}
