import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/presentation/onboarding/onboarding_screen.dart';
import 'package:detoxia/presentation/widgets/big_card_selector.dart';
import 'package:detoxia/presentation/widgets/choice_chip_group.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TriggersDepthPage extends ConsumerWidget {
  final VoidCallback onNext;

  const TriggersDepthPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingStateProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What pulls\nyou in?',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Select the triggers that usually start it.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          ChoiceChipGroup<TriggerType>(
            options: TriggerType.values,
            selected: state.triggers,
            labelBuilder: (t) => switch (t) {
              TriggerType.boredom => 'Boredom',
              TriggerType.stress => 'Stress',
              TriggerType.loneliness => 'Loneliness',
              TriggerType.cantSleep => "Can't sleep",
              TriggerType.scrolling => 'Scrolling',
              TriggerType.justAHabit => 'Just a habit',
              TriggerType.other => 'Other',
            },
            onToggle: (t) {
              final next = Set<TriggerType>.from(state.triggers);
              next.contains(t) ? next.remove(t) : next.add(t);
              ref
                  .read(onboardingStateProvider.notifier)
                  .update((s) => s.triggers = next);
            },
          ),

          const SizedBox(height: 32),
          Text(
            'How long has this been going on?',
            style: TextStyle(
                color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          BigCardSelector<StruggleDuration>(
            options: StruggleDuration.values,
            selected: state.struggleDuration,
            labelBuilder: (d) => switch (d) {
              StruggleDuration.lessThan6Months => 'Less than 6 months',
              StruggleDuration.sixToTwoYears => '6 months - 2 years',
              StruggleDuration.twoToFiveYears => '2 - 5 years',
              StruggleDuration.fivePlusYears => '5+ years',
            },
            onSelect: (d) {
              ref
                  .read(onboardingStateProvider.notifier)
                  .update((s) => s.struggleDuration = d);
            },
          ),

          const SizedBox(height: 24),
          Text(
            'When you try to resist, how often can you?',
            style: TextStyle(
                color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          BigCardSelector<ResistAbility>(
            options: ResistAbility.values,
            selected: state.resistAbility,
            labelBuilder: (r) => switch (r) {
              ResistAbility.rarely => 'Rarely',
              ResistAbility.sometimes => 'Sometimes',
              ResistAbility.aboutHalf => 'About half the time',
              ResistAbility.usually => 'Usually',
            },
            onSelect: (r) {
              ref
                  .read(onboardingStateProvider.notifier)
                  .update((s) => s.resistAbility = r);
            },
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.triggers.isNotEmpty &&
                      state.struggleDuration != null &&
                      state.resistAbility != null
                  ? onNext
                  : null,
              child: const Text('Continue'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
