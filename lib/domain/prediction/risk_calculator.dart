import 'dart:math';

import 'package:detoxia/core/constants/app_constants.dart';
import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/domain/entities/peak_node.dart';
import 'package:detoxia/domain/entities/user_profile.dart';
import 'package:detoxia/domain/prediction/day_context.dart';

class RiskBlock {
  final int dayOfWeek;
  final int blockIndex;
  final int startMinute;
  final int endMinute;
  final double score;
  final int? nearestPeakId;
  final String? dominantTrigger;

  const RiskBlock({
    required this.dayOfWeek,
    required this.blockIndex,
    required this.startMinute,
    required this.endMinute,
    required this.score,
    this.nearestPeakId,
    this.dominantTrigger,
  });
}

class RecentState {
  final double sleepQuality;
  final double stress;
  final double mood;
  final double confidenceTomorrow;
  final bool recentSlip;
  final int slipsToday;
  final Set<int> peakIdsSlippedToday;

  const RecentState({
    this.sleepQuality = 3.0,
    this.stress = 5.0,
    this.mood = 5.0,
    this.confidenceTomorrow = 5.0,
    this.recentSlip = false,
    this.slipsToday = 0,
    this.peakIdsSlippedToday = const {},
  });
}

class RiskCalculator {
  final UserProfile profile;
  final List<PeakNodeEntity> peaks;

  RiskCalculator({required this.profile, required this.peaks});

  List<RiskBlock> calculateDay(int dayOfWeek, RecentState state) {
    final dayCtx = DayContext.fromProfile(profile, dayOfWeek);
    final blocks = <RiskBlock>[];

    for (int i = 0; i < AppConstants.blocksPerDay; i++) {
      final startMin = i * AppConstants.blockDurationMinutes;
      final endMin = startMin + AppConstants.blockDurationMinutes;
      final midMin = startMin + AppConstants.blockDurationMinutes ~/ 2;

      final timeRisk = _timeWindowRisk(midMin, dayCtx);
      final triggerRisk = _triggerProbability(midMin, dayCtx);
      final contextRisk = _contextRisk(midMin, dayCtx);
      final habitStrength = _habitStrength();
      final stateModifier = _recentStateModifier(midMin, dayCtx, state);

      final nearestPeak = _nearestPeak(midMin, dayCtx);

      final rawScore = AppConstants.w1TimeWindow * timeRisk +
          AppConstants.w2Trigger * triggerRisk +
          AppConstants.w3Context * contextRisk +
          AppConstants.w4Habit * habitStrength +
          AppConstants.w5State * stateModifier;

      blocks.add(RiskBlock(
        dayOfWeek: dayOfWeek,
        blockIndex: i,
        startMinute: startMin,
        endMinute: endMin,
        score: rawScore.clamp(0.0, 1.0),
        nearestPeakId: nearestPeak?.id,
      ));
    }

    return blocks;
  }

  List<List<RiskBlock>> calculateWeek(RecentState state) {
    return List.generate(
      7,
      (i) => calculateDay(i + 1, state),
    );
  }

  double _timeWindowRisk(int minuteOfDay, DayContext dayCtx) {
    final shift = dayCtx.peakShift;

    for (final peak in peaks) {
      final shiftedCenter = peak.centerMinutes + shift.inMinutes;
      final shiftedStart =
          shiftedCenter - peak.windowRadiusMinutes;
      final shiftedEnd =
          shiftedCenter + peak.windowRadiusMinutes;

      if (minuteOfDay >= shiftedStart && minuteOfDay <= shiftedEnd) {
        var base = peak.frequencyWeight;
        base *= dayCtx.dayTypeMultiplier;
        if (peak.isHardest) base *= 1.2;
        return base.clamp(0.0, 1.0);
      }

      if (minuteOfDay >= shiftedStart - 60 &&
          minuteOfDay <= shiftedEnd + 60) {
        return 0.5;
      }
    }

    final isOff = dayCtx.dayType == DayType.offDay;
    if (isOff) return 0.4;

    if (_isDuringWork(minuteOfDay, dayCtx)) return 0.15;
    if (_isDuringSleep(minuteOfDay, dayCtx)) return 0.05;

    return 0.25;
  }

  double _triggerProbability(int minuteOfDay, DayContext dayCtx) {
    final nearestPeak = _nearestPeak(minuteOfDay, dayCtx);
    double prob = 0.2;

    if (nearestPeak != null) {
      if (profile.triggers.contains(TriggerType.scrolling) &&
          profile.hasLinkedPathway) {
        prob += 0.3;
      }
      if (profile.triggers.contains(TriggerType.boredom) &&
          dayCtx.dayType == DayType.offDay) {
        prob += 0.2;
      }
    }

    final sleepMin =
        dayCtx.sleepTime.hour * 60 + dayCtx.sleepTime.minute;
    if ((minuteOfDay - sleepMin).abs() < 60) {
      prob += 0.3;
    }

    if (profile.isWorkingOrStudying &&
        profile.workEnd != null) {
      final workEndMin =
          profile.workEnd!.hour * 60 + profile.workEnd!.minute;
      if (minuteOfDay > workEndMin &&
          minuteOfDay < workEndMin + 120) {
        prob += 0.25;
      }
    }

    return prob.clamp(0.0, 1.0);
  }

  double _contextRisk(int minuteOfDay, DayContext dayCtx) {
    final sleepMin =
        dayCtx.sleepTime.hour * 60 + dayCtx.sleepTime.minute;
    final wakeMin =
        dayCtx.wakeTime.hour * 60 + dayCtx.wakeTime.minute;

    if ((minuteOfDay - sleepMin).abs() < 60) return 0.9;
    if ((minuteOfDay - wakeMin).abs() < 30) return 0.7;
    if (dayCtx.dayType == DayType.offDay &&
        !_isDuringWork(minuteOfDay, dayCtx)) {
      return 0.6;
    }
    if (_isDuringWork(minuteOfDay, dayCtx)) return 0.2;

    return 0.4;
  }

  double _habitStrength() {
    double durationScore;
    switch (profile.struggleDuration ?? StruggleDuration.twoToFiveYears) {
      case StruggleDuration.lessThan6Months:
        durationScore = 0.3;
      case StruggleDuration.sixToTwoYears:
        durationScore = 0.5;
      case StruggleDuration.twoToFiveYears:
        durationScore = 0.7;
      case StruggleDuration.fivePlusYears:
        durationScore = 1.0;
    }

    double controlScore;
    switch (profile.resistAbility ?? ResistAbility.sometimes) {
      case ResistAbility.rarely:
        controlScore = 1.0;
      case ResistAbility.sometimes:
        controlScore = 0.7;
      case ResistAbility.aboutHalf:
        controlScore = 0.5;
      case ResistAbility.usually:
        controlScore = 0.2;
    }

    final freqMultiplier = peaks.length <= 1
        ? 0.6
        : peaks.length <= 3
            ? 0.8
            : 1.0;

    return ((durationScore + controlScore) / 2) * freqMultiplier;
  }

  double _recentStateModifier(
    int minuteOfDay,
    DayContext dayCtx,
    RecentState state,
  ) {
    double modifier = 0.0;
    if (state.sleepQuality < 2) modifier += 0.3;
    if (state.stress > 7) modifier += 0.25;
    if (state.mood < 3) modifier += 0.2;
    if (state.confidenceTomorrow < 3) modifier += 0.3;
    if (state.recentSlip) modifier += 0.2;

    final nearestPeak = _nearestPeak(minuteOfDay, dayCtx);
    if (nearestPeak != null &&
        state.peakIdsSlippedToday.contains(nearestPeak.id)) {
      modifier += 0.35;
    } else if (state.slipsToday > 0) {
      modifier += 0.15;
    }

    return min(modifier, 1.0);
  }

  PeakNodeEntity? _nearestPeak(int minuteOfDay, DayContext dayCtx) {
    final shift = dayCtx.peakShift;
    PeakNodeEntity? nearest;
    int minDist = 999999;

    for (final peak in peaks) {
      final shifted = peak.centerMinutes + shift.inMinutes;
      final dist = (minuteOfDay - shifted).abs();
      if (dist < minDist &&
          peak.isNear(minuteOfDay - shift.inMinutes)) {
        minDist = dist;
        nearest = peak;
      }
    }
    return nearest;
  }

  bool _isDuringWork(int minuteOfDay, DayContext dayCtx) {
    if (!profile.isWorkingOrStudying ||
        profile.workStart == null ||
        profile.workEnd == null) {
      return false;
    }
    if (dayCtx.dayType == DayType.offDay) return false;
    final startMin =
        profile.workStart!.hour * 60 + profile.workStart!.minute;
    final endMin =
        profile.workEnd!.hour * 60 + profile.workEnd!.minute;
    return minuteOfDay >= startMin && minuteOfDay <= endMin;
  }

  bool _isDuringSleep(int minuteOfDay, DayContext dayCtx) {
    final sleepMin =
        dayCtx.sleepTime.hour * 60 + dayCtx.sleepTime.minute;
    final wakeMin =
        dayCtx.wakeTime.hour * 60 + dayCtx.wakeTime.minute;
    if (sleepMin > wakeMin) {
      return minuteOfDay >= sleepMin || minuteOfDay <= wakeMin;
    }
    return minuteOfDay >= sleepMin && minuteOfDay <= wakeMin;
  }
}
