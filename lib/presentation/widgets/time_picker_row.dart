import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TimePickerRow extends StatelessWidget {
  final String label;
  final TimeOfDay value;
  final ValueChanged<TimeOfDay> onChanged;

  const TimePickerRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: value,
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: AppTheme.surface,
              ),
            ),
            child: child!,
          ),
        );
        if (picked != null) onChanged(picked);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70)),
            Text(
              value.format(context),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
