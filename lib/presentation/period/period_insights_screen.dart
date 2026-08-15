import 'dart:convert';
import 'dart:math' as math;

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/period/cycle_calculator.dart';
import 'package:detoxia/domain/period/symptom_definitions.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeriodInsightsScreen extends ConsumerStatefulWidget {
  const PeriodInsightsScreen({super.key});

  @override
  ConsumerState<PeriodInsightsScreen> createState() =>
      _PeriodInsightsScreenState();
}

class _PeriodInsightsScreenState extends ConsumerState<PeriodInsightsScreen> {
  double _avgCycleLength = 28.0;
  String _regularity = 'Not enough data';
  List<_SymptomStat> _topSymptoms = [];
  Map<CyclePhase, double> _phaseDurations = {};
  int _totalCycles = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _analyze();
  }

  Future<void> _analyze() async {
    final db = ref.read(databaseProvider);

    final entries = await (db.select(db.cycleEntries)
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();

    if (entries.isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    final periodStarts = _extractPeriodStarts(entries);
    final avg = CycleCalculator.averageCycleLength(periodStarts);
    final totalCycles = periodStarts.length > 1 ? periodStarts.length - 1 : 0;

    // Regularity: standard deviation of cycle gaps
    String regularity = 'Not enough data';
    if (periodStarts.length >= 3) {
      final sorted = [...periodStarts]..sort();
      final gaps = <int>[];
      for (var i = 1; i < sorted.length; i++) {
        gaps.add(sorted[i].difference(sorted[i - 1]).inDays);
      }
      final mean = gaps.reduce((a, b) => a + b) / gaps.length;
      final variance =
          gaps.map((g) => (g - mean) * (g - mean)).reduce((a, b) => a + b) /
              gaps.length;
      final stdDev = math.sqrt(variance);
      if (stdDev <= 2) {
        regularity = 'Very regular';
      } else if (stdDev <= 4) {
        regularity = 'Regular';
      } else if (stdDev <= 7) {
        regularity = 'Somewhat irregular';
      } else {
        regularity = 'Irregular';
      }
    }

    // Top symptoms across all entries
    final symptomCounts = <String, int>{};
    final symptomDays = <String, List<int>>{}; // maps to cycle days
    for (final e in entries) {
      final ids = _decodeList(e.symptoms);
      final cycleDay = e.cycleDay ?? 0;
      for (final id in ids) {
        symptomCounts[id] = (symptomCounts[id] ?? 0) + 1;
        symptomDays.putIfAbsent(id, () => []).add(cycleDay);
      }
    }
    final sortedSymptoms = symptomCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topSymptoms = sortedSymptoms.take(8).map((e) {
      final def = allSymptoms.where((s) => s.id == e.key).firstOrNull;
      final days = symptomDays[e.key] ?? [];
      final avgDay =
          days.isEmpty ? 0 : (days.reduce((a, b) => a + b) / days.length).round();
      return _SymptomStat(
        name: def?.name ?? e.key,
        emoji: def?.emoji ?? '•',
        count: e.value,
        avgCycleDay: avgDay,
      );
    }).toList();

    // Phase duration averages
    final phaseDays = <CyclePhase, List<int>>{};
    for (final phase in CyclePhase.values) {
      phaseDays[phase] = [];
    }
    if (periodStarts.length >= 2) {
      final sorted = [...periodStarts]..sort();
      for (var i = 0; i < sorted.length - 1; i++) {
        final cycleLen =
            sorted[i + 1].difference(sorted[i]).inDays.toDouble();
        phaseDays[CyclePhase.menstrual]!.add(5);
        phaseDays[CyclePhase.follicular]!
            .add(((cycleLen * 0.5).round() - 5).clamp(0, 30));
        phaseDays[CyclePhase.ovulation]!.add(3);
        phaseDays[CyclePhase.luteal]!
            .add((cycleLen - (cycleLen * 0.5).round() - 3).round().clamp(0, 30));
      }
    }
    final phaseDurations = <CyclePhase, double>{};
    for (final phase in CyclePhase.values) {
      final days = phaseDays[phase]!;
      phaseDurations[phase] =
          days.isEmpty ? 0 : days.reduce((a, b) => a + b) / days.length;
    }

    if (mounted) {
      setState(() {
        _avgCycleLength = avg;
        _regularity = regularity;
        _topSymptoms = topSymptoms;
        _phaseDurations = phaseDurations;
        _totalCycles = totalCycles;
        _loading = false;
      });
    }
  }

  List<DateTime> _extractPeriodStarts(List<CycleEntry> entries) {
    final sorted = entries
        .where((e) => e.flowIntensity != null && e.flowIntensity != 0)
        .toList()
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
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Cycle Insights')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                _buildOverviewCards(tt),
                const SizedBox(height: 24),
                _buildPhaseDurations(tt),
                const SizedBox(height: 24),
                _buildTopSymptoms(tt),
              ],
            ),
    );
  }

  Widget _buildOverviewCards(TextTheme tt) {
    return Row(
      children: [
        Expanded(child: _statCard(tt, 'Avg Cycle', '${_avgCycleLength.toStringAsFixed(1)} days')),
        const SizedBox(width: 12),
        Expanded(child: _statCard(tt, 'Regularity', _regularity)),
        const SizedBox(width: 12),
        Expanded(child: _statCard(tt, 'Cycles', '$_totalCycles tracked')),
      ],
    );
  }

  Widget _statCard(TextTheme tt, String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(label,
                style: tt.bodyMedium?.copyWith(color: AppTheme.palette(context).textSecondary)),
            const SizedBox(height: 4),
            Text(value,
                style: tt.titleLarge?.copyWith(fontSize: 15),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseDurations(TextTheme tt) {
    const colors = {
      CyclePhase.menstrual: Color(0xFFEF5350),
      CyclePhase.follicular: Color(0xFFFF8A80),
      CyclePhase.ovulation: Color(0xFFCE93D8),
      CyclePhase.luteal: Color(0xFF64B5F6),
    };
    const labels = {
      CyclePhase.menstrual: 'Menstrual',
      CyclePhase.follicular: 'Follicular',
      CyclePhase.ovulation: 'Ovulation',
      CyclePhase.luteal: 'Luteal',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Phase Durations (avg)', style: tt.titleLarge),
        const SizedBox(height: 12),
        for (final phase in CyclePhase.values) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(labels[phase]!,
                      style: TextStyle(
                          color: colors[phase], fontSize: 13)),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_phaseDurations[phase] ?? 0) /
                          _avgCycleLength.clamp(1, 99),
                      backgroundColor: colors[phase]!.withValues(alpha: .15),
                      color: colors[phase],
                      minHeight: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 50,
                  child: Text(
                    '${(_phaseDurations[phase] ?? 0).toStringAsFixed(1)}d',
                    style:
                         TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTopSymptoms(TextTheme tt) {
    if (_topSymptoms.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Common Symptoms', style: tt.titleLarge),
          const SizedBox(height: 12),
          Text('Log symptoms to see patterns here.',
              style: TextStyle(color: AppTheme.palette(context).textSecondary)),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Most Common Symptoms', style: tt.titleLarge),
        const SizedBox(height: 12),
        ..._topSymptoms.map((s) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Text(s.emoji, style: const TextStyle(fontSize: 24)),
                title: Text(s.name,
                    style:  TextStyle(color: AppTheme.palette(context).textPrimary)),
                subtitle: s.avgCycleDay > 0
                    ? Text('Usually around day ${s.avgCycleDay}',
                        style:  TextStyle(color: AppTheme.palette(context).textSecondary))
                    : null,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.pinkAccent.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('${s.count}x',
                      style: TextStyle(color: AppTheme.pinkAccent)),
                ),
              ),
            )),
      ],
    );
  }
}

class _SymptomStat {
  final String name;
  final String emoji;
  final int count;
  final int avgCycleDay;

  const _SymptomStat({
    required this.name,
    required this.emoji,
    required this.count,
    required this.avgCycleDay,
  });
}
