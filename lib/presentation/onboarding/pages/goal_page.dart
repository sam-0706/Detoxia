import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/presentation/onboarding/onboarding_screen.dart';
import 'package:detoxia/presentation/widgets/big_card_selector.dart';
import 'package:detoxia/presentation/widgets/choice_chip_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalPage extends ConsumerWidget {
  final VoidCallback onComplete;

  const GoalPage({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingStateProvider);

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
          const Text(
            'This matters because...',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
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
              child: const Text("See my risk map"),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
