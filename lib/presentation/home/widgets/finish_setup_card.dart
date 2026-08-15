import 'package:detoxia/core/motion/app_motion.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Invitation to answer the questions onboarding deferred.
///
/// Onboarding asks only what's needed to build a first plan; everything that
/// sharpens it lives here, surfaced a few at a time. The framing is
/// deliberately "make this more accurate", not "you left something
/// incomplete" — a nag bar is exactly what makes people stop opening an app.
class FinishSetupCard extends StatelessWidget {
  final int answered;
  final int total;
  final VoidCallback onContinue;

  const FinishSetupCard({
    super.key,
    required this.answered,
    required this.total,
    required this.onContinue,
  });

  double get _progress => total == 0 ? 1 : (answered / total).clamp(0.0, 1.0);
  int get _remaining => (total - answered).clamp(0, total);

  /// Rough read on effort, so the ask is bounded before they tap.
  String get _timeEstimate {
    final minutes = (_remaining * 8 / 60).ceil();
    if (minutes <= 1) return 'about a minute';
    return 'about $minutes min';
  }

  @override
  Widget build(BuildContext context) {
    final p = AppTheme.palette(context);
    if (_remaining == 0) return const SizedBox.shrink();

    return FadeSlideIn(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: p.surfaceRaised,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: p.accent.withValues(alpha: 0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: p.accentSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 19,
                    color: p.accent,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sharpen your plan',
                        style: TextStyle(
                          color: p.textPrimary,
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$_remaining more ${_remaining == 1 ? 'question' : 'questions'} · $_timeEstimate',
                        style: TextStyle(
                          color: p.textTertiary,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Detoxia is working from the essentials so far. A few more '
              'answers and it can time support to your actual day.',
              style: TextStyle(
                color: p.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: _progress),
                duration: AppMotion.slow,
                curve: AppMotion.morph,
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: p.surfaceHigh,
                  valueColor: AlwaysStoppedAnimation<Color>(p.accent),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$answered of $total answered',
              style: TextStyle(color: p.textTertiary, fontSize: 11.5),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onContinue,
                    child: Text(
                      _remaining <= 3 ? 'Finish up' : 'Answer a few',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
