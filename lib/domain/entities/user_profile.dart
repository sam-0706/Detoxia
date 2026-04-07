import 'package:detoxia/core/constants/enums.dart';
import 'package:flutter/material.dart';

class UserProfile {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String country;
  final RoleType roleType;
  final List<int> workDays;
  final TimeOfDay? workStart;
  final TimeOfDay? workEnd;
  final TimeOfDay weekdayWakeTime;
  final TimeOfDay weekdaySleepTime;
  final TimeOfDay offdayWakeTime;
  final TimeOfDay offdaySleepTime;
  final List<BehaviorType> struggles;
  final ScrollingLinkage scrollingTriggersSexual;
  final List<TriggerType> triggers;
  final StruggleDuration struggleDuration;
  final ResistAbility resistAbility;
  final GoalType goalType;
  final List<MotivationType> motivations;
  final bool weekendDifferent;

  const UserProfile({
    this.id,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.country = '',
    required this.roleType,
    this.workDays = const [],
    this.workStart,
    this.workEnd,
    required this.weekdayWakeTime,
    required this.weekdaySleepTime,
    required this.offdayWakeTime,
    required this.offdaySleepTime,
    this.struggles = const [],
    this.scrollingTriggersSexual = ScrollingLinkage.never,
    this.triggers = const [],
    required this.struggleDuration,
    required this.resistAbility,
    required this.goalType,
    this.motivations = const [],
    this.weekendDifferent = false,
  });

  bool get isWorkingOrStudying =>
      roleType == RoleType.working || roleType == RoleType.student;

  bool isWorkDay(int dayOfWeek) => workDays.contains(dayOfWeek);

  bool isOffDay(int dayOfWeek) => !isWorkDay(dayOfWeek);

  TimeOfDay wakeTimeFor(int dayOfWeek) =>
      isOffDay(dayOfWeek) ? offdayWakeTime : weekdayWakeTime;

  TimeOfDay sleepTimeFor(int dayOfWeek) =>
      isOffDay(dayOfWeek) ? offdaySleepTime : weekdaySleepTime;

  Duration get wakeTimeDifference {
    final weekdayMinutes =
        weekdayWakeTime.hour * 60 + weekdayWakeTime.minute;
    final offdayMinutes =
        offdayWakeTime.hour * 60 + offdayWakeTime.minute;
    return Duration(minutes: offdayMinutes - weekdayMinutes);
  }

  Duration get sleepTimeDifference {
    final weekdayMinutes =
        weekdaySleepTime.hour * 60 + weekdaySleepTime.minute;
    final offdayMinutes =
        offdaySleepTime.hour * 60 + offdaySleepTime.minute;
    return Duration(minutes: offdayMinutes - weekdayMinutes);
  }

  bool get hasLinkedPathway =>
      scrollingTriggersSexual == ScrollingLinkage.always ||
      scrollingTriggersSexual == ScrollingLinkage.sometimes;
}
