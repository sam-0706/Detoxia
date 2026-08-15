import 'package:flutter/material.dart';

/// Fade + slide entrance for each onboarding step, with staggered
/// section support when children are wrapped with [Stagger].
class AnimatedOnboardingPage extends StatefulWidget {
  final Widget child;
  final int pageIndex;
  final Duration duration;

  const AnimatedOnboardingPage({
    super.key,
    required this.child,
    required this.pageIndex,
    this.duration = const Duration(milliseconds: 520),
  });

  @override
  State<AnimatedOnboardingPage> createState() => _AnimatedOnboardingPageState();
}

class _AnimatedOnboardingPageState extends State<AnimatedOnboardingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0.04, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedOnboardingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageIndex != widget.pageIndex) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
