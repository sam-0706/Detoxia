import 'package:detoxia/core/constants/enums.dart';
import 'package:flutter/material.dart';

class PeakNodeEntity {
  final int? id;
  final String label;
  final TimeOfDay centerTime;
  final int windowRadiusMinutes;
  final Frequency frequency;
  final List<String> dayTypes;
  final bool isHardest;
  final List<TriggerType> triggers;
  final List<String> emotionalState;
  final List<String> preContext;

  final double empiricalFrequency;
  final Map<String, double> triggerPosteriors;
  final List<String> topInterventions;
  final double avgIntensity;
  final double slipRate;
  final int currentPeakStreak;
  final int bestPeakStreak;

  const PeakNodeEntity({
    this.id,
    required this.label,
    required this.centerTime,
    this.windowRadiusMinutes = 45,
    this.frequency = Frequency.almostDaily,
    this.dayTypes = const ['both'],
    this.isHardest = false,
    this.triggers = const [],
    this.emotionalState = const [],
    this.preContext = const [],
    this.empiricalFrequency = 0.0,
    this.triggerPosteriors = const {},
    this.topInterventions = const [],
    this.avgIntensity = 5.0,
    this.slipRate = 0.5,
    this.currentPeakStreak = 0,
    this.bestPeakStreak = 0,
  });

  int get startMinutes =>
      centerTime.hour * 60 +
      centerTime.minute -
      windowRadiusMinutes;

  int get endMinutes =>
      centerTime.hour * 60 +
      centerTime.minute +
      windowRadiusMinutes;

  int get centerMinutes => centerTime.hour * 60 + centerTime.minute;

  bool containsMinute(int minuteOfDay) =>
      minuteOfDay >= startMinutes && minuteOfDay <= endMinutes;

  bool isNear(int minuteOfDay, {int adjacentMinutes = 60}) =>
      (minuteOfDay >= startMinutes - adjacentMinutes &&
          minuteOfDay <= endMinutes + adjacentMinutes);

  TimeOfDay shiftedCenter(Duration shift) {
    final totalMinutes = centerMinutes + shift.inMinutes;
    final normalized = totalMinutes % 1440;
    return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
  }

  double get frequencyWeight {
    switch (frequency) {
      case Frequency.almostDaily:
        return 1.0;
      case Frequency.fewPerWeek:
        return 0.8;
      case Frequency.sometimes:
        return 0.6;
      case Frequency.weekendsOnly:
        return 0.7;
    }
  }
}
