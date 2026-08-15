import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/presentation/home/home_screen.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionnairePlaceholderScreen extends ConsumerStatefulWidget {
  final int profileId;
  final int sessionId;

  const QuestionnairePlaceholderScreen({
    super.key,
    required this.profileId,
    required this.sessionId,
  });

  @override
  ConsumerState<QuestionnairePlaceholderScreen> createState() =>
      _QuestionnairePlaceholderScreenState();
}

class _QuestionnairePlaceholderScreenState
    extends ConsumerState<QuestionnairePlaceholderScreen> {
  bool _saving = false;

  Future<void> _continue() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(questionnaireRepositoryProvider)
          .completePlaceholder(widget.sessionId);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref.read(registrationRepositoryProvider).getProfile(),
      builder: (context, snapshot) {
        final profile = snapshot.data;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Questionnaire V1 starts here',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Next, Detoxia will map routines, sleep windows, triggers, '
                    'emotions, pathways, and support scores into one unified plan.',
                    style: TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.45),
                  ),
                  const SizedBox(height: 28),
                  _InfoTile(
                    label: 'Name',
                    value: profile?.displayName ?? 'Loading...',
                  ),
                  _InfoTile(
                    label: 'Age band',
                    value: _ageLabel(profile?.ageBand),
                  ),
                  _InfoTile(
                    label: 'Gender',
                    value: _genderLabel(profile?.gender),
                  ),
                  const Spacer(),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phase 0 shell',
                            style: TextStyle(
                              color: AppTheme.palette(context).textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'This placeholder creates/resumes a local questionnaire '
                            'session. Full scoring questions come in Questionnaire V1.',
                            style:
                                TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _continue,
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _ageLabel(String? value) {
    return switch (value) {
      'teen13To15' => '13-15',
      'teen16To17' => '16-17',
      'adult18Plus' => '18+',
      _ => 'Loading...',
    };
  }

  String _genderLabel(String? value) {
    return switch (value) {
      'male' => 'Male',
      'female' => 'Female',
      'preferNotToSay' => 'Prefer not to say',
      _ => 'Loading...',
    };
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.palette(context).textPrimary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.palette(context).borderSubtle),
      ),
      child: Row(
        children: [
          Text(label, style:  TextStyle(color: AppTheme.palette(context).textSecondary)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.palette(context).textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
