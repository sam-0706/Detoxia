import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/routine/models/menstrual_phase.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:flutter/material.dart';

class CycleContextNote extends StatelessWidget {
  final SupportProfile profile;

  const CycleContextNote({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final menstrualProfile = profile.menstrualProfile;
    if (menstrualProfile == null || !menstrualProfile.enabled) {
      return const SizedBox.shrink();
    }

    final sentence = switch (menstrualProfile.currentPhase) {
      MenstrualPhase.menstruation =>
        'Menstruation phase. Rest and gentle resets work best today.',
      MenstrualPhase.follicular =>
        'Follicular phase. Energy tends to lift — good day for harder tasks.',
      MenstrualPhase.ovulation =>
        'Ovulation phase. High mood and energy possible.',
      MenstrualPhase.luteal =>
        'Luteal phase may be increasing sleep/mood sensitivity today.',
      MenstrualPhase.unknown => null,
    };

    if (sentence == null) return const SizedBox.shrink();

    return Card(
      color: AppTheme.pinkAccent.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(Icons.favorite_outline, color: AppTheme.pinkAccent, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                sentence,
                style:  TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
