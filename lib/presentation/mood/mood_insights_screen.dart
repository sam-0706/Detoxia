import 'dart:convert';

import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/mood/mood_analyzer.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _dayNames = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

class MoodInsightsScreen extends ConsumerStatefulWidget {
  const MoodInsightsScreen({super.key});

  @override
  ConsumerState<MoodInsightsScreen> createState() =>
      _MoodInsightsScreenState();
}

class _MoodInsightsScreenState extends ConsumerState<MoodInsightsScreen> {
  bool _loading = true;

  double _thisWeekAvg = 0;
  double _lastWeekAvg = 0;
  List<MapEntry<String, int>> _topEmotions = [];
  Map<String, double> _activityCorrelation = {};
  Map<int, double> _dayPattern = {};
  String _bestTime = 'N/A';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final startOfThisWeek =
        DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    final startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));

    final thisWeek = await (db.select(db.moodEntries)
          ..where((t) => t.timestamp.isBiggerOrEqualValue(startOfThisWeek)))
        .get();
    final lastWeek = await (db.select(db.moodEntries)
          ..where((t) =>
              t.timestamp.isBiggerOrEqualValue(startOfLastWeek) &
              t.timestamp.isSmallerThanValue(startOfThisWeek)))
        .get();

    // All entries from last 30 days for deeper analysis
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final allRecent = await (db.select(db.moodEntries)
          ..where((t) => t.timestamp.isBiggerOrEqualValue(thirtyDaysAgo))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .get();

    final thisAvg = thisWeek.isEmpty
        ? 0.0
        : thisWeek.fold<int>(0, (s, e) => s + e.moodLevel) / thisWeek.length;
    final lastAvg = lastWeek.isEmpty
        ? 0.0
        : lastWeek.fold<int>(0, (s, e) => s + e.moodLevel) / lastWeek.length;

    // Emotion frequency
    final emotionCounts = <String, int>{};
    for (final e in allRecent) {
      final list = _decodeList(e.emotions);
      for (final em in list) {
        emotionCounts[em] = (emotionCounts[em] ?? 0) + 1;
      }
    }
    final sortedEmotions = emotionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Activity correlation
    final maps = allRecent
        .map((e) => <String, dynamic>{
              'moodLevel': e.moodLevel,
              'activities': _decodeList(e.activities),
              'timestamp': e.timestamp,
            })
        .toList();
    final actCorr = MoodAnalyzer.activityCorrelation(maps);
    final bestTime = MoodAnalyzer.bestTimeOfDay(maps);
    final dayPat = MoodAnalyzer.dayOfWeekPattern(maps);

    if (mounted) {
      setState(() {
        _thisWeekAvg = thisAvg;
        _lastWeekAvg = lastAvg;
        _topEmotions = sortedEmotions.take(6).toList();
        _activityCorrelation = actCorr;
        _bestTime = bestTime;
        _dayPattern = dayPat;
        _loading = false;
      });
    }
  }

  List<String> _decodeList(String? json) {
    if (json == null || json.isEmpty) return [];
    try {
      return (jsonDecode(json) as List).cast<String>();
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Insights')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildWeekComparison(),
                const SizedBox(height: 20),
                _buildBestTime(),
                const SizedBox(height: 20),
                _buildTopEmotions(),
                const SizedBox(height: 20),
                _buildActivityCorrelation(),
                const SizedBox(height: 20),
                _buildDayOfWeek(),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  // ─── Week vs Week ───

  Widget _buildWeekComparison() {
    final delta = _thisWeekAvg - _lastWeekAvg;
    final (icon, color) = delta > 0.3
        ? (Icons.arrow_upward, AppTheme.palette(context).success)
        : delta < -0.3
            ? (Icons.arrow_downward, AppTheme.palette(context).danger)
            : (Icons.remove, AppTheme.palette(context).warning);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Weekly Average',
                style: TextStyle(color: AppTheme.palette(context).textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _avgColumn('Last week', _lastWeekAvg),
                Icon(icon, color: color, size: 28),
                _avgColumn('This week', _thisWeekAvg),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _avgColumn(String label, double avg) {
    return Column(
      children: [
        Text(avg.toStringAsFixed(1),
            style: TextStyle(
                color: AppTheme.palette(context).textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 13)),
      ],
    );
  }

  // ─── Best Time of Day ───

  Widget _buildBestTime() {
    return Card(
      child: ListTile(
        leading:  Icon(Icons.schedule, color: AppTheme.palette(context).textSecondary),
        title: Text('Best time of day',
            style: TextStyle(color: AppTheme.palette(context).textPrimary)),
        trailing: Text(_bestTime,
            style: TextStyle(
                color: AppTheme.palette(context).accent,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  // ─── Top Emotions ───

  Widget _buildTopEmotions() {
    if (_topEmotions.isEmpty) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Most Common Emotions',
                style: TextStyle(color: AppTheme.palette(context).textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ..._topEmotions.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(e.key,
                            style:  TextStyle(color: AppTheme.palette(context).textSecondary)),
                      ),
                      Container(
                        width: 120,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppTheme.palette(context).surface,
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _topEmotions.isEmpty
                              ? 0
                              : (e.value / _topEmotions.first.value)
                                  .clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppTheme.palette(context).accent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 24,
                        child: Text('${e.value}',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: AppTheme.palette(context).textSecondary, fontSize: 12)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // ─── Activity Correlation ───

  Widget _buildActivityCorrelation() {
    if (_activityCorrelation.isEmpty) return const SizedBox.shrink();
    final sorted = _activityCorrelation.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activity Impact on Mood',
                style: TextStyle(color: AppTheme.palette(context).textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Avg mood delta vs overall',
                style: TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 12)),
            const SizedBox(height: 12),
            ...sorted.map((e) {
              final positive = e.value >= 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(e.key,
                          style:  TextStyle(color: AppTheme.palette(context).textSecondary)),
                    ),
                    Icon(
                      positive ? Icons.add_circle_outline : Icons.remove_circle_outline,
                      size: 16,
                      color: positive ? AppTheme.palette(context).success : AppTheme.palette(context).danger,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${positive ? '+' : ''}${e.value.toStringAsFixed(1)}',
                      style: TextStyle(
                        color: positive ? AppTheme.palette(context).success : AppTheme.palette(context).danger,
                        fontWeight: FontWeight.w600,
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

  // ─── Day of Week ───

  Widget _buildDayOfWeek() {
    if (_dayPattern.isEmpty) return const SizedBox.shrink();

    double maxAvg = 0;
    int bestDay = 1;
    int worstDay = 1;
    double minAvg = 11;
    for (final kv in _dayPattern.entries) {
      if (kv.value > maxAvg) {
        maxAvg = kv.value;
        bestDay = kv.key;
      }
      if (kv.value < minAvg) {
        minAvg = kv.value;
        worstDay = kv.key;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Day of Week Pattern',
                style: TextStyle(color: AppTheme.palette(context).textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (i) {
                final dow = i + 1;
                final avg = _dayPattern[dow] ?? 0;
                final barH = (avg / 10 * 80).clamp(4.0, 80.0);
                final isBest = dow == bestDay;
                final isWorst = dow == worstDay;
                final color = isBest
                    ? AppTheme.palette(context).success
                    : isWorst
                        ? AppTheme.palette(context).danger
                        : AppTheme.palette(context).accent;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(avg.toStringAsFixed(1),
                        style: TextStyle(color: color, fontSize: 10)),
                    const SizedBox(height: 4),
                    Container(
                      width: 24,
                      height: barH,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: .7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(_dayNames[dow],
                        style:
                             TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 11)),
                  ],
                );
              }),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Best: ${_dayNames[bestDay]}',
                    style: TextStyle(color: AppTheme.palette(context).success, fontSize: 13)),
                Text('Worst: ${_dayNames[worstDay]}',
                    style: TextStyle(color: AppTheme.palette(context).danger, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
