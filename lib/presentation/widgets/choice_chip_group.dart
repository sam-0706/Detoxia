import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ChoiceChipGroup<T> extends StatelessWidget {
  final List<T> options;
  final Set<T> selected;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onToggle;
  final bool multiSelect;

  const ChoiceChipGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.labelBuilder,
    required this.onToggle,
    this.multiSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selected.contains(option);
        return FilterChip(
          label: Text(
            labelBuilder(option),
            style: TextStyle(
              color: isSelected ? AppTheme.palette(context).textPrimary : AppTheme.palette(context).textSecondary,
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          onSelected: (_) => onToggle(option),
          backgroundColor: AppTheme.palette(context).surfaceRaised,
          selectedColor: AppTheme.palette(context).accent,
          checkmarkColor: AppTheme.palette(context).textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }).toList(),
    );
  }
}
