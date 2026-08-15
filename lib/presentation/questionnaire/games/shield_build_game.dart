import 'dart:math';

import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class _ShieldPiece {
  final String label;
  final IconData icon;
  const _ShieldPiece(this.label, this.icon);
}

/// Tap each wellness pillar to build a protective shield.
/// Enhanced with assembly animation and glow intensification.
class ShieldBuildGame extends StatefulWidget {
  final VoidCallback onDone;

  const ShieldBuildGame({super.key, required this.onDone});

  @override
  State<ShieldBuildGame> createState() => _ShieldBuildGameState();
}

class _ShieldBuildGameState extends State<ShieldBuildGame>
    with TickerProviderStateMixin {
  static const _pieces = [
    _ShieldPiece('Sleep', Icons.nightlight_round),
    _ShieldPiece('Routine', Icons.schedule),
    _ShieldPiece('Movement', Icons.directions_walk),
    _ShieldPiece('Awareness', Icons.visibility_outlined),
    _ShieldPiece('Feedback', Icons.tune),
  ];

  final Set<String> _placed = {};
  bool _finished = false;
  late final AnimationController _glowController;
  late final AnimationController _shieldPulse;
  String? _lastPlaced;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _shieldPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _shieldPulse.dispose();
    super.dispose();
  }

  void _skip() => widget.onDone();

  void _placePiece(String label) {
    if (_finished || _placed.contains(label)) return;
    setState(() {
      _placed.add(label);
      _lastPlaced = label;
    });
    _shieldPulse.forward(from: 0);
    if (_placed.length == _pieces.length) {
      _finish();
    }
  }

  void _finish() {
    if (_finished) return;
    _finished = true;
    setState(() {});
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) widget.onDone();
    });
  }

  @override
  Widget build(BuildContext context) {
    final placedCount = _placed.length;
    final totalPieces = _pieces.length;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(onPressed: _skip, child: const Text('Skip')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Tap each piece to build your shield',
              style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '$placedCount / $totalPieces',
              style: TextStyle(
                color: placedCount == totalPieces
                    ? AppTheme.palette(context).accent
                    : AppTheme.palette(context).textTertiary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 28),

            // Shield with assembly animation
            AnimatedBuilder(
              animation: _shieldPulse,
              builder: (context, _) {
                final pulse = _shieldPulse.value;
                final currentSize = 160 + pulse * 12;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutBack,
                  width: currentSize,
                  height: currentSize + 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    border: Border.all(
                      color: placedCount == totalPieces
                          ? AppTheme.palette(context).accent
                          : AppTheme.palette(context).textPrimary.withValues(
                              alpha: 0.2 + (placedCount / totalPieces) * 0.3),
                      width: placedCount == totalPieces ? 3 : 1.5,
                    ),
                    boxShadow: placedCount > 0
                        ? [
                            BoxShadow(
                              color: AppTheme.palette(context).accent.withValues(
                                  alpha: (placedCount / totalPieces) * 0.5),
                              blurRadius: 24 + pulse * 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Shield segments
                      ...List.generate(totalPieces, (i) {
                        final piece = _pieces[i];
                        final isPlaced = _placed.contains(piece.label);
                        final angle = -pi / 2 + (i / totalPieces) * 2 * pi;
                        final r = 36.0;
                        return Positioned(
                          left: currentSize / 2 + cos(angle) * r - 14,
                          top: currentSize / 2 + sin(angle) * r - 14 + 10,
                          child: AnimatedScale(
                            scale: isPlaced ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.elasticOut,
                            child: AnimatedOpacity(
                              opacity: isPlaced ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isPlaced
                                      ? AppTheme.palette(context).success.withValues(alpha: 0.7)
                                      : Colors.transparent,
                                  boxShadow: isPlaced
                                      ? [
                                          BoxShadow(
                                            color: AppTheme.palette(context).success
                                                .withValues(alpha: 0.5),
                                            blurRadius: 8,
                                          ),
                                        ]
                                      : null,
                                ),
                                child:
                                    Icon(piece.icon, color: AppTheme.palette(context).textPrimary, size: 14),
                              ),
                            ),
                          ),
                        );
                      }),

                      // Center shield icon
                      AnimatedScale(
                        scale: placedCount == totalPieces ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.elasticOut,
                        child: Icon(
                          placedCount == totalPieces
                              ? Icons.shield
                              : Icons.shield_outlined,
                          size: 64,
                          color: placedCount == totalPieces
                              ? AppTheme.palette(context).accent
                              : AppTheme.palette(context).textPrimary.withValues(alpha: 0.25),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 36),

            if (_finished)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (_, v, __) => Opacity(
                  opacity: v,
                  child: Transform.scale(
                    scale: 0.7 + v * 0.3,
                    child: Text(
                      'Shield built. Detoxia is configured.',
                      style: TextStyle(
                        color: AppTheme.palette(context).textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: _pieces.map((piece) {
                  final placed = _placed.contains(piece.label);
                  return AnimatedScale(
                    scale: placed ? 0.9 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    child: Opacity(
                      opacity: placed ? 0.4 : 1,
                      child: ActionChip(
                        avatar: Icon(
                          piece.icon,
                          size: 18,
                          color: placed ? AppTheme.palette(context).textTertiary : AppTheme.palette(context).accent,
                        ),
                        label: Text(piece.label),
                        onPressed:
                            placed ? null : () => _placePiece(piece.label),
                        backgroundColor: AppTheme.palette(context).surfaceRaised,
                        labelStyle:  TextStyle(color: AppTheme.palette(context).textPrimary),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
