import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/constants/helplines.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/repositories/user_repository.dart';
import 'package:detoxia/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  NotificationMode _notifMode = NotificationMode.balanced;
  String _userCountry = '';

  @override
  void initState() {
    super.initState();
    _loadCountry();
  }

  Future<void> _loadCountry() async {
    final user = await ref.read(userRepositoryProvider).getUser();
    if (user != null && mounted) {
      setState(() => _userCountry = user.country);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle(title: 'Notifications'),
          Card(
            child: Column(
              children: NotificationMode.values.map((mode) {
                final isSelected = mode == _notifMode;
                return ListTile(
                  title: Text(
                    switch (mode) {
                      NotificationMode.strict =>
                        'Strict (up to 5/day)',
                      NotificationMode.balanced =>
                        'Balanced (up to 3/day)',
                      NotificationMode.gentle =>
                        'Gentle (up to 1/day)',
                    },
                    style: const TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color:
                        isSelected ? AppTheme.accent : Colors.white38,
                  ),
                  onTap: () {
                    setState(() => _notifMode = mode);
                    ref
                        .read(notificationServiceProvider)
                        .setMode(mode);
                  },
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),
          _SectionTitle(title: 'Get Professional Help'),
          const Text(
            'Recovery is brave. Sometimes you need someone to talk to '
            'who truly understands. These are real, verified helplines '
            'in your country.',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 12),
          _buildHelplineCards(),

          const SizedBox(height: 24),
          _SectionTitle(title: 'About'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detoxia v1.0',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'All your recovery data stays 100% on your device. '
                    'We never see your behavioral data.',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelplineCards() {
    final helplines = getHelplines(_userCountry);

    return Column(
      children: helplines.map((h) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.phone, color: Colors.white70),
            title: Text(h.name,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(h.number,
                    style: TextStyle(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                Text(h.description,
                    style: const TextStyle(
                        color: Colors.white38, fontSize: 12)),
              ],
            ),
            isThreeLine: true,
          ),
        );
      }).toList(),
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
      child: Text(title,
          style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
