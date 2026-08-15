import 'dart:convert';

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/period/symptom_definitions.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeriodLogScreen extends ConsumerStatefulWidget {
  const PeriodLogScreen({super.key});

  @override
  ConsumerState<PeriodLogScreen> createState() => _PeriodLogScreenState();
}

class _PeriodLogScreenState extends ConsumerState<PeriodLogScreen> {
  FlowIntensity? _flow;
  final _selectedSymptoms = <String>{};
  double _mood = 5;
  double _energy = 5;
  final _notesController = TextEditingController();
  bool _saving = false;

  static const _flowLabels = {
    FlowIntensity.spotting: ('Spotting', '🔸'),
    FlowIntensity.light: ('Light', '🩸'),
    FlowIntensity.medium: ('Medium', '🩸🩸'),
    FlowIntensity.heavy: ('Heavy', '🩸🩸🩸'),
    FlowIntensity.veryHeavy: ('Very Heavy', '🩸🩸🩸🩸'),
  };

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final db = ref.read(databaseProvider);
    await db.into(db.cycleEntries).insert(CycleEntriesCompanion.insert(
          date: DateTime.now(),
          flowIntensity: Value(_flow?.index),
          symptoms: Value(jsonEncode(_selectedSymptoms.toList())),
          mood: Value(_mood.round()),
          energy: Value(_energy.round()),
          notes: Value(_notesController.text.isEmpty
              ? null
              : _notesController.text),
        ));
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Log Period Day')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          _buildFlowSelector(tt),
          const SizedBox(height: 24),
          _buildSymptomPicker(tt),
          const SizedBox(height: 24),
          _buildSlider(tt, 'Mood', _mood, (v) => setState(() => _mood = v)),
          const SizedBox(height: 16),
          _buildSlider(
              tt, 'Energy', _energy, (v) => setState(() => _energy = v)),
          const SizedBox(height: 24),
          _buildNotesField(tt),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.pinkAccent,
              ),
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Save Entry'),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildFlowSelector(TextTheme tt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Flow Intensity', style: tt.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: FlowIntensity.values.map((f) {
            final (label, icon) = _flowLabels[f]!;
            final selected = _flow == f;
            return ChoiceChip(
              label: Text('$icon $label'),
              selected: selected,
              selectedColor: AppTheme.pinkAccent.withValues(alpha: .3),
              onSelected: (_) => setState(() => _flow = selected ? null : f),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSymptomPicker(TextTheme tt) {
    final grouped = <SymptomCategory, List<SymptomDef>>{};
    for (final s in allSymptoms) {
      grouped.putIfAbsent(s.category, () => []).add(s);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Symptoms', style: tt.titleLarge),
        const SizedBox(height: 12),
        for (final cat in SymptomCategory.values) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 6),
            child: Text(
              cat.name[0].toUpperCase() + cat.name.substring(1),
              style: tt.bodyLarge?.copyWith(
                color: AppTheme.pinkAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: (grouped[cat] ?? []).map((s) {
              final on = _selectedSymptoms.contains(s.id);
              return FilterChip(
                label: Text('${s.emoji} ${s.name}'),
                selected: on,
                selectedColor: AppTheme.pinkAccent.withValues(alpha: .25),
                checkmarkColor: AppTheme.pinkAccent,
                onSelected: (_) {
                  setState(() {
                    on ? _selectedSymptoms.remove(s.id) : _selectedSymptoms.add(s.id);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildSlider(
      TextTheme tt, String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: tt.titleLarge),
            const Spacer(),
            Text('${value.round()}/10',
                style:  TextStyle(color: AppTheme.palette(context).textSecondary)),
          ],
        ),
        Slider(
          value: value,
          min: 1,
          max: 10,
          divisions: 9,
          activeColor: AppTheme.pinkAccent,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildNotesField(TextTheme tt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notes', style: tt.titleLarge),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'How are you feeling today?',
            hintStyle: TextStyle(color: AppTheme.palette(context).textTertiary),
          ),
          style:  TextStyle(color: AppTheme.palette(context).textPrimary),
        ),
      ],
    );
  }
}
