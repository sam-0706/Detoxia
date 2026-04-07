import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/core/utils/time_utils.dart';
import 'package:detoxia/presentation/onboarding/onboarding_screen.dart';
import 'package:detoxia/presentation/widgets/choice_chip_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScopeTimingPage extends ConsumerWidget {
  final VoidCallback onNext;

  const ScopeTimingPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingStateProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What are you\ndealing with?',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 24),

          ChoiceChipGroup<BehaviorType>(
            options: const [
              BehaviorType.scrolling,
              BehaviorType.porn,
              BehaviorType.masturbation,
            ],
            selected: state.struggles,
            labelBuilder: (b) => switch (b) {
              BehaviorType.scrolling => 'Scrolling',
              BehaviorType.porn => 'Pornography',
              BehaviorType.masturbation => 'Masturbation',
              BehaviorType.combined => 'Combined',
            },
            onToggle: (b) {
              final next = Set<BehaviorType>.from(state.struggles);
              next.contains(b) ? next.remove(b) : next.add(b);
              ref
                  .read(onboardingStateProvider.notifier)
                  .update((s) => s.struggles = next);
            },
          ),

          if (state.struggles.length >= 2 &&
              state.struggles.contains(BehaviorType.scrolling)) ...[
            const SizedBox(height: 16),
            const Text(
              'Does scrolling usually lead to the other?',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            ChoiceChipGroup<ScrollingLinkage>(
              options: const [
                ScrollingLinkage.always,
                ScrollingLinkage.sometimes,
                ScrollingLinkage.rarely,
              ],
              selected: {state.scrollingLinkage},
              multiSelect: false,
              labelBuilder: (l) => switch (l) {
                ScrollingLinkage.always => 'Always',
                ScrollingLinkage.sometimes => 'Sometimes',
                ScrollingLinkage.rarely => 'Rarely',
                ScrollingLinkage.never => 'Never',
              },
              onToggle: (l) {
                ref
                    .read(onboardingStateProvider.notifier)
                    .update((s) => s.scrollingLinkage = l);
              },
            ),
          ],

          const SizedBox(height: 28),
          const Text(
            'It usually happens around...',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap on the timeline to mark when trouble happens',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _DayTimeline(
            peaks: state.peakPins,
            wakeTime: state.weekdayWake,
            sleepTime: state.weekdaySleep,
            workStart: state.workStart,
            workEnd: state.workEnd,
            isWorking: state.roleType == RoleType.working ||
                state.roleType == RoleType.student,
            onPeakAdded: (pin) {
              ref.read(onboardingStateProvider.notifier).update(
                  (s) => s.peakPins = [...s.peakPins, pin]);
            },
            onPeakRemoved: (index) {
              final pins = [...state.peakPins];
              pins.removeAt(index);
              ref
                  .read(onboardingStateProvider.notifier)
                  .update((s) => s.peakPins = pins);
            },
            onFrequencyChanged: (index, freq) {
              final pins = [...state.peakPins];
              pins[index] = PeakPin(
                  time: pins[index].time, frequency: freq);
              ref
                  .read(onboardingStateProvider.notifier)
                  .update((s) => s.peakPins = pins);
            },
          ),

          const SizedBox(height: 20),
          const Text(
            'Are weekends different?',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _ToggleButton(
                label: 'Yes',
                isSelected: state.weekendDifferent,
                onTap: () {
                  ref
                      .read(onboardingStateProvider.notifier)
                      .update((s) => s.weekendDifferent = true);
                },
              ),
              const SizedBox(width: 12),
              _ToggleButton(
                label: 'No',
                isSelected: !state.weekendDifferent,
                onTap: () {
                  ref
                      .read(onboardingStateProvider.notifier)
                      .update((s) => s.weekendDifferent = false);
                },
              ),
            ],
          ),

          if (state.weekendDifferent) ...[
            const SizedBox(height: 16),
            _DayTimeline(
              peaks: state.weekendPeakPins,
              wakeTime: state.offdayWake,
              sleepTime: state.offdaySleep,
              workStart: null,
              workEnd: null,
              isWorking: false,
              onPeakAdded: (pin) {
                ref.read(onboardingStateProvider.notifier).update(
                    (s) => s.weekendPeakPins = [
                          ...s.weekendPeakPins,
                          pin
                        ]);
              },
              onPeakRemoved: (index) {
                final pins = [...state.weekendPeakPins];
                pins.removeAt(index);
                ref
                    .read(onboardingStateProvider.notifier)
                    .update((s) => s.weekendPeakPins = pins);
              },
              onFrequencyChanged: (index, freq) {
                final pins = [...state.weekendPeakPins];
                pins[index] = PeakPin(
                    time: pins[index].time, frequency: freq);
                ref
                    .read(onboardingStateProvider.notifier)
                    .update((s) => s.weekendPeakPins = pins);
              },
            ),
          ],

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  state.struggles.isNotEmpty && state.peakPins.isNotEmpty
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

class _DayTimeline extends StatelessWidget {
  final List<PeakPin> peaks;
  final TimeOfDay wakeTime;
  final TimeOfDay sleepTime;
  final TimeOfDay? workStart;
  final TimeOfDay? workEnd;
  final bool isWorking;
  final ValueChanged<PeakPin> onPeakAdded;
  final ValueChanged<int> onPeakRemoved;
  final void Function(int index, Frequency freq) onFrequencyChanged;

  const _DayTimeline({
    required this.peaks,
    required this.wakeTime,
    required this.sleepTime,
    this.workStart,
    this.workEnd,
    required this.isWorking,
    required this.onPeakAdded,
    required this.onPeakRemoved,
    required this.onFrequencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapUp: (details) {
            if (peaks.length >= 4) return;
            final box = context.findRenderObject() as RenderBox;
            final fraction = details.localPosition.dx / box.size.width;
            final wakeMin = TimeUtils.timeToMinutes(wakeTime);
            var sleepMin = TimeUtils.timeToMinutes(sleepTime);
            if (sleepMin <= wakeMin) sleepMin += 1440;
            final totalMin = sleepMin - wakeMin;
            final tappedMin =
                wakeMin + (fraction * totalMin).round();
            final time = TimeUtils.minutesToTime(tappedMin);
            onPeakAdded(PeakPin(time: time));
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomPaint(
              size: const Size(double.infinity, 56),
              painter: _TimelinePainter(
                peaks: peaks,
                wakeTime: wakeTime,
                sleepTime: sleepTime,
                workStart: isWorking ? workStart : null,
                workEnd: isWorking ? workEnd : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(wakeTime.format(context),
                style: const TextStyle(
                    color: Colors.white38, fontSize: 12)),
            Text(sleepTime.format(context),
                style: const TextStyle(
                    color: Colors.white38, fontSize: 12)),
          ],
        ),
        if (peaks.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...peaks.asMap().entries.map((entry) {
            final i = entry.key;
            final pin = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.location_on,
                      color: AppTheme.danger, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    pin.time.format(context),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  _FrequencyPill(
                    value: pin.frequency,
                    onChanged: (f) => onFrequencyChanged(i, f),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => onPeakRemoved(i),
                    child: const Icon(Icons.close,
                        color: Colors.white38, size: 20),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final List<PeakPin> peaks;
  final TimeOfDay wakeTime;
  final TimeOfDay sleepTime;
  final TimeOfDay? workStart;
  final TimeOfDay? workEnd;

  _TimelinePainter({
    required this.peaks,
    required this.wakeTime,
    required this.sleepTime,
    this.workStart,
    this.workEnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final wakeMin = TimeUtils.timeToMinutes(wakeTime);
    var sleepMin = TimeUtils.timeToMinutes(sleepTime);
    if (sleepMin <= wakeMin) sleepMin += 1440;
    final totalMin = sleepMin - wakeMin;
    if (totalMin <= 0) return;

    double toX(int minutes) =>
        ((minutes - wakeMin) / totalMin * size.width).clamp(0, size.width);

    // Work hours background
    if (workStart != null && workEnd != null) {
      final ws = TimeUtils.timeToMinutes(workStart!);
      final we = TimeUtils.timeToMinutes(workEnd!);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(toX(ws), 0, toX(we), size.height),
          const Radius.circular(4),
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.05),
      );
    }

    // Timeline bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
            0, size.height / 2 - 3, size.width, size.height / 2 + 3),
        const Radius.circular(3),
      ),
      Paint()..color = Colors.white24,
    );

    // Peak pins
    for (final peak in peaks) {
      final min = TimeUtils.timeToMinutes(peak.time);
      final x = toX(min);
      canvas.drawCircle(
        Offset(x, size.height / 2),
        10,
        Paint()..color = const Color(0xFFEF5350),
      );
      canvas.drawCircle(
        Offset(x, size.height / 2),
        5,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TimelinePainter old) => true;
}

class _FrequencyPill extends StatelessWidget {
  final Frequency value;
  final ValueChanged<Frequency> onChanged;

  const _FrequencyPill({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Frequency>(
      initialValue: value,
      onSelected: onChanged,
      color: AppTheme.surface,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          switch (value) {
            Frequency.almostDaily => 'Daily',
            Frequency.fewPerWeek => 'Few/week',
            Frequency.sometimes => 'Sometimes',
            Frequency.weekendsOnly => 'Weekends',
          },
          style:
              const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ),
      itemBuilder: (_) => Frequency.values
          .map((f) => PopupMenuItem(
                value: f,
                child: Text(switch (f) {
                  Frequency.almostDaily => 'Almost daily',
                  Frequency.fewPerWeek => 'Few times a week',
                  Frequency.sometimes => 'Sometimes',
                  Frequency.weekendsOnly => 'Weekends only',
                }),
              ))
          .toList(),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent : AppTheme.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
