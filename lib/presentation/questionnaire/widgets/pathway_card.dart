import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:flutter/material.dart';

class PathwayCard extends StatelessWidget {
  final List<PathwayScore> pathways;

  const PathwayCard({super.key, required this.pathways});

  @override
  Widget build(BuildContext context) {
    final top = pathways.where((pathway) => pathway.enabled).firstOrNull;
    final body = top == null
        ? 'Your support pathway will become clearer as Detoxia learns.'
        : _sentenceFor(top);

    return Card(
      color: AppTheme.palette(context).surfaceRaised.withValues(alpha: 0.9),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline, color: AppTheme.palette(context).accent, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Likely pathway',
                  style: TextStyle(
                    color: AppTheme.palette(context).textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: TextStyle(
                color: AppTheme.palette(context).textSecondary,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _sentenceFor(PathwayScore pathway) {
    final id = pathway.pathwayId.toLowerCase();
    if (id.contains('sexual')) {
      return 'Post-school/work stress + late-night phone use → cues → loss of control.';
    }
    if (id.contains('scrolling')) {
      return 'Boredom or stress + phone access → scrolling → lost time.';
    }
    if (id.contains('sleep')) {
      return 'Sleep disruption + low recovery → weaker control windows.';
    }
    if (id.contains('anxiety')) {
      return 'Worry + avoidance pressure → checking or browsing loops.';
    }
    return '${pathway.label} is the strongest support pathway right now.';
  }
}
