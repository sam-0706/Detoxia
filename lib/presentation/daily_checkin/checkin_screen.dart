import 'dart:convert';

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/repositories/event_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/support_profile_repository.dart';
import 'package:detoxia/data/repositories/user_repository.dart';
import 'package:detoxia/presentation/daily_checkin/widgets/cycle_symptom_picker.dart';
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
  int _slipCount = 1;
  int _sleepQuality = 5;
  int _mood = 5;
  int _stress = 5;
  int _anxiety = 5;
  int _energy = 5;
  final int _confidenceTomorrow = 5;
  Set<String> _cycleSymptoms = {};
  bool _cycleEnabled = false;

  bool _loading = true;
  bool _alreadyCheckedIn = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final done = await ref.read(userRepositoryProvider).hasCheckedInToday();
    final cycleEnabled = await _loadCycleEnabled();
    if (mounted) {
      setState(() {
        _alreadyCheckedIn = done;
        _cycleEnabled = cycleEnabled;
        _loading = false;
      });
    }
  }

  Future<bool> _loadCycleEnabled() async {
    final registration = await ref
        .read(registrationRepositoryProvider)
        .getProfile();
    if (registration == null) return false;
    final supportProfile = await ref
        .read(supportProfileRepositoryProvider)
        .getLatestProfile(registration.id);
    return supportProfile?.menstrualProfile?.enabled ?? false;
  }

  Future<void> _submit() async {
    final already = await ref.read(userRepositoryProvider).hasCheckedInToday();
    if (already) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check-in already done for today.')),
        );
      }
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    await ref
        .read(eventRepositoryProvider)
        .insertCheckin(
          date: today,
          hadUrge: _hadUrge,
          urgeMax: _hadUrge ? _urgeMax : null,
          mainTrigger: _mainTrigger,
          slipped: _slipped,
          slipCount: _slipped ? _slipCount : 0,
          sleepQuality: _sleepQuality,
          mood: _mood,
          stress: _stress,
          confidenceTomorrow: _confidenceTomorrow,
          // V1 stores newly unified fields in `notes` to avoid a schema change.
          // Task 09_03 may migrate anxiety, energy, and cycle symptoms into
          // dedicated persistence columns when the learning service lands.
          notes: jsonEncode({
            'anxiety': _anxiety,
            'energy': _energy,
            'strongUrgeToday': _hadUrge,
            'cycleSymptoms': _cycleEnabled ? _cycleSymptoms.toList() : [],
          }),
        );

    await ref.read(userRepositoryProvider).markCheckedIn(true);
    await ref.read(notificationServiceProvider).cancelCheckinReminders();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check-in complete. See you tomorrow.')),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_alreadyCheckedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Daily Check-in')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: AppTheme.palette(context).success, size: 72),
                const SizedBox(height: 24),
                Text(
                  'Check-in already done',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'You\'ve already completed today\'s check-in. '
                  'Come back tomorrow and we\'ll keep adjusting with you.',
                  style: TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to home'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Check-in')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How was today?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),

            Text(
              'A quick calibration for your personal plan. Sensitive details stay on this device.',
              style: TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.4),
            ),
            const SizedBox(height: 24),
            _buildSlider(
              'Stress today',
              _stress.toDouble(),
              0,
              10,
              (v) => setState(() => _stress = v.round()),
              leftLabel: 'Calm',
              rightLabel: 'High',
            ),
            const SizedBox(height: 16),
            _buildSlider(
              'Anxiety today',
              _anxiety.toDouble(),
              0,
              10,
              (v) => setState(() => _anxiety = v.round()),
              leftLabel: 'Settled',
              rightLabel: 'High',
            ),
            const SizedBox(height: 16),
            _buildSlider(
              'Mood today',
              _mood.toDouble(),
              0,
              10,
              (v) => setState(() => _mood = v.round()),
              leftLabel: 'Low',
              rightLabel: 'Steady',
            ),
            const SizedBox(height: 16),
            _buildSlider(
              'Sleep quality',
              _sleepQuality.toDouble(),
              0,
              10,
              (v) => setState(() => _sleepQuality = v.round()),
              leftLabel: 'Poor',
              rightLabel: 'Great',
            ),
            const SizedBox(height: 16),
            _buildSlider(
              'Energy',
              _energy.toDouble(),
              0,
              10,
              (v) => setState(() => _energy = v.round()),
              leftLabel: 'Drained',
              rightLabel: 'Energized',
            ),
            const SizedBox(height: 16),
            _buildToggle(
              'Did you feel a strong urge today?',
              _hadUrge,
              (v) => setState(() => _hadUrge = v),
            ),
            if (_cycleEnabled) ...[
              const SizedBox(height: 16),
              CycleSymptomPicker(
                selectedSymptoms: _cycleSymptoms,
                onChanged: (symptoms) {
                  setState(() => _cycleSymptoms = symptoms);
                },
              ),
            ],
            const SizedBox(height: 16),
            _buildMoreDetails(),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Complete Check-in'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: AppTheme.palette(context).textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppTheme.palette(context).accent,
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
    final safeValue = value.clamp(min, max);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(label, style:  TextStyle(color: AppTheme.palette(context).textSecondary)),
            ),
            Text(
              safeValue.round().toString(),
              style: TextStyle(
                color: AppTheme.palette(context).textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Slider(
          value: safeValue,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: onChanged,
          activeColor: AppTheme.palette(context).accent,
        ),
        if (leftLabel != null || rightLabel != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftLabel ?? '',
                style:  TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 11),
              ),
              Text(
                rightLabel ?? '',
                style:  TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 11),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildMoreDetails() {
    return Card(
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        title: Text(
          'More',
          style: TextStyle(color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Optional detox recovery details',
          style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12),
        ),
        iconColor: AppTheme.palette(context).accent,
        collapsedIconColor: AppTheme.palette(context).textSecondary,
        children: [
          _buildSlider(
            'How strong was the strongest urge?',
            _urgeMax.toDouble(),
            0,
            10,
            (v) => setState(() => _urgeMax = v.round()),
            leftLabel: 'Mild',
            rightLabel: 'Strong',
          ),
          const SizedBox(height: 16),
          Text(
            'What shaped the rough window most?',
            style: TextStyle(color: AppTheme.palette(context).textSecondary),
          ),
          const SizedBox(height: 8),
          ChoiceChipGroup<TriggerType>(
            options: TriggerType.values,
            selected: _mainTrigger != null ? {_mainTrigger!} : {},
            multiSelect: false,
            labelBuilder: (t) => t.name,
            onToggle: (t) => setState(() => _mainTrigger = t),
          ),
          const SizedBox(height: 20),
          _buildToggle('Did a rough window continue further today?', _slipped, (
            v,
          ) {
            setState(() {
              _slipped = v;
              if (v && _slipCount < 1) _slipCount = 1;
            });
          }),
          Text(
            'No judgment here. We adjust and continue.',
            style: TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 12),
          ),
          if (_slipped) ...[
            const SizedBox(height: 16),
            _buildSlider(
              'How many rough windows?',
              _slipCount.toDouble(),
              1,
              5,
              (v) => setState(() => _slipCount = v.round()),
            ),
          ],
        ],
      ),
    );
  }
}
