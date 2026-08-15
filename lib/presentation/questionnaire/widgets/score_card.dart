import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  final DomainScore score;
  final Color? color;

  const ScoreCard({super.key, required this.score, this.color});

  @override
  Widget build(BuildContext context) {
    final accent = color ?? _bandColor(context, score.band);
    return Card(
      color: AppTheme.palette(context).surfaceRaised.withValues(alpha: 0.9),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    score.label,
                    style: TextStyle(
                      color: AppTheme.palette(context).textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    ScoreCard.displayBand(score.band),
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${score.visibleScore.toStringAsFixed(1)} / 10',
              style: TextStyle(
                color: accent,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              score.explanation,
              style: TextStyle(
                color: AppTheme.palette(context).textSecondary,
                fontSize: 13,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 5,
                value: score.confidence.clamp(0.0, 1.0),
                backgroundColor: AppTheme.palette(context).textPrimary.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Confidence indicator',
              style: TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Color _bandColor(BuildContext context, String band) {
    return switch (band.toLowerCase()) {
      'low' => AppTheme.palette(context).success,
      'mild' => const Color(0xFF64B5F6),
      'moderate' => AppTheme.palette(context).supportNeeded,
      'high' => AppTheme.palette(context).protectMoment,
      _ => AppTheme.palette(context).accent,
    };
  }

  /// Maps internal band values to calm display labels.
  /// Internal bands (Low/Mild/Moderate/High) are kept unchanged in the data layer.
  static String displayBand(String band) => switch (band) {
    'Low' => 'steady',
    'Mild' => 'watchful',
    'Moderate' => 'support needed',
    'High' => 'protect this moment',
    _ => band,
  };
}
