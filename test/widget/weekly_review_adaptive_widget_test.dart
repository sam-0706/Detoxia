import 'package:detoxia/domain/weekly_review/adaptive_weekly_review_resolver.dart';
import 'package:detoxia/presentation/dashboard/weekly_review/weekly_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'sleep/anxiety review shows reflection cards without shame labels',
    (tester) async {
      const review = AdaptiveWeeklyReview(
        isLocked: false,
        title: 'Your Weekly Reflection',
        subtitle: 'A calm look at what protected you and what needs support.',
        impactTitle: 'How your sleep rhythm evolved',
        impactBody: 'From your local check-ins this week.',
        metrics: <WeeklyReviewMetric>[
          WeeklyReviewMetric(
            label: 'Sleep rhythm',
            value: '4.8',
            helper: '/10 average sleep quality',
          ),
          WeeklyReviewMetric(
            label: 'Sleep interruptions',
            value: '3',
            helper: 'Check-ins with poor sleep',
          ),
          WeeklyReviewMetric(
            label: 'Evening support',
            value: '5.2',
            helper: 'Late-window support signal',
          ),
        ],
        trendBars: <WeeklyReviewDayBar>[
          WeeklyReviewDayBar(dayLabel: 'Mon', value0To10: 4),
          WeeklyReviewDayBar(dayLabel: 'Tue', value0To10: 5),
          WeeklyReviewDayBar(dayLabel: 'Wed', value0To10: 4),
          WeeklyReviewDayBar(dayLabel: 'Thu', value0To10: 6),
        ],
        topDriverText: 'Stress appears to be your strongest driver this week.',
        bestProtectedText: 'You completed 4 support actions this week.',
        triggerChainText: 'stress → late night → phone',
        supportWindowsText: 'After work — 2 moments needed support.',
        bestResetText: 'Your top reset is helping.',
        patternText: 'stress after low sleep seems worth protecting.',
        experimentText: 'Try putting your phone away 30 minutes before bed.',
      );

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: WeeklyReviewScreen(reviewOverride: review),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // New reflection cards
      expect(find.text('Your Weekly Reflection'), findsOneWidget);
      expect(
        find.text('A calm look at what protected you and what needs support.'),
        findsOneWidget,
      );
      expect(find.text('What protected you this week'), findsOneWidget);
      expect(find.text('Your most common trigger chain'), findsOneWidget);
      expect(find.text('Your support windows'), findsOneWidget);
      expect(find.text('Best working reset'), findsOneWidget);
      expect(find.text('One pattern to watch'), findsOneWidget);
      expect(find.text('One tiny experiment for next week'), findsOneWidget);
      expect(find.text("Plan tomorrow's reset"), findsOneWidget);

      // No shame labels
      expect(find.textContaining('Setbacks'), findsNothing);
      expect(find.textContaining('Urges'), findsNothing);
      expect(find.textContaining('Slip Pattern'), findsNothing);
      expect(find.textContaining('high-risk'), findsNothing);
    },
  );
}
