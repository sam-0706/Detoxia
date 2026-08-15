import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:flutter/material.dart';

class TopDriversCard extends StatelessWidget {
  final List<TriggerWeight> drivers;

  const TopDriversCard({super.key, required this.drivers});

  @override
  Widget build(BuildContext context) {
    final topDrivers = drivers.take(5).toList();
    return Card(
      color: AppTheme.palette(context).surfaceRaised.withValues(alpha: 0.9),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (topDrivers.isEmpty)
              Text(
                'Detoxia will surface stronger drivers as you use your plan.',
                style: TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.4),
              )
            else
              ...topDrivers.map(_DriverRow.new),
          ],
        ),
      ),
    );
  }
}

class _DriverRow extends StatelessWidget {
  final TriggerWeight driver;

  const _DriverRow(this.driver);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            driver.label,
            style: TextStyle(
              color: AppTheme.palette(context).textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: (driver.weight0To10 / 10.0).clamp(0.0, 1.0),
              backgroundColor: AppTheme.palette(context).textPrimary.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.palette(context).accent.withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
