import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/core/utils/time_utils.dart';
import 'package:detoxia/data/repositories/event_repository.dart';
import 'package:detoxia/data/repositories/peak_repository.dart';
import 'package:detoxia/data/repositories/user_repository.dart';
import 'package:detoxia/domain/prediction/risk_calculator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeeklyReviewScreen extends ConsumerStatefulWidget {
  const WeeklyReviewScreen({super.key});

  @override
  ConsumerState<WeeklyReviewScreen> createState() =>
      _WeeklyReviewScreenState();
}

class _WeeklyReviewScreenState
    extends ConsumerState<WeeklyReviewScreen> {
  List<List<RiskBlock>> _weekBlocks = [];
  int _urgesThisWeek = 0;
  int _slipsThisWeek = 0;
  double _avgSleep = 0;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = await ref.read(userRepositoryProvider).getUser();
    if (profile == null) return;

    final peaks = await ref.read(peakRepositoryProvider).getAllPeaks();
    final calculator =
        RiskCalculator(profile: profile, peaks: peaks);
    final week =
        calculator.calculateWeek(const RecentState());

    final urges =
        await ref.read(eventRepositoryProvider).getUrgesLastDays(7);
    final slips =
        await ref.read(eventRepositoryProvider).getSlipsLastDays(7);
    final checkins =
        await ref.read(eventRepositoryProvider).getCheckinsLastDays(7);
    final avgSleep = checkins.isNotEmpty
        ? checkins.map((c) => c.sleepQuality).reduce((a, b) => a + b) /
            checkins.length
        : 0.0;

    setState(() {
      _weekBlocks = week;
      _urgesThisWeek = urges.length;
      _slipsThisWeek = slips.length;
      _avgSleep = avgSleep;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Review')),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCards(),
                  const SizedBox(height: 24),
                  _buildHeatmap(),
                  const SizedBox(height: 24),
                  _buildSlipChart(),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        _SummaryCard(
            label: 'Urges', value: '$_urgesThisWeek', color: AppTheme.warning),
        const SizedBox(width: 8),
        _SummaryCard(
            label: 'Slips', value: '$_slipsThisWeek', color: AppTheme.danger),
        const SizedBox(width: 8),
        _SummaryCard(
            label: 'Avg Sleep',
            value: _avgSleep.toStringAsFixed(1),
            color: AppTheme.accent),
      ],
    );
  }

  Widget _buildHeatmap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Risk Heatmap',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  7,
                  (i) => SizedBox(
                    height: 16,
                    child: Text(
                      TimeUtils.dayName(i + 1),
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: List.generate(7, (day) {
                    if (day >= _weekBlocks.length) {
                      return const SizedBox(height: 18);
                    }
                    return SizedBox(
                      height: 18,
                      child: Row(
                        children: List.generate(48, (block) {
                          final b = block < _weekBlocks[day].length
                              ? _weekBlocks[day][block]
                              : null;
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(0.5),
                              color: b != null
                                  ? AppTheme.riskColor(b.score)
                                      .withValues(alpha: 0.8)
                                  : Colors.white12,
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSlipChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Slip Pattern',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              barGroups: List.generate(7, (i) {
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: _slipsThisWeek > 0 ? 1.0 : 0.0,
                      color: AppTheme.danger,
                      width: 14,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) => Text(
                      TimeUtils.dayName(value.toInt() + 1),
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 10),
                    ),
                  ),
                ),
                leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(value,
                  style: TextStyle(
                      color: color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
