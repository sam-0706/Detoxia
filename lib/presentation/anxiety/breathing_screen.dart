import 'dart:async';

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/anxiety/anxiety_toolkit.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BreathingScreen extends ConsumerStatefulWidget {
  final BreathingTechnique? initialTechnique;

  const BreathingScreen({super.key, this.initialTechnique});

  @override
  ConsumerState<BreathingScreen> createState() => _BreathingScreenState();
}

enum _SessionPhase { setup, active, complete }

class _BreathingScreenState extends ConsumerState<BreathingScreen>
    with TickerProviderStateMixin {
  late BreathingTechniqueData _selected;
  _SessionPhase _phase = _SessionPhase.setup;
  int _anxietyBefore = 5;
  int _anxietyAfter = 5;

  // Animation
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  // Session tracking
  int _currentStepIndex = 0;
  int _cyclesCompleted = 0;
  int _totalSecondsRemaining = 0;
  int _stepSecondsRemaining = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _selected = breathingTechniques.firstWhere(
      (t) => t.id == (widget.initialTechnique ?? BreathingTechnique.boxBreathing),
      orElse: () => breathingTechniques.first,
    );
    _totalSecondsRemaining = _selected.totalDurationSeconds;

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _breathAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathController.dispose();
    super.dispose();
  }

  void _startSession() {
    setState(() {
      _phase = _SessionPhase.active;
      _currentStepIndex = 0;
      _cyclesCompleted = 0;
      _totalSecondsRemaining = _selected.totalDurationSeconds;
    });
    _startStep();
  }

  void _startStep() {
    final step = _selected.steps[_currentStepIndex];
    _stepSecondsRemaining = step.seconds;

    _breathController.duration = Duration(seconds: step.seconds);

    switch (step.action) {
      case 'inhale':
        _breathController.forward(from: _breathController.value);
      case 'exhale':
        _breathController.reverse(from: _breathController.value);
      case 'hold':
        // Stay still
        break;
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _onTick(Timer timer) {
    if (!mounted) {
      timer.cancel();
      return;
    }

    setState(() {
      _stepSecondsRemaining--;
      _totalSecondsRemaining--;
    });

    if (_totalSecondsRemaining <= 0) {
      timer.cancel();
      _breathController.stop();
      setState(() => _phase = _SessionPhase.complete);
      return;
    }

    if (_stepSecondsRemaining <= 0) {
      _currentStepIndex++;
      if (_currentStepIndex >= _selected.steps.length) {
        _currentStepIndex = 0;
        _cyclesCompleted++;
      }
      _startStep();
    }
  }

  Future<void> _saveAndFinish() async {
    final db = ref.read(databaseProvider);
    await db.into(db.breathingLogs).insert(BreathingLogsCompanion.insert(
          timestamp: DateTime.now(),
          technique: _selected.id.name,
          durationSeconds: _selected.totalDurationSeconds,
          anxietyBefore: Value(_anxietyBefore),
          anxietyAfter: Value(_anxietyAfter),
        ));

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Breathing Guide')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: switch (_phase) {
          _SessionPhase.setup => _buildSetup(),
          _SessionPhase.active => _buildActive(),
          _SessionPhase.complete => _buildComplete(),
        },
      ),
    );
  }

  Widget _buildSetup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose a technique',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.palette(context).surfaceRaised,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<BreathingTechnique>(
            value: _selected.id,
            isExpanded: true,
            dropdownColor: AppTheme.palette(context).surfaceRaised,
            underline: const SizedBox.shrink(),
            style:  TextStyle(color: AppTheme.palette(context).textPrimary, fontSize: 15),
            items: breathingTechniques.map((t) {
              return DropdownMenuItem(
                value: t.id,
                child: Text(t.name),
              );
            }).toList(),
            onChanged: (v) {
              if (v == null) return;
              setState(() {
                _selected =
                    breathingTechniques.firstWhere((t) => t.id == v);
                _totalSecondsRemaining = _selected.totalDurationSeconds;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_selected.name,
                    style: TextStyle(
                        color: AppTheme.palette(context).textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16)),
                const SizedBox(height: 6),
                Text(_selected.description,
                    style: TextStyle(
                        color: AppTheme.palette(context).textSecondary, fontSize: 14, height: 1.4)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _InfoChip(
                      label:
                          '${_selected.totalDurationSeconds ~/ 60} min',
                      icon: Icons.timer,
                    ),
                    const SizedBox(width: 8),
                    _InfoChip(
                      label: _selected.difficulty,
                      icon: Icons.fitness_center,
                    ),
                    const SizedBox(width: 8),
                    _InfoChip(
                      label: _selected.steps
                          .map((s) => '${s.seconds}s')
                          .join('-'),
                      icon: Icons.air,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('How anxious are you right now?',
            style: TextStyle(color: AppTheme.palette(context).textSecondary)),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text('Calm', style: TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 12)),
            Text('$_anxietyBefore / 10',
                style: TextStyle(
                    color: _anxietyColor(_anxietyBefore),
                    fontWeight: FontWeight.w600)),
             Text('Severe', style: TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 12)),
          ],
        ),
        Slider(
          value: _anxietyBefore.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          activeColor: _anxietyColor(_anxietyBefore),
          onChanged: (v) => setState(() => _anxietyBefore = v.round()),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _startSession,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Begin'),
          ),
        ),
      ],
    );
  }

  Widget _buildActive() {
    final step = _selected.steps[_currentStepIndex];
    final phaseLabel = switch (step.action) {
      'inhale' => 'Breathe in...',
      'hold' => 'Hold...',
      'exhale' => 'Breathe out...',
      _ => '',
    };
    final phaseColor = switch (step.action) {
      'inhale' => AppTheme.palette(context).accent,
      'hold' => AppTheme.palette(context).warning,
      'exhale' => AppTheme.palette(context).success,
      _ => AppTheme.palette(context).textPrimary,
    };

    final minutes = _totalSecondsRemaining ~/ 60;
    final seconds = _totalSecondsRemaining % 60;

    return Column(
      children: [
        Text(
          '$minutes:${seconds.toString().padLeft(2, '0')}',
          style: TextStyle(
              color: AppTheme.palette(context).textTertiary, fontSize: 16, fontFamily: 'monospace'),
        ),
        const SizedBox(height: 8),
        Text(
          'Cycle ${_cyclesCompleted + 1}',
          style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 13),
        ),
        const Spacer(),
        AnimatedBuilder(
          animation: _breathAnimation,
          builder: (context, child) {
            final size = 120 + (_breathAnimation.value * 80);
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    phaseColor.withValues(alpha: 0.4),
                    phaseColor.withValues(alpha: 0.1),
                  ],
                ),
                border: Border.all(
                  color: phaseColor.withValues(alpha: 0.6),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: phaseColor.withValues(alpha: 0.2),
                    blurRadius: size * 0.3,
                    spreadRadius: size * 0.05,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$_stepSecondsRemaining',
                  style: TextStyle(
                    color: phaseColor,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            phaseLabel,
            key: ValueKey(step.action + _currentStepIndex.toString()),
            style: TextStyle(
              color: phaseColor,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            _timer?.cancel();
            _breathController.stop();
            setState(() => _phase = _SessionPhase.complete);
          },
          child: Text('End early',
              style: TextStyle(color: AppTheme.palette(context).textTertiary)),
        ),
      ],
    );
  }

  Widget _buildComplete() {
    final drop = _anxietyBefore - _anxietyAfter;

    return Column(
      children: [
        const Spacer(),
        Icon(Icons.check_circle,
            color: AppTheme.palette(context).success, size: 64),
        const SizedBox(height: 16),
        Text(
          'Session complete',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          '${_cyclesCompleted + 1} cycles of ${_selected.name}',
          style:  TextStyle(color: AppTheme.palette(context).textSecondary),
        ),
        const SizedBox(height: 32),
        Text('How anxious do you feel now?',
            style: TextStyle(color: AppTheme.palette(context).textSecondary)),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text('Calm', style: TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 12)),
            Text('$_anxietyAfter / 10',
                style: TextStyle(
                    color: _anxietyColor(_anxietyAfter),
                    fontWeight: FontWeight.w600)),
             Text('Severe', style: TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 12)),
          ],
        ),
        Slider(
          value: _anxietyAfter.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          activeColor: _anxietyColor(_anxietyAfter),
          onChanged: (v) => setState(() => _anxietyAfter = v.round()),
        ),
        if (drop > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.palette(context).success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Anxiety reduced by $drop ${drop == 1 ? 'point' : 'points'}',
                style: TextStyle(
                    color: AppTheme.palette(context).success, fontWeight: FontWeight.w600),
              ),
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
          child: Text('Discard',
              style: TextStyle(color: AppTheme.palette(context).textTertiary)),
        ),
      ],
    );
  }

  Color _anxietyColor(int level) {
    if (level <= 3) return AppTheme.palette(context).success;
    if (level <= 6) return AppTheme.palette(context).warning;
    return AppTheme.palette(context).danger;
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.palette(context).textPrimary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.palette(context).textTertiary, size: 14),
          const SizedBox(width: 4),
          Text(label,
              style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}
