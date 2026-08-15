import 'dart:async';
import 'dart:math';

import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Tap when the pulsing wave aligns with the target zone.
/// 5 successful hits = win. Miss = the wave speeds up briefly.
class MoodWaveGame extends StatefulWidget {
  final VoidCallback onDone;
  final int? seed;

  const MoodWaveGame({super.key, required this.onDone, this.seed});

  @override
  State<MoodWaveGame> createState() => _MoodWaveGameState();
}

class _MoodWaveGameState extends State<MoodWaveGame>
    with TickerProviderStateMixin {
  late final Random _random;

  late final AnimationController _waveController;
  late final AnimationController _glowController;
  late Animation<double> _waveAnim;

  int _hits = 0;
  static const _targetHits = 5;
  bool _finished = false;
  bool _won = false;
  double _targetZone = 0.5;
  double _currentWave = 0.0;
  bool _inZone = false;
  double _failShake = 0.0;
  Timer? _zoneTimer;
  int _zoneChangeCount = 0;

  @override
  void initState() {
    super.initState();
    _random = Random(widget.seed);
    _targetZone = 0.35 + _random.nextDouble() * 0.3;

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _waveAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _waveController, curve: const SineCurve()),
    )..addListener(() {
        if (!mounted || _finished) return;
        setState(() {
          _currentWave = _waveAnim.value;
          _inZone = (_currentWave - _targetZone).abs() < 0.08;
        });
      });

    _waveController.repeat(reverse: true);

    _zoneTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || _finished) return;
      _zoneChangeCount++;
      if (_zoneChangeCount % 2 == 0) {
        setState(() {
          _targetZone = 0.3 + _random.nextDouble() * 0.4;
        });
      }
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _glowController.dispose();
    _zoneTimer?.cancel();
    super.dispose();
  }

  void _tap() {
    if (_finished) return;

    if (_inZone) {
      setState(() => _hits++);
      if (_hits >= _targetHits) {
        _end(won: true);
        return;
      }
      // Brief success feedback: speed up wave momentarily
      _waveController.duration = const Duration(milliseconds: 800);
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted && !_finished) {
          _waveController.duration = const Duration(milliseconds: 1800);
        }
      });
    } else {
      // Miss: shake briefly
      setState(() => _failShake = 1.0);
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) setState(() => _failShake = 0.0);
      });
    }
  }

  void _end({required bool won}) {
    if (_finished) return;
    _finished = true;
    _won = won;
    _zoneTimer?.cancel();
    _waveController.stop();
    setState(() {});
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) widget.onDone();
    });
  }

  void _skip() {
    _zoneTimer?.cancel();
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(onPressed: _skip, child: const Text('Skip')),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tap when the wave is in the zone',
                  style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 15),
                ),
                Row(
                  children: List.generate(_targetHits, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        i < _hits ? Icons.star : Icons.star_border,
                        color: i < _hits ? AppTheme.palette(context).accent : AppTheme.palette(context).borderStrong,
                        size: 22,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: _finished
                ? Center(
                    child: _won
                        ? TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.elasticOut,
                            builder: (_, v, __) => Opacity(
                              opacity: v,
                              child: Transform.scale(
                                scale: 0.7 + v * 0.3,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.waves, color: AppTheme.palette(context).accent, size: 64),
                                    SizedBox(height: 16),
                                    Text(
                                      'In rhythm. Steady.',
                                      style: TextStyle(
                                        color: AppTheme.palette(context).textPrimary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.timer_outlined, color: AppTheme.palette(context).textTertiary, size: 56),
                              SizedBox(height: 16),
                              Text(
                                'Timing takes practice. Nice try.',
                                style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 17),
                              ),
                            ],
                          ),
                  )
                : GestureDetector(
                    onTap: _tap,
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _glowController,
                        builder: (context, _) {
                          final glowAlpha = 0.15 + _glowController.value * 0.2;
                          final zoneColor = _inZone
                              ? AppTheme.palette(context).success
                              : AppTheme.palette(context).textPrimary.withValues(alpha: 0.3);

                          return Transform.translate(
                            offset: Offset(
                              sin(_failShake * pi * 4) * 8 * _failShake,
                              0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Wave progress bar
                                Container(
                                  width: 280,
                                  height: 280,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        zoneColor.withValues(alpha: glowAlpha * 3),
                                        Colors.transparent,
                                      ],
                                    ),
                                    border: Border.all(
                                      color: zoneColor.withValues(alpha: 0.4),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Target zone band
                                      Positioned(
                                        top: (1 - _targetZone - 0.08) * 260,
                                        child: Container(
                                          width: 240,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(21),
                                            color: zoneColor.withValues(alpha: 0.12),
                                            border: Border.all(
                                              color: zoneColor.withValues(alpha: 0.4),
                                              width: _inZone ? 2 : 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Moving wave indicator
                                      Positioned(
                                        top: (1 - _currentWave) * 250,
                                        child: Container(
                                          width: 200,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(2),
                                            gradient: LinearGradient(
                                              colors: [
                                                AppTheme.palette(context).accent.withValues(alpha: 0.6),
                                                AppTheme.palette(context).accent,
                                                AppTheme.palette(context).accent.withValues(alpha: 0.6),
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.palette(context).accent
                                                    .withValues(alpha: 0.6),
                                                blurRadius: 10,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Hit feedback particles
                                      if (_hits > 0)
                                        ...List.generate(_hits, (i) {
                                          final angle = (i / _targetHits) * 2 * pi;
                                          final r = 110.0;
                                          return Positioned(
                                            left: 140 + cos(angle) * r - 8,
                                            top: 140 + sin(angle) * r - 8,
                                            child: Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppTheme.palette(context).success
                                                    .withValues(alpha: 0.8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppTheme.palette(context).success
                                                        .withValues(alpha: 0.5),
                                                    blurRadius: 8,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 28),
                                Text(
                                  _inZone ? 'NOW!' : 'Wait...',
                                  style: TextStyle(
                                    color: _inZone ? AppTheme.palette(context).success : AppTheme.palette(context).textTertiary,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 3,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap anywhere when the wave\ncrosses the highlighted zone',
                                  style: TextStyle(
                                    color: AppTheme.palette(context).textTertiary,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Ease-in-out sine curve for smooth wave motion.
class SineCurve extends Curve {
  const SineCurve();
  @override
  double transform(double t) => (1 - cos(t * pi)) / 2;
}
