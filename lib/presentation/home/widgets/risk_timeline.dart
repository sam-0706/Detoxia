import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/prediction/risk_calculator.dart';
import 'package:flutter/material.dart';

/// Today's risk, as a strip you can read at a glance.
///
/// The scoring engine already produces 48 half-hour blocks per day; before
/// this they were only consulted to find the single next risky window, which
/// threw away the shape of the day. Seeing "the next two hours are calm, it
/// gets hard around 10pm" is the difference between a number and a plan.
class RiskTimeline extends StatelessWidget {
  final List<RiskBlock> blocks;

  /// Minutes since midnight — passed in rather than read from the clock so the
  /// widget stays pure and the parent controls the tick.
  final int nowMinutes;

  const RiskTimeline({
    super.key,
    required this.blocks,
    required this.nowMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppTheme.palette(context);
    if (blocks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 56,
          width: double.infinity,
          child: CustomPaint(
            painter: _TimelinePainter(
              blocks: blocks,
              nowMinutes: nowMinutes,
              palette: p,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final label in const ['12am', '6am', '12pm', '6pm', '12am'])
              Text(
                label,
                style: TextStyle(color: p.textTertiary, fontSize: 10.5),
              ),
          ],
        ),
      ],
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final List<RiskBlock> blocks;
  final int nowMinutes;
  final AppPalette palette;

  _TimelinePainter({
    required this.blocks,
    required this.nowMinutes,
    required this.palette,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const minutesPerDay = 1440.0;
    final barTop = size.height * 0.18;
    final barHeight = size.height * 0.62;

    // Track behind the blocks, so gaps in the data still read as "a day".
    final trackPaint = Paint()..color = palette.surfaceHigh;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, barTop, size.width, barHeight),
        const Radius.circular(8),
      ),
      trackPaint,
    );

    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, barTop, size.width, barHeight),
        const Radius.circular(8),
      ),
    );

    for (final block in blocks) {
      final left = (block.startMinute / minutesPerDay) * size.width;
      final right = (block.endMinute / minutesPerDay) * size.width;
      final isPast = block.endMinute <= nowMinutes;
      final color = palette.riskColor(block.score);

      canvas.drawRect(
        Rect.fromLTRB(left, barTop, right + 0.5, barTop + barHeight),
        Paint()
          // Elapsed hours are dimmed — the point of the strip is what's ahead.
          ..color = isPast ? color.withValues(alpha: 0.28) : color,
      );
    }
    canvas.restore();

    // "Now" marker.
    final nowX = (nowMinutes / minutesPerDay) * size.width;
    canvas.drawLine(
      Offset(nowX, 0),
      Offset(nowX, barTop + barHeight + 4),
      Paint()
        ..color = palette.textPrimary
        ..strokeWidth = 2,
    );
    canvas.drawCircle(
      Offset(nowX, barTop + barHeight + 6),
      3.5,
      Paint()..color = palette.textPrimary,
    );
  }

  @override
  bool shouldRepaint(_TimelinePainter old) =>
      old.nowMinutes != nowMinutes ||
      old.blocks != blocks ||
      old.palette != palette;
}
