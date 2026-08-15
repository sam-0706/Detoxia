import 'dart:async';
import 'dart:math';

import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum _BreathPhase { inhale, exhale }

/// Breathing orb — animated inhale/exhale cycles with particle trail.
class BreathingOrbGame extends StatefulWidget {
  final VoidCallback onDone;
  final bool tapOnlyMode;
  final Duration phaseDuration;

  const BreathingOrbGame({
    super.key,
    required this.onDone,
    this.tapOnlyMode = false,
    this.phaseDuration = const Duration(milliseconds: 3500),
  });

  @override
  State<BreathingOrbGame> createState() => _BreathingOrbGameState();
}

class _TrailParticle {
  double x, y, opacity, size;
  _TrailParticle({
    required this.x,
    required this.y,
    this.opacity = 1.0,
    this.size = 0,
  });
}

class _BreathingOrbGameState extends State<BreathingOrbGame>
    with TickerProviderStateMixin {
  static const _cyclesRequired = 2;

  late AnimationController _orbController;
  late AnimationController _trailController;
  int _cyclesCompleted = 0;
  _BreathPhase _phase = _BreathPhase.inhale;
  bool _finished = false;
  Timer? _phaseTimer;
  final List<_TrailParticle> _trails = [];
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: widget.phaseDuration,
    );
    _trailController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
    if (!widget.tapOnlyMode) {
      _startAnimatedPhase();
    }
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _orbController.dispose();
    _trailController.dispose();
    super.dispose();
  }

  void _skip() {
    _phaseTimer?.cancel();
    widget.onDone();
  }

  String get _label =>
      _phase == _BreathPhase.inhale ? 'Breathe in' : 'Breathe out';

  Color _phaseColor() {
    if (_phase == _BreathPhase.inhale) {
      return const Color(0xFF4ECDC4);
    }
    return const Color(0xFF6C63FF);
  }

  void _spawnTrail(double orbSize) {
    if (_trails.length > 40) _trails.removeAt(0);
    _trails.add(_TrailParticle(
      x: (_random.nextDouble() - 0.5) * 0.3,
      y: (_random.nextDouble() - 0.5) * 0.3,
      opacity: 0.6,
      size: orbSize * 0.3 + _random.nextDouble() * orbSize * 0.2,
    ));
  }

  void _startAnimatedPhase() {
    _orbController.duration = widget.phaseDuration;
    if (_phase == _BreathPhase.inhale) {
      _orbController.forward(from: 0);
    } else {
      _orbController.reverse(from: 1);
    }
    _phaseTimer?.cancel();
    _phaseTimer = Timer(widget.phaseDuration, _advancePhase);
  }

  void _advancePhase() {
    if (_finished || !mounted) return;

    if (_phase == _BreathPhase.inhale) {
      setState(() => _phase = _BreathPhase.exhale);
    } else {
      _cyclesCompleted++;
      if (_cyclesCompleted >= _cyclesRequired) {
        _finish();
        return;
      }
      setState(() => _phase = _BreathPhase.inhale);
    }

    if (widget.tapOnlyMode) {
      setState(() {});
    } else {
      _startAnimatedPhase();
    }
  }

  void _onTap() {
    if (_finished) return;
    if (widget.tapOnlyMode) {
      _advancePhase();
    }
  }

  void _finish() {
    if (_finished) return;
    _finished = true;
    _phaseTimer?.cancel();
    setState(() {});
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) widget.onDone();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orbSize = widget.tapOnlyMode
        ? (_phase == _BreathPhase.inhale ? 140.0 : 90.0)
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(onPressed: _skip, child: const Text('Skip')),
        ],
      ),
      body: GestureDetector(
        onTap: widget.tapOnlyMode ? _onTap : null,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_finished)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.6, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (_, v, __) => Transform.scale(
                  scale: v,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.self_improvement,
                          color: AppTheme.palette(context).accent, size: 64),
                      const SizedBox(height: 12),
                      Text(
                        'Nice reset',
                        style: TextStyle(
                          color: AppTheme.palette(context).textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              // Cycle progress dots
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_cyclesRequired, (i) {
                    final active = i < _cyclesCompleted;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: active ? 14 : 10,
                        height: active ? 14 : 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active
                              ? AppTheme.palette(context).accent
                              : AppTheme.palette(context).textPrimary.withValues(alpha: 0.2),
                          boxShadow: active
                              ? [
                                  BoxShadow(
                                    color:
                                        AppTheme.palette(context).accent.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              Text(
                _label,
                style: TextStyle(
                  color: AppTheme.palette(context).textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: _phaseColor().withValues(alpha: 0.5),
                      blurRadius: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              if (widget.tapOnlyMode)
                Text(
                  'Tap to advance each phase',
                  style: TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 14),
                ),
              const SizedBox(height: 44),

              // Orb with particle trails
              Stack(
                alignment: Alignment.center,
                children: [
                  // Trail particles
                  if (!widget.tapOnlyMode)
                    ..._trails.map((p) {
                      return Transform.translate(
                        offset: Offset(p.x * 200, p.y * 200),
                        child: Opacity(
                          opacity: p.opacity,
                          child: Container(
                            width: p.size,
                            height: p.size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _phaseColor().withValues(alpha: 0.15),
                            ),
                          ),
                        ),
                      );
                    }),

                  widget.tapOnlyMode
                      ? AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutCubic,
                          width: orbSize,
                          height: orbSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _phaseColor().withValues(alpha: 0.35),
                            border: Border.all(
                              color: _phaseColor().withValues(alpha: 0.8),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _phaseColor().withValues(alpha: 0.5),
                                blurRadius: 32,
                                spreadRadius: 6,
                              ),
                            ],
                          ),
                        )
                      : AnimatedBuilder(
                          animation: _orbController,
                          builder: (context, child) {
                            final size = 80 + _orbController.value * 100;
                            _spawnTrail(size);
                            return Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    _phaseColor().withValues(alpha: 0.5),
                                    _phaseColor().withValues(alpha: 0.15),
                                  ],
                                ),
                                border: Border.all(
                                  color: _phaseColor().withValues(alpha: 0.8),
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _phaseColor().withValues(alpha: 0.5),
                                    blurRadius: 36,
                                    spreadRadius: 8,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),

              // Cycle counter
              const SizedBox(height: 36),
              Text(
                'Cycle ${_cyclesCompleted + 1} of $_cyclesRequired',
                style:  TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
