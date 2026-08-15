import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/repositories/event_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/support_profile_repository.dart';
import 'package:detoxia/domain/home/where_you_stand_metric_resolver.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfidenceScreen extends ConsumerStatefulWidget {
  final SupportProfile? supportProfileOverride;
  final List<Map<String, dynamic>>? checkinsOverride;

  const ConfidenceScreen({
    super.key,
    this.supportProfileOverride,
    this.checkinsOverride,
  });

  @override
  ConsumerState<ConfidenceScreen> createState() => _ConfidenceScreenState();
}

class _ConfidenceScreenState extends ConsumerState<ConfidenceScreen> {
  final WhereYouStandMetricResolver _resolver = const WhereYouStandMetricResolver();
  WhereYouStandMetricResult? _result;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final overrideProfile = widget.supportProfileOverride;
    final overrideCheckins = widget.checkinsOverride;
    if (overrideProfile != null && overrideCheckins != null) {
      if (!mounted) return;
      setState(() {
        _result = _resolver.resolve(
          supportProfile: overrideProfile,
          recentCheckins: overrideCheckins,
        );
      });
      return;
    }

    final registration = await ref.read(registrationRepositoryProvider).getProfile();
    final supportProfile = registration == null
        ? null
        : await ref
              .read(supportProfileRepositoryProvider)
              .getLatestProfile(registration.id);
    final checkins = await ref.read(eventRepositoryProvider).getCheckinsLastDays(7);
    final checkinMaps = checkins
        .map(
          (row) => <String, dynamic>{
            'sleepQuality': row.sleepQuality,
            'mood': row.mood,
            'stress': row.stress,
            'confidenceTomorrow': row.confidenceTomorrow,
          },
        )
        .toList(growable: false);

    if (!mounted) return;
    setState(() {
      _result = _resolver.resolve(
        supportProfile: supportProfile,
        recentCheckins: checkinMaps,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    if (result == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Where You Stand')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result.isLocked)
              _buildLockedState(result.lockedReason)
            else ...[
              _buildRadarChart(result.metrics),
              const SizedBox(height: 24),
              _buildMetricCards(result.metrics),
              const SizedBox(height: 24),
              _buildInsights(result.metrics),
            ],
            const SizedBox(height: 24),
            _buildLearningFooter(result),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedState(String? reason) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Metrics are still learning',
              style: TextStyle(color: AppTheme.palette(context).textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              reason ?? 'Complete more local check-ins to unlock dynamic metrics.',
              style:  TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadarChart(List<WhereYouStandMetric> metrics) {
    final limited = metrics.take(5).toList(growable: false);
    return SizedBox(
      height: 260,
      child: RadarChart(
        RadarChartData(
          radarTouchData: RadarTouchData(enabled: false),
          dataSets: [
            RadarDataSet(
              dataEntries: limited.map((metric) => RadarEntry(value: metric.value0To10)).toList(),
              borderColor: AppTheme.palette(context).accent,
              fillColor: AppTheme.palette(context).accent.withValues(alpha: 0.2),
              borderWidth: 2,
            ),
          ],
          titlePositionPercentageOffset: 0.15,
          getTitle: (index, _) => RadarChartTitle(
            text: index < limited.length ? limited[index].label : '',
            angle: 0,
          ),
          borderData: FlBorderData(show: false),
          radarBorderData:
               BorderSide(color: AppTheme.palette(context).borderSubtle, width: 1),
          tickBorderData:
               BorderSide(color: AppTheme.palette(context).borderSubtle, width: 1),
          gridBorderData:
               BorderSide(color: AppTheme.palette(context).borderSubtle, width: 1),
          tickCount: 5,
          ticksTextStyle:
              const TextStyle(color: Colors.transparent, fontSize: 0),
        ),
      ),
    );
  }

  Widget _buildMetricCards(List<WhereYouStandMetric> metrics) {
    return Column(
      children: metrics
          .map(
            (metric) => _DimensionCard(
              label: metric.label,
              value: metric.value0To10,
              subtitle: metric.explanation,
              color: _colorForMetric(metric.value0To10),
            ),
          )
          .toList(growable: false),
    );
  }

  Widget _buildInsights(List<WhereYouStandMetric> metrics) {
    final ordered = metrics.toList()..sort((a, b) => a.value0To10.compareTo(b.value0To10));
    final growthAreas = ordered.take(2).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Growth areas',
            style: TextStyle(
                color: AppTheme.palette(context).textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(
          'These are not failures. They are places where a small reset or clearer routine may help.',
          style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12, height: 1.35),
        ),
        const SizedBox(height: 12),
        ...growthAreas.map((metric) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline,
                          color: AppTheme.palette(context).accent, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                            '${metric.label} could use a little more support. ${metric.explanation}',
                            style: TextStyle(
                                color: AppTheme.palette(context).textSecondary, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildLearningFooter(WhereYouStandMetricResult result) {
    return Text(
      result.isLocked
          ? 'Detoxia is learning from local check-ins before rendering dynamic metric trends.'
          : 'Metrics are derived from your local support profile, recent check-ins, pathway signals, and recovery momentum.',
      style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12),
    );
  }

  Color _colorForMetric(double value0To10) {
    if (value0To10 >= 7) return AppTheme.palette(context).success;
    if (value0To10 >= 4) return AppTheme.palette(context).supportNeeded;
    return AppTheme.palette(context).protectMoment;
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
                      value: value / 10,
                      strokeWidth: 4,
                      backgroundColor: AppTheme.palette(context).borderSubtle,
                      color: color,
                    ),
                    Center(
                      child: Text(
                        value.toStringAsFixed(1),
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
                        style: TextStyle(
                            color: AppTheme.palette(context).textPrimary,
                            fontWeight: FontWeight.w500)),
                    Text(subtitle,
                        style: TextStyle(
                            color: AppTheme.palette(context).textSecondary, fontSize: 12)),
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
