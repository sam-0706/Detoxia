import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/event_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/support_profile_repository.dart';
import 'package:detoxia/domain/weekly_review/adaptive_weekly_review_resolver.dart';
import 'package:detoxia/presentation/home/home_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeeklyReviewScreen extends ConsumerStatefulWidget {
  final AdaptiveWeeklyReview? reviewOverride;

  const WeeklyReviewScreen({super.key, this.reviewOverride});

  @override
  ConsumerState<WeeklyReviewScreen> createState() =>
      _WeeklyReviewScreenState();
}

class _WeeklyReviewScreenState
    extends ConsumerState<WeeklyReviewScreen> {
  final AdaptiveWeeklyReviewResolver _resolver =
      const AdaptiveWeeklyReviewResolver();
  AdaptiveWeeklyReview? _review;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final override = widget.reviewOverride;
    if (override != null) {
      setState(() {
        _review = override;
      });
      return;
    }

    final registration = await ref.read(registrationRepositoryProvider).getProfile();
    final supportProfile = registration == null
        ? null
        : await ref
              .read(supportProfileRepositoryProvider)
              .getLatestProfile(registration.id);
    final urges = await ref.read(eventRepositoryProvider).getUrgesLastDays(7);
    final slips = await ref.read(eventRepositoryProvider).getSlipsLastDays(7);
    final checkins = await ref.read(eventRepositoryProvider).getCheckinsLastDays(7);
    final completedTasks = await _completedTasksLast7Days();

    final review = _resolver.resolve(
      supportProfile: supportProfile,
      checkins: checkins
          .map(
            (row) => <String, dynamic>{
              'date': row.date,
              'hadUrge': row.hadUrge,
              'slipped': row.slipped,
              'sleepQuality': row.sleepQuality,
              'mood': row.mood,
              'stress': row.stress,
              'confidenceTomorrow': row.confidenceTomorrow,
              'mainTrigger': row.mainTrigger,
            },
          )
          .toList(growable: false),
      urgesLast7Days: urges.length,
      slipsLast7Days: slips.length,
      completedTasksLast7Days: completedTasks,
    );

    setState(() {
      _review = review;
    });
  }

  Future<int> _completedTasksLast7Days() async {
    final db = ref.read(databaseProvider);
    final since = DateTime.now().subtract(const Duration(days: 7));
    final rows = await (db.select(db.dailyTaskAssignments)
          ..where((t) => t.date.isBiggerOrEqualValue(since))
          ..where((t) => t.completed.equals(true)))
        .get();
    return rows.length;
  }

  @override
  Widget build(BuildContext context) {
    final review = _review;
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Reflection')),
      body: review == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    review.subtitle,
                    style:  TextStyle(color: AppTheme.palette(context).textSecondary),
                  ),
                  const SizedBox(height: 20),
                  if (review.isLocked)
                    _buildLockedCard(review)
                  else ...[
                    _buildProtectedCard(review),
                    const SizedBox(height: 16),
                    _buildTriggerChainCard(review),
                    const SizedBox(height: 16),
                    _buildSupportWindowsCard(review),
                    const SizedBox(height: 16),
                    _buildBestResetCard(review),
                    const SizedBox(height: 16),
                    _buildPatternCard(review),
                    const SizedBox(height: 16),
                    _buildExperimentCard(review),
                    const SizedBox(height: 20),
                    _buildSummaryCards(review),
                    const SizedBox(height: 24),
                    _buildTrendChart(review),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                          );
                        },
                        child: const Text("Plan tomorrow's reset"),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildLockedCard(AdaptiveWeeklyReview review) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          review.impactBody,
          style:  TextStyle(color: AppTheme.palette(context).textSecondary),
        ),
      ),
    );
  }

  // ── New reflection cards ─────────────────────────────────────────────

  Widget _buildProtectedCard(AdaptiveWeeklyReview review) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shield_outlined, color: AppTheme.palette(context).success, size: 20),
                const SizedBox(width: 8),
                Text(
                  'What protected you this week',
                  style: TextStyle(
                    color: AppTheme.palette(context).textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.bestProtectedText,
              style:  TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTriggerChainCard(AdaptiveWeeklyReview review) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_tree_outlined,
                    color: AppTheme.palette(context).accent, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Your most common trigger chain',
                  style: TextStyle(
                    color: AppTheme.palette(context).textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.triggerChainText,
              style: TextStyle(
                color: AppTheme.palette(context).textSecondary,
                fontSize: 15,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportWindowsCard(AdaptiveWeeklyReview review) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.schedule, color: AppTheme.palette(context).supportNeeded, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Your support windows',
                  style: TextStyle(
                    color: AppTheme.palette(context).textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.supportWindowsText,
              style:  TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestResetCard(AdaptiveWeeklyReview review) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: AppTheme.palette(context).accent, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Best working reset',
                  style: TextStyle(
                    color: AppTheme.palette(context).textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.bestResetText,
              style:  TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatternCard(AdaptiveWeeklyReview review) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.visibility_outlined,
                    color: AppTheme.palette(context).protectMoment, size: 20),
                const SizedBox(width: 8),
                Text(
                  'One pattern to watch',
                  style: TextStyle(
                    color: AppTheme.palette(context).textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.patternText,
              style:  TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperimentCard(AdaptiveWeeklyReview review) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science_outlined,
                    color: AppTheme.palette(context).success, size: 20),
                const SizedBox(width: 8),
                Text(
                  'One tiny experiment for next week',
                  style: TextStyle(
                    color: AppTheme.palette(context).textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.experimentText,
              style:  TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  // ── Existing widgets (kept, reframed) ────────────────────────────────

  Widget _buildSummaryCards(AdaptiveWeeklyReview review) {
    return Row(
      children: [
        for (var i = 0; i < review.metrics.length; i++) ...[
          _SummaryCard(
            label: review.metrics[i].label,
            value: review.metrics[i].value,
            helper: review.metrics[i].helper,
            color: i == 0
                ? AppTheme.palette(context).supportNeeded
                : i == 1
                    ? AppTheme.palette(context).accent
                    : AppTheme.palette(context).success,
          ),
          if (i != review.metrics.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }

  Widget _buildTrendChart(AdaptiveWeeklyReview review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Check-in rhythm',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              maxY: 10,
              barGroups: List.generate(review.trendBars.length, (index) {
                final bar = review.trendBars[index];
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: bar.value0To10,
                      color: AppTheme.palette(context).accent,
                      width: 14,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= review.trendBars.length) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        review.trendBars[idx].dayLabel,
                        style: TextStyle(
                            color: AppTheme.palette(context).textTertiary, fontSize: 10),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) => Text(
                      value.toStringAsFixed(0),
                      style:  TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 10),
                    ),
                  ),
                ),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: AppTheme.palette(context).borderSubtle, strokeWidth: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final String helper;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.helper,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(value,
                  style: TextStyle(
                      color: color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      color: AppTheme.palette(context).textSecondary, fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                helper,
                textAlign: TextAlign.center,
                style:  TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
