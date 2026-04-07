import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/achievements/achievement_definitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defs = AchievementRegistry.all;
    final ctx = const AchievementContext(
      cleanStreak: 5,
      urgesResisted: 8,
      sleepBoundaryStreak: 3,
      checkinStreak: 5,
      rescuesCompleted: 6,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Your journey',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text(
            'Achievements are never erased. '
            'Even after a slip, your progress is real.',
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 24),

          // Streak achievements
          _SectionHeader(title: 'Streak Milestones'),
          ...defs
              .where((d) => d.tier == AchievementTier.streak)
              .map((d) => _AchievementCard(
                    def: d,
                    unlocked: d.condition(ctx),
                  )),

          const SizedBox(height: 20),
          _SectionHeader(title: 'Behavioral Badges'),
          ...defs
              .where((d) => d.tier == AchievementTier.behavioral)
              .map((d) => _AchievementCard(
                    def: d,
                    unlocked: d.condition(ctx),
                  )),

          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.rocket_launch,
                          color: AppTheme.accent, size: 20),
                      const SizedBox(width: 8),
                      const Text('Next milestone',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'If you hold your current pace, you will reach '
                    '"One Week Strong" in 2 days.',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 13),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title,
          style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final AchievementDef def;
  final bool unlocked;

  const _AchievementCard({
    required this.def,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        color: unlocked ? AppTheme.accent.withValues(alpha: 0.1) : null,
        child: ListTile(
          leading: Icon(
            unlocked ? Icons.emoji_events : Icons.lock_outline,
            color: unlocked ? Colors.amber : Colors.white24,
            size: 28,
          ),
          title: Text(
            def.title,
            style: TextStyle(
              color: unlocked ? Colors.white : Colors.white38,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(def.description,
                  style: TextStyle(
                    color: unlocked ? Colors.white54 : Colors.white24,
                    fontSize: 12,
                  )),
              if (unlocked) ...[
                const SizedBox(height: 4),
                Text(def.insight,
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
