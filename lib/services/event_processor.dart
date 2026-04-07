import 'dart:async';

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/event_bus/event_bus.dart';
import 'package:detoxia/core/event_bus/events.dart';
import 'package:detoxia/data/repositories/event_repository.dart';
import 'package:detoxia/data/repositories/peak_repository.dart';
import 'package:detoxia/data/repositories/user_repository.dart';
import 'package:detoxia/domain/prediction/adaptive_updater.dart';
import 'package:detoxia/domain/prediction/cascade_detector.dart';
import 'package:detoxia/domain/prediction/linked_pathway_detector.dart';
import 'package:detoxia/domain/prediction/risk_calculator.dart';
import 'package:detoxia/domain/prediction/trigger_model.dart';
import 'package:detoxia/domain/streaks/streak_manager.dart';
import 'package:detoxia/services/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventProcessor {
  final EventBus _eventBus;
  final EventRepository _eventRepo;
  final UserRepository _userRepo;
  final PeakRepository _peakRepo;
  final NotificationService _notifService;

  final TriggerModel triggerModel = TriggerModel();
  final StreakManager streakManager = StreakManager();
  final AdaptiveUpdater adaptiveUpdater = AdaptiveUpdater();
  final CascadeDetector cascadeDetector = CascadeDetector();
  final LinkedPathwayDetector linkedPathwayDetector =
      LinkedPathwayDetector();

  StreamSubscription? _subscription;

  EventProcessor({
    required EventBus eventBus,
    required EventRepository eventRepo,
    required UserRepository userRepo,
    required PeakRepository peakRepo,
    required NotificationService notifService,
  })  : _eventBus = eventBus,
        _eventRepo = eventRepo,
        _userRepo = userRepo,
        _peakRepo = peakRepo,
        _notifService = notifService;

  void start() {
    _subscription = _eventBus.stream.listen(_handleEvent);
  }

  void dispose() {
    _subscription?.cancel();
  }

  Future<void> _handleEvent(AppEvent event) async {
    switch (event) {
      case UrgeReportedEvent():
        await _handleUrge(event);
      case SlipLoggedEvent():
        await _handleSlip(event);
      case RescueCompletedEvent():
        await _handleRescue(event);
      case CheckInCompletedEvent():
        await _handleCheckIn(event);
      case StreakBrokenEvent():
        break;
    }

    await _rescoreAndReschedule();
  }

  Future<void> _handleUrge(UrgeReportedEvent event) async {
    await _eventRepo.insertUrge(
      timestamp: event.timestamp,
      trigger: event.trigger,
      intensityBefore: event.intensityBefore,
      location: event.location,
    );

    final blockIndex =
        (event.timestamp.hour * 60 + event.timestamp.minute) ~/ 30;
    adaptiveUpdater.recordBlockEvent(
      event.timestamp.weekday,
      blockIndex,
      wasUrge: true,
      wasSlip: false,
    );
  }

  Future<void> _handleSlip(SlipLoggedEvent event) async {
    await _eventRepo.insertSlip(
      timestamp: event.timestamp,
      behaviorType: event.behaviorType,
      triggerChain: event.triggerChain,
      precededByScrolling: event.precededByScrolling,
      reflectionNote: event.reflectionNote,
      source: event.source,
    );

    for (final trigger in event.triggerChain) {
      triggerModel.recordEvent(trigger, slipped: true);
    }

    linkedPathwayDetector.recordSlip(
      precededByScrolling: event.precededByScrolling,
    );

    streakManager.breakOnSlip();

    final blockIndex =
        (event.timestamp.hour * 60 + event.timestamp.minute) ~/ 30;
    adaptiveUpdater.recordBlockEvent(
      event.timestamp.weekday,
      blockIndex,
      wasUrge: true,
      wasSlip: true,
    );
  }

  Future<void> _handleRescue(RescueCompletedEvent event) async {
    final slipped = event.outcome == UrgeOutcome.slipped;

    await _eventRepo.updateUrgeOutcome(
      event.urgeEventId,
      chosenRescue: event.interventionType,
      intensityAfter: event.intensityAfter,
      slipFollowed: slipped,
    );

    await _eventRepo.logIntervention(
      urgeEventId: event.urgeEventId,
      interventionType: event.interventionType,
      success: !slipped,
      intensityDrop: event.intensityAfter,
    );
  }

  Future<void> _handleCheckIn(CheckInCompletedEvent event) async {
    await _eventRepo.insertCheckin(
      date: event.timestamp,
      hadUrge: event.hadUrge,
      urgeMax: event.urgeMax,
      mainTrigger: event.mainTrigger,
      slipped: event.slipped,
      slipCount: event.slipCount,
      sleepQuality: event.sleepQuality,
      mood: event.mood,
      stress: event.stress,
      confidenceTomorrow: event.confidenceTomorrow,
    );
  }

  Future<void> _rescoreAndReschedule() async {
    final profile = await _userRepo.getUser();
    if (profile == null) return;

    final peaks = await _peakRepo.getAllPeaks();
    final today = DateTime.now();
    final slipsToday = await _eventRepo.getSlipsForDate(today);

    final state = RecentState(
      slipsToday: slipsToday.length,
      recentSlip: slipsToday.isNotEmpty,
    );

    final calculator = RiskCalculator(profile: profile, peaks: peaks);
    final todayBlocks = calculator.calculateDay(today.weekday, state);

    await _notifService.scheduleRiskNotifications(todayBlocks, today);
  }
}

final eventProcessorProvider = Provider<EventProcessor>((ref) {
  final processor = EventProcessor(
    eventBus: ref.watch(eventBusProvider),
    eventRepo: ref.watch(eventRepositoryProvider),
    userRepo: ref.watch(userRepositoryProvider),
    peakRepo: ref.watch(peakRepositoryProvider),
    notifService: ref.watch(notificationServiceProvider),
  );
  ref.onDispose(processor.dispose);
  return processor;
});
