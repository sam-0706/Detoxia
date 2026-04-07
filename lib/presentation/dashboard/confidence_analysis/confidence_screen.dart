import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/analysis/state_profile.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfidenceScreen extends ConsumerWidget {
  const ConfidenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = StateProfile.compute(
      streakScore: 45,
      rescueSuccessRate: 0.6,
      selfReportedConfidenceAvg: 5.0,
      improvementTrend: 0.2,
      urgesResisted: 15,
      totalUrges: 25,
      sleepBoundaryCompliance: 0.7,
      sleepQualityAvg: 3.5,
      stressAvg: 5.0,
      confidenceTomorrowAvg: 5.5,
      recentSlip: false,
      triggerSlipRates: {
        'boredom': 0.68,
        'stress': 0.22,
        'loneliness': 0.45,
        'scrolling': 0.55,
      },
      slipFrequencyTrend: -0.15,
      impact: const DownstreamImpact(
        moodAfterSlip: 3.2,
        moodAfterClean: 6.8,
        sleepOnSlipNight: 2.0,
        sleepOnCleanNight: 3.5,
        confidenceAfterSlip: 3.0,
        confidenceAfterClean: 7.0,
        stressInSlipWeek: 8.1,
        stressInCleanWeek: 4.3,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Where You Stand')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRadarChart(profile),
            const SizedBox(height: 24),
            _buildDimensionCards(profile),
            const SizedBox(height: 24),
            _buildInsights(profile),
            const SizedBox(height: 24),
            _buildDownstreamImpact(profile.downstreamImpact),
          ],
        ),
      ),
    );
  }

  Widget _buildRadarChart(StateProfile profile) {
    return SizedBox(
      height: 260,
      child: RadarChart(
        RadarChartData(
          radarTouchData: RadarTouchData(enabled: false),
          dataSets: [
            RadarDataSet(
              dataEntries: [
                RadarEntry(value: profile.confidenceIndex),
                RadarEntry(value: profile.selfControlRating),
                RadarEntry(value: 100 - profile.vulnerabilityIndex),
                RadarEntry(value: profile.recoveryMomentum.abs()),
                RadarEntry(
                    value: profile.downstreamImpact.moodDelta * 10),
              ],
              borderColor: AppTheme.accent,
              fillColor: AppTheme.accent.withValues(alpha: 0.2),
              borderWidth: 2,
            ),
          ],
          titlePositionPercentageOffset: 0.15,
          getTitle: (index, _) => RadarChartTitle(
            text: switch (index) {
              0 => 'Confidence',
              1 => 'Self-Control',
              2 => 'Resilience',
              3 => 'Momentum',
              4 => 'Impact',
              _ => '',
            },
            angle: 0,
          ),
          borderData: FlBorderData(show: false),
          radarBorderData:
              const BorderSide(color: Colors.white12, width: 1),
          tickBorderData:
              const BorderSide(color: Colors.white12, width: 1),
          gridBorderData:
              const BorderSide(color: Colors.white12, width: 1),
          tickCount: 4,
          ticksTextStyle:
              const TextStyle(color: Colors.transparent, fontSize: 0),
        ),
      ),
    );
  }

  Widget _buildDimensionCards(StateProfile profile) {
    return Column(
      children: [
        _DimensionCard(
          label: 'Confidence',
          value: profile.confidenceIndex,
          subtitle: profile.confidenceText,
          color: AppTheme.accent,
        ),
        _DimensionCard(
          label: 'Self-Control',
          value: profile.selfControlRating,
          subtitle:
              '${(profile.selfControlRating / 10).toStringAsFixed(0)}/10',
          color: AppTheme.success,
        ),
        _DimensionCard(
          label: 'Vulnerability',
          value: profile.vulnerabilityIndex,
          subtitle: profile.vulnerabilityIndex > 60
              ? 'Elevated risk'
              : 'Manageable',
          color: AppTheme.warning,
        ),
        _DimensionCard(
          label: 'Recovery Momentum',
          value: profile.recoveryMomentum.abs(),
          subtitle: profile.momentumText,
          color: profile.recoveryMomentum > 0
              ? AppTheme.success
              : AppTheme.danger,
        ),
      ],
    );
  }

  Widget _buildInsights(StateProfile profile) {
    final insights = <String>[];

    final topTrigger = profile.triggerSensitivity.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (topTrigger.isNotEmpty) {
      final t = topTrigger.first;
      insights.add(
        '${t.key} is your most challenging trigger. '
        '${(t.value * 100).round()}% of the time, it leads to a setback.',
      );
    }

    insights.add(profile.downstreamImpact.moodInsight);
    insights.add(profile.downstreamImpact.sleepInsight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Insights',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ...insights.map((insight) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline,
                          color: AppTheme.accent, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(insight,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildDownstreamImpact(DownstreamImpact impact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('How setbacks affect your life',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        const Text(
          'Compare how you feel after a setback vs. a clean day:',
          style: TextStyle(color: Colors.white38, fontSize: 12),
        ),
        const SizedBox(height: 12),
        _ImpactRow(
            label: 'Your mood',
            value: impact.moodAfterSlip,
            compareValue: impact.moodAfterClean,
            lowLabel: 'After setback',
            highLabel: 'Clean day',
            unit: '/10'),
        _ImpactRow(
            label: 'Sleep quality',
            value: impact.sleepOnSlipNight,
            compareValue: impact.sleepOnCleanNight,
            lowLabel: 'Setback night',
            highLabel: 'Clean night',
            unit: '/5'),
        _ImpactRow(
            label: 'Confidence',
            value: impact.confidenceAfterSlip,
            compareValue: impact.confidenceAfterClean,
            lowLabel: 'After setback',
            highLabel: 'Clean day',
            unit: '/10'),
        _ImpactRow(
            label: 'Stress level',
            value: impact.stressInSlipWeek,
            compareValue: impact.stressInCleanWeek,
            lowLabel: 'Setback week',
            highLabel: 'Clean week',
            unit: '/10',
            invertColors: true),
      ],
    );
  }
}

class _DimensionCard extends StatelessWidget {
  final String label;
  final double value;
  final String subtitle;
  final Color color;

  const _DimensionCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: value / 100,
                      strokeWidth: 4,
                      backgroundColor: Colors.white12,
                      color: color,
                    ),
                    Center(
                      child: Text(
                        value.round().toString(),
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                    Text(subtitle,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImpactRow extends StatelessWidget {
  final String label;
  final double value;
  final double compareValue;
  final String unit;
  final String lowLabel;
  final String highLabel;
  final bool invertColors;

  const _ImpactRow({
    required this.label,
    required this.value,
    required this.compareValue,
    required this.unit,
    this.lowLabel = '',
    this.highLabel = '',
    this.invertColors = false,
  });

  @override
  Widget build(BuildContext context) {
    final isWorse = invertColors ? value > compareValue : value < compareValue;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  decoration: BoxDecoration(
                    color: (isWorse ? AppTheme.danger : AppTheme.warning)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${value.toStringAsFixed(1)}$unit',
                        style: TextStyle(
                          color: isWorse ? AppTheme.danger : AppTheme.warning,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (lowLabel.isNotEmpty)
                        Text(lowLabel,
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 10)),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward,
                    color: Colors.white24, size: 16),
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${compareValue.toStringAsFixed(1)}$unit',
                        style: TextStyle(
                          color: AppTheme.success,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (highLabel.isNotEmpty)
                        Text(highLabel,
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
