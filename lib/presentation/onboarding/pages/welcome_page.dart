import 'dart:math';

import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OnboardingWelcomePage extends StatefulWidget {
  final VoidCallback onNext;

  const OnboardingWelcomePage({super.key, required this.onNext});

  @override
  State<OnboardingWelcomePage> createState() => _OnboardingWelcomePageState();
}

class _Particle {
  double x, y, vx, vy, size, opacity, rotation;
  Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.opacity,
    required this.color,
    this.rotation = 0,
  });
}

class _OnboardingWelcomePageState extends State<OnboardingWelcomePage>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _floatController;
  late final AnimationController _particleController;
  late final Animation<double> _scale;
  late final Animation<double> _fade;
  final _random = Random();
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = Tween<double>(begin: 0.82, end: 1).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.elasticOut),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeOut),
    );
    _floatController.forward();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _spawnParticles();
  }

  void _spawnParticles() {
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFF4ECDC4),
      const Color(0xFFFFB347),
      const Color(0xFFFF6B9D),
    ];
    for (int i = 0; i < 30; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: 1.0 + _random.nextDouble() * 0.4,
        vx: (_random.nextDouble() - 0.5) * 0.003,
        vy: -0.003 - _random.nextDouble() * 0.006,
        size: 2 + _random.nextDouble() * 5,
        opacity: 0.3 + _random.nextDouble() * 0.5,
        color: colors[_random.nextInt(colors.length)],
        rotation: _random.nextDouble() * 2 * pi,
      ));
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        // Background particles
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _particleController,
            builder: (context, _) {
              return CustomPaint(
                painter: _ParticlePainter(_particles),
              );
            },
          ),
        ),

        Positioned(
          top: -40,
          right: -30,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) => _GlowOrb(
              size: 180,
              color: primary.withValues(
                  alpha: 0.22 + _pulseController.value * 0.12),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: -50,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) => _GlowOrb(
              size: 140,
              color: AppTheme.palette(context).accent.withValues(
                  alpha: 0.14 + (1 - _pulseController.value) * 0.1),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.rotate(
                        angle: (1 - value) * 0.5,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primary, AppTheme.palette(context).accent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.45),
                            blurRadius: 28,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child:
                           Icon(Icons.spa, color: AppTheme.palette(context).textPrimary, size: 44),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              FadeTransition(
                opacity: _fade,
                child: Text(
                  'Welcome to\nDetoxia',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 36,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              FadeTransition(
                opacity: _fade,
                child: Text(
                  'Your private wellness companion — anxiety, ADHD, mood, '
                  'period tracking, and recovery. All on your device.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.palette(context).textSecondary,
                        height: 1.5,
                      ),
                ),
              ),
              const Spacer(flex: 3),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.95 + value * 0.05,
                    child: child,
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.onNext,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Get started',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Takes about 2 minutes',
                  style: TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 13),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      p.x += p.vx;
      p.y += p.vy;
      p.rotation += 0.01;

      if (p.y < -0.1) {
        p.y = 1.05;
        p.x = Random().nextDouble();
      }
      if (p.x < -0.05) p.x = 1.05;
      if (p.x > 1.05) p.x = -0.05;

      final pos = Offset(p.x * size.width, p.y * size.height);
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(p.rotation);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset.zero, width: p.size, height: p.size),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
