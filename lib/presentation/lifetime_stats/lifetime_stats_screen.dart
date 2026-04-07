import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LifetimeStatsScreen extends ConsumerWidget {
  const LifetimeStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lifetime Stats')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Your journey',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),

          Row(
            children: [
              _StatCard(
                  label: 'Clean Days', value: '0', icon: Icons.sunny),
              const SizedBox(width: 12),
              _StatCard(
                  label: 'Urges Resisted',
                  value: '0',
                  icon: Icons.shield),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatCard(
                  label: 'Best Streak',
                  value: '0d',
                  icon: Icons.local_fire_department),
              const SizedBox(width: 12),
              _StatCard(
                  label: 'Rescues Done',
                  value: '0',
                  icon: Icons.health_and_safety),
            ],
          ),

          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.trending_up,
                          color: AppTheme.success),
                      const SizedBox(width: 8),
                      const Text('Recovery Score',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: 0.0,
                    backgroundColor: Colors.white12,
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '30-day rolling composite score. '
                    'This number trends upward over months.',
                    style: TextStyle(
                        color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Long-term Insights',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _InsightRow(
                    icon: Icons.info_outline,
                    text: 'Keep using the app to unlock insights '
                        'like "Your risk drops 45% on days you '
                        'exercise" (available after 3+ months).',
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, color: AppTheme.accent, size: 28),
              const SizedBox(height: 8),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InsightRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.accent, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 13)),
        ),
      ],
    );
  }
}
