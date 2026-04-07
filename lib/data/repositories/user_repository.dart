import 'dart:convert';

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/utils/time_utils.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/entities/user_profile.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  final AppDatabase _db;

  UserRepository(this._db);

  Future<UserProfile?> getUser() async {
    final row = await _db.select(_db.users).getSingleOrNull();
    if (row == null) return null;
    return _fromRow(row);
  }

  Future<void> saveUser(UserProfile profile) async {
    final companion = UsersCompanion(
      name: Value(profile.name),
      email: Value(profile.email),
      phone: Value(profile.phone),
      country: Value(profile.country),
      roleType: Value(profile.roleType.name),
      workDays: Value(jsonEncode(profile.workDays)),
      workStart: Value(profile.workStart != null
          ? TimeUtils.formatTimeOfDay(profile.workStart!)
          : null),
      workEnd: Value(profile.workEnd != null
          ? TimeUtils.formatTimeOfDay(profile.workEnd!)
          : null),
      weekdayWakeTime: Value(
          TimeUtils.formatTimeOfDay(profile.weekdayWakeTime)),
      weekdaySleepTime: Value(
          TimeUtils.formatTimeOfDay(profile.weekdaySleepTime)),
      offdayWakeTime:
          Value(TimeUtils.formatTimeOfDay(profile.offdayWakeTime)),
      offdaySleepTime:
          Value(TimeUtils.formatTimeOfDay(profile.offdaySleepTime)),
      struggles: Value(
          jsonEncode(profile.struggles.map((s) => s.name).toList())),
      scrollingTriggersSexual:
          Value(profile.scrollingTriggersSexual.name),
      triggers: Value(
          jsonEncode(profile.triggers.map((t) => t.name).toList())),
      struggleDuration: Value(profile.struggleDuration.name),
      resistAbility: Value(profile.resistAbility.name),
      goalType: Value(profile.goalType.name),
      motivations: Value(
          jsonEncode(profile.motivations.map((m) => m.name).toList())),
      weekendDifferent: Value(profile.weekendDifferent),
      updatedAt: Value(DateTime.now()),
    );

    final existing = await _db.select(_db.users).getSingleOrNull();
    if (existing != null) {
      await (_db.update(_db.users)
            ..where((t) => t.id.equals(existing.id)))
          .write(companion);
    } else {
      await _db.into(_db.users).insert(companion);
    }
  }

  Future<void> markCheckedIn(bool value) async {
    final existing = await _db.select(_db.users).getSingleOrNull();
    if (existing == null) return;
    await (_db.update(_db.users)
          ..where((t) => t.id.equals(existing.id)))
        .write(UsersCompanion(checkedInToday: Value(value)));
  }

  Future<bool> hasCheckedInToday() async {
    final row = await _db.select(_db.users).getSingleOrNull();
    return row?.checkedInToday ?? false;
  }

  UserProfile _fromRow(User row) {
    return UserProfile(
      id: row.id,
      name: row.name,
      email: row.email,
      phone: row.phone,
      country: row.country,
      roleType: RoleType.values.firstWhere(
        (e) => e.name == row.roleType,
        orElse: () => RoleType.working,
      ),
      workDays: (jsonDecode(row.workDays) as List).cast<int>(),
      workStart: row.workStart != null
          ? TimeUtils.parseTimeOfDay(row.workStart!)
          : null,
      workEnd: row.workEnd != null
          ? TimeUtils.parseTimeOfDay(row.workEnd!)
          : null,
      weekdayWakeTime: TimeUtils.parseTimeOfDay(row.weekdayWakeTime),
      weekdaySleepTime:
          TimeUtils.parseTimeOfDay(row.weekdaySleepTime),
      offdayWakeTime: TimeUtils.parseTimeOfDay(row.offdayWakeTime),
      offdaySleepTime: TimeUtils.parseTimeOfDay(row.offdaySleepTime),
      struggles: (jsonDecode(row.struggles) as List)
          .map((s) => BehaviorType.values.firstWhere(
                (e) => e.name == s,
                orElse: () => BehaviorType.scrolling,
              ))
          .toList(),
      scrollingTriggersSexual: ScrollingLinkage.values.firstWhere(
        (e) => e.name == row.scrollingTriggersSexual,
        orElse: () => ScrollingLinkage.never,
      ),
      triggers: (jsonDecode(row.triggers) as List)
          .map((t) => TriggerType.values.firstWhere(
                (e) => e.name == t,
                orElse: () => TriggerType.other,
              ))
          .toList(),
      struggleDuration: StruggleDuration.values.firstWhere(
        (e) => e.name == row.struggleDuration,
        orElse: () => StruggleDuration.twoToFiveYears,
      ),
      resistAbility: ResistAbility.values.firstWhere(
        (e) => e.name == row.resistAbility,
        orElse: () => ResistAbility.sometimes,
      ),
      goalType: GoalType.values.firstWhere(
        (e) => e.name == row.goalType,
        orElse: () => GoalType.quit,
      ),
      motivations: (jsonDecode(row.motivations) as List)
          .map((m) => MotivationType.values.firstWhere(
                (e) => e.name == m,
                orElse: () => MotivationType.health,
              ))
          .toList(),
      weekendDifferent: row.weekendDifferent,
    );
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(databaseProvider));
});
