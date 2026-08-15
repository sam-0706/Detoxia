import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/event_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/support_profile_repository.dart';
import 'package:detoxia/domain/journey/recovery_journey_projection_resolver.dart';
import 'package:detoxia/presentation/home/home_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectionScreen extends ConsumerStatefulWidget {
  final RecoveryJourneyProjection? projectionOverride;

  const ProjectionScreen({super.key, this.projectionOverride});

  @override
  ConsumerState<ProjectionScreen> createState() => _ProjectionScreenState();
}

class _ProjectionScreenState extends ConsumerState<ProjectionScreen> {
  final RecoveryJourneyProjectionResolver _resolver =
      const RecoveryJourneyProjectionResolver();
  RecoveryJourneyProjection? _projection;

  @override
  void initState() {
    super.initState();
    _loadProjection();
  }

  Future<void> _loadProjection() async {
    final override = widget.projectionOverride;
    if (override != null) {
      if (!mounted) return;
      setState(() => _projection = override);
      return;
    }

    final registration = await ref.read(registrationRepositoryProvider).getProfile();
    final supportProfile = registration == null
        ? null
        : await ref
              .read(supportProfileRepositoryProvider)
              .getLatestProfile(registration.id);
    final checkins = await ref.read(eventRepositoryProvider).getCheckinsLastDays(28);
    final slips = await ref.read(eventRepositoryProvider).getSlipsLastDays(28);
    final completedTasks = await _completedTasksLast14Days();

    final projection = _resolver.resolve(
      supportProfile: supportProfile,
      checkins: checkins
          .map(
            (row) => <String, dynamic>{
              'date': row.date,
              'slipped': row.slipped,
              'stress': row.stress,
              'mood': row.mood,
              'sleepQuality': row.sleepQuality,
            },
          )
          .toList(growable: false),
      slipsLast28Days: slips.length,
      completedTasksLast14Days: completedTasks,
    );

    if (!mounted) return;
    setState(() => _projection = projection);
  }

  Future<int> _completedTasksLast14Days() async {
    final db = ref.read(databaseProvider);
    final since = DateTime.now().subtract(const Duration(days: 14));
    final rows = await (db.select(db.dailyTaskAssignments)
          ..where((t) => t.date.isBiggerOrEqualValue(since))
          ..where((t) => t.completed.equals(true)))
        .get();
    return rows.length;
  }

  @override
  Widget build(BuildContext context) {
    final projection = _projection;
    if (projection == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(projection.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              projection.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              projection.summary,
              style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),
            if (projection.isLocked)
              _buildLockedState(projection)
            else ...[
              // Direction card — replaces old "Where you are now / After 12 weeks"
              _buildDirectionCard(projection),
              const SizedBox(height: 24),
              // Momentum trend chart (reframed)
              Text('Momentum trend',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                projection.caption,
                style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: projection.points
                            .map((point) => FlSpot(
                                point.week.toDouble(),
                                point.projectedEventsPerWeek))
                            .toList(growable: false),
                        isCurved: true,
                        color: AppTheme.palette(context).accent,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppTheme.palette(context).accent.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2,
                          getTitlesWidget: (value, _) => Text(
                            'W${value.toInt()}',
                            style: TextStyle(
                                color: AppTheme.palette(context).textTertiary, fontSize: 10),
                          ),
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) => Text(
                            value.toStringAsFixed(1),
                            style: TextStyle(
                                color: AppTheme.palette(context).textTertiary, fontSize: 10),
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
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: AppTheme.palette(context).borderSubtle,
                        strokeWidth: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            // Info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: AppTheme.palette(context).accent, size: 20),
                        const SizedBox(width: 8),
                        Text('How this works',
                            style: TextStyle(
                                color: AppTheme.palette(context).textPrimary,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      projection.isLocked
                          ? (projection.lockedReason ??
                              'Your path will become clearer after a few more check-ins.')
                          : 'Uses only your local check-ins, completed resets, and recovery momentum.\n'
                              'No cure prediction. No timeline. Just your pattern becoming clearer.',
                      style: TextStyle(
                          color: AppTheme.palette(context).textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
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
                child: const Text('Go to Today'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedState(RecoveryJourneyProjection projection) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your path is still forming',
              style: TextStyle(
                color: AppTheme.palette(context).textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              projection.lockedReason ??
                  'Your path will become clearer after a few more check-ins.',
              style:  TextStyle(color: AppTheme.palette(context).textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionCard(RecoveryJourneyProjection projection) {
    if (projection.directionItems.isEmpty) {
      return const SizedBox.shrink();
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your current direction',
              style: TextStyle(
                color: AppTheme.palette(context).textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            ...projection.directionItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_forward,
                        color: AppTheme.palette(context).success, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                            color: AppTheme.palette(context).textSecondary, fontSize: 14, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
