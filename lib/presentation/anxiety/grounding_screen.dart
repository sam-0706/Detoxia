import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/anxiety/grounding_exercises.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroundingScreen extends ConsumerStatefulWidget {
  final GroundingExercise? initialExercise;

  const GroundingScreen({super.key, this.initialExercise});

  @override
  ConsumerState<GroundingScreen> createState() => _GroundingScreenState();
}

enum _GroundingPhase { select, active, complete }

class _GroundingScreenState extends ConsumerState<GroundingScreen> {
  late GroundingExerciseData _selected;
  _GroundingPhase _phase = _GroundingPhase.select;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _selected = groundingExercises.firstWhere(
      (e) => e.id == (widget.initialExercise ?? GroundingExercise.sensory54321),
      orElse: () => groundingExercises.first,
    );
    if (widget.initialExercise != null) {
      _phase = _GroundingPhase.active;
    }
  }

  void _beginExercise() {
    setState(() {
      _currentStep = 0;
      _phase = _GroundingPhase.active;
    });
  }

  void _nextStep() {
    if (_currentStep < _selected.steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      setState(() => _phase = _GroundingPhase.complete);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _saveAndFinish() async {
    final db = ref.read(databaseProvider);
    await db.into(db.anxietyEvents).insert(AnxietyEventsCompanion.insert(
          timestamp: DateTime.now(),
          anxietyLevel: 0,
          copingUsed: Value(_selected.id.name),
        ));

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grounding Exercise')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: switch (_phase) {
          _GroundingPhase.select => _buildSelect(),
          _GroundingPhase.active => _buildActive(),
          _GroundingPhase.complete => _buildComplete(),
        },
      ),
    );
  }

  Widget _buildSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose an exercise',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: groundingExercises.length,
            itemBuilder: (context, index) {
              final ex = groundingExercises[index];
              final isSelected = ex.id == _selected.id;
              return Card(
                color: isSelected
                    ? AppTheme.accent.withValues(alpha: 0.15)
                    : null,
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppTheme.accent.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.06),
                    ),
                    child: Icon(
                      Icons.self_improvement,
                      color: isSelected ? AppTheme.accent : Colors.white38,
                      size: 20,
                    ),
                  ),
                  title: Text(ex.name,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    '${ex.durationMinutes} min · ${ex.steps.length} steps',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: AppTheme.accent)
                      : null,
                  onTap: () => setState(() => _selected = ex),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              _selected.description,
              style: const TextStyle(
                  color: Colors.white60, fontSize: 14, height: 1.4),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _beginExercise,
            icon: const Icon(Icons.play_arrow),
            label: Text('Start ${_selected.name}'),
          ),
        ),
      ],
    );
  }

  Widget _buildActive() {
    final step = _selected.steps[_currentStep];
    final progress = (_currentStep + 1) / _selected.steps.length;

    return Column(
      children: [
        Row(
          children: [
            Text(
              'Step ${_currentStep + 1} of ${_selected.steps.length}',
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const Spacer(),
            Text(
              _selected.name,
              style: const TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation(AppTheme.accent),
            minHeight: 6,
          ),
        ),
        const Spacer(),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Padding(
            key: ValueKey(_currentStep),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              step,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Spacer(),
        Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Back',
                      style: TextStyle(color: Colors.white70)),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  _currentStep < _selected.steps.length - 1
                      ? 'Next'
                      : 'Finish',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child:
              const Text('Exit', style: TextStyle(color: Colors.white38)),
        ),
      ],
    );
  }

  Widget _buildComplete() {
    return Column(
      children: [
        const Spacer(),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.success.withValues(alpha: 0.15),
          ),
          child: Icon(Icons.check, color: AppTheme.success, size: 48),
        ),
        const SizedBox(height: 24),
        Text(
          'Well done!',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'You completed ${_selected.name}',
          style: const TextStyle(color: Colors.white54, fontSize: 15),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.success.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            'Grounding exercises work best when practised regularly. '
            'Your nervous system learns to calm down faster each time.',
            style: TextStyle(color: Colors.white60, fontSize: 14, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveAndFinish,
            child: const Text('Save & finish'),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Discard',
              style: TextStyle(color: Colors.white38)),
        ),
      ],
    );
  }
}
