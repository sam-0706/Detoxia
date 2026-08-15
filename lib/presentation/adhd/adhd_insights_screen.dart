import 'dart:convert';

import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdhdInsightsScreen extends ConsumerStatefulWidget {
  const AdhdInsightsScreen({super.key});

  @override
  ConsumerState<AdhdInsightsScreen> createState() => _AdhdInsightsScreenState();
}

class _AdhdInsightsScreenState extends ConsumerState<AdhdInsightsScreen> {
  int _sessionsThisWeek = 0;
  double _avgFocusRating = 0;
  Map<int, int> _hourlyDistribution = {};
  List<int> _dailyDistractions = [];
  int _tasksPlanned = 0;
  int _tasksCompleted = 0;

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDate =
        DateTime(weekStart.year, weekStart.month, weekStart.day);
    final weekEnd = weekStartDate.add(const Duration(days: 7));

    final sessions = await (db.select(db.focusSessions)
          ..where((t) => t.startTime.isBetweenValues(weekStartDate, weekEnd)))
        .get();

    double totalRating = 0;
    int ratedCount = 0;
    final hourCounts = <int, int>{};
    final dailyDist = <int>[];

    // Build per-day distraction counts for the week (Mon=0..Sun=6)
    final dayDistractions = List.filled(7, 0);

    for (final s in sessions) {
      if (s.focusRating != null) {
        totalRating += s.focusRating!;
        ratedCount++;
      }
      final hour = s.startTime.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;

      final dayIndex = s.startTime.weekday - 1;
      if (dayIndex >= 0 && dayIndex < 7) {
        dayDistractions[dayIndex] += s.distractions;
      }
    }

    for (var d = 0; d < 7; d++) {
      dailyDist.add(dayDistractions[d]);
    }

    // Task completion stats from AdhdDailyPlans this week
    final plans = await (db.select(db.adhdDailyPlans)
          ..where((t) => t.date.isBetweenValues(weekStartDate, weekEnd)))
        .get();

    int planned = 0;
    int completed = 0;
    for (final p in plans) {
      final tasks = (jsonDecode(p.top3Tasks) as List).cast<String>();
      final done = (jsonDecode(p.completedTasks) as List).cast<String>();
      planned += tasks.length;
      completed += done.length;
    }

    if (mounted) {
      setState(() {
        _sessionsThisWeek = sessions.length;
        _avgFocusRating = ratedCount > 0 ? totalRating / ratedCount : 0;
        _hourlyDistribution = hourCounts;
        _dailyDistractions = dailyDist;
        _tasksPlanned = planned;
        _tasksCompleted = completed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ADHD Insights')),
      body: RefreshIndicator(
        onRefresh: _loadInsights,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildWeeklyOverview(),
            const SizedBox(height: 16),
            _buildProductiveHours(),
            const SizedBox(height: 16),
            _buildDistractionTrend(),
            const SizedBox(height: 16),
            _buildTaskCompletion(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyOverview() {
    return Row(
      children: [
        _InsightTile(
          icon: Icons.timer,
          label: 'Sessions',
          value: '$_sessionsThisWeek',
          color: AppTheme.palette(context).accent,
        ),
        const SizedBox(width: 12),
        _InsightTile(
          icon: Icons.star,
          label: 'Avg Rating',
          value: _avgFocusRating > 0
              ? _avgFocusRating.toStringAsFixed(1)
              : '-',
          color: AppTheme.palette(context).warning,
        ),
      ],
    );
  }

  Widget _buildProductiveHours() {
    final sorted = _hourlyDistribution.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    String bestHours = 'No data yet';
    if (sorted.isNotEmpty) {
      final top = sorted.take(3).map((e) {
        final h = e.key;
        final ampm = h >= 12 ? 'PM' : 'AM';
        final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
        return '$hour12 $ampm';
      });
      bestHours = top.join(', ');
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, color: AppTheme.palette(context).success, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Best Productive Hours',
                  style: TextStyle(
                    color: AppTheme.palette(context).textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              bestHours,
              style: TextStyle(
                color: AppTheme.palette(context).success,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Based on when you start focus sessions',
              style: TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 12),
            ),
            if (_hourlyDistribution.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(24, (h) {
                    final count = _hourlyDistribution[h] ?? 0;
                    final maxCount = sorted.isNotEmpty ? sorted.first.value : 1;
                    final fraction =
                        maxCount > 0 ? count / maxCount : 0.0;
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        height: fraction > 0 ? (fraction * 50 + 4) : 2,
                        decoration: BoxDecoration(
                          color: count > 0
                              ? AppTheme.palette(context).success.withValues(alpha: 0.4 + fraction * 0.6)
                              : AppTheme.palette(context).borderSubtle,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(2)),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('12AM', style: TextStyle(color: AppTheme.palette(context).borderStrong, fontSize: 9)),
                  Text('6AM', style: TextStyle(color: AppTheme.palette(context).borderStrong, fontSize: 9)),
                  Text('12PM', style: TextStyle(color: AppTheme.palette(context).borderStrong, fontSize: 9)),
                  Text('6PM', style: TextStyle(color: AppTheme.palette(context).borderStrong, fontSize: 9)),
                  Text('12AM', style: TextStyle(color: AppTheme.palette(context).borderStrong, fontSize: 9)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDistractionTrend() {
    final hasData = _dailyDistractions.any((d) => d > 0);
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notifications_active,
                    color: AppTheme.palette(context).warning, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Distraction Trend',
                  style: TextStyle(
                    color: AppTheme.palette(context).textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!hasData)
              Text(
                'Complete focus sessions to see your distraction trend.',
                style: TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 13),
              )
            else
              SizedBox(
                height: 80,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (i) {
                    final count = _dailyDistractions[i];
                    final max = _dailyDistractions.reduce(
                        (a, b) => a > b ? a : b);
                    final fraction =
                        max > 0 ? count / max : 0.0;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (count > 0)
                              Text(
                                '$count',
                                style: TextStyle(
                                    color: AppTheme.palette(context).textSecondary, fontSize: 10),
                              ),
                            const SizedBox(height: 2),
                            Container(
                              height: fraction > 0 ? fraction * 50 + 4 : 2,
                              decoration: BoxDecoration(
                                color: count > 0
                                    ? AppTheme.palette(context).warning
                                        .withValues(alpha: 0.4 + fraction * 0.6)
                                    : AppTheme.palette(context).borderSubtle,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              days[i],
                              style: TextStyle(
                                  color: AppTheme.palette(context).textTertiary, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCompletion() {
    final rate =
        _tasksPlanned > 0 ? (_tasksCompleted / _tasksPlanned) : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.task_alt, color: AppTheme.palette(context).accent, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Tasks: Planned vs Completed',
                  style: TextStyle(
                    color: AppTheme.palette(context).textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _TaskStat(
                  label: 'Planned',
                  count: _tasksPlanned,
                  color: AppTheme.palette(context).textSecondary,
                ),
                const SizedBox(width: 24),
                _TaskStat(
                  label: 'Completed',
                  count: _tasksCompleted,
                  color: AppTheme.palette(context).success,
                ),
                const SizedBox(width: 24),
                _TaskStat(
                  label: 'Rate',
                  count: null,
                  display: '${(rate * 100).round()}%',
                  color: rate >= 0.7
                      ? AppTheme.palette(context).success
                      : rate >= 0.4
                          ? AppTheme.palette(context).warning
                          : AppTheme.palette(context).danger,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: rate,
                minHeight: 8,
                backgroundColor: AppTheme.palette(context).surfaceRaised,
                valueColor: AlwaysStoppedAnimation(
                  rate >= 0.7
                      ? AppTheme.palette(context).success
                      : rate >= 0.4
                          ? AppTheme.palette(context).warning
                          : AppTheme.palette(context).danger,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InsightTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$label this week',
              style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskStat extends StatelessWidget {
  final String label;
  final int? count;
  final String? display;
  final Color color;

  const _TaskStat({
    required this.label,
    this.count,
    this.display,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          display ?? '$count',
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style:  TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 12),
        ),
      ],
    );
  }
}
