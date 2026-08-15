import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/prediction/risk_calculator.dart';
import 'package:flutter/material.dart';

import 'risk_timeline.dart';

/// What's happening *right now*, and what's coming.
///
/// The old home screen showed a static "current state" line and, separately, a
/// card for the next risky window. Merging them into one live card — current
/// level, the day's shape, and a countdown to the next hard window — is what
/// makes opening the app at 11pm actually tell you something.
class RightNowCard extends StatelessWidget {
  final List<RiskBlock> blocks;
  final DateTime now;
  final VoidCallback? onAct;

  const RightNowCard({
    super.key,
    required this.blocks,
    required this.now,
    this.onAct,
  });

  int get _nowMinutes => now.hour * 60 + now.minute;

  RiskBlock? get _current {
    for (final b in blocks) {
      if (_nowMinutes >= b.startMinute && _nowMinutes < b.endMinute) return b;
    }
    return null;
  }

  /// Next block ahead of now that crosses the "this is a hard window" line.
  RiskBlock? get _nextHigh {
    RiskBlock? found;
    for (final b in blocks) {
      if (b.startMinute > _nowMinutes && b.score >= 0.7) {
        if (found == null || b.startMinute < found.startMinute) found = b;
      }
    }
    return found;
  }

  static String _describe(double score) {
    if (score < 0.3) return 'Steady';
    if (score < 0.5) return 'Mostly steady';
    if (score < 0.7) return 'Keep an eye out';
    if (score < 0.85) return 'A harder stretch';
    return 'Your hardest window';
  }

  static String _guidance(double score) {
    if (score < 0.3) {
      return 'Nothing to manage right now. A good time for anything that '
          'needs focus.';
    }
    if (score < 0.5) {
      return 'Calm enough. Worth setting up whatever makes tonight easier.';
    }
    if (score < 0.7) {
      return 'This is usually where things start to drift. Small resets work '
          'best now, before the urge builds.';
    }
    return 'This window has been hard for you before. Having a plan ready '
        'beats deciding in the moment.';
  }

  String _countdown(RiskBlock block) {
    final mins = block.startMinute - _nowMinutes;
    if (mins <= 0) return 'now';
    if (mins < 60) return 'in $mins min';
    final h = mins ~/ 60;
    final m = mins % 60;
    return m == 0 ? 'in ${h}h' : 'in ${h}h ${m}m';
  }

  static String _clock(int minutes) {
    final h24 = (minutes ~/ 60) % 24;
    final m = minutes % 60;
    final suffix = h24 < 12 ? 'am' : 'pm';
    final h = h24 % 12 == 0 ? 12 : h24 % 12;
    return m == 0
        ? '$h$suffix'
        : '$h:${m.toString().padLeft(2, '0')}$suffix';
  }

  @override
  Widget build(BuildContext context) {
    final p = AppTheme.palette(context);
    final current = _current;
    final score = current?.score ?? 0.0;
    final tone = p.riskColor(score);
    final next = _nextHigh;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: p.surfaceRaised,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: tone, shape: BoxShape.circle),
              ),
              const SizedBox(width: 9),
              Text(
                'RIGHT NOW',
                style: TextStyle(
                  color: p.textTertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const Spacer(),
              Text(
                _clock(_nowMinutes),
                style: TextStyle(color: p.textTertiary, fontSize: 12.5),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _describe(score),
            style: TextStyle(
              color: p.textPrimary,
              fontSize: 25,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _guidance(score),
            style: TextStyle(
              color: p.textSecondary,
              fontSize: 14.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          RiskTimeline(blocks: blocks, nowMinutes: _nowMinutes),
          if (next != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: p.tintOf(p.supportNeeded),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 17,
                    color: p.supportNeeded,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Harder window ${_countdown(next)}',
                            style: TextStyle(
                              color: p.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: '  ·  around ${_clock(next.startMinute)}',
                            style: TextStyle(color: p.textSecondary),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 13.5, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (onAct != null && score >= 0.5) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAct,
                child: const Text('Get me through this'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
