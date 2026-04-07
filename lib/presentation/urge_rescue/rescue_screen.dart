import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/event_bus/event_bus.dart';
import 'package:detoxia/core/event_bus/events.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/diversion/task_pool.dart';
import 'package:detoxia/domain/diversion/task_selector.dart';
import 'package:detoxia/presentation/widgets/choice_chip_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RescueScreen extends ConsumerStatefulWidget {
  const RescueScreen({super.key});

  @override
  ConsumerState<RescueScreen> createState() => _RescueScreenState();
}

class _RescueScreenState extends ConsumerState<RescueScreen> {
  int _step = 0; // 0=context, 1=tasks, 2=outcome
  TriggerType? _trigger;
  int _intensity = 5;
  List<DiversionTask> _recommended = [];
  String? _chosenTask;
  final int _urgeEventId = -1;

  late final TaskSelector _taskSelector;

  @override
  void initState() {
    super.initState();
    _taskSelector = TaskSelector(TaskPool.getDefaultTasks());
  }

  void _startRescue() {
    if (_trigger == null) return;

    final event = UrgeReportedEvent(
      trigger: _trigger!,
      intensityBefore: _intensity,
    );
    ref.read(eventBusProvider).fire(event);

    final now = DateTime.now();
    _recommended = _taskSelector.recommend(
      urgeIntensity: _intensity,
      hourOfDay: now.hour,
      location: null,
    );

    setState(() => _step = 1);
  }

  void _chooseTask(DiversionTask task) {
    setState(() {
      _chosenTask = task.name;
    });
  }

  void _recordOutcome(UrgeOutcome outcome) {
    if (_chosenTask != null) {
      _taskSelector.recordUsage(
        _chosenTask!,
        succeeded: outcome == UrgeOutcome.passed ||
            outcome == UrgeOutcome.reduced,
      );
    }

    final event = RescueCompletedEvent(
      urgeEventId: _urgeEventId,
      interventionType: _chosenTask ?? 'none',
      intensityAfter: outcome == UrgeOutcome.passed
          ? 1
          : outcome == UrgeOutcome.reduced
              ? 3
              : _intensity,
      outcome: outcome,
    );
    ref.read(eventBusProvider).fire(event);

    if (outcome == UrgeOutcome.slipped) {
      ref.read(eventBusProvider).fire(SlipLoggedEvent(
            behaviorType: BehaviorType.combined,
            triggerChain: [_trigger ?? TriggerType.other],
            precededByScrolling:
                _trigger == TriggerType.scrolling,
          ));
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(outcome == UrgeOutcome.passed
          ? 'You did it! Urge passed.'
          : outcome == UrgeOutcome.reduced
              ? 'Urge reduced. Stay strong.'
              : "It's okay. Reset and move forward."),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Urge Rescue')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: switch (_step) {
          0 => _buildContextStep(),
          1 => _buildTaskStep(),
          2 => _buildOutcomeStep(),
          _ => const SizedBox(),
        },
      ),
    );
  }

  Widget _buildContextStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What's triggering this?",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        ChoiceChipGroup<TriggerType>(
          options: TriggerType.values,
          selected: _trigger != null ? {_trigger!} : {},
          multiSelect: false,
          labelBuilder: (t) => t.name,
          onToggle: (t) => setState(() => _trigger = t),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('How strong?',
                style: TextStyle(color: Colors.white70)),
            Text(
              switch (_intensity) {
                <= 3 => 'Mild',
                <= 6 => 'Moderate',
                _ => 'Intense',
              },
              style: TextStyle(
                color: _intensity <= 3
                    ? AppTheme.success
                    : _intensity <= 6
                        ? AppTheme.warning
                        : AppTheme.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Slider(
          value: _intensity.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          onChanged: (v) => setState(() => _intensity = v.round()),
          activeColor: AppTheme.accent,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _trigger != null ? _startRescue : null,
            child: const Text('Get help'),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Try one of these',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        const Text(
          'Pick a task and do it right now.',
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 24),
        ..._recommended.map((task) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                color: _chosenTask == task.name
                    ? AppTheme.accent.withValues(alpha: 0.2)
                    : null,
                child: ListTile(
                  leading: Icon(
                    _iconForCategory(task.category),
                    color: AppTheme.accent,
                  ),
                  title: Text(task.name,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    '${task.minDurationSeconds ~/ 60}-'
                    '${task.maxDurationSeconds ~/ 60} min',
                    style: const TextStyle(color: Colors.white38),
                  ),
                  trailing: task.timesUsed >= 3
                      ? Text(
                          '${(task.effectivenessRate * 100).round()}%',
                          style: TextStyle(
                              color: AppTheme.success, fontSize: 13),
                        )
                      : null,
                  onTap: () => _chooseTask(task),
                ),
              ),
            )),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _step = 2),
            child: const Text('Done with task'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => setState(() => _step = 2),
            child: const Text('Skip'),
          ),
        ),
      ],
    );
  }

  Widget _buildOutcomeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How did it go?',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 32),
        _OutcomeButton(
          icon: Icons.check_circle,
          label: 'Urge passed',
          color: AppTheme.success,
          onTap: () => _recordOutcome(UrgeOutcome.passed),
        ),
        const SizedBox(height: 12),
        _OutcomeButton(
          icon: Icons.trending_down,
          label: 'Reduced but still there',
          color: AppTheme.warning,
          onTap: () => _recordOutcome(UrgeOutcome.reduced),
        ),
        const SizedBox(height: 12),
        _OutcomeButton(
          icon: Icons.remove_circle_outline,
          label: 'No change',
          color: Colors.white54,
          onTap: () => _recordOutcome(UrgeOutcome.same),
        ),
        const SizedBox(height: 12),
        _OutcomeButton(
          icon: Icons.replay,
          label: 'I slipped',
          color: AppTheme.danger,
          onTap: () => _recordOutcome(UrgeOutcome.slipped),
        ),
      ],
    );
  }

  IconData _iconForCategory(TaskCategory cat) {
    return switch (cat) {
      TaskCategory.physical => Icons.fitness_center,
      TaskCategory.breathing => Icons.air,
      TaskCategory.cognitive => Icons.psychology,
      TaskCategory.environmental => Icons.door_front_door,
      TaskCategory.productive => Icons.task_alt,
      TaskCategory.social => Icons.people,
      TaskCategory.valuesAnchor => Icons.favorite,
    };
  }
}

class _OutcomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OutcomeButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 16),
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
