import 'dart:convert';

import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/mood/mood_analyzer.dart';
import 'package:detoxia/presentation/mood/mood_log_screen.dart';
import 'package:detoxia/presentation/mood/mood_calendar_screen.dart';
import 'package:detoxia/presentation/mood/mood_insights_screen.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _moodFaces = ['😵', '😣', '😢', '😞', '😕', '😐', '🙂', '😊', '😁', '🤩'];

class MoodHome extends ConsumerStatefulWidget {
  const MoodHome({super.key});

  @override
  ConsumerState<MoodHome> createState() => _MoodHomeState();
}

class _MoodHomeState extends ConsumerState<MoodHome> {
  double _quickMood = 5;
  List<MoodEntry> _todayEntries = [];
  String _trend = 'stable';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadToday();
  }

  Future<void> _loadToday() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final entries = await (db.select(db.moodEntries)
          ..where((t) => t.timestamp.isBiggerOrEqualValue(startOfDay))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();

    final recentMoods = entries.map((e) => e.moodLevel).toList();
    if (entries.length < 3) {
      final older = await (db.select(db.moodEntries)
            ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
            ..limit(14))
          .get();
      recentMoods
        ..clear()
        ..addAll(older.reversed.map((e) => e.moodLevel));
    }

    if (mounted) {
      setState(() {
        _todayEntries = entries;
        _trend = MoodAnalyzer.computeTrend(recentMoods);
      });
    }
  }

  Future<void> _quickSave() async {
    setState(() => _saving = true);
    final db = ref.read(databaseProvider);
    await db.into(db.moodEntries).insert(MoodEntriesCompanion.insert(
          timestamp: DateTime.now(),
          moodLevel: _quickMood.round(),
          energy: 5,
        ));
    await _loadToday();
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Year view',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const MoodCalendarScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.insights),
            tooltip: 'Insights',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const MoodInsightsScreen())),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          _buildQuickLog(),
          const SizedBox(height: 24),
          _buildTrendBanner(),
          const SizedBox(height: 24),
          _buildTodayHistory(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.accent,
        icon: const Icon(Icons.add),
        label: const Text('Full Log'),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MoodLogScreen()),
          );
          _loadToday();
        },
      ),
    );
  }

  Widget _buildQuickLog() {
    final idx = (_quickMood.round() - 1).clamp(0, 9);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('How are you feeling right now?',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text(_moodFaces[idx], style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 4),
            Text('${_quickMood.round()}/10',
                style: const TextStyle(color: Colors.white70, fontSize: 16)),
            Slider(
              value: _quickMood,
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: AppTheme.accent,
              onChanged: (v) => setState(() => _quickMood = v),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _quickSave,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save Quick Mood'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendBanner() {
    final (icon, label, color) = switch (_trend) {
      'improving' => (Icons.trending_up, 'Trending up', AppTheme.success),
      'declining' => (Icons.trending_down, 'Trending down', AppTheme.danger),
      _ => (Icons.trending_flat, 'Stable', AppTheme.warning),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 16, fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(
            '${_todayEntries.length} log${_todayEntries.length == 1 ? '' : 's'} today',
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayHistory() {
    if (_todayEntries.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 32),
          child: Text('No moods logged today',
              style: TextStyle(color: Colors.white54)),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Today's Moods",
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ..._todayEntries.map(_entryTile),
      ],
    );
  }

  Widget _entryTile(MoodEntry entry) {
    final face = _moodFaces[(entry.moodLevel - 1).clamp(0, 9)];
    final time = TimeOfDay.fromDateTime(entry.timestamp).format(context);
    final emotions = _decodeList(entry.emotions);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Text(face, style: const TextStyle(fontSize: 28)),
        title: Text('Mood ${entry.moodLevel}/10  ·  Energy ${entry.energy}/10',
            style: const TextStyle(color: Colors.white)),
        subtitle: emotions.isNotEmpty
            ? Text(emotions.join(', '),
                style: const TextStyle(color: Colors.white54))
            : null,
        trailing: Text(time,
            style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ),
    );
  }

  List<String> _decodeList(String? json) {
    if (json == null || json.isEmpty) return [];
    try {
      return (jsonDecode(json) as List).cast<String>();
    } catch (_) {
      return [];
    }
  }
}
