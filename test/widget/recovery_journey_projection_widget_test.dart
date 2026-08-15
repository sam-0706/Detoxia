import 'package:detoxia/domain/journey/recovery_journey_projection_resolver.dart';
import 'package:detoxia/presentation/dashboard/recovery_projection/projection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows direction card with qualitative language, no fake precision', (
    tester,
  ) async {
    const projection = RecoveryJourneyProjection(
      isLocked: false,
      title: 'Your Recovery Path',
      summary: 'A calm look at your direction, not a prediction.',
      caption: 'Local data only. This is direction, not prediction.',
      lockedReason: null,
      directionItems: <String>[
        'Your recovery momentum is holding steady.',
        'Your support windows are becoming clearer.',
        'Your reset speed is improving.',
        'You are learning which resets fit.',
      ],
      points: <RecoveryJourneyPoint>[
        RecoveryJourneyPoint(week: 1, projectedEventsPerWeek: 2.4),
        RecoveryJourneyPoint(week: 2, projectedEventsPerWeek: 2.2),
        RecoveryJourneyPoint(week: 3, projectedEventsPerWeek: 2.0),
        RecoveryJourneyPoint(week: 4, projectedEventsPerWeek: 1.8),
        RecoveryJourneyPoint(week: 5, projectedEventsPerWeek: 1.6),
        RecoveryJourneyPoint(week: 6, projectedEventsPerWeek: 1.5),
        RecoveryJourneyPoint(week: 7, projectedEventsPerWeek: 1.3),
        RecoveryJourneyPoint(week: 8, projectedEventsPerWeek: 1.2),
        RecoveryJourneyPoint(week: 9, projectedEventsPerWeek: 1.1),
        RecoveryJourneyPoint(week: 10, projectedEventsPerWeek: 1.0),
        RecoveryJourneyPoint(week: 11, projectedEventsPerWeek: 0.9),
        RecoveryJourneyPoint(week: 12, projectedEventsPerWeek: 0.9),
      ],
    );

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProjectionScreen(projectionOverride: projection),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // New direction language
    expect(find.text('Your Recovery Path'), findsWidgets);
    expect(
      find.text('A calm look at your direction, not a prediction.'),
      findsOneWidget,
    );
    expect(find.text('Your current direction'), findsOneWidget);
    expect(
      find.text('Your recovery momentum is holding steady.'),
      findsOneWidget,
    );
    expect(find.text('Momentum trend'), findsOneWidget);
    expect(
      find.text('Local data only. This is direction, not prediction.'),
      findsOneWidget,
    );
    expect(
      find.textContaining('No cure prediction. No timeline.'),
      findsOneWidget,
    );
    expect(find.text('Go to Today'), findsOneWidget);

    // No fake precision
    expect(find.textContaining('Week 4'), findsNothing);
    expect(find.textContaining('Week 12'), findsNothing);
    expect(find.textContaining('/week'), findsNothing);
    expect(find.textContaining('projection curve'), findsNothing);
    expect(find.textContaining('70-80%'), findsNothing);
    expect(find.textContaining('70–80%'), findsNothing);
    expect(find.textContaining('after 12 weeks'), findsNothing);
  });
}
