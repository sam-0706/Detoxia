import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:flutter/material.dart';

class SupportMapSummary extends StatelessWidget {
  final SupportProfile profile;
  final VoidCallback? onViewFullMap;

  const SupportMapSummary({super.key, required this.profile, this.onViewFullMap});

  @override
  Widget build(BuildContext context) {
    final topScores =
        profile.domainScores.where((score) => score.enabled).toList()
          ..sort((a, b) => b.visibleScore.compareTo(a.visibleScore));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.radar, color: AppTheme.palette(context).accent, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Support Map',
                    style: TextStyle(
                      color: AppTheme.palette(context).textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onViewFullMap,
                  child: const Text(
                    'View Full Support Map',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (topScores.isEmpty)
              Text(
                'Your support map will appear after calibration.',
                style: TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.4),
              )
            else
              Row(
                children: topScores
                    .take(3)
                    .map(
                      (score) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _CompactScoreCard(score: score),
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _CompactScoreCard extends StatelessWidget {
  final DomainScore score;

  const _CompactScoreCard({required this.score});

  @override
  Widget build(BuildContext context) {
    final color = _bandColor(context, score.band);
    return Container(
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            score.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppTheme.palette(context).textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${score.visibleScore.toStringAsFixed(1)}/10',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            score.band,
            style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Color _bandColor(BuildContext context, String band) {
    return switch (band.toLowerCase()) {
      'low' => AppTheme.palette(context).success,
      'mild' => const Color(0xFF64B5F6),
      'moderate' => AppTheme.palette(context).warning,
      'high' => const Color(0xFFE57373),
      _ => AppTheme.palette(context).accent,
    };
  }
}
