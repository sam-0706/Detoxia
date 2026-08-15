import 'package:detoxia/domain/routine/models/menstrual_phase.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/services/notification_service.dart';

class UnifiedNotificationScheduler {
  final NotificationService notifications;

  const UnifiedNotificationScheduler(this.notifications);

  Future<void> scheduleDailyForProfile(
    SupportProfile profile,
    DateTime now,
  ) async {
    final candidates = _buildCandidates(profile, now)
      ..sort((a, b) => b.priority.compareTo(a.priority));
    var scheduled = 0;

    for (final candidate in candidates) {
      if (scheduled >= notifications.maxNotificationsPerDay) break;
      if (!candidate.scheduledTime.isAfter(now)) continue;
      await notifications.scheduleUnifiedNotification(
        id: candidate.id,
        title: candidate.title,
        body: candidate.body,
        scheduledTime: candidate.scheduledTime,
      );
      scheduled++;
    }
  }

  List<_NotificationCandidate> _buildCandidates(
    SupportProfile profile,
    DateTime now,
  ) {
    final cycleSuffix = _cycleSuffix(profile);
    return [
      if (_hasHighRoutineRisk(profile))
        _NotificationCandidate(
          id: 1000,
          title: 'Support window ahead',
          body:
              'Because your evening alone-time window is on your support map, it is starting soon. Want a 2-minute reset?$cycleSuffix',
          scheduledTime: _todayAt(now, 17, 45),
          priority: 95,
        ),
      if (profile.routineProfile.phoneInBedScore >= 2)
        _NotificationCandidate(
          id: 1001,
          title: 'Bedtime support',
          body:
              'Because late-night phone time and poor sleep are a risky combo on your map, try a 2-minute reset before bed.$cycleSuffix',
          scheduledTime: _minutesToday(
            now,
            profile.sleepProfile.estimatedSleepStartMinutes - 45,
          ),
          priority: 90,
        ),
      if (_hasPostWorkRisk(profile))
        _NotificationCandidate(
          id: 1002,
          title: 'Post-work reset',
          body:
              'Because post-work stress is one of your top drivers, decompress before scrolling.$cycleSuffix',
          scheduledTime: _todayAt(now, 17, 30),
          priority: 85,
        ),
      if (_hasCommuteRisk(profile))
        _NotificationCandidate(
          id: 1003,
          title: 'Commute plan',
          body:
              'Because commute scrolling is on your map, pre-pick something else for the ride home.$cycleSuffix',
          scheduledTime: _todayAt(now, 17, 15),
          priority: 80,
        ),
      if (profile.sleepProfile.sleepDebtScore >= 7)
        _NotificationCandidate(
          id: 1004,
          title: 'Sleep debt support',
          body:
              "Because sleep debt is high this week, tonight's earlier wind-down would help.$cycleSuffix",
          scheduledTime: _minutesToday(
            now,
            profile.sleepProfile.estimatedSleepStartMinutes - 120,
          ),
          priority: 75,
        ),
      if (_hasHighAnxietyOrStress(profile))
        _NotificationCandidate(
          id: 1005,
          title: 'Breathing reset',
          body:
              'Because anxiety or stress is elevated on your support map, try a 90-second breathing reset.$cycleSuffix',
          scheduledTime: _todayAt(now, 13, 0),
          priority: 70,
        ),
    ];
  }

  bool _hasHighRoutineRisk(SupportProfile profile) {
    return profile.pathwayScores.any(
          (score) => score.enabled && score.routineRisk >= 7,
        ) ||
        profile.routineProfile.aloneWindows.isNotEmpty ||
        profile.routineProfile.vulnerableWindows.isNotEmpty;
  }

  bool _hasPostWorkRisk(SupportProfile profile) {
    return profile.pathwayScores.any((score) {
      final text = '${score.pathwayId} ${score.label} ${score.explanation}'
          .toLowerCase();
      return score.enabled &&
          score.score0To10 >= 6 &&
          text.contains('post') &&
          text.contains('work');
    });
  }

  bool _hasCommuteRisk(SupportProfile profile) {
    return profile.routineProfile.commutePhoneUseScore >= 2 ||
        profile.pathwayScores.any((score) {
          final text = '${score.pathwayId} ${score.label} ${score.explanation}'
              .toLowerCase();
          return score.enabled &&
              score.routineRisk >= 6 &&
              text.contains('commute');
        });
  }

  bool _hasHighAnxietyOrStress(SupportProfile profile) {
    return profile.domainScores.any((score) {
      final text = '${score.id} ${score.label}'.toLowerCase();
      return score.enabled &&
          score.visibleScore >= 7 &&
          (text.contains('anxiety') || text.contains('stress'));
    });
  }

  String _cycleSuffix(SupportProfile profile) {
    final menstrual = profile.menstrualProfile;
    if (menstrual == null ||
        !menstrual.enabled ||
        menstrual.currentPhase != MenstrualPhase.luteal) {
      return '';
    }
    return ' Luteal phase may be amplifying today.';
  }

  DateTime _todayAt(DateTime now, int hour, int minute) {
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  DateTime _minutesToday(DateTime now, int minutes) {
    final normalized = minutes.clamp(0, 23 * 60 + 59);
    return DateTime(
      now.year,
      now.month,
      now.day,
      normalized ~/ 60,
      normalized % 60,
    );
  }
}

class _NotificationCandidate {
  final int id;
  final String title;
  final String body;
  final DateTime scheduledTime;
  final int priority;

  const _NotificationCandidate({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    required this.priority,
  });
}
