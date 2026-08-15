import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/learning/models/intervention_feedback.dart';
import 'package:detoxia/domain/learning/models/outcome.dart';
import 'package:detoxia/presentation/feedback/risk_window_feedback_sheet.dart';
import 'package:detoxia/presentation/feedback/task_feedback_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('1. risk window sheet shows 4 buttons', (tester) async {
    await tester.pumpWidget(_RiskHarness(onResult: (_) {}));

    await tester.tap(find.text('Open risk'));
    await tester.pumpAndSettle();

    expect(find.text('What happened during this support window?'), findsOneWidget);
    expect(find.text('Moved through'), findsOneWidget);
    expect(find.text('Reset moment'), findsOneWidget);
    expect(find.text('No urge'), findsOneWidget);
    expect(find.text('False alarm'), findsOneWidget);
  });

  testWidgets('2. tapping Resisted returns Outcome.resisted', (tester) async {
    Outcome? result;
    await tester.pumpWidget(_RiskHarness(onResult: (value) => result = value));

    await tester.tap(find.text('Open risk'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Moved through'));
    await tester.pumpAndSettle();

    expect(result, Outcome.resisted);
  });

  testWidgets('3. tapping Slipped returns Outcome.slipped', (tester) async {
    Outcome? result;
    await tester.pumpWidget(_RiskHarness(onResult: (value) => result = value));

    await tester.tap(find.text('Open risk'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset moment'));
    await tester.pumpAndSettle();

    expect(result, Outcome.slipped);
  });

  testWidgets('4. dismissing risk window sheet returns null', (tester) async {
    var completed = false;
    Outcome? result = Outcome.resisted;
    await tester.pumpWidget(
      _RiskHarness(
        onResult: (value) {
          result = value;
          completed = true;
        },
      ),
    );

    await tester.tap(find.text('Open risk'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    expect(completed, isTrue);
    expect(result, isNull);
  });

  testWidgets('5. task feedback sheet shows feedback buttons', (tester) async {
    await tester.pumpWidget(_TaskHarness(onResult: (_) {}));

    await tester.tap(find.text('Open task'));
    await tester.pumpAndSettle();

    expect(find.text('Did this task help?'), findsOneWidget);
    expect(find.text('Helped'), findsOneWidget);
    expect(find.text('Somewhat'), findsOneWidget);
    expect(find.text('Did not help'), findsOneWidget);
    expect(find.text('Ignored'), findsOneWidget);
    expect(find.text('Reset moment after task'), findsOneWidget);
  });

  testWidgets('6. tapping Helped returns InterventionFeedback.helped', (
    tester,
  ) async {
    InterventionFeedback? result;
    await tester.pumpWidget(_TaskHarness(onResult: (value) => result = value));

    await tester.tap(find.text('Open task'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Helped'));
    await tester.pumpAndSettle();

    expect(result, InterventionFeedback.helped);
  });
}

class _RiskHarness extends StatelessWidget {
  final ValueChanged<Outcome?> onResult;

  const _RiskHarness({required this.onResult});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  onResult(await showRiskWindowFeedback(context));
                },
                child: const Text('Open risk'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TaskHarness extends StatelessWidget {
  final ValueChanged<InterventionFeedback?> onResult;

  const _TaskHarness({required this.onResult});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  onResult(
                    await showTaskFeedback(
                      context,
                      interventionId: 'breathing_reset',
                    ),
                  );
                },
                child: const Text('Open task'),
              ),
            ),
          );
        },
      ),
    );
  }
}
