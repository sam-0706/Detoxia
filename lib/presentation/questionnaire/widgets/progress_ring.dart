import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Circular progress indicator with "answered/total" in the centre.
///
/// The arc is animated so answering a question reads as visible forward
/// movement — the main antidote to a long form feeling endless.
class ProgressRing extends StatelessWidget {
  final int answered;
  final int total;
  final double size;

  const ProgressRing({
    super.key,
    required this.answered,
    required this.total,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppTheme.palette(context);
    final progress = total > 0 ? (answered / total).clamp(0.0, 1.0) : 0.0;

    return Semantics(
      label: 'Progress: $answered of $total questions answered',
      child: SizedBox(
        width: size,
        height: size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: progress),
          duration: const Duration(milliseconds: 520),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 3,
                  strokeCap: StrokeCap.round,
                  backgroundColor: p.surfaceHigh,
                  valueColor: AlwaysStoppedAnimation<Color>(p.accent),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$answered',
                    style: TextStyle(
                      color: p.textPrimary,
                      fontSize: size * 0.28,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  Text(
                    '/',
                    style: TextStyle(
                      color: p.textTertiary,
                      fontSize: size * 0.2,
                      height: 1,
                    ),
                  ),
                  Text(
                    '$total',
                    style: TextStyle(
                      color: p.textTertiary,
                      fontSize: size * 0.2,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
