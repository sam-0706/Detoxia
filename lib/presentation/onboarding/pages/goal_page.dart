import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/presentation/onboarding/onboarding_screen.dart';
import 'package:detoxia/presentation/widgets/big_card_selector.dart';
import 'package:detoxia/presentation/widgets/choice_chip_group.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalPage extends ConsumerWidget {
  final VoidCallback onComplete;

  const GoalPage({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingStateProvider);
    final hasDetox = state.conditions.contains(ConditionType.detoxRecovery);

    if (hasDetox) {
      return _DetoxGoalPage(state: state, ref: ref, onComplete: onComplete);
    }
    return _WellnessGoalPage(state: state, ref: ref, onComplete: onComplete);
  }
}

class _DetoxGoalPage extends StatelessWidget {
  final OnboardingState state;
  final WidgetRef ref;
  final VoidCallback onComplete;

  const _DetoxGoalPage({
    required this.state,
    required this.ref,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What do you\nwant?',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Your goal shapes everything we build for you.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 28),

          BigCardSelector<GoalType>(
            options: GoalType.values,
            selected: state.goalType,
            labelBuilder: (g) => switch (g) {
              GoalType.quit => 'Quit completely',
              GoalType.control => 'Get it under control',
              GoalType.reduce => 'Reduce significantly',
            },
            iconBuilder: (g) => switch (g) {
              GoalType.quit => Icons.block,
              GoalType.control => Icons.tune,
              GoalType.reduce => Icons.trending_down,
            },
            onSelect: (g) {
              ref
                  .read(onboardingStateProvider.notifier)
                  .update((s) => s.goalType = g);
            },
          ),

          const SizedBox(height: 28),
          Text(
            'This matters because...',
            style: TextStyle(
                color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ChoiceChipGroup<MotivationType>(
            options: MotivationType.values,
            selected: state.motivations,
            labelBuilder: (m) => switch (m) {
              MotivationType.health => 'Health',
              MotivationType.relationships => 'Relationships',
              MotivationType.selfRespect => 'Self-respect',
              MotivationType.productivity => 'Productivity',
              MotivationType.sleep => 'Sleep',
              MotivationType.faith => 'Faith',
              MotivationType.mentalClarity => 'Mental clarity',
              MotivationType.confidence => 'Confidence',
            },
            onToggle: (m) {
              final next = Set<MotivationType>.from(state.motivations);
              next.contains(m) ? next.remove(m) : next.add(m);
              ref
                  .read(onboardingStateProvider.notifier)
                  .update((s) => s.motivations = next);
            },
          ),

          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.goalType != null &&
                      state.motivations.isNotEmpty
                  ? onComplete
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Let's get started"),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _WellnessGoalPage extends StatelessWidget {
  final OnboardingState state;
  final WidgetRef ref;
  final VoidCallback onComplete;

  const _WellnessGoalPage({
    required this.state,
    required this.ref,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final selectedConditions = state.conditions;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "You're all set!",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            "Here's what we'll help you with based on your selections.",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 28),

          ...selectedConditions.map((c) {
            final config = _conditionSummary(c);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: config.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: config.color.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: config.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          Icon(config.icon, color: config.color, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            config.title,
                            style: TextStyle(
                              color: AppTheme.palette(context).textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            config.description,
                            style: TextStyle(
                                color: AppTheme.palette(context).textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.check_circle,
                        color: config.color, size: 22),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          Text(
            'What motivates you?',
            style: TextStyle(
                color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ChoiceChipGroup<MotivationType>(
            options: MotivationType.values,
            selected: state.motivations,
            labelBuilder: (m) => switch (m) {
              MotivationType.health => 'Health',
              MotivationType.relationships => 'Relationships',
              MotivationType.selfRespect => 'Self-respect',
              MotivationType.productivity => 'Productivity',
              MotivationType.sleep => 'Sleep',
              MotivationType.faith => 'Faith',
              MotivationType.mentalClarity => 'Mental clarity',
              MotivationType.confidence => 'Confidence',
            },
            onToggle: (m) {
              final next = Set<MotivationType>.from(state.motivations);
              next.contains(m) ? next.remove(m) : next.add(m);
              ref
                  .read(onboardingStateProvider.notifier)
                  .update((s) => s.motivations = next);
            },
          ),

          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.motivations.isNotEmpty ? onComplete : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Let's begin"),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ConditionSummaryConfig {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  const _ConditionSummaryConfig(
      this.title, this.description, this.icon, this.color);
}

_ConditionSummaryConfig _conditionSummary(ConditionType c) {
  switch (c) {
    case ConditionType.anxiety:
      return const _ConditionSummaryConfig(
        'Anxiety Support',
        '12 breathing techniques, grounding exercises, and tracking',
        Icons.air,
        Color(0xFF4ECDC4),
      );
    case ConditionType.depression:
      return const _ConditionSummaryConfig(
        'Depression Support',
        'Behavioral activation, thought records, and weekly assessments',
        Icons.wb_sunny_outlined,
        Color(0xFFFFB347),
      );
    case ConditionType.adhd:
      return const _ConditionSummaryConfig(
        'ADHD Tools',
        'Focus timer, dopamine menu, and task management',
        Icons.psychology,
        Color(0xFFFF6B6B),
      );
    case ConditionType.periodTracking:
      return const _ConditionSummaryConfig(
        'Period Tracker',
        'Cycle tracking, symptom logging, and phase-based tips',
        Icons.favorite,
        Color(0xFFFF6B9D),
      );
    case ConditionType.moodTracking:
      return const _ConditionSummaryConfig(
        'Mood Tracker',
        'Daily mood logging, emotion library, and pattern insights',
        Icons.emoji_emotions,
        Color(0xFF9B59B6),
      );
    case ConditionType.detoxRecovery:
      return const _ConditionSummaryConfig(
        'Detox Recovery',
        'Direction insights, support timeline, and 12-week program',
        Icons.shield,
        Color(0xFF6C63FF),
      );
  }
}
