import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/support_profile_repository.dart';
import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/questionnaire/detoxia_question_bank.dart';
import 'package:detoxia/domain/questionnaire/question_visibility_resolver.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/domain/tasks/task_utility_score.dart';
import 'package:detoxia/domain/tasks/unified_task_engine.dart';
import 'package:detoxia/presentation/home/home_screen.dart';
import 'package:detoxia/presentation/questionnaire/support_map_builder.dart';
import 'package:detoxia/presentation/questionnaire/widgets/score_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final supportMapQuestionBankProvider =
    Provider<Future<DetoxiaQuestionBank> Function()>(
      (_) => DetoxiaQuestionBank.loadFromAssets,
    );

class SupportMapScreen extends ConsumerStatefulWidget {
  final int profileId;
  final int sessionId;
  final SupportProfile? profileOverride;

  const SupportMapScreen({
    super.key,
    required this.profileId,
    required this.sessionId,
    this.profileOverride,
  });

  @override
  ConsumerState<SupportMapScreen> createState() => _SupportMapScreenState();
}

class _SupportMapScreenState extends ConsumerState<SupportMapScreen> {
  SupportProfile? _profile;
  String? _error;

  @override
  void initState() {
    super.initState();
    final override = widget.profileOverride;
    if (override != null) {
      _profile = override;
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    try {
      final registration = await ref
          .read(registrationRepositoryProvider)
          .getProfile();
      if (registration == null) {
        throw StateError('Registration profile not found.');
      }

      final questionnaireRepo = ref.read(questionnaireRepositoryProvider);
      final answers = await questionnaireRepo.getAnswersMap(widget.sessionId);
      final bank = await ref.read(supportMapQuestionBankProvider)();
      final resolver = QuestionVisibilityResolver(bank);
      final builder = SupportMapBuilder(bank: bank, resolver: resolver);
      final profile = builder.build(
        registration: registration,
        answers: answers,
        now: DateTime.now(),
      );

      final saved = await ref
          .read(supportProfileRepositoryProvider)
          .saveProfile(profile);
      await questionnaireRepo.markCompleted(widget.sessionId);

      if (!mounted) return;
      setState(() => _profile = saved);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;
    return Scaffold(
      body: SafeArea(
        child: profile == null
            ? _buildLoadingOrError()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Your Support Map',
                      style: TextStyle(
                        color: AppTheme.palette(context).textPrimary,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A private map of the moments that need support.',
                      style: TextStyle(
                        color: AppTheme.palette(context).textSecondary,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _PrivacyReassuranceCard(),
                    const SizedBox(height: 16),
                    // Top 3 support needs with calm band labels
                    ...(() {
                      final sorted = profile.domainScores
                          .where((score) => score.enabled)
                          .toList()
                        ..sort((a, b) => b.visibleScore.compareTo(a.visibleScore));
                      return sorted.take(3).map(
                        (score) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ScoreCard(score: score),
                        ),
                      );
                    })(),
                    const SizedBox(height: 6),
                    _MainTriggerChainCard(
                      triggers: profile.triggerWeights,
                      pathways: profile.pathwayScores,
                    ),
                    const SizedBox(height: 12),
                    _StrongestDriversCard(
                      drivers: profile.triggerWeights,
                      scores: profile.domainScores,
                    ),
                    const SizedBox(height: 12),
                    _VulnerableWindowsCard(profile: profile),
                    const SizedBox(height: 12),
                    _BestFirstResetCard(
                      suggestions: const UnifiedTaskEngine().selectTasks(
                        profile: profile,
                        now: DateTime.now(),
                        count: 3,
                      ),
                      preferences: profile.interventionPreferences,
                    ),
                    const SizedBox(height: 14),
                    _WhatDetoxiaWillDoCard(),
                    const SizedBox(height: 10),
                    _WhatDetoxiaWillNotDoCard(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                          );
                        },
                        child: const Text("Start today's reset plan"),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Your data stays on this device. No diagnosis, no surveillance.',
                      style: TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingOrError() {
    final error = _error;
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline, color: AppTheme.palette(context).warning, size: 32),
              const SizedBox(height: 16),
              Text(
                'Support map could not load.',
                style: TextStyle(color: AppTheme.palette(context).textPrimary, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style:  TextStyle(color: AppTheme.palette(context).textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return const Center(child: CircularProgressIndicator());
  }
}

class _PrivacyReassuranceCard extends StatelessWidget {
  const _PrivacyReassuranceCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.palette(context).success.withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(Icons.lock_outline, color: AppTheme.palette(context).success, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Your sensitive recovery patterns stay on this device.',
                style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 13, height: 1.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainTriggerChainCard extends StatelessWidget {
  final List<TriggerWeight> triggers;
  final List<PathwayScore> pathways;

  const _MainTriggerChainCard({required this.triggers, required this.pathways});

  @override
  Widget build(BuildContext context) {
    final sorted = triggers.toList()
      ..sort((a, b) => b.weight0To10.compareTo(a.weight0To10));
    if (sorted.isEmpty) {
      return const _LearningCard(
        title: 'Your trigger chain is still forming',
        body: 'Complete more local check-ins so Detoxia can map your trigger chain.',
      );
    }

    final chainLabels = sorted
        .take(4)
        .map((t) => t.label.toLowerCase())
        .toList();
    final chain = chainLabels.join(' → ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your trigger chain',
              style: TextStyle(color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              chain,
              style: TextStyle(
                color: AppTheme.palette(context).textSecondary,
                fontSize: 15,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'This is not a label. It is a pattern Detoxia will help you notice earlier.',
              style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}

class _StrongestDriversCard extends StatelessWidget {
  final List<TriggerWeight> drivers;
  final List<DomainScore> scores;

  const _StrongestDriversCard({required this.drivers, required this.scores});

  @override
  Widget build(BuildContext context) {
    final topDrivers = drivers.toList()
      ..sort((a, b) => b.weight0To10.compareTo(a.weight0To10));
    if (topDrivers.isEmpty) {
      return const _LearningCard(
        title: 'Strongest drivers are still learning',
        body: 'Complete more local check-ins so Detoxia can rank your strongest drivers.',
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Strongest drivers',
              style: TextStyle(color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...topDrivers.take(3).map(
              (driver) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${driver.label}: ${_driverExplanation(driver.label)}',
                        style:  TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.35),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _driverExplanation(String label) {
    final normalized = label.toLowerCase();
    if (normalized.contains('stress')) return 'tends to show up before rough windows';
    if (normalized.contains('night') || normalized.contains('late')) return 'often leads to late-night vulnerability';
    if (normalized.contains('scroll')) return 'can pull you into automatic loops';
    if (normalized.contains('boredom') || normalized.contains('bored')) return 'often opens the door to old patterns';
    if (normalized.contains('lonely') || normalized.contains('alone')) return 'can make it harder to pause';
    if (normalized.contains('tired') || normalized.contains('sleep')) return 'lowers your ability to notice early signals';
    if (normalized.contains('anxiety') || normalized.contains('anxious')) return 'can amplify other triggers';
    return 'is one of your key support signals';
  }
}

class _VulnerableWindowsCard extends StatelessWidget {
  final SupportProfile profile;

  const _VulnerableWindowsCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final windows = profile.routineProfile.vulnerableWindows;
    final aloneWindows = profile.routineProfile.aloneWindows;
    final phoneInBed = profile.routineProfile.phoneInBedScore;
    final sleepDebt = profile.sleepProfile.dailySleepDebtHours;

    if (windows.isEmpty && aloneWindows.isEmpty) {
      return const _LearningCard(
        title: 'Support windows are still learning',
        body: 'Detoxia needs more routine data to identify your most vulnerable windows.',
      );
    }

    final parts = <String>[];
    if (windows.isNotEmpty) parts.add(windows.join(', '));
    if (aloneWindows.isNotEmpty) parts.add('alone during ${aloneWindows.join(', ')}');
    if (phoneInBed >= 2) parts.add('phone in bed');
    if (sleepDebt >= 2) parts.add('sleep debt building');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your support windows',
              style: TextStyle(color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              parts.join(' · '),
              style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 4),
            Text(
              'These are the moments most likely to need a small reset.',
              style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}

class _BestFirstResetCard extends StatelessWidget {
  final List<TaskUtility> suggestions;
  final InterventionPreferences preferences;

  const _BestFirstResetCard({
    required this.suggestions,
    required this.preferences,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const _LearningCard(
        title: 'Best first reset is still learning',
        body: 'Detoxia will suggest the most helpful first reset after more local signal.',
      );
    }

    final first = suggestions.first;
    final task = first.task;
    final prefHint = _preferenceHint();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Best first reset',
              style: TextStyle(color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              '${task['title']} (${task['durationMinutes']} min)',
              style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              '${first.whyChosen}$prefHint',
              style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 13, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  String _preferenceHint() {
    if (preferences.breathingGrounding) return ' Breathing and grounding techniques fit your current support preferences.';
    if (preferences.physicalReset) return ' A physical reset fits your current support preferences.';
    if (preferences.sleepShutdown) return ' Evening wind-down support fits your current preferences.';
    if (preferences.journalingThoughtDump) return ' Quick reflection fits your current support preferences.';
    return '';
  }
}

class _WhatDetoxiaWillDoCard extends StatelessWidget {
  const _WhatDetoxiaWillDoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What Detoxia will do',
              style: TextStyle(color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...const [
              'notice patterns locally',
              'suggest small resets',
              'learn from outcomes',
              'reduce false alarms',
            ].map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.check, color: AppTheme.palette(context).success, size: 15),
                  const SizedBox(width: 8),
                  Text(item, style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 13)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _WhatDetoxiaWillNotDoCard extends StatelessWidget {
  const _WhatDetoxiaWillNotDoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What Detoxia will not do',
              style: TextStyle(color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...const [
              'hard block you',
              'detect incognito',
              'send sensitive behavior data to a server',
              'shame you for reset moments',
            ].map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.close, color: AppTheme.palette(context).warning, size: 15),
                  const SizedBox(width: 8),
                  Text(item, style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 13)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _LearningCard extends StatelessWidget {
  final String title;
  final String body;

  const _LearningCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:  TextStyle(color: AppTheme.palette(context).textPrimary, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(body, style:  TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
