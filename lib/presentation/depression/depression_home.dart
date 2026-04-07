import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/depression/depression_scorer.dart';
import 'package:detoxia/presentation/depression/activity_scheduler_screen.dart';
import 'package:detoxia/presentation/depression/depression_insights_screen.dart';
import 'package:detoxia/presentation/depression/thought_record_screen.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DepressionHome extends ConsumerStatefulWidget {
  const DepressionHome({super.key});

  @override
  ConsumerState<DepressionHome> createState() => _DepressionHomeState();
}

class _DepressionHomeState extends ConsumerState<DepressionHome> {
  List<BehavioralActivity> _todayActivities = [];
  List<ThoughtRecord> _recentThoughts = [];
  WeeklyAssessment? _lastAssessment;
  List<int> _weeklyScores = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final activities = await (db.select(db.behavioralActivities)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(todayStart) &
              t.date.isSmallerThanValue(todayEnd)))
        .get();

    final thoughts = await (db.select(db.thoughtRecords)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(5))
        .get();

    final assessments = await (db.select(db.weeklyAssessments)
          ..where((t) => t.assessmentType.equals('phq9'))
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(8))
        .get();

    if (mounted) {
      setState(() {
        _todayActivities = activities;
        _recentThoughts = thoughts;
        _lastAssessment = assessments.isNotEmpty ? assessments.first : null;
        _weeklyScores = assessments.map((a) => a.totalScore).toList().reversed.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final trend = DepressionScorer.trendDirection(_weeklyScores);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Depression Module'),
        actions: [
          IconButton(
            icon: const Icon(Icons.insights),
            tooltip: 'Insights',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DepressionInsightsScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_lastAssessment != null) _buildScoreCard(trend),
            const SizedBox(height: 16),
            _buildTodayActivities(),
            const SizedBox(height: 16),
            _buildRecentThoughts(),
            const SizedBox(height: 16),
            _buildQuickActions(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(String trend) {
    final score = _lastAssessment!.totalScore;
    final label = DepressionScorer.severityLabel(score);
    final trendIcon = switch (trend) {
      'improving' => Icons.trending_down,
      'worsening' => Icons.trending_up,
      _ => Icons.trending_flat,
    };
    final trendColor = switch (trend) {
      'improving' => AppTheme.success,
      'worsening' => AppTheme.danger,
      _ => Colors.white54,
    };
    final trendText = switch (trend) {
      'improving' => 'Improving',
      'worsening' => 'Needs attention',
      _ => 'Stable',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assessment, color: AppTheme.accent, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Last Weekly Check-in',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _severityColor(score).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$score / 27',
                    style: TextStyle(
                      color: _severityColor(score),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(color: Colors.white, fontSize: 15)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(trendIcon, color: trendColor, size: 16),
                          const SizedBox(width: 4),
                          Text(trendText,
                              style: TextStyle(color: trendColor, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _severityColor(int score) {
    if (score <= 4) return AppTheme.success;
    if (score <= 9) return Colors.lightGreen;
    if (score <= 14) return AppTheme.warning;
    if (score <= 19) return Colors.deepOrange;
    return AppTheme.danger;
  }

  Widget _buildTodayActivities() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle_outline, color: AppTheme.success, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Today\'s Activities',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ActivitySchedulerScreen()),
                    );
                    _loadData();
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add'),
                ),
              ],
            ),
            if (_todayActivities.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No activities logged yet today. Schedule some to get started.',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
              )
            else
              ..._todayActivities.map((a) => Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: AppTheme.success, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(a.activityType,
                              style: const TextStyle(color: Colors.white70, fontSize: 14)),
                        ),
                        if (a.pleasureRating > 0)
                          _ratingChip('P', a.pleasureRating),
                        if (a.masteryRating > 0) ...[
                          const SizedBox(width: 6),
                          _ratingChip('M', a.masteryRating),
                        ],
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _ratingChip(String label, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label:$value',
        style: TextStyle(color: AppTheme.accent, fontSize: 11),
      ),
    );
  }

  Widget _buildRecentThoughts() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: AppTheme.accent, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Recent Thought Records',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ThoughtRecordScreen()),
                    );
                    _loadData();
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Log'),
                ),
              ],
            ),
            if (_recentThoughts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No thought records yet. Logging thoughts helps identify patterns.',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
              )
            else
              ..._recentThoughts.take(3).map((t) => Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.automaticThought,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white60, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              t.emotion,
                              style: TextStyle(
                                  color: AppTheme.accent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            if (t.distortionType != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                t.distortionType!,
                                style: const TextStyle(
                                    color: Colors.white38, fontSize: 11),
                              ),
                            ],
                          ],
                        ),
                        const Divider(color: Colors.white12, height: 16),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.directions_run,
                label: 'Schedule\nActivities',
                color: AppTheme.success,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ActivitySchedulerScreen()),
                  );
                  _loadData();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.edit_note,
                label: 'Log a\nThought',
                color: AppTheme.accent,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ThoughtRecordScreen()),
                  );
                  _loadData();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.insights,
                label: 'View\nInsights',
                color: AppTheme.warning,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DepressionInsightsScreen()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
