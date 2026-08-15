import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CycleSymptomPicker extends StatelessWidget {
  final Set<String> selectedSymptoms;
  final ValueChanged<Set<String>> onChanged;

  const CycleSymptomPicker({
    super.key,
    required this.selectedSymptoms,
    required this.onChanged,
  });

  static const symptoms = <({String id, String label})>[
    (id: 'crampsPain', label: 'Cramps / pain'),
    (id: 'lowMood', label: 'Low mood'),
    (id: 'anxiety', label: 'Anxiety'),
    (id: 'fatigue', label: 'Fatigue'),
    (id: 'sleepIssue', label: 'Sleep issue'),
    (id: 'cravingsUrges', label: 'Cravings / urges'),
    (id: 'none', label: 'None'),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cycle context today',
              style: TextStyle(
                color: AppTheme.palette(context).textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Select any symptoms that shaped today.',
              style: TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.35),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: symptoms.map((symptom) {
                final selected = selectedSymptoms.contains(symptom.id);
                return FilterChip(
                  label: Text(symptom.label),
                  selected: selected,
                  onSelected: (_) => _toggle(symptom.id),
                  selectedColor: AppTheme.pinkAccent.withValues(alpha: 0.24),
                  checkmarkColor: AppTheme.pinkAccent,
                  backgroundColor: AppTheme.palette(context).textPrimary.withValues(alpha: 0.06),
                  labelStyle: TextStyle(
                    color: selected ? AppTheme.palette(context).textPrimary : AppTheme.palette(context).textSecondary,
                  ),
                  side: BorderSide(
                    color: selected
                        ? AppTheme.pinkAccent.withValues(alpha: 0.5)
                        : AppTheme.palette(context).borderSubtle,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _toggle(String id) {
    final next = Set<String>.from(selectedSymptoms);
    if (id == 'none') {
      onChanged(next.contains('none') ? <String>{} : <String>{'none'});
      return;
    }

    next.remove('none');
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    onChanged(next);
  }
}
