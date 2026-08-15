import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:flutter/material.dart';

class FirstPlanCard extends StatelessWidget {
  final List<PathwayScore> pathways;
  final InterventionPreferences preferences;

  const FirstPlanCard({
    super.key,
    required this.pathways,
    required this.preferences,
  });

  @override
  Widget build(BuildContext context) {
    final tasks = _tasks();
    return Card(
      color: AppTheme.palette(context).surfaceRaised.withValues(alpha: 0.9),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.route_outlined, color: AppTheme.palette(context).accent, size: 20),
                const SizedBox(width: 8),
                Text(
                  'First plan',
                  style: TextStyle(
                    color: AppTheme.palette(context).textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...tasks.map(
              (task) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppTheme.palette(context).success,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        task,
                        style: TextStyle(
                          color: AppTheme.palette(context).textSecondary,
                          height: 1.35,
                        ),
                      ),
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

  List<String> _tasks() {
    final defaults = [
      'Post-work decompression reset',
      'Night phone boundary',
      'Anxiety downshift before browsing',
    ];

    if (preferences.sleepShutdown) {
      return [
        'Night phone boundary',
        'Post-work decompression reset',
        'Anxiety downshift before browsing',
      ];
    }
    if (preferences.physicalReset) {
      return [
        'Post-work decompression reset',
        'Night phone boundary',
        'Anxiety downshift before browsing',
      ];
    }
    return defaults;
  }
}
