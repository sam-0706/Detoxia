import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// One selectable answer row.
///
/// Every answer widget in the questionnaire renders through this so a tap
/// target, its selected state and its spacing are identical everywhere —
/// across ~80 questions, inconsistency here is what makes a form feel long.
class AnswerOptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Position of this option on an intensity scale, 0.0 → 1.0.
  ///
  /// Drives the leading indicator so the same rung of a Likert scale looks
  /// identical on every question. After a couple of questions people answer
  /// by position instead of re-reading four near-identical labels.
  final double? intensity;

  /// Multi-select rows read as checkboxes; single-select rows do not.
  final bool multiSelect;

  const AnswerOptionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.intensity,
    this.multiSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppTheme.palette(context);

    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: !multiSelect,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: selected ? p.accentSoft : p.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? p.accent : p.borderSubtle,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                if (intensity != null)
                  _IntensityDot(value: intensity!, selected: selected)
                else if (multiSelect)
                  _CheckBox(selected: selected)
                else
                  _RadioDot(selected: selected),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected ? p.textPrimary : p.textSecondary,
                      fontSize: 15.5,
                      height: 1.35,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Ramp indicator for Likert rows — grows and brightens with intensity.
///
/// Deliberately a single-hue accent ramp rather than green→red: this app asks
/// people to admit how often they struggle, and colouring the honest answer
/// as "danger" discourages honesty.
class _IntensityDot extends StatelessWidget {
  final double value;
  final bool selected;

  const _IntensityDot({required this.value, required this.selected});

  @override
  Widget build(BuildContext context) {
    final p = AppTheme.palette(context);
    final size = 10.0 + (value * 8.0);
    final color = selected
        ? p.accent
        : Color.lerp(p.borderStrong, p.accent, 0.25 + value * 0.5)!;

    return SizedBox(
      width: 20,
      height: 20,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: selected ? color : color.withValues(alpha: 0.55),
            shape: BoxShape.circle,
            border: selected ? null : Border.all(color: color, width: 1.2),
          ),
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;

  const _RadioDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    final p = AppTheme.palette(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? p.accent : p.borderStrong,
          width: selected ? 6 : 1.5,
        ),
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  final bool selected;

  const _CheckBox({required this.selected});

  @override
  Widget build(BuildContext context) {
    final p = AppTheme.palette(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: selected ? p.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: selected ? p.accent : p.borderStrong,
          width: 1.5,
        ),
      ),
      child: selected
          ?  Icon(Icons.check_rounded, size: 14, color: AppTheme.palette(context).textPrimary)
          : null,
    );
  }
}
