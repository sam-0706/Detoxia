import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/presentation/onboarding/onboarding_screen.dart';
import 'package:detoxia/presentation/widgets/big_card_selector.dart';
import 'package:detoxia/presentation/widgets/time_picker_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LifeStructurePage extends ConsumerWidget {
  final VoidCallback onNext;

  const LifeStructurePage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingStateProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's understand\nyour day",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'This helps us map your routine and find patterns.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 28),

          // Role selection
          const Text('I am a...',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          BigCardSelector<RoleType>(
            options: RoleType.values,
            selected: state.roleType,
            labelBuilder: (r) => switch (r) {
              RoleType.student => 'Student',
              RoleType.working => 'Working professional',
              RoleType.freelancer => 'Freelancer',
              RoleType.notWorking => 'Not currently working',
            },
            iconBuilder: (r) => switch (r) {
              RoleType.student => Icons.school,
              RoleType.working => Icons.work,
              RoleType.freelancer => Icons.laptop_mac,
              RoleType.notWorking => Icons.home,
            },
            onSelect: (role) {
              ref
                  .read(onboardingStateProvider.notifier)
                  .update((s) => s.roleType = role);
            },
          ),

          // Work days (only if working/student)
          if (state.roleType == RoleType.working ||
              state.roleType == RoleType.student) ...[
            const SizedBox(height: 20),
            const Text('My work/study days',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _DayToggleRow(
              selected: state.workDays,
              onChanged: (days) {
                ref
                    .read(onboardingStateProvider.notifier)
                    .update((s) => s.workDays = days);
              },
            ),

            const SizedBox(height: 20),
            const Text('Work/study hours',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TimePickerRow(
                    label: 'From',
                    value: state.workStart ??
                        const TimeOfDay(hour: 10, minute: 0),
                    onChanged: (t) {
                      ref
                          .read(onboardingStateProvider.notifier)
                          .update((s) => s.workStart = t);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TimePickerRow(
                    label: 'To',
                    value: state.workEnd ??
                        const TimeOfDay(hour: 18, minute: 0),
                    onChanged: (t) {
                      ref
                          .read(onboardingStateProvider.notifier)
                          .update((s) => s.workEnd = t);
                    },
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 24),
          const Text('Your typical day',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TimePickerRow(
            label: 'Wake up around',
            value: state.weekdayWake,
            onChanged: (t) {
              ref
                  .read(onboardingStateProvider.notifier)
                  .update((s) => s.weekdayWake = t);
            },
          ),
          const SizedBox(height: 8),
          TimePickerRow(
            label: 'Sleep around',
            value: state.weekdaySleep,
            onChanged: (t) {
              ref
                  .read(onboardingStateProvider.notifier)
                  .update((s) => s.weekdaySleep = t);
            },
          ),

          // Off-day schedule
          if (state.roleType != null &&
              state.roleType != RoleType.notWorking) ...[
            const SizedBox(height: 20),
            const Text('What about your off days?',
                style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            TimePickerRow(
              label: 'Wake up (off days)',
              value: state.offdayWake,
              onChanged: (t) {
                ref
                    .read(onboardingStateProvider.notifier)
                    .update((s) => s.offdayWake = t);
              },
            ),
            const SizedBox(height: 8),
            TimePickerRow(
              label: 'Sleep (off days)',
              value: state.offdaySleep,
              onChanged: (t) {
                ref
                    .read(onboardingStateProvider.notifier)
                    .update((s) => s.offdaySleep = t);
              },
            ),
          ],

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.roleType != null ? onNext : null,
              child: const Text('Continue'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _DayToggleRow extends StatelessWidget {
  final Set<int> selected;
  final ValueChanged<Set<int>> onChanged;

  const _DayToggleRow({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final day = i + 1;
        final isOn = selected.contains(day);
        return GestureDetector(
          onTap: () {
            final newSet = Set<int>.from(selected);
            if (isOn) {
              newSet.remove(day);
            } else {
              newSet.add(day);
            }
            onChanged(newSet);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOn
                  ? Theme.of(context).primaryColor
                  : Colors.white12,
            ),
            child: Center(
              child: Text(
                days[i],
                style: TextStyle(
                  color: isOn ? Colors.white : Colors.white54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
