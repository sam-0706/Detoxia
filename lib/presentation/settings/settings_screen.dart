import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/encryption/data_export.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/support_profile_repository.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/presentation/questionnaire/questionnaire_screen.dart';
import 'package:detoxia/presentation/settings/theme_picker_screen.dart';
import 'package:detoxia/presentation/signup/signup_profile_screen.dart';
import 'package:detoxia/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final RegistrationProfile? registrationProfileOverride;
  final SupportProfile? supportProfileOverride;

  const SettingsScreen({
    super.key,
    this.registrationProfileOverride,
    this.supportProfileOverride,
  });

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const String _appVersion = 'Detoxia v1.0.0';

  RegistrationProfile? _registrationProfile;
  SupportProfile? _supportProfile;
  NotificationMode _notifMode = NotificationMode.balanced;
  bool _quietHoursEnabled = false;
  int _quietStartMinutes = 22 * 60;
  int _quietEndMinutes = 7 * 60;
  bool _busy = false;

  static const Map<String, String> _goalLabels = <String, String>{
    'goal_sleep': 'Sleep',
    'goal_anxiety': 'Anxiety',
    'goal_focus': 'Focus / ADHD',
    'goal_scrolling': 'Scrolling',
    'goal_sexualControl': 'Sexual-control',
    'goal_lowMood': 'Low mood',
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final notificationService = ref.read(notificationServiceProvider);
    if (widget.registrationProfileOverride != null ||
        widget.supportProfileOverride != null) {
      setState(() {
        _registrationProfile = widget.registrationProfileOverride;
        _supportProfile = widget.supportProfileOverride;
        _notifMode = notificationService.mode;
        _quietHoursEnabled = notificationService.quietHoursEnabled;
        _quietStartMinutes = notificationService.quietStartMinutes;
        _quietEndMinutes = notificationService.quietEndMinutes;
      });
      return;
    }

    final registration =
        await ref.read(registrationRepositoryProvider).getProfile();
    final support = registration == null
        ? null
        : await ref
              .read(supportProfileRepositoryProvider)
              .getLatestProfile(registration.id);
    if (!mounted) return;
    setState(() {
      _registrationProfile = registration;
      _supportProfile = support;
      _notifMode = notificationService.mode;
      _quietHoursEnabled = notificationService.quietHoursEnabled;
      _quietStartMinutes = notificationService.quietStartMinutes;
      _quietEndMinutes = notificationService.quietEndMinutes;
    });
  }

  Future<void> _confirmDeleteLocalData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete local data?'),
        content: const Text(
          'This removes your local profile, support map, check-ins, and progress from this device only.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.palette(context).danger),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      await DataExport(ref.read(databaseProvider)).deleteAll();
      await ref.read(notificationServiceProvider).cancelAllScheduled();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SignupProfileScreen()),
        (_) => false,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmResetLearningEngine() async {
    final support = _supportProfile;
    if (support == null) {
      _snack('Complete support mapping first.');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset learning engine?'),
        content: const Text(
          'This resets recovery momentum and learning weights locally. It does not send anything to the cloud.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Reset',
              style: TextStyle(color: AppTheme.palette(context).warning),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final reset = LearningState(
      recoveryMomentum: 5,
      predictionAccuracy: 0,
      falseAlarmRate: 0,
      triggerReliabilityMap: const <String, double>{},
      interventionRewardsMap: const <String, double>{},
      lastUpdatedAt: DateTime.now(),
    );
    await ref
        .read(supportProfileRepositoryProvider)
        .updateLearningState(support.registrationProfileId, reset);
    setState(() {
      _supportProfile = _copySupportProfile(
        support,
        learningState: reset,
      );
    });
    _snack('Learning engine reset locally.');
  }

  Future<void> _updateGoals() async {
    final support = _supportProfile;
    if (support == null) {
      _snack('Support map not ready yet.');
      return;
    }

    final initial = _normalizeGoals(support.selectedGoals);
    final selected = await showDialog<Set<String>>(
      context: context,
      builder: (ctx) {
        final working = {...initial};
        return StatefulBuilder(
          builder: (ctx, setModalState) => AlertDialog(
            title: const Text('Update goals'),
            content: SizedBox(
              width: 340,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _goalLabels.entries
                      .map(
                        (entry) => CheckboxListTile(
                          value: working.contains(entry.key),
                          onChanged: (value) {
                            setModalState(() {
                              if (value == true) {
                                working.add(entry.key);
                              } else {
                                working.remove(entry.key);
                              }
                            });
                          },
                          title: Text(entry.value),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, null),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, working),
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );

    if (selected == null || selected.isEmpty || !mounted) return;

    final updated = _copySupportProfile(
      support,
      selectedGoals: selected.toList(growable: false),
      learningState: LearningState(
        recoveryMomentum: 5,
        predictionAccuracy: 0,
        falseAlarmRate: 0,
        triggerReliabilityMap: const <String, double>{},
        interventionRewardsMap: const <String, double>{},
        lastUpdatedAt: DateTime.now(),
      ),
    );
    await ref.read(supportProfileRepositoryProvider).saveProfile(updated);
    setState(() => _supportProfile = updated);
    _snack('Goals updated locally. Consider retaking the questionnaire.');
  }

  Future<void> _retakeQuestionnaire() async {
    final registration = _registrationProfile;
    if (registration == null) {
      _snack('Registration profile not found.');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Retake questionnaire?'),
        content: const Text(
          'This clears local questionnaire progress and starts a fresh support-map calibration.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Retake'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await ref
        .read(questionnaireRepositoryProvider)
        .clearAllProgressForRegistration(registration.id);
    await ref
        .read(supportProfileRepositoryProvider)
        .deleteAllForRegistration(registration.id);
    final session = await ref
        .read(questionnaireRepositoryProvider)
        .ensureSession(registration.id);
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuestionnaireScreen(
          profileId: registration.id,
          sessionId: session.id,
        ),
      ),
    );
    await _loadSettings();
  }

  Future<void> _pickQuietTime({required bool start}) async {
    final initial = _timeOfDayFromMinutes(start ? _quietStartMinutes : _quietEndMinutes);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null || !mounted) return;
    setState(() {
      if (start) {
        _quietStartMinutes = _minutesFromTimeOfDay(picked);
      } else {
        _quietEndMinutes = _minutesFromTimeOfDay(picked);
      }
    });
    ref.read(notificationServiceProvider).setQuietHours(
          enabled: _quietHoursEnabled,
          startMinutes: _quietStartMinutes,
          endMinutes: _quietEndMinutes,
        );
  }

  TimeOfDay _timeOfDayFromMinutes(int minutes) {
    final normalized = minutes.clamp(0, 1439);
    return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
  }

  int _minutesFromTimeOfDay(TimeOfDay time) => time.hour * 60 + time.minute;

  Set<String> _normalizeGoals(List<String> goals) {
    final normalized = <String>{};
    for (final goal in goals) {
      final lower = goal.toLowerCase().replaceAll('_', '');
      if (lower.contains('sleep')) normalized.add('goal_sleep');
      if (lower.contains('anxiety')) normalized.add('goal_anxiety');
      if (lower.contains('focus') || lower.contains('adhd')) {
        normalized.add('goal_focus');
      }
      if (lower.contains('scroll')) normalized.add('goal_scrolling');
      if (lower.contains('sexual') || lower.contains('porn')) {
        normalized.add('goal_sexualControl');
      }
      if (lower.contains('lowmood') || lower.contains('mood')) {
        normalized.add('goal_lowMood');
      }
    }
    return normalized;
  }

  SupportProfile _copySupportProfile(
    SupportProfile source, {
    List<String>? selectedGoals,
    LearningState? learningState,
  }) {
    return SupportProfile(
      registrationProfileId: source.registrationProfileId,
      selectedGoals: selectedGoals ?? source.selectedGoals,
      domainScores: source.domainScores,
      routineProfile: source.routineProfile,
      sleepProfile: source.sleepProfile,
      menstrualProfile: source.menstrualProfile,
      triggerWeights: source.triggerWeights,
      pathwayScores: source.pathwayScores,
      interventionPreferences: source.interventionPreferences,
      learningState: learningState ?? source.learningState,
      createdAt: source.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatTime(int minutes) {
    final time = _timeOfDayFromMinutes(minutes);
    final hour12 = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour12:$minute $period';
  }

  Widget _goalChips() {
    final goals = _normalizeGoals(_supportProfile?.selectedGoals ?? const <String>[]);
    if (goals.isEmpty) {
      return Text(
        'No goals configured yet.',
        style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12),
      );
    }
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: goals
          .map(
            (goal) => Chip(
              label: Text(
                _goalLabels[goal] ?? goal,
                style: const TextStyle(fontSize: 11),
              ),
              visualDensity: VisualDensity.compact,
            ),
          )
          .toList(growable: false),
    );
  }

  Widget _buildAppearanceSection() {
    final p = AppTheme.palette(context);
    final preset = ref.watch(activeThemeProvider.notifier).preset;

    return Card(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: preset.palette.canvas,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: p.borderStrong),
          ),
          child: Center(
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: preset.palette.accent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        title: Text('Theme', style: TextStyle(color: p.textPrimary)),
        subtitle: Text(
          '${preset.label} · ${preset.isDark ? 'Dark' : 'Light'}',
          style: TextStyle(color: p.textTertiary, fontSize: 12),
        ),
        trailing: Icon(Icons.chevron_right, color: p.textTertiary),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ThemePickerScreen()),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    final profile = _registrationProfile;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: TextStyle(color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            if (profile == null)
              Text(
                'Profile is not available yet.',
                style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12),
              )
            else ...[
              Text('Name: ${profile.displayName}', style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12)),
              Text('Email: ${profile.email}', style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12)),
              Text('Phone: ${profile.phone}', style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12)),
              Text('Region: ${profile.regionName}', style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12)),
              Text('Timezone: ${profile.timezone}', style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationService = ref.read(notificationServiceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle(title: 'Profile'),
          _buildProfileSection(),
          const SizedBox(height: 20),
          _SectionTitle(title: 'Appearance'),
          _buildAppearanceSection(),
          const SizedBox(height: 20),
          _SectionTitle(title: 'Goals & Questionnaire'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title:  Text('Update goals', style: TextStyle(color: AppTheme.palette(context).textPrimary)),
                  subtitle: Text(
                    'Refresh selected goals and recalibrate safely.',
                    style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12),
                  ),
                  trailing:  Icon(Icons.chevron_right, color: AppTheme.palette(context).textTertiary),
                  onTap: _updateGoals,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _goalChips(),
                  ),
                ),
                 Divider(height: 20, color: AppTheme.palette(context).borderSubtle),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title:  Text('Retake questionnaire', style: TextStyle(color: AppTheme.palette(context).textPrimary)),
                  subtitle: Text(
                    'Start a fresh support-map calibration.',
                    style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12),
                  ),
                  trailing:  Icon(Icons.chevron_right, color: AppTheme.palette(context).textTertiary),
                  onTap: _retakeQuestionnaire,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle(title: 'Notifications'),
          Card(
            child: Column(
              children: NotificationMode.values.map((mode) {
                final isSelected = mode == _notifMode;
                return ListTile(
                  title: Text(
                    switch (mode) {
                      NotificationMode.strict => 'Strict (up to 8/day)',
                      NotificationMode.balanced => 'Balanced (up to 5/day)',
                      NotificationMode.gentle => 'Gentle (up to 3/day)',
                    },
                    style:  TextStyle(color: AppTheme.palette(context).textPrimary),
                  ),
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected ? AppTheme.palette(context).accent : AppTheme.palette(context).textTertiary,
                  ),
                  onTap: () {
                    setState(() => _notifMode = mode);
                    notificationService.setMode(mode);
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              value: _quietHoursEnabled,
              onChanged: (value) {
                setState(() => _quietHoursEnabled = value);
                notificationService.setQuietHours(
                  enabled: value,
                  startMinutes: _quietStartMinutes,
                  endMinutes: _quietEndMinutes,
                );
              },
              title: Text(
                'Quiet hours',
                style: TextStyle(color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${_formatTime(_quietStartMinutes)} - ${_formatTime(_quietEndMinutes)}',
                style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12),
              ),
            ),
          ),
          if (_quietHoursEnabled) ...[
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.nightlight_outlined),
                    title:  Text('Quiet start', style: TextStyle(color: AppTheme.palette(context).textPrimary)),
                    subtitle: Text(
                      _formatTime(_quietStartMinutes),
                      style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12),
                    ),
                    onTap: () => _pickQuietTime(start: true),
                  ),
                   Divider(height: 1, color: AppTheme.palette(context).borderSubtle),
                  ListTile(
                    leading: const Icon(Icons.wb_sunny_outlined),
                    title:  Text('Quiet end', style: TextStyle(color: AppTheme.palette(context).textPrimary)),
                    subtitle: Text(
                      _formatTime(_quietEndMinutes),
                      style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12),
                    ),
                    onTap: () => _pickQuietTime(start: false),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          _SectionTitle(title: 'Privacy & Local Data'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sensitive wellness data stays local on this device.',
                    style: TextStyle(color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Questionnaire answers, scores, triggers, pathways, check-ins, and learning state are not synced to remote analytics or ad services.',
                    style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.tune, color: AppTheme.palette(context).warning),
                  title: Text(
                    'Reset learning engine',
                    style: TextStyle(color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Reset local momentum and learning weights.',
                    style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12),
                  ),
                  trailing:  Icon(Icons.chevron_right, color: AppTheme.palette(context).textTertiary),
                  onTap: _confirmResetLearningEngine,
                ),
                 Divider(height: 1, color: AppTheme.palette(context).borderSubtle),
                ListTile(
                  leading: Icon(Icons.delete_forever, color: AppTheme.palette(context).danger),
                  title: Text(
                    'Delete local data',
                    style: TextStyle(color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Remove all local data and return to sign up.',
                    style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12),
                  ),
                  trailing: _busy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      :  Icon(Icons.chevron_right, color: AppTheme.palette(context).textTertiary),
                  onTap: _busy ? null : _confirmDeleteLocalData,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle(title: 'About'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _appVersion,
                    style: TextStyle(
                        color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Offline-first by design. Registration details may sync for account records; wellness signals remain local.',
                    style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
