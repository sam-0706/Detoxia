import 'package:detoxia/core/constants/enums.dart';

sealed class AppEvent {
  final DateTime timestamp;
  AppEvent({DateTime? timestamp}) : timestamp = timestamp ?? DateTime.now();
}

class UrgeReportedEvent extends AppEvent {
  final TriggerType trigger;
  final int intensityBefore;
  final String? location;

  UrgeReportedEvent({
    required this.trigger,
    required this.intensityBefore,
    this.location,
    super.timestamp,
  });
}

class RescueCompletedEvent extends AppEvent {
  final int urgeEventId;
  final String interventionType;
  final int intensityAfter;
  final UrgeOutcome outcome;

  RescueCompletedEvent({
    required this.urgeEventId,
    required this.interventionType,
    required this.intensityAfter,
    required this.outcome,
    super.timestamp,
  });
}

class SlipLoggedEvent extends AppEvent {
  final BehaviorType behaviorType;
  final List<TriggerType> triggerChain;
  final bool precededByScrolling;
  final String? reflectionNote;
  final EventSource source;

  SlipLoggedEvent({
    required this.behaviorType,
    required this.triggerChain,
    required this.precededByScrolling,
    this.reflectionNote,
    this.source = EventSource.realtime,
    super.timestamp,
  });
}

class CheckInCompletedEvent extends AppEvent {
  final bool hadUrge;
  final int? urgeMax;
  final TriggerType? mainTrigger;
  final bool slipped;
  final int slipCount;
  final int sleepQuality;
  final int mood;
  final int stress;
  final int confidenceTomorrow;

  CheckInCompletedEvent({
    required this.hadUrge,
    this.urgeMax,
    this.mainTrigger,
    required this.slipped,
    this.slipCount = 0,
    required this.sleepQuality,
    required this.mood,
    required this.stress,
    required this.confidenceTomorrow,
    super.timestamp,
  });
}

class StreakBrokenEvent extends AppEvent {
  final StreakType streakType;
  final int? peakId;
  final int lengthBeforeBreak;

  StreakBrokenEvent({
    required this.streakType,
    this.peakId,
    required this.lengthBeforeBreak,
    super.timestamp,
  });
}
