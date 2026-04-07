import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/event_bus/event_bus.dart';
import 'package:detoxia/core/event_bus/events.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/presentation/urge_rescue/rescue_screen.dart';
import 'package:detoxia/presentation/widgets/choice_chip_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdHocSheet extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const AdHocSheet({super.key, required this.onComplete});

  @override
  ConsumerState<AdHocSheet> createState() => _AdHocSheetState();
}

class _AdHocSheetState extends ConsumerState<AdHocSheet> {
  bool _isSlipReport = false;

  // Slip fields
  BehaviorType? _behaviorType;
  Set<TriggerType> _triggerChain = {};
  bool _precededByScrolling = false;
  final _reflectionController = TextEditingController();
  String _when = 'just_now';

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  void _submitSlip() {
    if (_behaviorType == null) return;

    ref.read(eventBusProvider).fire(SlipLoggedEvent(
          behaviorType: _behaviorType!,
          triggerChain: _triggerChain.toList(),
          precededByScrolling: _precededByScrolling,
          reflectionNote: _reflectionController.text.isNotEmpty
              ? _reflectionController.text
              : null,
          source: _when == 'just_now'
              ? EventSource.realtime
              : EventSource.backfill,
        ));

    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              if (!_isSlipReport) ...[
                // Choice: urge or slip
                Text('What happened?',
                    style:
                        Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),
                _ActionButton(
                  icon: Icons.flash_on,
                  label: "I'm having an urge RIGHT NOW",
                  color: AppTheme.warning,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RescueScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ActionButton(
                  icon: Icons.replay,
                  label: 'I had a setback',
                  color: AppTheme.danger,
                  onTap: () =>
                      setState(() => _isSlipReport = true),
                ),
              ] else ...[
                // Slip report flow
                Text('Log a setback',
                    style:
                        Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                const Text(
                  'One setback does not erase your progress. What matters is what you do next.',
                  style: TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 20),

                const Text('When?',
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                ChoiceChipGroup<String>(
                  options: const [
                    'just_now',
                    'earlier_today',
                    'yesterday'
                  ],
                  selected: {_when},
                  multiSelect: false,
                  labelBuilder: (w) => switch (w) {
                    'just_now' => 'Just now',
                    'earlier_today' => 'Earlier today',
                    'yesterday' => 'Yesterday',
                    _ => w,
                  },
                  onToggle: (w) => setState(() => _when = w),
                ),

                const SizedBox(height: 16),
                const Text('What happened?',
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                ChoiceChipGroup<BehaviorType>(
                  options: BehaviorType.values,
                  selected:
                      _behaviorType != null ? {_behaviorType!} : {},
                  multiSelect: false,
                  labelBuilder: (b) => switch (b) {
                    BehaviorType.scrolling => 'Scrolling binge',
                    BehaviorType.porn => 'Watched pornography',
                    BehaviorType.masturbation => 'Masturbated',
                    BehaviorType.combined => 'Combined',
                  },
                  onToggle: (b) =>
                      setState(() => _behaviorType = b),
                ),

                const SizedBox(height: 16),
                const Text('What triggered it?',
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                ChoiceChipGroup<TriggerType>(
                  options: TriggerType.values,
                  selected: _triggerChain,
                  labelBuilder: (t) => t.name,
                  onToggle: (t) {
                    final s = Set<TriggerType>.from(_triggerChain);
                    s.contains(t) ? s.remove(t) : s.add(t);
                    setState(() => _triggerChain = s);
                  },
                ),

                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Were you scrolling before?',
                      style: TextStyle(color: Colors.white70)),
                  value: _precededByScrolling,
                  onChanged: (v) =>
                      setState(() => _precededByScrolling = v),
                  activeTrackColor: AppTheme.accent,
                  contentPadding: EdgeInsets.zero,
                ),

                const SizedBox(height: 12),
                TextField(
                  controller: _reflectionController,
                  maxLength: 140,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText:
                        'What could you do differently next time?',
                    hintStyle: TextStyle(color: Colors.white38),
                  ),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _behaviorType != null ? _submitSlip : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16),
                    ),
                    child: const Text('Log & move forward'),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
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
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
