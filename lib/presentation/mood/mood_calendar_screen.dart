import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoodCalendarScreen extends ConsumerStatefulWidget {
  const MoodCalendarScreen({super.key});

  @override
  ConsumerState<MoodCalendarScreen> createState() =>
      _MoodCalendarScreenState();
}

class _MoodCalendarScreenState extends ConsumerState<MoodCalendarScreen> {
  int _year = DateTime.now().year;
  Map<int, double> _dayAvgMood = {};
  Map<int, List<MoodEntry>> _dayEntries = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final db = ref.read(databaseProvider);
    final start = DateTime(_year);
    final end = DateTime(_year + 1);
    final entries = await (db.select(db.moodEntries)
          ..where((t) =>
              t.timestamp.isBiggerOrEqualValue(start) &
              t.timestamp.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .get();

    final grouped = <int, List<MoodEntry>>{};
    for (final e in entries) {
      final dayOfYear = e.timestamp.difference(start).inDays;
      (grouped[dayOfYear] ??= []).add(e);
    }

    final avgs = <int, double>{};
    for (final kv in grouped.entries) {
      avgs[kv.key] =
          kv.value.fold<int>(0, (s, e) => s + e.moodLevel) / kv.value.length;
    }

    if (mounted) {
      setState(() {
        _dayEntries = grouped;
        _dayAvgMood = avgs;
        _loading = false;
      });
    }
  }

  Color _colorForMood(double mood) {
    final t = ((mood - 1) / 9).clamp(0.0, 1.0);
    return Color.lerp(AppTheme.palette(context).danger, AppTheme.palette(context).success, t)!;
  }

  @override
  Widget build(BuildContext context) {
    final daysInYear =
        DateTime(_year + 1).difference(DateTime(_year)).inDays;
    final firstWeekday = DateTime(_year).weekday; // 1=Mon

    return Scaffold(
      appBar: AppBar(
        title: Text('Year in Pixels · $_year'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              _year--;
              _load();
            },
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _year < DateTime.now().year
                ? () {
                    _year++;
                    _load();
                  }
                : null,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegend(),
                  const SizedBox(height: 16),
                  _buildGrid(daysInYear, firstWeekday),
                ],
              ),
            ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Text('1', style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 11)),
        const SizedBox(width: 4),
        for (var i = 1; i <= 10; i++)
          Container(
            width: 14,
            height: 14,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: _colorForMood(i.toDouble()),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        const SizedBox(width: 4),
        Text('10',
            style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 11)),
      ],
    );
  }

  Widget _buildGrid(int daysInYear, int firstWeekday) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month labels
        SizedBox(
          width: 30,
          child: Column(
            children: List.generate(12, (m) {
              final firstDay =
                  DateTime(_year, m + 1).difference(DateTime(_year)).inDays;
              final topOffset = ((firstDay + firstWeekday - 1) ~/ 7) * 14.0;
              return Container(
                height: 14,
                margin: EdgeInsets.only(
                    top: m == 0 ? topOffset : (topOffset - _monthTop(m - 1, firstWeekday)).clamp(0, 500)),
                alignment: Alignment.centerLeft,
                child: Text(months[m],
                    style:
                         TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 10)),
              );
            }),
          ),
        ),
        // Pixel grid
        Expanded(
          child: Wrap(
            spacing: 2,
            runSpacing: 2,
            children: List.generate(daysInYear, (day) {
              final avg = _dayAvgMood[day];
              return GestureDetector(
                onTap: () => _showDayDetail(day),
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: avg != null
                        ? _colorForMood(avg)
                        : AppTheme.palette(context).textPrimary.withValues(alpha: .06),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  double _monthTop(int monthIndex, int firstWeekday) {
    final firstDay =
        DateTime(_year, monthIndex + 1).difference(DateTime(_year)).inDays;
    return ((firstDay + firstWeekday - 1) ~/ 7) * 14.0;
  }

  void _showDayDetail(int dayOfYear) {
    final entries = _dayEntries[dayOfYear];
    final date = DateTime(_year).add(Duration(days: dayOfYear));
    final label =
        '${date.day}/${date.month}/${date.year}';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.palette(context).surfaceRaised,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: AppTheme.palette(context).textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            if (entries == null || entries.isEmpty)
              Text('No entries',
                  style: TextStyle(color: AppTheme.palette(context).textSecondary))
            else
              ...entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Mood ${e.moodLevel}/10  ·  Energy ${e.energy}/10',
                      style:  TextStyle(color: AppTheme.palette(context).textSecondary),
                    ),
                  )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
