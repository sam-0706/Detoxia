import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/event_bus/event_bus.dart';
import 'package:detoxia/core/event_bus/events.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/support_profile_repository.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/domain/tasks/task_tag.dart';
import 'package:detoxia/domain/tasks/task_utility_score.dart';
import 'package:detoxia/domain/tasks/unified_task_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Internal domain mapping for task filtering. Not shown to the user.
enum ResetDomain {
  anxiety,
  focus,
  lowMood,
  scrolling,
  sleep,
  sexualControl,
  cycle,
}

class RescueScreen extends ConsumerStatefulWidget {
  final SupportProfile? supportProfileOverride;

  const RescueScreen({super.key, this.supportProfileOverride});

  @override
  ConsumerState<RescueScreen> createState() => _RescueScreenState();
}

class _RescueScreenState extends ConsumerState<RescueScreen> {
  int _step = 0; // 0=entry, 1=intensity, 2=triggers, 3=reset, 4=outcome
  SupportProfile? _supportProfile;
  bool _loading = true;
  String? _entryCategory;
  int _intensity = 5;
  final Set<String> _selectedTriggers = {};
  List<TaskUtility> _recommended = [];
  TaskUtility? _chosenTask;
  final int _urgeEventId = -1;

  static const _entryOptions = [
    'Urge',
    'Scroll spiral',
    'Anxiety spike',
    'Focus crash',
    'Sleep drift',
    'After-slip reset',
  ];

  static const _triggerOptions = [
    'stress',
    'boredom',
    'loneliness',
    'tired',
    'phone in bed',
    'argument',
    'deadline',
    'shame',
    'random',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final override = widget.supportProfileOverride;
    if (override != null) {
      setState(() {
        _supportProfile = override;
        _loading = false;
      });
      return;
    }

    final registration = await ref.read(registrationRepositoryProvider).getProfile();
    final profile = registration == null
        ? null
        : await ref
              .read(supportProfileRepositoryProvider)
              .getLatestProfile(registration.id);
    if (!mounted) return;
    setState(() {
      _supportProfile = profile;
      _loading = false;
    });
  }

  void _loadResets() {
    // Fire UrgeReportedEvent
    final primaryTrigger = _selectedTriggers.isNotEmpty
        ? _selectedTriggers.first
        : 'unknown';
    ref.read(eventBusProvider).fire(UrgeReportedEvent(
          trigger: _mapTrigger(primaryTrigger),
          intensityBefore: _intensity,
        ));

    final profile = _supportProfile;
    if (profile != null) {
      final ranked = const UnifiedTaskEngine().selectTasks(
        profile: profile,
        now: DateTime.now(),
        count: 8,
      );
      final domain = _domainForEntry(_entryCategory);
      if (domain != null) {
        _recommended = ranked
            .where((task) => _taskFitsDomain(task, domain))
            .take(4)
            .toList();
      }
      if (_recommended.isEmpty) {
        _recommended = ranked.take(4).toList();
      }
    } else {
      _recommended = const [];
    }

    setState(() => _step = 3);
  }

  void _recordOutcome(UrgeOutcome outcome) {
    ref.read(eventBusProvider).fire(RescueCompletedEvent(
          urgeEventId: _urgeEventId,
          interventionType: _chosenTask?.task['id'] as String? ?? 'none',
          intensityAfter: outcome == UrgeOutcome.passed
              ? 1
              : outcome == UrgeOutcome.reduced
                  ? 3
                  : _intensity,
          outcome: outcome,
        ));

    // Fire SlipLoggedEvent internally for "I had a reset moment"
    // (user never sees the word "slip")
    if (outcome == UrgeOutcome.slipped) {
      final primaryTrigger = _selectedTriggers.isNotEmpty
          ? _selectedTriggers.first
          : '';
      ref.read(eventBusProvider).fire(SlipLoggedEvent(
            behaviorType: BehaviorType.scrolling,
            triggerChain: [_mapTrigger(primaryTrigger)],
            precededByScrolling:
                _mapTrigger(primaryTrigger) == TriggerType.scrolling,
          ));
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_successMessage(outcome)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Protected moment')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : switch (_step) {
                0 => _buildEntryStep(),
                1 => _buildIntensityStep(),
                2 => _buildTriggerStep(),
                3 => _buildResetStep(),
                4 => _buildOutcomeStep(),
                _ => const SizedBox(),
              },
      ),
    );
  }

  // ─── Step 0: Entry ────────────────────────────────────────────────────────

  Widget _buildEntryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What's happening right now?",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          "Pick what's closest. No wrong answer.",
          style: TextStyle(color: AppTheme.palette(context).textSecondary),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: _entryOptions.map((option) {
                final selected = option == _entryCategory;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: OutlinedButton(
                    onPressed: () => setState(() => _entryCategory = option),
                    style: OutlinedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      minimumSize: const Size(double.infinity, 52),
                      side: BorderSide(
                        color: selected ? AppTheme.palette(context).accent : AppTheme.palette(context).borderStrong,
                      ),
                    ),
                    child: Text(option),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _entryCategory == null
                ? null
                : () => setState(() => _step = 1),
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }

  // ─── Step 1: Intensity ────────────────────────────────────────────────────

  Widget _buildIntensityStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How strong is it?',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(
            _intensityLabel(_intensity),
            style: TextStyle(
              color: _intensityColor(_intensity),
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            '$_intensity / 10',
            style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 16),
          ),
        ),
        const SizedBox(height: 24),
        Slider(
          value: _intensity.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          onChanged: (v) => setState(() => _intensity = v.round()),
          activeColor: _intensityColor(_intensity),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _step = 2),
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }

  // ─── Step 2: Triggers ─────────────────────────────────────────────────────

  Widget _buildTriggerStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What might have led here?',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          "Choose any that fit. You can skip this.",
          style: TextStyle(color: AppTheme.palette(context).textSecondary),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _triggerOptions.map((trigger) {
            final selected = _selectedTriggers.contains(trigger);
            return FilterChip(
              label: Text(trigger),
              selected: selected,
              onSelected: (isSelected) {
                setState(() {
                  if (isSelected) {
                    _selectedTriggers.add(trigger);
                  } else {
                    _selectedTriggers.remove(trigger);
                  }
                });
              },
              selectedColor: AppTheme.palette(context).accent.withValues(alpha: 0.25),
              checkmarkColor: AppTheme.palette(context).accent,
              side: BorderSide(
                color: selected ? AppTheme.palette(context).accent : AppTheme.palette(context).borderStrong,
              ),
            );
          }).toList(),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _loadResets,
            child: const Text('Get support'),
          ),
        ),
      ],
    );
  }

  // ─── Step 3: Reset ────────────────────────────────────────────────────────

  Widget _buildResetStep() {
    final firstTask = _recommended.isNotEmpty ? _recommended.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Try a small reset',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          "This one fits your current pattern best.",
          style: TextStyle(color: AppTheme.palette(context).textSecondary),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (firstTask != null) ...[
                  Card(
                    color: AppTheme.palette(context).accent.withValues(alpha: 0.15),
                    child: ListTile(
                      leading: Icon(
                        _iconForTags(firstTask.tags),
                        color: AppTheme.palette(context).accent,
                      ),
                      title: Text(
                        firstTask.task['title'] as String? ?? 'Support action',
                        style:  TextStyle(color: AppTheme.palette(context).textPrimary),
                      ),
                      subtitle: Text(
                        '${firstTask.task['durationMinutes']} min · ${firstTask.whyChosen}',
                        style:  TextStyle(color: AppTheme.palette(context).textTertiary),
                      ),
                      onTap: () => _chooseTask(firstTask),
                      selected:
                          _chosenTask?.task['id'] == firstTask.task['id'],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (_recommended.length > 1)
                  ..._recommended.skip(1).map(
                    (task) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        color: _chosenTask?.task['id'] == task.task['id']
                            ? AppTheme.palette(context).accent.withValues(alpha: 0.12)
                            : null,
                        child: ListTile(
                          leading: Icon(
                            _iconForTags(task.tags),
                            color: AppTheme.palette(context).accent.withValues(alpha: 0.7),
                          ),
                          title: Text(
                            task.task['title'] as String? ?? 'Support action',
                            style:  TextStyle(color: AppTheme.palette(context).textSecondary),
                          ),
                          subtitle: Text(
                            '${task.task['durationMinutes']} min · ${task.whyChosen}',
                            style:  TextStyle(color: AppTheme.palette(context).textTertiary),
                          ),
                          onTap: () => _chooseTask(task),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _step = 4),
            child: const Text('I did it'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => setState(() => _step = 4),
            child: const Text('Skip'),
          ),
        ),
      ],
    );
  }

  // ─── Step 4: Outcome ──────────────────────────────────────────────────────

  Widget _buildOutcomeStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What happened after the reset?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 32),
          _OutcomeButton(
            icon: Icons.check_circle,
            label: 'I moved through it',
            color: AppTheme.palette(context).success,
            onTap: () => _recordOutcome(UrgeOutcome.passed),
          ),
          const SizedBox(height: 12),
          _OutcomeButton(
            icon: Icons.trending_up,
            label: 'I delayed it',
            color: AppTheme.palette(context).supportNeeded,
            onTap: () => _recordOutcome(UrgeOutcome.reduced),
          ),
          const SizedBox(height: 12),
          _OutcomeButton(
            icon: Icons.help_outline,
            label: 'I still need support',
            color: AppTheme.palette(context).warning,
            onTap: () => _recordOutcome(UrgeOutcome.same),
          ),
          const SizedBox(height: 12),
          _OutcomeButton(
            icon: Icons.refresh,
            label: 'I had a reset moment',
            color: AppTheme.palette(context).protectMoment,
            onTap: () => _recordOutcome(UrgeOutcome.slipped),
          ),
          const SizedBox(height: 12),
          _OutcomeButton(
            icon: Icons.not_interested,
            label: 'False alarm',
            color: AppTheme.palette(context).textTertiary,
            onTap: () =>
                // TODO: add a dedicated false-alarm outcome to the Outcome enum
                _recordOutcome(UrgeOutcome.same),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  void _chooseTask(TaskUtility task) {
    setState(() {
      _chosenTask = task;
    });
  }

  /// Maps entry category to ResetDomain for internal task filtering.
  /// "After-slip reset" returns null — no domain filtering, show all tasks.
  ResetDomain? _domainForEntry(String? entry) => switch (entry) {
    'Urge' => ResetDomain.sexualControl,
    'Scroll spiral' => ResetDomain.scrolling,
    'Anxiety spike' => ResetDomain.anxiety,
    'Focus crash' => ResetDomain.focus,
    'Sleep drift' => ResetDomain.sleep,
    'After-slip reset' => null,
    _ => null,
  };

  String _intensityLabel(int value) => switch (value) {
    <= 3 => 'manageable',
    <= 6 => 'building',
    <= 8 => 'needs support',
    _ => 'protect this moment',
  };

  Color _intensityColor(int value) => switch (value) {
    <= 3 => AppTheme.palette(context).success,
    <= 6 => AppTheme.palette(context).accent,
    <= 8 => AppTheme.palette(context).supportNeeded,
    _ => AppTheme.palette(context).protectMoment,
  };

  bool _taskFitsDomain(TaskUtility task, ResetDomain domain) {
    final tags = task.tags.toSet();
    return switch (domain) {
      ResetDomain.anxiety =>
        tags.contains(TaskTag.anxiety) || tags.contains(TaskTag.breathingReset),
      ResetDomain.focus =>
        tags.contains(TaskTag.focus) || tags.contains(TaskTag.focusSprint),
      ResetDomain.lowMood =>
        tags.contains(TaskTag.lowMood) || tags.contains(TaskTag.lowPressure),
      ResetDomain.scrolling =>
        tags.contains(TaskTag.scrolling) || tags.contains(TaskTag.commuteScrolling),
      ResetDomain.sleep =>
        tags.contains(TaskTag.sleep) ||
        tags.contains(TaskTag.sleepShutdown) ||
        tags.contains(TaskTag.sleepDebt) ||
        tags.contains(TaskTag.lateNightRisk),
      ResetDomain.sexualControl => tags.contains(TaskTag.sexualControl),
      ResetDomain.cycle => tags.contains(TaskTag.cycle),
    };
  }

  TriggerType _mapTrigger(String? trigger) {
    final value = (trigger ?? '').toLowerCase();
    if (value.contains('stress') || value.contains('overwhelm')) {
      return TriggerType.stress;
    }
    if (value.contains('sleep') || value.contains('night') || value.contains('tired')) {
      return TriggerType.cantSleep;
    }
    if (value.contains('scroll')) {
      return TriggerType.scrolling;
    }
    if (value.contains('lonely') || value.contains('alone') || value.contains('argument')) {
      return TriggerType.loneliness;
    }
    if (value.contains('bored')) return TriggerType.boredom;
    if (value.contains('shame')) return TriggerType.other;
    return TriggerType.other;
  }

  IconData _iconForTags(List<TaskTag> tags) {
    if (tags.contains(TaskTag.breathingReset)) return Icons.air;
    if (tags.contains(TaskTag.focus) || tags.contains(TaskTag.focusSprint)) {
      return Icons.psychology;
    }
    if (tags.contains(TaskTag.sleep) || tags.contains(TaskTag.sleepShutdown)) {
      return Icons.bedtime;
    }
    if (tags.contains(TaskTag.physicalReset)) return Icons.fitness_center;
    return Icons.task_alt;
  }

  String _successMessage(UrgeOutcome outcome) {
    if (outcome == UrgeOutcome.slipped) {
      return "Nothing is ruined. Let's understand the chain while it is still fresh.";
    }
    if (outcome == UrgeOutcome.passed) {
      return 'Saved. One protected moment at a time.';
    }
    return 'Saved locally. Your pattern is becoming clearer.';
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
