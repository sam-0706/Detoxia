import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:flutter/material.dart';

class TopDriversSummary extends StatelessWidget {
  final SupportProfile profile;

  const TopDriversSummary({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final drivers = profile.triggerWeights.toList()
      ..sort((a, b) => b.weight0To10.compareTo(a.weight0To10));
    final topDomain = profile.domainScores
        .where((score) => score.enabled)
        .fold<DomainScore?>(null, (best, score) {
          if (best == null || score.visibleScore > best.visibleScore) {
            return score;
          }
          return best;
        });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bolt, color: AppTheme.palette(context).accent, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Top drivers',
                  style: TextStyle(
                    color: AppTheme.palette(context).textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              _sentence(drivers, topDomain),
              style:  TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.4),
            ),
            const SizedBox(height: 12),
            ...drivers.take(3).map(_DriverRow.new),
          ],
        ),
      ),
    );
  }

  // V1 heuristic template:
  // "<driver1> + <driver2> are increasing <highest-domain> sensitivity today."
  // If only one driver exists, use a singular version. Future task engines can
  // replace this with intervention-specific explanations.
  String _sentence(List<TriggerWeight> drivers, DomainScore? topDomain) {
    final domain = (topDomain?.label ?? 'support').toLowerCase();
    if (drivers.length >= 2) {
      return '${drivers[0].label} + ${drivers[1].label} are increasing $domain sensitivity today.';
    }
    if (drivers.length == 1) {
      return '${drivers.first.label} is increasing $domain sensitivity today.';
    }
    return 'Detoxia will highlight your strongest drivers as your plan gets live feedback.';
  }
}

class _DriverRow extends StatelessWidget {
  final TriggerWeight driver;

  const _DriverRow(this.driver);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              driver.label,
              style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 13),
            ),
          ),
          SizedBox(
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 5,
                value: (driver.weight0To10 / 10).clamp(0.0, 1.0),
                backgroundColor: AppTheme.palette(context).textPrimary.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.palette(context).accent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
