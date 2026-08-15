import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class _PatternPair {
  final String left;
  final String right;

  const _PatternPair(this.left, this.right);
}

/// Match stress / sleep / boredom patterns to their outcomes.
class PatternMatchGame extends StatefulWidget {
  final VoidCallback onDone;

  const PatternMatchGame({super.key, required this.onDone});

  @override
  State<PatternMatchGame> createState() => _PatternMatchGameState();
}

class _PatternMatchGameState extends State<PatternMatchGame> {
  static const _pairs = [
    _PatternPair('Stress', 'Scrolling'),
    _PatternPair('Poor sleep', 'Low control'),
    _PatternPair('Boredom', 'Reels → Urge'),
  ];

  late final List<String> _rightLabels;
  String? _selectedLeft;
  final Set<String> _matchedLeft = {};
  bool _finished = false;
  Color? _flashColor;

  @override
  void initState() {
    super.initState();
    _rightLabels = _pairs.map((p) => p.right).toList()..shuffle();
  }

  void _skip() => widget.onDone();

  void _selectLeft(String label) {
    if (_finished || _matchedLeft.contains(label)) return;
    setState(() => _selectedLeft = label);
  }

  void _selectRight(String label) {
    if (_finished || _selectedLeft == null) return;

    final left = _selectedLeft!;
    final expected = _pairs
        .firstWhere((p) => p.left == left, orElse: () => const _PatternPair('', ''))
        .right;

    if (label == expected) {
      setState(() {
        _matchedLeft.add(left);
        _selectedLeft = null;
        _flashColor = AppTheme.palette(context).success.withValues(alpha: 0.25);
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        setState(() => _flashColor = null);
        if (_matchedLeft.length == _pairs.length) {
          _finish();
        }
      });
    } else {
      setState(() {
        _selectedLeft = null;
        _flashColor = const Color(0xFFEF5350).withValues(alpha: 0.2);
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _flashColor = null);
      });
    }
  }

  void _finish() {
    if (_finished) return;
    _finished = true;
    setState(() {});
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) widget.onDone();
    });
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
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _flashColor ?? const Color(0xFF1A1B2E),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _finished
              ? Center(
                  child: Text(
                    'Pattern detected. Engine learns.',
                    style: TextStyle(
                      color: AppTheme.palette(context).textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Match each pattern',
                      style: TextStyle(
                        color: AppTheme.palette(context).textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap left, then right',
                      style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: _pairs.map((p) {
                                final matched = _matchedLeft.contains(p.left);
                                final selected = _selectedLeft == p.left;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _LabelChip(
                                    label: p.left,
                                    selected: selected,
                                    matched: matched,
                                    onTap: matched
                                        ? null
                                        : () => _selectLeft(p.left),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              children: _rightLabels.map((label) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _LabelChip(
                                    label: label,
                                    onTap: () => _selectRight(label),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _LabelChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool matched;
  final VoidCallback? onTap;

  const _LabelChip({
    required this.label,
    this.selected = false,
    this.matched = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: matched
          ? AppTheme.palette(context).success.withValues(alpha: 0.2)
          : selected
              ? AppTheme.palette(context).accent.withValues(alpha: 0.35)
              : AppTheme.palette(context).surfaceRaised,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Text(
            label,
            style: TextStyle(
              color: matched ? AppTheme.palette(context).success : AppTheme.palette(context).textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
