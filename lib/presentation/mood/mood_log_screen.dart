import 'dart:convert';

import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/mood/emotion_library.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _moodFaces = ['😵', '😣', '😢', '😞', '😕', '😐', '🙂', '😊', '😁', '🤩'];

const _activityTags = [
  'Exercise',
  'Work',
  'Social',
  'Nature',
  'Creative',
  'Rest',
  'Screen time',
  'Eating',
];

class MoodLogScreen extends ConsumerStatefulWidget {
  const MoodLogScreen({super.key});

  @override
  ConsumerState<MoodLogScreen> createState() => _MoodLogScreenState();
}

class _MoodLogScreenState extends ConsumerState<MoodLogScreen> {
  double _mood = 5;
  double _energy = 5;
  final _selectedEmotions = <String>{};
  final _selectedActivities = <String>{};
  final _noteController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final db = ref.read(databaseProvider);
    await db.into(db.moodEntries).insert(MoodEntriesCompanion.insert(
          timestamp: DateTime.now(),
          moodLevel: _mood.round(),
          energy: _energy.round(),
          emotions: Value(jsonEncode(_selectedEmotions.toList())),
          activities: Value(jsonEncode(_selectedActivities.toList())),
          note: Value(_noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim()),
        ));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mood logged')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Your Mood')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMoodSlider(),
            const SizedBox(height: 28),
            _buildEnergySlider(),
            const SizedBox(height: 28),
            _buildEmotionPicker(),
            const SizedBox(height: 28),
            _buildActivityPicker(),
            const SizedBox(height: 28),
            _buildNoteField(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ─── Mood Slider ───

  Widget _buildMoodSlider() {
    final idx = (_mood.round() - 1).clamp(0, 9);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Mood',
                style: TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Text(_moodFaces[idx], style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 4),
            Text('${_mood.round()}/10',
                style: const TextStyle(color: Colors.white70)),
            Slider(
              value: _mood,
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: AppTheme.accent,
              onChanged: (v) => setState(() => _mood = v),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_moodFaces.first,
                    style: const TextStyle(fontSize: 20)),
                Text(_moodFaces.last,
                    style: const TextStyle(fontSize: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Energy Slider ───

  Widget _buildEnergySlider() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Energy',
                style: TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('${_energy.round()}/10',
                style: const TextStyle(color: Colors.white70)),
            Slider(
              value: _energy,
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: AppTheme.success,
              onChanged: (v) => setState(() => _energy = v),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('🔋', style: TextStyle(fontSize: 18)),
                Text('⚡', style: TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Emotion Multi-Select ───

  Widget _buildEmotionPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('How do you feel?',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        for (final cat in EmotionCategory.values) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(categoryLabel(cat),
                style: const TextStyle(color: Colors.white54, fontSize: 13)),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: emotionsByCategory(cat).map((e) {
              final selected = _selectedEmotions.contains(e.name);
              return FilterChip(
                label: Text('${e.emoji} ${e.name}'),
                selected: selected,
                selectedColor: AppTheme.accent.withValues(alpha: .25),
                checkmarkColor: AppTheme.accent,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.white70,
                  fontSize: 13,
                ),
                backgroundColor: AppTheme.surface,
                onSelected: (v) {
                  setState(() {
                    v ? _selectedEmotions.add(e.name)
                      : _selectedEmotions.remove(e.name);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  // ─── Activity Tags ───

  Widget _buildActivityPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Activities',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: _activityTags.map((tag) {
            final selected = _selectedActivities.contains(tag);
            return FilterChip(
              label: Text(tag),
              selected: selected,
              selectedColor: AppTheme.success.withValues(alpha: .25),
              checkmarkColor: AppTheme.success,
              labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontSize: 13,
              ),
              backgroundColor: AppTheme.surface,
              onSelected: (v) {
                setState(() {
                  v ? _selectedActivities.add(tag)
                    : _selectedActivities.remove(tag);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─── Note ───

  Widget _buildNoteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Note (optional)',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: _noteController,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Anything on your mind...',
            hintStyle: TextStyle(color: Colors.white38),
          ),
        ),
      ],
    );
  }
}
