import 'package:detoxia/core/constants/helplines.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/helpline_card.dart';

class SafetyGateScreen extends ConsumerWidget {
  final RegistrationProfile profile;
  final int sessionId;

  const SafetyGateScreen({
    super.key,
    required this.profile,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final helplines = _getHelplinesForCountry(profile.countryCode);
    final p = AppTheme.palette(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                "You matter. You're not alone.",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                "These thoughts can be scary, and they don't define you. "
                "Talking to someone trained to help can make a big difference.",
                style: TextStyle(
                  color: p.textSecondary,
                  fontSize: 17,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "If you're in immediate danger, please reach out:",
                style: TextStyle(
                  color: p.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ...helplines.map((h) => HelplineCard(helpline: h)),
              const SizedBox(height: 32),
              // Reaching out is the primary action here. Giving "continue the
              // questionnaire" the filled button would visually nudge someone
              // straight past the help offer on the one screen where that
              // matters most.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (helplines.isEmpty) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please dial ${helplines.first.number} to reach ${helplines.first.name}',
                        ),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: const Text(
                    'I need to talk to someone now',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    await ref
                        .read(questionnaireRepositoryProvider)
                        .markSafetyGateTriggered(sessionId);
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: p.textSecondary,
                    side: BorderSide(color: p.borderStrong, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: const Text(
                    'I want to continue the questionnaire',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: p.borderSubtle),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 16,
                      color: p.calm,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Detoxia keeps your answers on this device.',
                        style: TextStyle(color: p.textTertiary, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<HelplineEntry> _getHelplinesForCountry(String countryCode) {
    // Map common country codes to full country names used in helplines.dart
    final countryMapping = {
      'IN': 'India',
      'US': 'United States',
      'GB': 'United Kingdom',
      'UK': 'United Kingdom',
      'CA': 'Canada',
      'AU': 'Australia',
      'DE': 'Germany',
      'FR': 'France',
      'BR': 'Brazil',
      'NG': 'Nigeria',
      'ZA': 'South Africa',
      'AE': 'UAE',
      'SA': 'Saudi Arabia',
      'PK': 'Pakistan',
      'BD': 'Bangladesh',
      'PH': 'Philippines',
      'ID': 'Indonesia',
      'MX': 'Mexico',
      'JP': 'Japan',
      'KR': 'South Korea',
      'TR': 'Turkey',
      'EG': 'Egypt',
      'KE': 'Kenya',
    };

    final country = countryMapping[countryCode.toUpperCase()];
    if (country != null) {
      return getHelplines(country);
    }
    return getHelplines('');
  }
}
