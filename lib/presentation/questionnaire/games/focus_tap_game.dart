import 'dart:async';
import 'dart:math';

import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Tap glowing dots before they fade — quick focus reset.
/// Now with ripple effects, combo counter, and celebration.
class FocusTapGame extends StatefulWidget {
  final VoidCallback onDone;
  final Duration dotLifetime;

  const FocusTapGame({
    super.key,
    required this.onDone,
    this.dotLifetime = const Duration(milliseconds: 1500),
  });

  @override
  State<FocusTapGame> createState() => _FocusTapGameState();
}

class _Ripple {
  final Offset position;
  double radius;
  double opacity;
  _Ripple({required this.position, this.radius = 0, this.opacity = 0.6});
}

class _FocusTapGameState extends State<FocusTapGame>
    with TickerProviderStateMixin {
  static const _totalDots = 5;

  final _random = Random();
  int _dotsShown = 0;
  int _caught = 0;
  int _combo = 0;
  int _bestCombo = 0;
  int? _activeDotIndex;
  Offset? _dotPosition;
  bool _finished = false;
  Timer? _dotTimer;
  Timer? _finishTimer;
  final List<_Ripple> _ripples = [];
  late final AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _spawnDot());
  }

  @override
  void dispose() {
    _dotTimer?.cancel();
    _finishTimer?.cancel();
    _rippleController.dispose();
    super.dispose();
  }

  void _skip() {
    _dotTimer?.cancel();
    _finishTimer?.cancel();
    widget.onDone();
  }

  void _spawnDot() {
    if (_dotsShown >= _totalDots || !mounted) {
      _showResult();
      return;
    }
    setState(() {
      _dotsShown++;
      _activeDotIndex = _dotsShown;
      _dotPosition = Offset(
        0.15 + _random.nextDouble() * 0.7,
        0.2 + _random.nextDouble() * 0.55,
      );
    });
    _dotTimer?.cancel();
    _dotTimer = Timer(widget.dotLifetime, () {
      if (!mounted || _finished) return;
      setState(() {
        _combo = 0;
        _activeDotIndex = null;
        _dotPosition = null;
      });
      _spawnDot();
    });
  }

  void _tapDot() {
    if (_activeDotIndex == null || _finished) return;
    _dotTimer?.cancel();

    setState(() {
      _caught++;
      _combo++;
      if (_combo > _bestCombo) _bestCombo = _combo;
      _activeDotIndex = null;
      _dotPosition = null;

      // Add ripple effect at the dot position
      if (_dotPosition != null) {
        _spawnRipple(_dotPosition!);
      }
    });

    _rippleController.forward(from: 0);
    _spawnDot();
  }

  void _spawnRipple(Offset pos) {
    final ripple = _Ripple(position: pos);
    _ripples.add(ripple);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _ripples.remove(ripple));
      }
    });
  }

  void _showResult() {
    if (_finished) return;
    _finished = true;
    _dotTimer?.cancel();
    setState(() {});
    _finishTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) widget.onDone();
    });
  }

  Color _comboColor() {
    if (_combo >= 4) return const Color(0xFFFFD700);
    if (_combo >= 2) return AppTheme.palette(context).success;
    return AppTheme.palette(context).accent;
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
                  'Tap the glowing dots before they fade',
                  style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 15),
                ),
                if (_combo > 1)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.elasticOut,
                    builder: (_, v, __) => Transform.scale(
                      scale: v,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: _comboColor().withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_combo}x combo!',
                          style: TextStyle(
                            color: _comboColor(),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Score dots
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_totalDots, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Icon(
                    i < _caught ? Icons.circle : Icons.circle_outlined,
                    color: i < _caught
                        ? AppTheme.palette(context).accent
                        : AppTheme.palette(context).textPrimary.withValues(alpha: 0.2),
                    size: i < _caught ? 14 : 12,
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: _finished
                ? Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.3, end: 1.0),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.elasticOut,
                      builder: (_, v, __) => Transform.scale(
                        scale: v,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _caught == _totalDots
                                  ? Icons.emoji_events
                                  : Icons.stars,
                              color: _caught == _totalDots
                                  ? const Color(0xFFFFD700)
                                  : AppTheme.palette(context).accent,
                              size: 56,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _caught == _totalDots
                                  ? 'Perfect! All $_totalDots caught.'
                                  : 'You caught $_caught/$_totalDots. Best combo: $_bestCombo.',
                              style: TextStyle(
                                color: AppTheme.palette(context).textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          // Ripple effects
                          ..._ripples.map((r) => Positioned(
                                left: r.position.dx *
                                        (constraints.maxWidth - 56) -
                                    r.radius / 2,
                                top: r.position.dy *
                                        (constraints.maxHeight - 56) -
                                    r.radius / 2,
                                child: IgnorePointer(
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0, end: 40),
                                    duration: const Duration(milliseconds: 500),
                                    onEnd: () {
                                      if (mounted)
                                        setState(() => _ripples.remove(r));
                                    },
                                    builder: (_, v, __) => Container(
                                      width: v * 2,
                                      height: v * 2,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppTheme.palette(context).accent
                                              .withValues(alpha: 0.3),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          if (_dotPosition != null)
                            Positioned(
                              left: _dotPosition!.dx *
                                  (constraints.maxWidth - 56),
                              top: _dotPosition!.dy *
                                  (constraints.maxHeight - 56),
                              child: GestureDetector(
                                onTap: _tapDot,
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.7, end: 1.0),
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.elasticOut,
                                  builder: (_, v, __) => Transform.scale(
                                    scale: v,
                                    child: Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _comboColor()
                                            .withValues(alpha: 0.85),
                                        boxShadow: [
                                          BoxShadow(
                                            color: _comboColor()
                                                .withValues(alpha: 0.6),
                                            blurRadius: 20,
                                            spreadRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
