import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/event_bus/event_bus.dart';
import 'package:detoxia/core/event_bus/events.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/repositories/user_repository.dart';
import 'package:detoxia/presentation/widgets/choice_chip_group.dart';
import 'package:detoxia/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckinScreen extends ConsumerStatefulWidget {
  const CheckinScreen({super.key});

  @override
  ConsumerState<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends ConsumerState<CheckinScreen> {
  bool _hadUrge = false;
  int _urgeMax = 5;
  TriggerType? _mainTrigger;
  bool _slipped = false;
  int _slipCount = 0;
  int _sleepQuality = 3;
  int _mood = 5;
  int _stress = 5;
  int _confidenceTomorrow = 5;

  Future<void> _submit() async {
    final event = CheckInCompletedEvent(
      hadUrge: _hadUrge,
      urgeMax: _hadUrge ? _urgeMax : null,
      mainTrigger: _mainTrigger,
      slipped: _slipped,
      slipCount: _slipCount,
      sleepQuality: _sleepQuality,
      mood: _mood,
      stress: _stress,
      confidenceTomorrow: _confidenceTomorrow,
    );

    ref.read(eventBusProvider).fire(event);

    // Mark today as checked in and stop the reminders
    await ref.read(userRepositoryProvider).markCheckedIn(true);
    await ref.read(notificationServiceProvider).cancelCheckinReminders();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Check-in complete. See you tomorrow.')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Check-in')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How was today?',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),

            _buildToggle('Did you feel any urges today?', _hadUrge,
                (v) => setState(() => _hadUrge = v)),
            if (_hadUrge) ...[
              const SizedBox(height: 16),
              _buildSlider(
                  'How strong was the strongest urge?', _urgeMax.toDouble(), 1, 10,
                  (v) => setState(() => _urgeMax = v.round()),
                  leftLabel: 'Mild', rightLabel: 'Overwhelming'),
              const SizedBox(height: 16),
              const Text('What triggered it the most?',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              ChoiceChipGroup<TriggerType>(
                options: TriggerType.values,
                selected: _mainTrigger != null ? {_mainTrigger!} : {},
                multiSelect: false,
                labelBuilder: (t) => t.name,
                onToggle: (t) => setState(() => _mainTrigger = t),
              ),
            ],

            const SizedBox(height: 20),
            _buildToggle('Did you have a setback today?', _slipped,
                (v) => setState(() => _slipped = v)),
            const Text(
              'A setback means you gave in to the behavior you\'re working to overcome.',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
            if (_slipped) ...[
              const SizedBox(height: 16),
              _buildSlider('How many times?', _slipCount.toDouble(),
                  1, 5, (v) => setState(() => _slipCount = v.round())),
            ],

            const SizedBox(height: 24),
            _buildSlider('Sleep quality last night',
                _sleepQuality.toDouble(), 1, 5,
                (v) => setState(() => _sleepQuality = v.round()),
                leftLabel: 'Poor', rightLabel: 'Great'),
            const SizedBox(height: 16),
            _buildSlider('Mood today', _mood.toDouble(), 1, 10,
                (v) => setState(() => _mood = v.round()),
                leftLabel: 'Low', rightLabel: 'High'),
            const SizedBox(height: 16),
            _buildSlider('Stress today', _stress.toDouble(), 1, 10,
                (v) => setState(() => _stress = v.round()),
                leftLabel: 'Calm', rightLabel: 'Stressed'),
            const SizedBox(height: 16),
            _buildSlider(
                'Confidence for tomorrow',
                _confidenceTomorrow.toDouble(),
                1,
                10,
                (v) => setState(() => _confidenceTomorrow = v.round()),
                leftLabel: 'Low', rightLabel: 'High'),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Complete Check-in'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(
      String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppTheme.accent,
        ),
      ],
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged, {
    String? leftLabel,
    String? rightLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white70)),
            Text(value.round().toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: onChanged,
          activeColor: AppTheme.accent,
        ),
        if (leftLabel != null || rightLabel != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(leftLabel ?? '',
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 11)),
              Text(rightLabel ?? '',
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 11)),
            ],
          ),
      ],
    );
  }
}
