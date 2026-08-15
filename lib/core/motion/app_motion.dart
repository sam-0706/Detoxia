import 'package:flutter/material.dart';

/// Detoxia's motion vocabulary.
///
/// One place for durations and curves so every screen moves the same way.
/// The bias is *fast and soft*: this app is opened by people who are agitated
/// or avoidant, and slow, showy motion reads as the app wasting their time.
/// Nothing here blocks input — animations decorate, they never gate.
abstract final class AppMotion {
  // ── Durations ──
  /// Taps, toggles, selection states.
  static const fast = Duration(milliseconds: 180);

  /// Cards entering, sheets, section changes.
  static const medium = Duration(milliseconds: 320);

  /// Full-screen transitions and celebratory beats.
  static const slow = Duration(milliseconds: 520);

  /// Gap between siblings in a staggered list.
  static const stagger = Duration(milliseconds: 55);

  // ── Curves ──
  /// Default for things arriving on screen.
  static const enter = Curves.easeOutCubic;

  /// Default for things leaving.
  static const exit = Curves.easeInCubic;

  /// Slight overshoot — for confirmations and things that should feel alive.
  static const spring = Curves.easeOutBack;

  /// Smooth both ends, for values that morph in place (numbers, bars, rings).
  static const morph = Curves.easeInOutCubic;
}

/// Fades and lifts a child into place, optionally after a stagger delay.
///
/// Used for list and column entrances. Runs once on mount; rebuilding with the
/// same key will not replay it, so it never re-animates on setState.
class FadeSlideIn extends StatefulWidget {
  final Widget child;

  /// Multiplied by [AppMotion.stagger] to offset the start.
  final int index;

  /// How far below its final position the child starts, in logical pixels.
  final double offset;

  final Duration duration;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.index = 0,
    this.offset = 16,
    this.duration = AppMotion.medium,
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curved;

  @override
  void initState() {
    super.initState();

    // The stagger is expressed as a leading Interval on one controller rather
    // than a delayed start. A `Future.delayed` would leave a timer alive after
    // dispose — harmless in the app, but it fails widget tests and it's a leak
    // either way.
    final delay = AppMotion.stagger * widget.index;
    final total = widget.duration + delay;
    _controller = AnimationController(vsync: this, duration: total);

    final start = total.inMicroseconds == 0
        ? 0.0
        : delay.inMicroseconds / total.inMicroseconds;
    _curved = CurvedAnimation(
      parent: _controller,
      curve: Interval(start.clamp(0.0, 0.95), 1, curve: AppMotion.enter),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curved,
      builder: (context, child) => Opacity(
        opacity: _curved.value,
        child: Transform.translate(
          offset: Offset(0, (1 - _curved.value) * widget.offset),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

/// Counts a number up when it changes, instead of snapping.
///
/// Progress that visibly moves is the cheapest way to make a long form feel
/// like it's going somewhere.
class AnimatedCount extends StatelessWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;

  const AnimatedCount({
    super.key,
    required this.value,
    this.style,
    this.duration = AppMotion.slow,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: value.toDouble(), end: value.toDouble()),
      duration: duration,
      curve: AppMotion.morph,
      builder: (context, v, _) => Text('${v.round()}', style: style),
    );
  }
}

/// Briefly scales a child when [trigger] changes — a confirmation pulse.
class PulseOnChange extends StatefulWidget {
  final Object? trigger;
  final Widget child;
  final double scale;

  const PulseOnChange({
    super.key,
    required this.trigger,
    required this.child,
    this.scale = 1.08,
  });

  @override
  State<PulseOnChange> createState() => _PulseOnChangeState();
}

class _PulseOnChangeState extends State<PulseOnChange>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.fast,
  );

  @override
  void didUpdateWidget(PulseOnChange old) {
    super.didUpdateWidget(old);
    if (old.trigger != widget.trigger) {
      _controller.forward(from: 0).then((_) {
        if (mounted) _controller.reverse();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: 1 + (_controller.value * (widget.scale - 1)),
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// Page transition used across onboarding and the questionnaire: the incoming
/// page slides a short distance and fades, the outgoing one just fades. Short
/// travel keeps it from feeling like a carousel.
class DirectionalPageRoute<T> extends PageRouteBuilder<T> {
  DirectionalPageRoute({
    required WidgetBuilder builder,
    bool forward = true,
  }) : super(
         transitionDuration: AppMotion.medium,
         reverseTransitionDuration: AppMotion.fast,
         pageBuilder: (context, _, _) => builder(context),
         transitionsBuilder: (context, animation, _, child) {
           final curved = CurvedAnimation(
             parent: animation,
             curve: AppMotion.enter,
             reverseCurve: AppMotion.exit,
           );
           return FadeTransition(
             opacity: curved,
             child: SlideTransition(
               position: Tween<Offset>(
                 begin: Offset(forward ? 0.06 : -0.06, 0),
                 end: Offset.zero,
               ).animate(curved),
               child: child,
             ),
           );
         },
       );
}
