import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/depression/depression_scorer.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DepressionInsightsScreen extends ConsumerStatefulWidget {
  const DepressionInsightsScreen({super.key});

  @override
  ConsumerState<DepressionInsightsScreen> createState() =>
      _DepressionInsightsScreenState();
}

class _DepressionInsightsScreenState
    extends ConsumerState<DepressionInsightsScreen> {
  List<BehavioralActivity> _weekActivities = [];
  List<BehavioralActivity> _topByPleasure = [];
  List<WeeklyAssessment> _assessments = [];
  int _activitiesThisWeek = 0;
  double _avgPleasure = 0;
  double _avgMastery = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDate =
        DateTime(weekStart.year, weekStart.month, weekStart.day);

    final activities = await (db.select(db.behavioralActivities)
          ..where((t) => t.date.isBiggerOrEqualValue(weekStartDate))
          ..orderBy([(t) => OrderingTerm.desc(t.pleasureRating)]))
        .get();

    final assessments = await (db.select(db.weeklyAssessments)
          ..where((t) => t.assessmentType.equals('phq9'))
          ..orderBy([(t) => OrderingTerm.asc(t.date)])
          ..limit(12))
        .get();

    final totalPleasure =
        activities.fold<int>(0, (s, a) => s + a.pleasureRating);
    final totalMastery =
        activities.fold<int>(0, (s, a) => s + a.masteryRating);

    if (mounted) {
      setState(() {
        _weekActivities = activities;
        _activitiesThisWeek = activities.length;
        _topByPleasure = activities.where((a) => a.pleasureRating > 0).toList()
          ..sort((a, b) => b.pleasureRating.compareTo(a.pleasureRating));
        _assessments = assessments;
        _avgPleasure =
            activities.isNotEmpty ? totalPleasure / activities.length : 0;
        _avgMastery =
            activities.isNotEmpty ? totalMastery / activities.length : 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Depression Insights')),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildWeekSummary(),
            const SizedBox(height: 16),
            _buildTopActivities(),
            const SizedBox(height: 16),
            _buildActivityMoodCorrelation(),
            const SizedBox(height: 16),
            _buildAssessmentTrend(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: AppTheme.accent, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'This Week',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _StatTile(
                  label: 'Activities',
                  value: '$_activitiesThisWeek',
                  color: AppTheme.accent,
                ),
                const SizedBox(width: 12),
                _StatTile(
                  label: 'Avg Pleasure',
                  value: _avgPleasure.toStringAsFixed(1),
                  color: AppTheme.success,
                ),
                const SizedBox(width: 12),
                _StatTile(
                  label: 'Avg Mastery',
                  value: _avgMastery.toStringAsFixed(1),
                  color: AppTheme.warning,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopActivities() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: AppTheme.warning, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Top Activities by Pleasure',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_topByPleasure.isEmpty)
              const Text(
                'Complete some activities with pleasure ratings to see your favorites.',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              )
            else
              ..._topByPleasure.take(5).map((a) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${a.pleasureRating}',
                            style: TextStyle(
                              color: AppTheme.success,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a.activityType,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14)),
                              Text(a.category,
                                  style: const TextStyle(
                                      color: Colors.white38, fontSize: 11)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.warning.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'M:${a.masteryRating}',
                            style: TextStyle(
                                color: AppTheme.warning, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityMoodCorrelation() {
    final categoryCounts = <String, int>{};
    final categoryPleasure = <String, double>{};

    for (final a in _weekActivities) {
      categoryCounts[a.category] = (categoryCounts[a.category] ?? 0) + 1;
      categoryPleasure[a.category] =
          (categoryPleasure[a.category] ?? 0) + a.pleasureRating;
    }

    final sortedCategories = categoryCounts.keys.toList()
      ..sort((a, b) => categoryCounts[b]!.compareTo(categoryCounts[a]!));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_graph, color: AppTheme.accent, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Activity–Mood Correlation',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (sortedCategories.isEmpty)
              const Text(
                'Log activities this week to see patterns.',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              )
            else
              ...sortedCategories.take(5).map((cat) {
                final count = categoryCounts[cat]!;
                final avgP = categoryPleasure[cat]! / count;
                final barWidth = (count / (_activitiesThisWeek.clamp(1, 100))) *
                    (MediaQuery.of(context).size.width - 120);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text(
                              cat,
                              style: const TextStyle(
                                  color: Colors.white60, fontSize: 12),
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                Container(
                                  height: 16,
                                  width: barWidth.clamp(8, double.infinity),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accent.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$count',
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 80, top: 2),
                        child: Text(
                          'Avg pleasure: ${avgP.toStringAsFixed(1)}',
                          style: const TextStyle(
                              color: Colors.white30, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentTrend() {
    final scores = _assessments.map((a) => a.totalScore).toList();
    final trend = DepressionScorer.trendDirection(scores);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart, color: AppTheme.accent, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Weekly Assessment Trend',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_assessments.isEmpty)
              const Text(
                'Complete weekly check-ins to track your progress over time.',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              )
            else ...[
              SizedBox(
                height: 120,
                child: _AssessmentChart(assessments: _assessments),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    switch (trend) {
                      'improving' => Icons.trending_down,
                      'worsening' => Icons.trending_up,
                      _ => Icons.trending_flat,
                    },
                    color: switch (trend) {
                      'improving' => AppTheme.success,
                      'worsening' => AppTheme.danger,
                      _ => Colors.white54,
                    },
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    switch (trend) {
                      'improving' => 'Scores are improving',
                      'worsening' => 'Scores need attention',
                      _ => 'Scores are stable',
                    },
                    style: TextStyle(
                      color: switch (trend) {
                        'improving' => AppTheme.success,
                        'worsening' => AppTheme.danger,
                        _ => Colors.white54,
                      },
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                  color: color, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(color: Colors.white54, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _AssessmentChart extends StatelessWidget {
  final List<WeeklyAssessment> assessments;

  const _AssessmentChart({required this.assessments});

  @override
  Widget build(BuildContext context) {
    if (assessments.isEmpty) return const SizedBox.shrink();

    const maxScore = 27.0;

    return CustomPaint(
      size: const Size(double.infinity, 120),
      painter: _ChartPainter(
        scores: assessments.map((a) => a.totalScore.toDouble()).toList(),
        maxValue: maxScore,
        lineColor: AppTheme.accent,
        fillColor: AppTheme.accent.withValues(alpha: 0.15),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<double> scores;
  final double maxValue;
  final Color lineColor;
  final Color fillColor;

  _ChartPainter({
    required this.scores,
    required this.maxValue,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (scores.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final xStep = scores.length > 1
        ? size.width / (scores.length - 1)
        : size.width / 2;

    for (var i = 0; i < scores.length; i++) {
      final x = scores.length > 1 ? i * xStep : size.width / 2;
      final y = size.height - (scores[i] / maxValue) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      canvas.drawCircle(Offset(x, y), 4, dotPaint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: scores[i].round().toString(),
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
          canvas, Offset(x - textPainter.width / 2, y - 16));
    }

    final lastX = scores.length > 1
        ? (scores.length - 1) * xStep
        : size.width / 2;
    fillPath.lineTo(lastX, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
