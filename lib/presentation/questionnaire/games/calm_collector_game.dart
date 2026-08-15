import 'dart:async';
import 'dart:math';

import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Catch falling calm drops while avoiding stress sparks.
/// Each drop caught = +1 calm. Each spark hit = -1 calm.
/// Goal: reach 8 calm to win. Game over at -3.
class CalmCollectorGame extends StatefulWidget {
  final VoidCallback onDone;
  final int? seed;

  const CalmCollectorGame({super.key, required this.onDone, this.seed});

  @override
  State<CalmCollectorGame> createState() => _CalmCollectorGameState();
}

class _FallingItem {
  final bool isDrop; // true = calm drop, false = stress spark
  double x, y;
  final double speed;
  final double size;
  double opacity;

  _FallingItem({
    required this.isDrop,
    required this.x,
    this.y = -0.05,
    required this.speed,
    this.size = 40,
    this.opacity = 1.0,
  });
}

class _CalmCollectorGameState extends State<CalmCollectorGame>
    with TickerProviderStateMixin {
  late final Random _random;
  final List<_FallingItem> _items = [];
  int _score = 0;
  bool _finished = false;
  bool _won = false;
  Timer? _spawnTimer;
  Timer? _tickTimer;
  late final AnimationController _bgController;
  int _tick = 0;

  @override
  void initState() {
    super.initState();
    _random = Random(widget.seed);
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 550), (_) => _spawn());
    _tickTimer = Timer.periodic(const Duration(milliseconds: 33), (_) => _tickGame());
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    _tickTimer?.cancel();
    _bgController.dispose();
    super.dispose();
  }

  void _spawn() {
    if (_finished || !mounted) return;
    final isDrop = _random.nextDouble() > 0.35; // 65% calm drops
    setState(() {
      _items.add(_FallingItem(
        isDrop: isDrop,
        x: 0.08 + _random.nextDouble() * 0.84,
        speed: 0.008 + _random.nextDouble() * 0.014,
        size: isDrop ? 36 + _random.nextDouble() * 16 : 28 + _random.nextDouble() * 12,
      ));
    });
  }

  void _tickGame() {
    if (_finished || !mounted) return;
    _tick++;

    final toRemove = <_FallingItem>[];
    for (final item in _items) {
      item.y += item.speed;
      if (item.y > 0.9 && item.isDrop) {
        // Missed a calm drop
        _score--;
        toRemove.add(item);
      } else if (item.y > 1.05) {
        toRemove.add(item);
      }
    }

    setState(() {
      for (final item in toRemove) {
        _items.remove(item);
      }
    });

    if (_score <= -3) {
      _end(won: false);
    }
  }

  void _onTapUp(TapUpDetails details, Size size) {
    if (_finished) return;
    final tapX = details.localPosition.dx / size.width;
    final tapY = details.localPosition.dy / size.height;

    _FallingItem? closest;
    double closestDist = double.infinity;
    for (final item in _items) {
      final dx = (item.x - tapX).abs();
      final dy = (item.y - tapY).abs();
      final dist = dx * dx + dy * dy;
      if (dist < 0.025 && dist < closestDist) {
        closest = item;
        closestDist = dist;
      }
    }

    if (closest != null) {
      setState(() {
        _items.remove(closest);
        if (closest!.isDrop) {
          _score++;
          if (_score >= 8) _end(won: true);
        } else {
          _score--;
          if (_score <= -3) _end(won: false);
        }
      });
    }
  }

  void _end({required bool won}) {
    if (_finished) return;
    _finished = true;
    _won = won;
    _spawnTimer?.cancel();
    setState(() {});
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) widget.onDone();
    });
  }

  void _skip() {
    _spawnTimer?.cancel();
    _tickTimer?.cancel();
    widget.onDone();
  }

  Color _scoreColor() {
    if (_score >= 5) return AppTheme.palette(context).success;
    if (_score >= 2) return AppTheme.palette(context).accent;
    if (_score >= -1) return Colors.orange;
    return const Color(0xFFEF5350);
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
                  'Catch the calm, dodge the stress',
                  style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: _scoreColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _scoreColor().withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    'Calm: $_score / 8',
                    style: TextStyle(
                      color: _scoreColor(),
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _finished
                ? Center(
                    child: _won
                        ? TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.8, end: 1.0),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.elasticOut,
                            builder: (_, v, __) => Transform.scale(
                              scale: v,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.spa, color: AppTheme.palette(context).success, size: 64),
                                  SizedBox(height: 16),
                                  Text(
                                    'So calm. You got this.',
                                    style: TextStyle(
                                      color: AppTheme.palette(context).textPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.self_improvement, color: AppTheme.palette(context).textTertiary, size: 56),
                              SizedBox(height: 16),
                              Text(
                                'Every wave passes. Keep going.',
                                style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 17),
                              ),
                            ],
                          ),
                  )
                : GestureDetector(
                    onTapUp: (d) {
                      final size = (context.findRenderObject() as RenderBox).size;
                      _onTapUp(d, size);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedBuilder(
                      animation: _bgController,
                      builder: (context, _) {
                        final bgHue = (_tick / 200.0) % 1.0;
                        return Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment(0.3, 0.3),
                              colors: [
                                HSLColor.fromAHSL(0.08, bgHue * 360, 0.6, 0.5).toColor(),
                                const Color(0xFF1A1B2E),
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              for (final item in _items)
                                Positioned(
                                  left: item.x * MediaQuery.of(context).size.width -
                                      item.size / 2,
                                  top: item.y * MediaQuery.of(context).size.height -
                                      item.size / 2,
                                  child: IgnorePointer(
                                    child: item.isDrop
                                        ? Container(
                                            width: item.size,
                                            height: item.size,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: const RadialGradient(
                                                colors: [
                                                  Color(0xFF4ECDC4),
                                                  Color(0xFF2ECC71),
                                                ],
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF4ECDC4)
                                                      .withValues(alpha: 0.5),
                                                  blurRadius: 16,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: Icon(Icons.water_drop,
                                                color: AppTheme.palette(context).textPrimary, size: 18),
                                          )
                                        : Icon(
                                            Icons.flash_on,
                                            color: const Color(0xFFFF6B6B)
                                                .withValues(alpha: 0.9),
                                            size: item.size,
                                            shadows: [
                                              const Shadow(
                                                color: Color(0xFFFF6B6B),
                                                blurRadius: 12,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
