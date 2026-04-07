import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnxietyInsightsScreen extends ConsumerStatefulWidget {
  const AnxietyInsightsScreen({super.key});

  @override
  ConsumerState<AnxietyInsightsScreen> createState() =>
      _AnxietyInsightsScreenState();
}

class _AnxietyInsightsScreenState
    extends ConsumerState<AnxietyInsightsScreen> {
  List<double> _dailyAvgs = [];
  Map<String, double> _techniqueEffectiveness = {};
  Map<String, int> _triggerCounts = {};
  int _sessionsThisWeek = 0;

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    // 7-day anxiety averages
    final events = await (db.select(db.anxietyEvents)
          ..where((t) => t.timestamp.isBiggerOrEqualValue(weekAgo))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .get();

    final dailyMap = <int, List<int>>{};
    for (final e in events) {
      final dayKey = e.timestamp.difference(weekAgo).inDays;
      dailyMap.putIfAbsent(dayKey, () => []).add(e.anxietyLevel);
    }
    final avgs = List.generate(7, (i) {
      final levels = dailyMap[i];
      if (levels == null || levels.isEmpty) return 0.0;
      return levels.reduce((a, b) => a + b) / levels.length;
    });

    // Breathing technique effectiveness (anxiety drop)
    final logs = await (db.select(db.breathingLogs)
          ..where((t) => t.timestamp.isBiggerOrEqualValue(weekAgo)))
        .get();

    final techDrops = <String, List<int>>{};
    for (final log in logs) {
      if (log.anxietyBefore != null && log.anxietyAfter != null) {
        final drop = log.anxietyBefore! - log.anxietyAfter!;
        techDrops.putIfAbsent(log.technique, () => []).add(drop);
      }
    }
    final effectiveness = <String, double>{};
    for (final entry in techDrops.entries) {
      if (entry.value.isNotEmpty) {
        effectiveness[entry.key] =
            entry.value.reduce((a, b) => a + b) / entry.value.length;
      }
    }
    final sortedEffectiveness = Map.fromEntries(
      effectiveness.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)),
    );

    // Trigger patterns
    final triggers = <String, int>{};
    for (final e in events) {
      final trigger = e.triggerSituation;
      if (trigger != null && trigger.isNotEmpty) {
        triggers[trigger] = (triggers[trigger] ?? 0) + 1;
      }
    }
    final sortedTriggers = Map.fromEntries(
      triggers.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)),
    );

    // Sessions this week
    final weekSessions = logs.length;

    if (mounted) {
      setState(() {
        _dailyAvgs = avgs;
        _techniqueEffectiveness = sortedEffectiveness;
        _triggerCounts = sortedTriggers;
        _sessionsThisWeek = weekSessions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anxiety Insights')),
      body: RefreshIndicator(
        onRefresh: _loadInsights,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildWeeklySummary(),
            const SizedBox(height: 16),
            _buildTrendCard(),
            const SizedBox(height: 16),
            _buildEffectivenessCard(),
            const SizedBox(height: 16),
            _buildTriggerPatternsCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySummary() {
    final overallAvg = _dailyAvgs.where((v) => v > 0).isNotEmpty
        ? _dailyAvgs.where((v) => v > 0).reduce((a, b) => a + b) /
            _dailyAvgs.where((v) => v > 0).length
        : 0.0;

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Avg anxiety',
            value: overallAvg > 0
                ? overallAvg.toStringAsFixed(1)
                : '--',
            icon: Icons.show_chart,
            color: overallAvg <= 4
                ? AppTheme.success
                : overallAvg <= 6
                    ? AppTheme.warning
                    : AppTheme.danger,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Sessions',
            value: '$_sessionsThisWeek',
            icon: Icons.air,
            color: AppTheme.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Techniques',
            value: '${_techniqueEffectiveness.length}',
            icon: Icons.category,
            color: AppTheme.success,
          ),
        ),
      ],
    );
  }

  Widget _buildTrendCard() {
    final maxVal =
        _dailyAvgs.isEmpty ? 10.0 : (_dailyAvgs.reduce((a, b) => a > b ? a : b));
    final chartMax = maxVal < 1 ? 10.0 : maxVal + 1;
    final dayLabels = List.generate(7, (i) {
      final d = DateTime.now().subtract(Duration(days: 6 - i));
      return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][d.weekday - 1];
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_down,
                    color: AppTheme.accent, size: 20),
                const SizedBox(width: 8),
                const Text('Anxiety Trend (7 days)',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: _dailyAvgs.every((v) => v == 0)
                  ? const Center(
                      child: Text('No data yet',
                          style: TextStyle(color: Colors.white38)),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(7, (i) {
                        final val = i < _dailyAvgs.length ? _dailyAvgs[i] : 0.0;
                        final height = val > 0 ? (val / chartMax) * 100 : 2.0;
                        final color = val <= 3
                            ? AppTheme.success
                            : val <= 6
                                ? AppTheme.warning
                                : AppTheme.danger;
                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (val > 0)
                                  Text(
                                    val.toStringAsFixed(1),
                                    style: TextStyle(
                                        color: color, fontSize: 10),
                                  ),
                                const SizedBox(height: 4),
                                Container(
                                  height: height,
                                  decoration: BoxDecoration(
                                    color: val > 0
                                        ? color.withValues(alpha: 0.7)
                                        : Colors.white12,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(dayLabels[i],
                                    style: const TextStyle(
                                        color: Colors.white38,
                                        fontSize: 10)),
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

  Widget _buildEffectivenessCard() {
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
                const Text('Most Effective Techniques',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),
            if (_techniqueEffectiveness.isEmpty)
              const Text(
                'Complete breathing sessions with before/after ratings to see which techniques work best for you.',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              )
            else
              ..._techniqueEffectiveness.entries.take(5).map((entry) {
                final drop = entry.value;
                final name = _formatTechniqueName(entry.key);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(name,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: drop > 0
                              ? AppTheme.success.withValues(alpha: 0.15)
                              : Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          drop > 0
                              ? '-${drop.toStringAsFixed(1)} pts'
                              : 'no change',
                          style: TextStyle(
                            color: drop > 0
                                ? AppTheme.success
                                : Colors.white38,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
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

  Widget _buildTriggerPatternsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology,
                    color: AppTheme.accent, size: 20),
                const SizedBox(width: 8),
                const Text('Trigger Patterns',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),
            if (_triggerCounts.isEmpty)
              const Text(
                'Log anxiety events with trigger situations to discover patterns.',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              )
            else
              ..._triggerCounts.entries.take(5).map((entry) {
                final maxCount = _triggerCounts.values.first;
                final fraction =
                    maxCount > 0 ? entry.value / maxCount : 0.0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(entry.key,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                          ),
                          Text(
                            '${entry.value}x',
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: fraction,
                          backgroundColor: Colors.white12,
                          valueColor:
                              AlwaysStoppedAnimation(AppTheme.accent),
                          minHeight: 4,
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

  String _formatTechniqueName(String enumName) {
    return enumName
        .replaceAllMapped(RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}')
        .replaceFirst(RegExp(r'^\s'), '')
        .replaceFirstMapped(
            RegExp(r'^[a-z]'), (m) => m.group(0)!.toUpperCase());
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
                color: color, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }
}
