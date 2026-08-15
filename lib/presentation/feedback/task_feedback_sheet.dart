import 'package:detoxia/core/event_bus/event_bus.dart';
import 'package:detoxia/core/event_bus/events.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/learning/models/intervention_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<InterventionFeedback?> showTaskFeedback(
  BuildContext context, {
  required String interventionId,
}) async {
  final eventBus = _maybeEventBus(context);
  final feedback = await showModalBottomSheet<InterventionFeedback>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => const _TaskFeedbackSheet(),
  );
  if (feedback != null && eventBus != null) {
    eventBus.fire(
      InterventionFeedbackEvent(
        interventionId: interventionId,
        feedback: feedback,
      ),
    );
  }
  return feedback;
}

EventBus? _maybeEventBus(BuildContext context) {
  try {
    return ProviderScope.containerOf(
      context,
      listen: false,
    ).read(eventBusProvider);
  } catch (_) {
    return null;
  }
}

class _TaskFeedbackSheet extends StatelessWidget {
  const _TaskFeedbackSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.palette(context).borderStrong,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Did this task help?',
              style: TextStyle(
                color: AppTheme.palette(context).textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your answer helps tune future tasks to what actually supports you.',
              style: TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.4),
            ),
            const SizedBox(height: 18),
            _FeedbackOption(
              label: 'Helped',
              color: AppTheme.palette(context).success,
              onTap: () =>
                  Navigator.of(context).pop(InterventionFeedback.helped),
            ),
            _FeedbackOption(
              label: 'Somewhat',
              color: AppTheme.palette(context).accent,
              onTap: () =>
                  Navigator.of(context).pop(InterventionFeedback.somewhat),
            ),
            _FeedbackOption(
              label: 'Did not help',
              color: AppTheme.palette(context).warning,
              onTap: () =>
                  Navigator.of(context).pop(InterventionFeedback.didNotHelp),
            ),
            _FeedbackOption(
              label: 'Ignored',
              color: AppTheme.palette(context).textSecondary,
              onTap: () =>
                  Navigator.of(context).pop(InterventionFeedback.ignored),
            ),
            _FeedbackOption(
              label: 'Reset moment after task',
              color: const Color(0xFFFF8A65),
              compact: true,
              onTap: () => Navigator.of(
                context,
              ).pop(InterventionFeedback.slippedAfterTask),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackOption extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool compact;

  const _FeedbackOption({
    required this.label,
    required this.color,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: BoxConstraints(minHeight: compact ? 48 : 56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: compact ? 0.08 : 0.14),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.28)),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              color: compact ? AppTheme.palette(context).textSecondary : AppTheme.palette(context).textPrimary,
              fontSize: compact ? 14 : 16,
              fontWeight: compact ? FontWeight.w500 : FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
