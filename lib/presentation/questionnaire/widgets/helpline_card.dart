import 'package:detoxia/core/constants/helplines.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class HelplineCard extends StatelessWidget {
  final HelplineEntry helpline;

  const HelplineCard({
    super.key,
    required this.helpline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.palette(context).surfaceRaised.withValues(alpha: 0.5),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppTheme.palette(context).textPrimary.withValues(alpha: 0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    helpline.name,
                    style: TextStyle(
                      color: AppTheme.palette(context).textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SelectableText(
                    helpline.number,
                    style: TextStyle(
                      color: AppTheme.palette(context).accent,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    helpline.description,
                    style: TextStyle(
                      color: AppTheme.palette(context).textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.palette(context).accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon:  Icon(Icons.phone, color: AppTheme.palette(context).textPrimary),
                iconSize: 22,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Dial ${helpline.number} to reach ${helpline.name}'),
                      backgroundColor: AppTheme.palette(context).accent,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 4),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
