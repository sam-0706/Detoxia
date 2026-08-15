import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/presentation/onboarding/onboarding_screen.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _ConditionOption {
  final ConditionType type;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _ConditionOption({
    required this.type,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

const _options = [
  _ConditionOption(
    type: ConditionType.detoxRecovery,
    label: 'Detox Recovery',
    subtitle: 'Overcome scrolling, porn, or masturbation habits',
    icon: Icons.shield,
    color: Color(0xFF6C63FF),
  ),
  _ConditionOption(
    type: ConditionType.anxiety,
    label: 'Anxiety',
    subtitle: 'Breathing exercises, grounding, and worry management',
    icon: Icons.air,
    color: Color(0xFF4ECDC4),
  ),
  _ConditionOption(
    type: ConditionType.depression,
    label: 'Depression',
    subtitle: 'Behavioral activation, thought records, and mood lifting',
    icon: Icons.wb_sunny_outlined,
    color: Color(0xFFFFB347),
  ),
  _ConditionOption(
    type: ConditionType.adhd,
    label: 'ADHD',
    subtitle: 'Focus timer, task management, and dopamine regulation',
    icon: Icons.psychology,
    color: Color(0xFFFF6B6B),
  ),
  _ConditionOption(
    type: ConditionType.periodTracking,
    label: 'Period Tracker',
    subtitle: 'Cycle tracking, symptom logging, and phase-based tips',
    icon: Icons.favorite,
    color: Color(0xFFFF6B9D),
  ),
  _ConditionOption(
    type: ConditionType.moodTracking,
    label: 'Mood Tracker',
    subtitle: 'Daily mood logging, patterns, and emotion awareness',
    icon: Icons.emoji_emotions,
    color: Color(0xFF9B59B6),
  ),
];

class ConditionSelectPage extends ConsumerWidget {
  final VoidCallback onNext;

  const ConditionSelectPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingStateProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What can we\nhelp with?',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Select everything that applies. You can always change this later.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          ..._options.map((opt) {
            final selected = state.conditions.contains(opt.type);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                builder: (context, value, _) {
                  return Transform.scale(
                    scale: selected ? 0.96 + value * 0.04 : 1.0,
                    child: Material(
                      color: selected
                          ? opt.color.withValues(alpha: 0.15)
                          : AppTheme.palette(context).textPrimary.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          ref
                              .read(onboardingStateProvider.notifier)
                              .update((s) {
                            final next =
                                Set<ConditionType>.from(s.conditions);
                            if (next.contains(opt.type)) {
                              next.remove(opt.type);
                            } else {
                              next.add(opt.type);
                            }
                            s.conditions = next;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected
                                  ? opt.color.withValues(alpha: 0.5)
                                  : AppTheme.palette(context).borderSubtle,
                              width: selected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutCubic,
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: opt.color.withValues(
                                      alpha: selected ? 0.3 : 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(opt.icon,
                                    color: opt.color, size: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      opt.label,
                                      style: TextStyle(
                                        color: selected
                                            ? AppTheme.palette(context).textPrimary
                                            : AppTheme.palette(context).textSecondary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      opt.subtitle,
                                      style: TextStyle(
                                          color: AppTheme.palette(context).textTertiary,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (child, anim) =>
                                    ScaleTransition(
                                        scale: anim, child: child),
                                child: selected
                                    ? Icon(Icons.check_circle,
                                        key: const ValueKey('check'),
                                        color: opt.color,
                                        size: 24)
                                    : Icon(Icons.circle_outlined,
                                        key: ValueKey('circle'),
                                        color: AppTheme.palette(context).borderStrong,
                                        size: 24),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.conditions.isNotEmpty ? onNext : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Continue'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
