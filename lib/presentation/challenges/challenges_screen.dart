import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Challenges')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Active Challenges',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),

          _ChallengeCard(
            title: 'The 30-Day Sleep Guardian',
            description:
                'Respect sleep boundary every night for 30 days.',
            progress: 0.0,
            target: 30,
            icon: Icons.nightlight,
          ),
          _ChallengeCard(
            title: 'Weekend Warrior Month',
            description: '4 consecutive clean weekends.',
            progress: 0.0,
            target: 4,
            icon: Icons.calendar_today,
          ),
          _ChallengeCard(
            title: 'Urge Master',
            description:
                'Successfully surf 20 urges in a month.',
            progress: 0.0,
            target: 20,
            icon: Icons.waves,
          ),
          _ChallengeCard(
            title: 'Phone-Free Mornings',
            description:
                'No phone for 30 min after waking, every day.',
            progress: 0.0,
            target: 30,
            icon: Icons.phone_disabled,
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final double progress;
  final int target;
  final IconData icon;

  const _ChallengeCard({
    required this.title,
    required this.description,
    required this.progress,
    required this.target,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppTheme.accent, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                  Text(
                    '${(progress * target).round()}/$target',
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(description,
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white12,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
