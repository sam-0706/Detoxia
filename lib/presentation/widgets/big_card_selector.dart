import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BigCardSelector<T> extends StatelessWidget {
  final List<T> options;
  final T? selected;
  final String Function(T) labelBuilder;
  final IconData Function(T)? iconBuilder;
  final ValueChanged<T> onSelect;

  const BigCardSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.labelBuilder,
    this.iconBuilder,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        final isSelected = selected == option;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: isSelected ? AppTheme.accent : AppTheme.card,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () => onSelect(option),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 18),
                child: Row(
                  children: [
                    if (iconBuilder != null) ...[
                      Icon(
                        iconBuilder!(option),
                        color: isSelected
                            ? Colors.white
                            : Colors.white70,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      child: Text(
                        labelBuilder(option),
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected
                              ? Colors.white
                              : Colors.white70,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle,
                          color: Colors.white, size: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
