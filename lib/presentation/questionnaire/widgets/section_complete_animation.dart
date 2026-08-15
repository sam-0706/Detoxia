import 'dart:async';

import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SectionCompleteAnimation extends StatefulWidget {
  final String message;
  final VoidCallback onComplete;
  final Duration duration;

  const SectionCompleteAnimation({
    super.key,
    required this.message,
    required this.onComplete,
    this.duration = const Duration(milliseconds: 2500),
  });

  @override
  State<SectionCompleteAnimation> createState() =>
      _SectionCompleteAnimationState();
}

class _SectionCompleteAnimationState extends State<SectionCompleteAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _dismissed = false;
  bool _didStart = false;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didStart) return;
    _didStart = true;

    final reducedMotion = MediaQuery.maybeDisableAnimationsOf(context);
    if (reducedMotion == true) {
      _dismissTimer = Timer(const Duration(milliseconds: 500), _complete);
    } else {
      _controller.forward();
      _dismissTimer = Timer(widget.duration, _complete);
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _complete() {
    if (!_dismissed && mounted) {
      _dismissed = true;
      widget.onComplete();
    }
  }

  IconData _getIcon() {
    final message = widget.message.toLowerCase();
    if (message.contains('routine')) return Icons.schedule;
    if (message.contains('sleep')) return Icons.nightlight_round;
    if (message.contains('focus')) return Icons.center_focus_strong;
    if (message.contains('anxiety')) return Icons.air;
    if (message.contains('mood')) return Icons.wb_sunny_outlined;
    if (message.contains('trigger')) return Icons.bolt;
    if (message.contains('pathway')) return Icons.timeline;
    if (message.contains('feedback')) return Icons.tune;
    return Icons.check_circle_outline;
  }

  @override
  Widget build(BuildContext context) {
    final p = AppTheme.palette(context);
    return GestureDetector(
      onTap: _complete,
      child: Container(
        color: p.canvas.withValues(alpha: 0.93),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      color: p.accentSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_getIcon(), size: 44, color: p.accent),
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: p.textPrimary,
                        fontSize: 20,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Tap to continue',
                    style: TextStyle(color: p.textTertiary, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
