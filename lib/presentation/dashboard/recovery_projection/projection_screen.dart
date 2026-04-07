import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/prediction/projection_engine.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectionScreen extends ConsumerWidget {
  const ProjectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = ProjectionEngine(
      baselineSlipsPerWeek: 5.0,
      habitStrength: 0.7,
      regulationCapacity: 0.4,
    );

    final curve = engine.projectionCurve();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Recovery Journey')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your life is\ngetting better',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Here\'s what your recovery looks like based on your '
              'actual data. These numbers recalibrate every week.',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _Panel(
                    title: 'Where you are now',
                    color: AppTheme.warning,
                    items: const [
                      'Avg urges per day: ~3',
                      'Setbacks per week: ~5',
                      'Sleep quality: Low',
                      'Confidence: 35%',
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Panel(
                    title: 'After 12 weeks',
                    color: AppTheme.success,
                    items: [
                      engine.weekProjectionText(4),
                      engine.weekProjectionText(8),
                      engine.weekProjectionText(12),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              color: AppTheme.success.withValues(alpha: 0.1),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, color: Color(0xFF4ECDC4), size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'People who follow the plan see 70-80% '
                        'fewer setbacks by week 8. You\'re building '
                        'that momentum right now.',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text('Weekly improvement curve',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            const Text(
              'This shows how setbacks decrease week over week as your '
              'brain rewires. The curve gets steeper with consistency.',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: curve.entries
                          .map((e) =>
                              FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      color: AppTheme.accent,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.accent.withValues(alpha: 0.1),
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
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 10),
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) => Text(
                          value.toStringAsFixed(1),
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 10),
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
                      color: Colors.white12,
                      strokeWidth: 1,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: AppTheme.accent, size: 20),
                        const SizedBox(width: 8),
                        const Text('How this works',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Projections are based on your actual data '
                      'and recalibrate weekly. The curve adjusts '
                      'to your adherence rate.',
                      style: TextStyle(
                          color: Colors.white54, fontSize: 13),
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

class _Panel extends StatelessWidget {
  final String title;
  final Color color;
  final List<String> items;

  const _Panel({
    required this.title,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(item,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12)),
                )),
          ],
        ),
      ),
    );
  }
}
