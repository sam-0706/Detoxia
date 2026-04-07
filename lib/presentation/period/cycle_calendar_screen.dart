import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/period/cycle_calculator.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CycleCalendarScreen extends ConsumerStatefulWidget {
  const CycleCalendarScreen({super.key});

  @override
  ConsumerState<CycleCalendarScreen> createState() =>
      _CycleCalendarScreenState();
}

class _CycleCalendarScreenState extends ConsumerState<CycleCalendarScreen> {
  late DateTime _viewMonth;
  Map<DateTime, CycleEntry> _entryMap = {};
  List<CyclePrediction> _predictions = [];
  List<DateTime> _periodStarts = [];
  double _avgLength = 28.0;

  static const _phaseColors = {
    CyclePhase.menstrual: Color(0xFFEF5350),
    CyclePhase.follicular: Color(0xFFFF8A80),
    CyclePhase.ovulation: Color(0xFFCE93D8),
    CyclePhase.luteal: Color(0xFF64B5F6),
  };

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _viewMonth = DateTime(now.year, now.month);
    _loadData();
  }

  Future<void> _loadData() async {
    final db = ref.read(databaseProvider);

    final entries = await (db.select(db.cycleEntries)
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();

    final predictions = await (db.select(db.cyclePredictions)
          ..orderBy([(t) => OrderingTerm.asc(t.predictedStart)]))
        .get();

    final map = <DateTime, CycleEntry>{};
    for (final e in entries) {
      map[DateTime(e.date.year, e.date.month, e.date.day)] = e;
    }

    final starts = _extractPeriodStarts(entries);
    final avg = CycleCalculator.averageCycleLength(starts);

    if (mounted) {
      setState(() {
        _entryMap = map;
        _predictions = predictions;
        _periodStarts = starts;
        _avgLength = avg;
      });
    }
  }

  List<DateTime> _extractPeriodStarts(List<CycleEntry> entries) {
    final sorted = entries.where((e) => e.flowIntensity != null && e.flowIntensity != 0).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final starts = <DateTime>[];
    DateTime? prev;
    for (final e in sorted) {
      if (prev == null || e.date.difference(prev).inDays > 5) {
        starts.add(e.date);
      }
      prev = e.date;
    }
    return starts;
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Cycle Calendar')),
      body: Column(
        children: [
          _buildMonthNav(tt),
          _buildWeekdayHeaders(),
          Expanded(child: _buildGrid()),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildMonthNav(TextTheme tt) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => setState(() {
              _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1);
            }),
          ),
          Expanded(
            child: Text(
              '${months[_viewMonth.month]} ${_viewMonth.year}',
              textAlign: TextAlign.center,
              style: tt.titleLarge,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => setState(() {
              _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: days
            .map((d) => Expanded(
                  child: Center(
                    child: Text(d,
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 12)),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildGrid() {
    final firstDay = DateTime(_viewMonth.year, _viewMonth.month, 1);
    final daysInMonth =
        DateTime(_viewMonth.year, _viewMonth.month + 1, 0).day;
    // Monday=1 ... Sunday=7
    final startWeekday = firstDay.weekday;
    final cells = <Widget>[];

    for (var i = 1; i < startWeekday; i++) {
      cells.add(const SizedBox());
    }

    final today = DateTime.now();
    for (var d = 1; d <= daysInMonth; d++) {
      final date = DateTime(_viewMonth.year, _viewMonth.month, d);
      final entry = _entryMap[date];
      final hasFlow = entry != null && entry.flowIntensity != null && entry.flowIntensity! > 0;
      final isToday = date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;

      final phase = _phaseForDate(date);
      final isPredicted = _isPredictedDate(date);
      final color = phase != null ? _phaseColors[phase]! : Colors.transparent;

      cells.add(
        Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: phase != null
                ? color.withValues(alpha: isPredicted ? .15 : .3)
                : null,
            borderRadius: BorderRadius.circular(8),
            border: isToday
                ? Border.all(color: AppTheme.pinkAccent, width: 2)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$d',
                style: TextStyle(
                  color: isToday ? AppTheme.pinkAccent : Colors.white70,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
              if (hasFlow)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      entry.flowIntensity!.clamp(1, 4),
                      (_) => Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 0.5),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF5350),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      childAspectRatio: 1,
      children: cells,
    );
  }

  CyclePhase? _phaseForDate(DateTime date) {
    if (_periodStarts.isEmpty) return null;

    // Find the most recent period start on or before this date
    DateTime? lastStart;
    for (final s in _periodStarts.reversed) {
      if (!s.isAfter(date)) {
        lastStart = s;
        break;
      }
    }
    if (lastStart == null) return null;

    final cycleDay = date.difference(DateTime(lastStart.year, lastStart.month, lastStart.day)).inDays + 1;
    if (cycleDay < 1 || cycleDay > _avgLength.round() + 7) return null;
    return CycleCalculator.currentPhase(cycleDay, _avgLength);
  }

  bool _isPredictedDate(DateTime date) {
    if (date.isBefore(DateTime.now())) return false;
    for (final p in _predictions) {
      if (!date.isBefore(p.predictedStart) && !date.isAfter(p.predictedEnd)) {
        return true;
      }
    }
    return true; // future dates computed from averages are predictions
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: _phaseColors.entries.map((e) {
          final label = switch (e.key) {
            CyclePhase.menstrual => 'Menstrual',
            CyclePhase.follicular => 'Follicular',
            CyclePhase.ovulation => 'Ovulation',
            CyclePhase.luteal => 'Luteal',
          };
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: e.value,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 4),
              Text(label,
                  style:
                      const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
