import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';

class DayContext {
  final int dayOfWeek; // 1=Mon ... 7=Sun (DateTime convention)
  final DayType dayType;
  final TimeOfDay wakeTime;
  final TimeOfDay sleepTime;
  final double structureLevel;
  final double freeHours;
  final Duration peakShift;

  const DayContext({
    required this.dayOfWeek,
    required this.dayType,
    required this.wakeTime,
    required this.sleepTime,
    required this.structureLevel,
    required this.freeHours,
    required this.peakShift,
  });

  factory DayContext.fromProfile(UserProfile profile, int dayOfWeek) {
    final isOff = profile.isOffDay(dayOfWeek);
    final wake = profile.wakeTimeFor(dayOfWeek);
    final sleep = profile.sleepTimeFor(dayOfWeek);

    final dayType = _classifyDay(profile, dayOfWeek);

    double structureLevel;
    double freeHours;
    if (isOff) {
      structureLevel = 0.2;
      freeHours = 14.0;
    } else if (profile.isWorkingOrStudying &&
        profile.workStart != null &&
        profile.workEnd != null) {
      final workMinutes = (profile.workEnd!.hour * 60 +
              profile.workEnd!.minute) -
          (profile.workStart!.hour * 60 + profile.workStart!.minute);
      structureLevel = (workMinutes / (16 * 60)).clamp(0.0, 1.0);
      freeHours = (16 - workMinutes / 60).clamp(0, 16);
    } else {
      structureLevel = 0.3;
      freeHours = 12.0;
    }

    final peakShift = isOff ? profile.sleepTimeDifference : Duration.zero;

    return DayContext(
      dayOfWeek: dayOfWeek,
      dayType: dayType,
      wakeTime: wake,
      sleepTime: sleep,
      structureLevel: structureLevel,
      freeHours: freeHours,
      peakShift: peakShift,
    );
  }

  static DayType _classifyDay(UserProfile profile, int dayOfWeek) {
    if (!profile.isWorkingOrStudying || profile.workDays.isEmpty) {
      return profile.isOffDay(dayOfWeek)
          ? DayType.offDay
          : DayType.workDay;
    }

    final isWork = profile.isWorkDay(dayOfWeek);
    if (!isWork) return DayType.offDay;

    final nextDay = dayOfWeek == 7 ? 1 : dayOfWeek + 1;
    final prevDay = dayOfWeek == 1 ? 7 : dayOfWeek - 1;

    if (!profile.isWorkDay(nextDay)) return DayType.transitionEvening;
    if (!profile.isWorkDay(prevDay)) return DayType.transitionMorning;

    return DayType.workDay;
  }

  double get dayTypeMultiplier {
    switch (dayType) {
      case DayType.offDay:
        return 1.15;
      case DayType.transitionEvening:
        return 1.25;
      case DayType.transitionMorning:
        return 1.15;
      case DayType.workDay:
        return 1.0;
    }
  }
}
