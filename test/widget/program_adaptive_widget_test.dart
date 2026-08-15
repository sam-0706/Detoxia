import 'package:detoxia/domain/program/adaptive_program_resolver.dart';
import 'package:detoxia/presentation/program/program_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('non-sexual plan keeps phases and removes detox-only labels', (
    tester,
  ) async {
    const plan = AdaptiveProgramPlan(
      isLocked: false,
      weekLabel: 'Week 1 of 12',
      phaseLabel: 'Phase 1',
      subtitle: 'Baseline + Map: calibrating your sleep stability.',
      starterGuidance:
          'This program adapts by selected goals and local progress. No fixed outcome guarantees are shown.',
      phases: [
        ProgramPhasePlan(
          title: 'Phase 1: Baseline + Map',
          weeks: 'Weeks 1-2',
          modules: [
            ProgramModuleItem(
              title: 'Map sleep disruptions',
              description: 'Track late-night support windows.',
              complete: false,
            ),
          ],
        ),
        ProgramPhasePlan(
          title: 'Phase 2: Interrupt + Stabilize',
          weeks: 'Weeks 3-5',
          modules: [
            ProgramModuleItem(
              title: 'Sleep reset drills',
              description: '2-5 minute downshift actions.',
              complete: false,
            ),
          ],
        ),
        ProgramPhasePlan(
          title: 'Phase 3: Rebuild Control',
          weeks: 'Weeks 6-8',
          modules: [
            ProgramModuleItem(
              title: 'Rebuild sleep consistency',
              description: 'Stabilize sleep/wake anchors.',
              complete: false,
            ),
          ],
        ),
        ProgramPhasePlan(
          title: 'Phase 4: Maintain + Prevent',
          weeks: 'Weeks 9-12',
          modules: [
            ProgramModuleItem(
              title: 'Prevent sleep disruptions',
              description: 'Use recovery plans after disrupted nights.',
              complete: false,
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProgramScreen(planOverride: plan),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Phase 1: Baseline + Map'), findsOneWidget);
    expect(find.text('Phase 2: Interrupt + Stabilize'), findsOneWidget);
    expect(find.text('Phase 3: Rebuild Control'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Phase 4: Maintain + Prevent'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Phase 4: Maintain + Prevent'), findsOneWidget);
    expect(find.textContaining('urge'), findsNothing);
    expect(find.textContaining('setback'), findsNothing);
  });
}
