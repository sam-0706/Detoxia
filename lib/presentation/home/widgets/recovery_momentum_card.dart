import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:flutter/material.dart';

class RecoveryMomentumCard extends StatelessWidget {
  final SupportProfile profile;

  const RecoveryMomentumCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final momentum = profile.learningState.recoveryMomentum.clamp(0.0, 10.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: AppTheme.palette(context).success, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Recovery Momentum',
                    style: TextStyle(
                      color: AppTheme.palette(context).textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${momentum.toStringAsFixed(1)}/10',
                  style: TextStyle(
                    color: AppTheme.palette(context).success,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: momentum / 10,
                backgroundColor: AppTheme.palette(context).textPrimary.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.palette(context).success),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Today's outcomes will adjust this.",
              style: TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}
