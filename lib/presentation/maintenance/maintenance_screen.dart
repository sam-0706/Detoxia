import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance Mode')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: AppTheme.success.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.verified,
                      color: AppTheme.success, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'Program Complete',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You have graduated from the 12-week program. '
                    'The app continues to watch for regression '
                    'and supports your long-term recovery.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          _MaintenanceCard(
            icon: Icons.check_circle_outline,
            title: 'Lighter Check-ins',
            description:
                'Daily check-in is now optional. '
                'A simple 3-tap check-in keeps the engine learning.',
          ),
          _MaintenanceCard(
            icon: Icons.shield,
            title: 'Active Protection',
            description:
                'Risk calendar and notifications remain active, '
                'firing only for high-risk windows (score > 0.8).',
          ),
          _MaintenanceCard(
            icon: Icons.warning_amber,
            title: 'Regression Detection',
            description:
                'The engine monitors for regression signals: '
                'sleep decline, returning slips, or score drops. '
                'It will re-escalate if needed.',
          ),
          _MaintenanceCard(
            icon: Icons.calendar_month,
            title: 'Quarterly Reviews',
            description:
                'Every 90 days: side-by-side comparison of '
                'Day 1 vs Now, with all metrics compared.',
          ),
          _MaintenanceCard(
            icon: Icons.replay,
            title: 'Booster Available',
            description:
                'If you need it, a focused 4-week booster program '
                'is available anytime to reinforce your skills.',
          ),
        ],
      ),
    );
  }
}

class _MaintenanceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _MaintenanceCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: AppTheme.accent),
          title: Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
          subtitle: Text(description,
              style: const TextStyle(
                  color: Colors.white54, fontSize: 13)),
        ),
      ),
    );
  }
}
