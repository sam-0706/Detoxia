// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _checkedInTodayMeta = const VerificationMeta(
    'checkedInToday',
  );
  @override
  late final GeneratedColumn<bool> checkedInToday = GeneratedColumn<bool>(
    'checked_in_today',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("checked_in_today" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _roleTypeMeta = const VerificationMeta(
    'roleType',
  );
  @override
  late final GeneratedColumn<String> roleType = GeneratedColumn<String>(
    'role_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workDaysMeta = const VerificationMeta(
    'workDays',
  );
  @override
  late final GeneratedColumn<String> workDays = GeneratedColumn<String>(
    'work_days',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _workStartMeta = const VerificationMeta(
    'workStart',
  );
  @override
  late final GeneratedColumn<String> workStart = GeneratedColumn<String>(
    'work_start',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workEndMeta = const VerificationMeta(
    'workEnd',
  );
  @override
  late final GeneratedColumn<String> workEnd = GeneratedColumn<String>(
    'work_end',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weekdayWakeTimeMeta = const VerificationMeta(
    'weekdayWakeTime',
  );
  @override
  late final GeneratedColumn<String> weekdayWakeTime = GeneratedColumn<String>(
    'weekday_wake_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdaySleepTimeMeta = const VerificationMeta(
    'weekdaySleepTime',
  );
  @override
  late final GeneratedColumn<String> weekdaySleepTime = GeneratedColumn<String>(
    'weekday_sleep_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _offdayWakeTimeMeta = const VerificationMeta(
    'offdayWakeTime',
  );
  @override
  late final GeneratedColumn<String> offdayWakeTime = GeneratedColumn<String>(
    'offday_wake_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _offdaySleepTimeMeta = const VerificationMeta(
    'offdaySleepTime',
  );
  @override
  late final GeneratedColumn<String> offdaySleepTime = GeneratedColumn<String>(
    'offday_sleep_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _strugglesMeta = const VerificationMeta(
    'struggles',
  );
  @override
  late final GeneratedColumn<String> struggles = GeneratedColumn<String>(
    'struggles',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _scrollingTriggersSexualMeta =
      const VerificationMeta('scrollingTriggersSexual');
  @override
  late final GeneratedColumn<String> scrollingTriggersSexual =
      GeneratedColumn<String>(
        'scrolling_triggers_sexual',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('never'),
      );
  static const VerificationMeta _triggersMeta = const VerificationMeta(
    'triggers',
  );
  @override
  late final GeneratedColumn<String> triggers = GeneratedColumn<String>(
    'triggers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _struggleDurationMeta = const VerificationMeta(
    'struggleDuration',
  );
  @override
  late final GeneratedColumn<String> struggleDuration = GeneratedColumn<String>(
    'struggle_duration',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resistAbilityMeta = const VerificationMeta(
    'resistAbility',
  );
  @override
  late final GeneratedColumn<String> resistAbility = GeneratedColumn<String>(
    'resist_ability',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalTypeMeta = const VerificationMeta(
    'goalType',
  );
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
    'goal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _motivationsMeta = const VerificationMeta(
    'motivations',
  );
  @override
  late final GeneratedColumn<String> motivations = GeneratedColumn<String>(
    'motivations',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _weekendDifferentMeta = const VerificationMeta(
    'weekendDifferent',
  );
  @override
  late final GeneratedColumn<bool> weekendDifferent = GeneratedColumn<bool>(
    'weekend_different',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("weekend_different" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    phone,
    country,
    checkedInToday,
    roleType,
    workDays,
    workStart,
    workEnd,
    weekdayWakeTime,
    weekdaySleepTime,
    offdayWakeTime,
    offdaySleepTime,
    struggles,
    scrollingTriggersSexual,
    triggers,
    struggleDuration,
    resistAbility,
    goalType,
    motivations,
    weekendDifferent,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('checked_in_today')) {
      context.handle(
        _checkedInTodayMeta,
        checkedInToday.isAcceptableOrUnknown(
          data['checked_in_today']!,
          _checkedInTodayMeta,
        ),
      );
    }
    if (data.containsKey('role_type')) {
      context.handle(
        _roleTypeMeta,
        roleType.isAcceptableOrUnknown(data['role_type']!, _roleTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_roleTypeMeta);
    }
    if (data.containsKey('work_days')) {
      context.handle(
        _workDaysMeta,
        workDays.isAcceptableOrUnknown(data['work_days']!, _workDaysMeta),
      );
    }
    if (data.containsKey('work_start')) {
      context.handle(
        _workStartMeta,
        workStart.isAcceptableOrUnknown(data['work_start']!, _workStartMeta),
      );
    }
    if (data.containsKey('work_end')) {
      context.handle(
        _workEndMeta,
        workEnd.isAcceptableOrUnknown(data['work_end']!, _workEndMeta),
      );
    }
    if (data.containsKey('weekday_wake_time')) {
      context.handle(
        _weekdayWakeTimeMeta,
        weekdayWakeTime.isAcceptableOrUnknown(
          data['weekday_wake_time']!,
          _weekdayWakeTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weekdayWakeTimeMeta);
    }
    if (data.containsKey('weekday_sleep_time')) {
      context.handle(
        _weekdaySleepTimeMeta,
        weekdaySleepTime.isAcceptableOrUnknown(
          data['weekday_sleep_time']!,
          _weekdaySleepTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weekdaySleepTimeMeta);
    }
    if (data.containsKey('offday_wake_time')) {
      context.handle(
        _offdayWakeTimeMeta,
        offdayWakeTime.isAcceptableOrUnknown(
          data['offday_wake_time']!,
          _offdayWakeTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_offdayWakeTimeMeta);
    }
    if (data.containsKey('offday_sleep_time')) {
      context.handle(
        _offdaySleepTimeMeta,
        offdaySleepTime.isAcceptableOrUnknown(
          data['offday_sleep_time']!,
          _offdaySleepTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_offdaySleepTimeMeta);
    }
    if (data.containsKey('struggles')) {
      context.handle(
        _strugglesMeta,
        struggles.isAcceptableOrUnknown(data['struggles']!, _strugglesMeta),
      );
    }
    if (data.containsKey('scrolling_triggers_sexual')) {
      context.handle(
        _scrollingTriggersSexualMeta,
        scrollingTriggersSexual.isAcceptableOrUnknown(
          data['scrolling_triggers_sexual']!,
          _scrollingTriggersSexualMeta,
        ),
      );
    }
    if (data.containsKey('triggers')) {
      context.handle(
        _triggersMeta,
        triggers.isAcceptableOrUnknown(data['triggers']!, _triggersMeta),
      );
    }
    if (data.containsKey('struggle_duration')) {
      context.handle(
        _struggleDurationMeta,
        struggleDuration.isAcceptableOrUnknown(
          data['struggle_duration']!,
          _struggleDurationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_struggleDurationMeta);
    }
    if (data.containsKey('resist_ability')) {
      context.handle(
        _resistAbilityMeta,
        resistAbility.isAcceptableOrUnknown(
          data['resist_ability']!,
          _resistAbilityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_resistAbilityMeta);
    }
    if (data.containsKey('goal_type')) {
      context.handle(
        _goalTypeMeta,
        goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_goalTypeMeta);
    }
    if (data.containsKey('motivations')) {
      context.handle(
        _motivationsMeta,
        motivations.isAcceptableOrUnknown(
          data['motivations']!,
          _motivationsMeta,
        ),
      );
    }
    if (data.containsKey('weekend_different')) {
      context.handle(
        _weekendDifferentMeta,
        weekendDifferent.isAcceptableOrUnknown(
          data['weekend_different']!,
          _weekendDifferentMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      )!,
      checkedInToday: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}checked_in_today'],
      )!,
      roleType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_type'],
      )!,
      workDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_days'],
      )!,
      workStart: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_start'],
      ),
      workEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_end'],
      ),
      weekdayWakeTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weekday_wake_time'],
      )!,
      weekdaySleepTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weekday_sleep_time'],
      )!,
      offdayWakeTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}offday_wake_time'],
      )!,
      offdaySleepTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}offday_sleep_time'],
      )!,
      struggles: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}struggles'],
      )!,
      scrollingTriggersSexual: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scrolling_triggers_sexual'],
      )!,
      triggers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}triggers'],
      )!,
      struggleDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}struggle_duration'],
      )!,
      resistAbility: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resist_ability'],
      )!,
      goalType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_type'],
      )!,
      motivations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motivations'],
      )!,
      weekendDifferent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}weekend_different'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String country;
  final bool checkedInToday;
  final String roleType;
  final String workDays;
  final String? workStart;
  final String? workEnd;
  final String weekdayWakeTime;
  final String weekdaySleepTime;
  final String offdayWakeTime;
  final String offdaySleepTime;
  final String struggles;
  final String scrollingTriggersSexual;
  final String triggers;
  final String struggleDuration;
  final String resistAbility;
  final String goalType;
  final String motivations;
  final bool weekendDifferent;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.country,
    required this.checkedInToday,
    required this.roleType,
    required this.workDays,
    this.workStart,
    this.workEnd,
    required this.weekdayWakeTime,
    required this.weekdaySleepTime,
    required this.offdayWakeTime,
    required this.offdaySleepTime,
    required this.struggles,
    required this.scrollingTriggersSexual,
    required this.triggers,
    required this.struggleDuration,
    required this.resistAbility,
    required this.goalType,
    required this.motivations,
    required this.weekendDifferent,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['phone'] = Variable<String>(phone);
    map['country'] = Variable<String>(country);
    map['checked_in_today'] = Variable<bool>(checkedInToday);
    map['role_type'] = Variable<String>(roleType);
    map['work_days'] = Variable<String>(workDays);
    if (!nullToAbsent || workStart != null) {
      map['work_start'] = Variable<String>(workStart);
    }
    if (!nullToAbsent || workEnd != null) {
      map['work_end'] = Variable<String>(workEnd);
    }
    map['weekday_wake_time'] = Variable<String>(weekdayWakeTime);
    map['weekday_sleep_time'] = Variable<String>(weekdaySleepTime);
    map['offday_wake_time'] = Variable<String>(offdayWakeTime);
    map['offday_sleep_time'] = Variable<String>(offdaySleepTime);
    map['struggles'] = Variable<String>(struggles);
    map['scrolling_triggers_sexual'] = Variable<String>(
      scrollingTriggersSexual,
    );
    map['triggers'] = Variable<String>(triggers);
    map['struggle_duration'] = Variable<String>(struggleDuration);
    map['resist_ability'] = Variable<String>(resistAbility);
    map['goal_type'] = Variable<String>(goalType);
    map['motivations'] = Variable<String>(motivations);
    map['weekend_different'] = Variable<bool>(weekendDifferent);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      phone: Value(phone),
      country: Value(country),
      checkedInToday: Value(checkedInToday),
      roleType: Value(roleType),
      workDays: Value(workDays),
      workStart: workStart == null && nullToAbsent
          ? const Value.absent()
          : Value(workStart),
      workEnd: workEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(workEnd),
      weekdayWakeTime: Value(weekdayWakeTime),
      weekdaySleepTime: Value(weekdaySleepTime),
      offdayWakeTime: Value(offdayWakeTime),
      offdaySleepTime: Value(offdaySleepTime),
      struggles: Value(struggles),
      scrollingTriggersSexual: Value(scrollingTriggersSexual),
      triggers: Value(triggers),
      struggleDuration: Value(struggleDuration),
      resistAbility: Value(resistAbility),
      goalType: Value(goalType),
      motivations: Value(motivations),
      weekendDifferent: Value(weekendDifferent),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      phone: serializer.fromJson<String>(json['phone']),
      country: serializer.fromJson<String>(json['country']),
      checkedInToday: serializer.fromJson<bool>(json['checkedInToday']),
      roleType: serializer.fromJson<String>(json['roleType']),
      workDays: serializer.fromJson<String>(json['workDays']),
      workStart: serializer.fromJson<String?>(json['workStart']),
      workEnd: serializer.fromJson<String?>(json['workEnd']),
      weekdayWakeTime: serializer.fromJson<String>(json['weekdayWakeTime']),
      weekdaySleepTime: serializer.fromJson<String>(json['weekdaySleepTime']),
      offdayWakeTime: serializer.fromJson<String>(json['offdayWakeTime']),
      offdaySleepTime: serializer.fromJson<String>(json['offdaySleepTime']),
      struggles: serializer.fromJson<String>(json['struggles']),
      scrollingTriggersSexual: serializer.fromJson<String>(
        json['scrollingTriggersSexual'],
      ),
      triggers: serializer.fromJson<String>(json['triggers']),
      struggleDuration: serializer.fromJson<String>(json['struggleDuration']),
      resistAbility: serializer.fromJson<String>(json['resistAbility']),
      goalType: serializer.fromJson<String>(json['goalType']),
      motivations: serializer.fromJson<String>(json['motivations']),
      weekendDifferent: serializer.fromJson<bool>(json['weekendDifferent']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'phone': serializer.toJson<String>(phone),
      'country': serializer.toJson<String>(country),
      'checkedInToday': serializer.toJson<bool>(checkedInToday),
      'roleType': serializer.toJson<String>(roleType),
      'workDays': serializer.toJson<String>(workDays),
      'workStart': serializer.toJson<String?>(workStart),
      'workEnd': serializer.toJson<String?>(workEnd),
      'weekdayWakeTime': serializer.toJson<String>(weekdayWakeTime),
      'weekdaySleepTime': serializer.toJson<String>(weekdaySleepTime),
      'offdayWakeTime': serializer.toJson<String>(offdayWakeTime),
      'offdaySleepTime': serializer.toJson<String>(offdaySleepTime),
      'struggles': serializer.toJson<String>(struggles),
      'scrollingTriggersSexual': serializer.toJson<String>(
        scrollingTriggersSexual,
      ),
      'triggers': serializer.toJson<String>(triggers),
      'struggleDuration': serializer.toJson<String>(struggleDuration),
      'resistAbility': serializer.toJson<String>(resistAbility),
      'goalType': serializer.toJson<String>(goalType),
      'motivations': serializer.toJson<String>(motivations),
      'weekendDifferent': serializer.toJson<bool>(weekendDifferent),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? country,
    bool? checkedInToday,
    String? roleType,
    String? workDays,
    Value<String?> workStart = const Value.absent(),
    Value<String?> workEnd = const Value.absent(),
    String? weekdayWakeTime,
    String? weekdaySleepTime,
    String? offdayWakeTime,
    String? offdaySleepTime,
    String? struggles,
    String? scrollingTriggersSexual,
    String? triggers,
    String? struggleDuration,
    String? resistAbility,
    String? goalType,
    String? motivations,
    bool? weekendDifferent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    country: country ?? this.country,
    checkedInToday: checkedInToday ?? this.checkedInToday,
    roleType: roleType ?? this.roleType,
    workDays: workDays ?? this.workDays,
    workStart: workStart.present ? workStart.value : this.workStart,
    workEnd: workEnd.present ? workEnd.value : this.workEnd,
    weekdayWakeTime: weekdayWakeTime ?? this.weekdayWakeTime,
    weekdaySleepTime: weekdaySleepTime ?? this.weekdaySleepTime,
    offdayWakeTime: offdayWakeTime ?? this.offdayWakeTime,
    offdaySleepTime: offdaySleepTime ?? this.offdaySleepTime,
    struggles: struggles ?? this.struggles,
    scrollingTriggersSexual:
        scrollingTriggersSexual ?? this.scrollingTriggersSexual,
    triggers: triggers ?? this.triggers,
    struggleDuration: struggleDuration ?? this.struggleDuration,
    resistAbility: resistAbility ?? this.resistAbility,
    goalType: goalType ?? this.goalType,
    motivations: motivations ?? this.motivations,
    weekendDifferent: weekendDifferent ?? this.weekendDifferent,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      country: data.country.present ? data.country.value : this.country,
      checkedInToday: data.checkedInToday.present
          ? data.checkedInToday.value
          : this.checkedInToday,
      roleType: data.roleType.present ? data.roleType.value : this.roleType,
      workDays: data.workDays.present ? data.workDays.value : this.workDays,
      workStart: data.workStart.present ? data.workStart.value : this.workStart,
      workEnd: data.workEnd.present ? data.workEnd.value : this.workEnd,
      weekdayWakeTime: data.weekdayWakeTime.present
          ? data.weekdayWakeTime.value
          : this.weekdayWakeTime,
      weekdaySleepTime: data.weekdaySleepTime.present
          ? data.weekdaySleepTime.value
          : this.weekdaySleepTime,
      offdayWakeTime: data.offdayWakeTime.present
          ? data.offdayWakeTime.value
          : this.offdayWakeTime,
      offdaySleepTime: data.offdaySleepTime.present
          ? data.offdaySleepTime.value
          : this.offdaySleepTime,
      struggles: data.struggles.present ? data.struggles.value : this.struggles,
      scrollingTriggersSexual: data.scrollingTriggersSexual.present
          ? data.scrollingTriggersSexual.value
          : this.scrollingTriggersSexual,
      triggers: data.triggers.present ? data.triggers.value : this.triggers,
      struggleDuration: data.struggleDuration.present
          ? data.struggleDuration.value
          : this.struggleDuration,
      resistAbility: data.resistAbility.present
          ? data.resistAbility.value
          : this.resistAbility,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      motivations: data.motivations.present
          ? data.motivations.value
          : this.motivations,
      weekendDifferent: data.weekendDifferent.present
          ? data.weekendDifferent.value
          : this.weekendDifferent,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('country: $country, ')
          ..write('checkedInToday: $checkedInToday, ')
          ..write('roleType: $roleType, ')
          ..write('workDays: $workDays, ')
          ..write('workStart: $workStart, ')
          ..write('workEnd: $workEnd, ')
          ..write('weekdayWakeTime: $weekdayWakeTime, ')
          ..write('weekdaySleepTime: $weekdaySleepTime, ')
          ..write('offdayWakeTime: $offdayWakeTime, ')
          ..write('offdaySleepTime: $offdaySleepTime, ')
          ..write('struggles: $struggles, ')
          ..write('scrollingTriggersSexual: $scrollingTriggersSexual, ')
          ..write('triggers: $triggers, ')
          ..write('struggleDuration: $struggleDuration, ')
          ..write('resistAbility: $resistAbility, ')
          ..write('goalType: $goalType, ')
          ..write('motivations: $motivations, ')
          ..write('weekendDifferent: $weekendDifferent, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    email,
    phone,
    country,
    checkedInToday,
    roleType,
    workDays,
    workStart,
    workEnd,
    weekdayWakeTime,
    weekdaySleepTime,
    offdayWakeTime,
    offdaySleepTime,
    struggles,
    scrollingTriggersSexual,
    triggers,
    struggleDuration,
    resistAbility,
    goalType,
    motivations,
    weekendDifferent,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.country == this.country &&
          other.checkedInToday == this.checkedInToday &&
          other.roleType == this.roleType &&
          other.workDays == this.workDays &&
          other.workStart == this.workStart &&
          other.workEnd == this.workEnd &&
          other.weekdayWakeTime == this.weekdayWakeTime &&
          other.weekdaySleepTime == this.weekdaySleepTime &&
          other.offdayWakeTime == this.offdayWakeTime &&
          other.offdaySleepTime == this.offdaySleepTime &&
          other.struggles == this.struggles &&
          other.scrollingTriggersSexual == this.scrollingTriggersSexual &&
          other.triggers == this.triggers &&
          other.struggleDuration == this.struggleDuration &&
          other.resistAbility == this.resistAbility &&
          other.goalType == this.goalType &&
          other.motivations == this.motivations &&
          other.weekendDifferent == this.weekendDifferent &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> phone;
  final Value<String> country;
  final Value<bool> checkedInToday;
  final Value<String> roleType;
  final Value<String> workDays;
  final Value<String?> workStart;
  final Value<String?> workEnd;
  final Value<String> weekdayWakeTime;
  final Value<String> weekdaySleepTime;
  final Value<String> offdayWakeTime;
  final Value<String> offdaySleepTime;
  final Value<String> struggles;
  final Value<String> scrollingTriggersSexual;
  final Value<String> triggers;
  final Value<String> struggleDuration;
  final Value<String> resistAbility;
  final Value<String> goalType;
  final Value<String> motivations;
  final Value<bool> weekendDifferent;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.country = const Value.absent(),
    this.checkedInToday = const Value.absent(),
    this.roleType = const Value.absent(),
    this.workDays = const Value.absent(),
    this.workStart = const Value.absent(),
    this.workEnd = const Value.absent(),
    this.weekdayWakeTime = const Value.absent(),
    this.weekdaySleepTime = const Value.absent(),
    this.offdayWakeTime = const Value.absent(),
    this.offdaySleepTime = const Value.absent(),
    this.struggles = const Value.absent(),
    this.scrollingTriggersSexual = const Value.absent(),
    this.triggers = const Value.absent(),
    this.struggleDuration = const Value.absent(),
    this.resistAbility = const Value.absent(),
    this.goalType = const Value.absent(),
    this.motivations = const Value.absent(),
    this.weekendDifferent = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.country = const Value.absent(),
    this.checkedInToday = const Value.absent(),
    required String roleType,
    this.workDays = const Value.absent(),
    this.workStart = const Value.absent(),
    this.workEnd = const Value.absent(),
    required String weekdayWakeTime,
    required String weekdaySleepTime,
    required String offdayWakeTime,
    required String offdaySleepTime,
    this.struggles = const Value.absent(),
    this.scrollingTriggersSexual = const Value.absent(),
    this.triggers = const Value.absent(),
    required String struggleDuration,
    required String resistAbility,
    required String goalType,
    this.motivations = const Value.absent(),
    this.weekendDifferent = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : roleType = Value(roleType),
       weekdayWakeTime = Value(weekdayWakeTime),
       weekdaySleepTime = Value(weekdaySleepTime),
       offdayWakeTime = Value(offdayWakeTime),
       offdaySleepTime = Value(offdaySleepTime),
       struggleDuration = Value(struggleDuration),
       resistAbility = Value(resistAbility),
       goalType = Value(goalType);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? country,
    Expression<bool>? checkedInToday,
    Expression<String>? roleType,
    Expression<String>? workDays,
    Expression<String>? workStart,
    Expression<String>? workEnd,
    Expression<String>? weekdayWakeTime,
    Expression<String>? weekdaySleepTime,
    Expression<String>? offdayWakeTime,
    Expression<String>? offdaySleepTime,
    Expression<String>? struggles,
    Expression<String>? scrollingTriggersSexual,
    Expression<String>? triggers,
    Expression<String>? struggleDuration,
    Expression<String>? resistAbility,
    Expression<String>? goalType,
    Expression<String>? motivations,
    Expression<bool>? weekendDifferent,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (country != null) 'country': country,
      if (checkedInToday != null) 'checked_in_today': checkedInToday,
      if (roleType != null) 'role_type': roleType,
      if (workDays != null) 'work_days': workDays,
      if (workStart != null) 'work_start': workStart,
      if (workEnd != null) 'work_end': workEnd,
      if (weekdayWakeTime != null) 'weekday_wake_time': weekdayWakeTime,
      if (weekdaySleepTime != null) 'weekday_sleep_time': weekdaySleepTime,
      if (offdayWakeTime != null) 'offday_wake_time': offdayWakeTime,
      if (offdaySleepTime != null) 'offday_sleep_time': offdaySleepTime,
      if (struggles != null) 'struggles': struggles,
      if (scrollingTriggersSexual != null)
        'scrolling_triggers_sexual': scrollingTriggersSexual,
      if (triggers != null) 'triggers': triggers,
      if (struggleDuration != null) 'struggle_duration': struggleDuration,
      if (resistAbility != null) 'resist_ability': resistAbility,
      if (goalType != null) 'goal_type': goalType,
      if (motivations != null) 'motivations': motivations,
      if (weekendDifferent != null) 'weekend_different': weekendDifferent,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? email,
    Value<String>? phone,
    Value<String>? country,
    Value<bool>? checkedInToday,
    Value<String>? roleType,
    Value<String>? workDays,
    Value<String?>? workStart,
    Value<String?>? workEnd,
    Value<String>? weekdayWakeTime,
    Value<String>? weekdaySleepTime,
    Value<String>? offdayWakeTime,
    Value<String>? offdaySleepTime,
    Value<String>? struggles,
    Value<String>? scrollingTriggersSexual,
    Value<String>? triggers,
    Value<String>? struggleDuration,
    Value<String>? resistAbility,
    Value<String>? goalType,
    Value<String>? motivations,
    Value<bool>? weekendDifferent,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      checkedInToday: checkedInToday ?? this.checkedInToday,
      roleType: roleType ?? this.roleType,
      workDays: workDays ?? this.workDays,
      workStart: workStart ?? this.workStart,
      workEnd: workEnd ?? this.workEnd,
      weekdayWakeTime: weekdayWakeTime ?? this.weekdayWakeTime,
      weekdaySleepTime: weekdaySleepTime ?? this.weekdaySleepTime,
      offdayWakeTime: offdayWakeTime ?? this.offdayWakeTime,
      offdaySleepTime: offdaySleepTime ?? this.offdaySleepTime,
      struggles: struggles ?? this.struggles,
      scrollingTriggersSexual:
          scrollingTriggersSexual ?? this.scrollingTriggersSexual,
      triggers: triggers ?? this.triggers,
      struggleDuration: struggleDuration ?? this.struggleDuration,
      resistAbility: resistAbility ?? this.resistAbility,
      goalType: goalType ?? this.goalType,
      motivations: motivations ?? this.motivations,
      weekendDifferent: weekendDifferent ?? this.weekendDifferent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (checkedInToday.present) {
      map['checked_in_today'] = Variable<bool>(checkedInToday.value);
    }
    if (roleType.present) {
      map['role_type'] = Variable<String>(roleType.value);
    }
    if (workDays.present) {
      map['work_days'] = Variable<String>(workDays.value);
    }
    if (workStart.present) {
      map['work_start'] = Variable<String>(workStart.value);
    }
    if (workEnd.present) {
      map['work_end'] = Variable<String>(workEnd.value);
    }
    if (weekdayWakeTime.present) {
      map['weekday_wake_time'] = Variable<String>(weekdayWakeTime.value);
    }
    if (weekdaySleepTime.present) {
      map['weekday_sleep_time'] = Variable<String>(weekdaySleepTime.value);
    }
    if (offdayWakeTime.present) {
      map['offday_wake_time'] = Variable<String>(offdayWakeTime.value);
    }
    if (offdaySleepTime.present) {
      map['offday_sleep_time'] = Variable<String>(offdaySleepTime.value);
    }
    if (struggles.present) {
      map['struggles'] = Variable<String>(struggles.value);
    }
    if (scrollingTriggersSexual.present) {
      map['scrolling_triggers_sexual'] = Variable<String>(
        scrollingTriggersSexual.value,
      );
    }
    if (triggers.present) {
      map['triggers'] = Variable<String>(triggers.value);
    }
    if (struggleDuration.present) {
      map['struggle_duration'] = Variable<String>(struggleDuration.value);
    }
    if (resistAbility.present) {
      map['resist_ability'] = Variable<String>(resistAbility.value);
    }
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
    }
    if (motivations.present) {
      map['motivations'] = Variable<String>(motivations.value);
    }
    if (weekendDifferent.present) {
      map['weekend_different'] = Variable<bool>(weekendDifferent.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('country: $country, ')
          ..write('checkedInToday: $checkedInToday, ')
          ..write('roleType: $roleType, ')
          ..write('workDays: $workDays, ')
          ..write('workStart: $workStart, ')
          ..write('workEnd: $workEnd, ')
          ..write('weekdayWakeTime: $weekdayWakeTime, ')
          ..write('weekdaySleepTime: $weekdaySleepTime, ')
          ..write('offdayWakeTime: $offdayWakeTime, ')
          ..write('offdaySleepTime: $offdaySleepTime, ')
          ..write('struggles: $struggles, ')
          ..write('scrollingTriggersSexual: $scrollingTriggersSexual, ')
          ..write('triggers: $triggers, ')
          ..write('struggleDuration: $struggleDuration, ')
          ..write('resistAbility: $resistAbility, ')
          ..write('goalType: $goalType, ')
          ..write('motivations: $motivations, ')
          ..write('weekendDifferent: $weekendDifferent, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PeakNodesTable extends PeakNodes
    with TableInfo<$PeakNodesTable, PeakNode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeakNodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _centerTimeMeta = const VerificationMeta(
    'centerTime',
  );
  @override
  late final GeneratedColumn<String> centerTime = GeneratedColumn<String>(
    'center_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _windowRadiusMinutesMeta =
      const VerificationMeta('windowRadiusMinutes');
  @override
  late final GeneratedColumn<int> windowRadiusMinutes = GeneratedColumn<int>(
    'window_radius_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(45),
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('almostDaily'),
  );
  static const VerificationMeta _dayTypesMeta = const VerificationMeta(
    'dayTypes',
  );
  @override
  late final GeneratedColumn<String> dayTypes = GeneratedColumn<String>(
    'day_types',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('["both"]'),
  );
  static const VerificationMeta _isHardestMeta = const VerificationMeta(
    'isHardest',
  );
  @override
  late final GeneratedColumn<bool> isHardest = GeneratedColumn<bool>(
    'is_hardest',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_hardest" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _triggersMeta = const VerificationMeta(
    'triggers',
  );
  @override
  late final GeneratedColumn<String> triggers = GeneratedColumn<String>(
    'triggers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _emotionalStateMeta = const VerificationMeta(
    'emotionalState',
  );
  @override
  late final GeneratedColumn<String> emotionalState = GeneratedColumn<String>(
    'emotional_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _preContextMeta = const VerificationMeta(
    'preContext',
  );
  @override
  late final GeneratedColumn<String> preContext = GeneratedColumn<String>(
    'pre_context',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _empiricalFrequencyMeta =
      const VerificationMeta('empiricalFrequency');
  @override
  late final GeneratedColumn<double> empiricalFrequency =
      GeneratedColumn<double>(
        'empirical_frequency',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _avgIntensityMeta = const VerificationMeta(
    'avgIntensity',
  );
  @override
  late final GeneratedColumn<double> avgIntensity = GeneratedColumn<double>(
    'avg_intensity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(5.0),
  );
  static const VerificationMeta _slipRateMeta = const VerificationMeta(
    'slipRate',
  );
  @override
  late final GeneratedColumn<double> slipRate = GeneratedColumn<double>(
    'slip_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.5),
  );
  static const VerificationMeta _triggerPosteriorsMeta = const VerificationMeta(
    'triggerPosteriors',
  );
  @override
  late final GeneratedColumn<String> triggerPosteriors =
      GeneratedColumn<String>(
        'trigger_posteriors',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      );
  static const VerificationMeta _topInterventionsMeta = const VerificationMeta(
    'topInterventions',
  );
  @override
  late final GeneratedColumn<String> topInterventions = GeneratedColumn<String>(
    'top_interventions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _currentPeakStreakMeta = const VerificationMeta(
    'currentPeakStreak',
  );
  @override
  late final GeneratedColumn<int> currentPeakStreak = GeneratedColumn<int>(
    'current_peak_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bestPeakStreakMeta = const VerificationMeta(
    'bestPeakStreak',
  );
  @override
  late final GeneratedColumn<int> bestPeakStreak = GeneratedColumn<int>(
    'best_peak_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    centerTime,
    windowRadiusMinutes,
    frequency,
    dayTypes,
    isHardest,
    triggers,
    emotionalState,
    preContext,
    empiricalFrequency,
    avgIntensity,
    slipRate,
    triggerPosteriors,
    topInterventions,
    currentPeakStreak,
    bestPeakStreak,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'peak_nodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<PeakNode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('center_time')) {
      context.handle(
        _centerTimeMeta,
        centerTime.isAcceptableOrUnknown(data['center_time']!, _centerTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_centerTimeMeta);
    }
    if (data.containsKey('window_radius_minutes')) {
      context.handle(
        _windowRadiusMinutesMeta,
        windowRadiusMinutes.isAcceptableOrUnknown(
          data['window_radius_minutes']!,
          _windowRadiusMinutesMeta,
        ),
      );
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    }
    if (data.containsKey('day_types')) {
      context.handle(
        _dayTypesMeta,
        dayTypes.isAcceptableOrUnknown(data['day_types']!, _dayTypesMeta),
      );
    }
    if (data.containsKey('is_hardest')) {
      context.handle(
        _isHardestMeta,
        isHardest.isAcceptableOrUnknown(data['is_hardest']!, _isHardestMeta),
      );
    }
    if (data.containsKey('triggers')) {
      context.handle(
        _triggersMeta,
        triggers.isAcceptableOrUnknown(data['triggers']!, _triggersMeta),
      );
    }
    if (data.containsKey('emotional_state')) {
      context.handle(
        _emotionalStateMeta,
        emotionalState.isAcceptableOrUnknown(
          data['emotional_state']!,
          _emotionalStateMeta,
        ),
      );
    }
    if (data.containsKey('pre_context')) {
      context.handle(
        _preContextMeta,
        preContext.isAcceptableOrUnknown(data['pre_context']!, _preContextMeta),
      );
    }
    if (data.containsKey('empirical_frequency')) {
      context.handle(
        _empiricalFrequencyMeta,
        empiricalFrequency.isAcceptableOrUnknown(
          data['empirical_frequency']!,
          _empiricalFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('avg_intensity')) {
      context.handle(
        _avgIntensityMeta,
        avgIntensity.isAcceptableOrUnknown(
          data['avg_intensity']!,
          _avgIntensityMeta,
        ),
      );
    }
    if (data.containsKey('slip_rate')) {
      context.handle(
        _slipRateMeta,
        slipRate.isAcceptableOrUnknown(data['slip_rate']!, _slipRateMeta),
      );
    }
    if (data.containsKey('trigger_posteriors')) {
      context.handle(
        _triggerPosteriorsMeta,
        triggerPosteriors.isAcceptableOrUnknown(
          data['trigger_posteriors']!,
          _triggerPosteriorsMeta,
        ),
      );
    }
    if (data.containsKey('top_interventions')) {
      context.handle(
        _topInterventionsMeta,
        topInterventions.isAcceptableOrUnknown(
          data['top_interventions']!,
          _topInterventionsMeta,
        ),
      );
    }
    if (data.containsKey('current_peak_streak')) {
      context.handle(
        _currentPeakStreakMeta,
        currentPeakStreak.isAcceptableOrUnknown(
          data['current_peak_streak']!,
          _currentPeakStreakMeta,
        ),
      );
    }
    if (data.containsKey('best_peak_streak')) {
      context.handle(
        _bestPeakStreakMeta,
        bestPeakStreak.isAcceptableOrUnknown(
          data['best_peak_streak']!,
          _bestPeakStreakMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PeakNode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PeakNode(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      centerTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}center_time'],
      )!,
      windowRadiusMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}window_radius_minutes'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      dayTypes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_types'],
      )!,
      isHardest: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_hardest'],
      )!,
      triggers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}triggers'],
      )!,
      emotionalState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emotional_state'],
      )!,
      preContext: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pre_context'],
      )!,
      empiricalFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}empirical_frequency'],
      )!,
      avgIntensity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_intensity'],
      )!,
      slipRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}slip_rate'],
      )!,
      triggerPosteriors: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger_posteriors'],
      )!,
      topInterventions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}top_interventions'],
      )!,
      currentPeakStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_peak_streak'],
      )!,
      bestPeakStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_peak_streak'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PeakNodesTable createAlias(String alias) {
    return $PeakNodesTable(attachedDatabase, alias);
  }
}

class PeakNode extends DataClass implements Insertable<PeakNode> {
  final int id;
  final String label;
  final String centerTime;
  final int windowRadiusMinutes;
  final String frequency;
  final String dayTypes;
  final bool isHardest;
  final String triggers;
  final String emotionalState;
  final String preContext;
  final double empiricalFrequency;
  final double avgIntensity;
  final double slipRate;
  final String triggerPosteriors;
  final String topInterventions;
  final int currentPeakStreak;
  final int bestPeakStreak;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PeakNode({
    required this.id,
    required this.label,
    required this.centerTime,
    required this.windowRadiusMinutes,
    required this.frequency,
    required this.dayTypes,
    required this.isHardest,
    required this.triggers,
    required this.emotionalState,
    required this.preContext,
    required this.empiricalFrequency,
    required this.avgIntensity,
    required this.slipRate,
    required this.triggerPosteriors,
    required this.topInterventions,
    required this.currentPeakStreak,
    required this.bestPeakStreak,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    map['center_time'] = Variable<String>(centerTime);
    map['window_radius_minutes'] = Variable<int>(windowRadiusMinutes);
    map['frequency'] = Variable<String>(frequency);
    map['day_types'] = Variable<String>(dayTypes);
    map['is_hardest'] = Variable<bool>(isHardest);
    map['triggers'] = Variable<String>(triggers);
    map['emotional_state'] = Variable<String>(emotionalState);
    map['pre_context'] = Variable<String>(preContext);
    map['empirical_frequency'] = Variable<double>(empiricalFrequency);
    map['avg_intensity'] = Variable<double>(avgIntensity);
    map['slip_rate'] = Variable<double>(slipRate);
    map['trigger_posteriors'] = Variable<String>(triggerPosteriors);
    map['top_interventions'] = Variable<String>(topInterventions);
    map['current_peak_streak'] = Variable<int>(currentPeakStreak);
    map['best_peak_streak'] = Variable<int>(bestPeakStreak);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PeakNodesCompanion toCompanion(bool nullToAbsent) {
    return PeakNodesCompanion(
      id: Value(id),
      label: Value(label),
      centerTime: Value(centerTime),
      windowRadiusMinutes: Value(windowRadiusMinutes),
      frequency: Value(frequency),
      dayTypes: Value(dayTypes),
      isHardest: Value(isHardest),
      triggers: Value(triggers),
      emotionalState: Value(emotionalState),
      preContext: Value(preContext),
      empiricalFrequency: Value(empiricalFrequency),
      avgIntensity: Value(avgIntensity),
      slipRate: Value(slipRate),
      triggerPosteriors: Value(triggerPosteriors),
      topInterventions: Value(topInterventions),
      currentPeakStreak: Value(currentPeakStreak),
      bestPeakStreak: Value(bestPeakStreak),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PeakNode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PeakNode(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      centerTime: serializer.fromJson<String>(json['centerTime']),
      windowRadiusMinutes: serializer.fromJson<int>(
        json['windowRadiusMinutes'],
      ),
      frequency: serializer.fromJson<String>(json['frequency']),
      dayTypes: serializer.fromJson<String>(json['dayTypes']),
      isHardest: serializer.fromJson<bool>(json['isHardest']),
      triggers: serializer.fromJson<String>(json['triggers']),
      emotionalState: serializer.fromJson<String>(json['emotionalState']),
      preContext: serializer.fromJson<String>(json['preContext']),
      empiricalFrequency: serializer.fromJson<double>(
        json['empiricalFrequency'],
      ),
      avgIntensity: serializer.fromJson<double>(json['avgIntensity']),
      slipRate: serializer.fromJson<double>(json['slipRate']),
      triggerPosteriors: serializer.fromJson<String>(json['triggerPosteriors']),
      topInterventions: serializer.fromJson<String>(json['topInterventions']),
      currentPeakStreak: serializer.fromJson<int>(json['currentPeakStreak']),
      bestPeakStreak: serializer.fromJson<int>(json['bestPeakStreak']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'centerTime': serializer.toJson<String>(centerTime),
      'windowRadiusMinutes': serializer.toJson<int>(windowRadiusMinutes),
      'frequency': serializer.toJson<String>(frequency),
      'dayTypes': serializer.toJson<String>(dayTypes),
      'isHardest': serializer.toJson<bool>(isHardest),
      'triggers': serializer.toJson<String>(triggers),
      'emotionalState': serializer.toJson<String>(emotionalState),
      'preContext': serializer.toJson<String>(preContext),
      'empiricalFrequency': serializer.toJson<double>(empiricalFrequency),
      'avgIntensity': serializer.toJson<double>(avgIntensity),
      'slipRate': serializer.toJson<double>(slipRate),
      'triggerPosteriors': serializer.toJson<String>(triggerPosteriors),
      'topInterventions': serializer.toJson<String>(topInterventions),
      'currentPeakStreak': serializer.toJson<int>(currentPeakStreak),
      'bestPeakStreak': serializer.toJson<int>(bestPeakStreak),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PeakNode copyWith({
    int? id,
    String? label,
    String? centerTime,
    int? windowRadiusMinutes,
    String? frequency,
    String? dayTypes,
    bool? isHardest,
    String? triggers,
    String? emotionalState,
    String? preContext,
    double? empiricalFrequency,
    double? avgIntensity,
    double? slipRate,
    String? triggerPosteriors,
    String? topInterventions,
    int? currentPeakStreak,
    int? bestPeakStreak,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PeakNode(
    id: id ?? this.id,
    label: label ?? this.label,
    centerTime: centerTime ?? this.centerTime,
    windowRadiusMinutes: windowRadiusMinutes ?? this.windowRadiusMinutes,
    frequency: frequency ?? this.frequency,
    dayTypes: dayTypes ?? this.dayTypes,
    isHardest: isHardest ?? this.isHardest,
    triggers: triggers ?? this.triggers,
    emotionalState: emotionalState ?? this.emotionalState,
    preContext: preContext ?? this.preContext,
    empiricalFrequency: empiricalFrequency ?? this.empiricalFrequency,
    avgIntensity: avgIntensity ?? this.avgIntensity,
    slipRate: slipRate ?? this.slipRate,
    triggerPosteriors: triggerPosteriors ?? this.triggerPosteriors,
    topInterventions: topInterventions ?? this.topInterventions,
    currentPeakStreak: currentPeakStreak ?? this.currentPeakStreak,
    bestPeakStreak: bestPeakStreak ?? this.bestPeakStreak,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PeakNode copyWithCompanion(PeakNodesCompanion data) {
    return PeakNode(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      centerTime: data.centerTime.present
          ? data.centerTime.value
          : this.centerTime,
      windowRadiusMinutes: data.windowRadiusMinutes.present
          ? data.windowRadiusMinutes.value
          : this.windowRadiusMinutes,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      dayTypes: data.dayTypes.present ? data.dayTypes.value : this.dayTypes,
      isHardest: data.isHardest.present ? data.isHardest.value : this.isHardest,
      triggers: data.triggers.present ? data.triggers.value : this.triggers,
      emotionalState: data.emotionalState.present
          ? data.emotionalState.value
          : this.emotionalState,
      preContext: data.preContext.present
          ? data.preContext.value
          : this.preContext,
      empiricalFrequency: data.empiricalFrequency.present
          ? data.empiricalFrequency.value
          : this.empiricalFrequency,
      avgIntensity: data.avgIntensity.present
          ? data.avgIntensity.value
          : this.avgIntensity,
      slipRate: data.slipRate.present ? data.slipRate.value : this.slipRate,
      triggerPosteriors: data.triggerPosteriors.present
          ? data.triggerPosteriors.value
          : this.triggerPosteriors,
      topInterventions: data.topInterventions.present
          ? data.topInterventions.value
          : this.topInterventions,
      currentPeakStreak: data.currentPeakStreak.present
          ? data.currentPeakStreak.value
          : this.currentPeakStreak,
      bestPeakStreak: data.bestPeakStreak.present
          ? data.bestPeakStreak.value
          : this.bestPeakStreak,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PeakNode(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('centerTime: $centerTime, ')
          ..write('windowRadiusMinutes: $windowRadiusMinutes, ')
          ..write('frequency: $frequency, ')
          ..write('dayTypes: $dayTypes, ')
          ..write('isHardest: $isHardest, ')
          ..write('triggers: $triggers, ')
          ..write('emotionalState: $emotionalState, ')
          ..write('preContext: $preContext, ')
          ..write('empiricalFrequency: $empiricalFrequency, ')
          ..write('avgIntensity: $avgIntensity, ')
          ..write('slipRate: $slipRate, ')
          ..write('triggerPosteriors: $triggerPosteriors, ')
          ..write('topInterventions: $topInterventions, ')
          ..write('currentPeakStreak: $currentPeakStreak, ')
          ..write('bestPeakStreak: $bestPeakStreak, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    centerTime,
    windowRadiusMinutes,
    frequency,
    dayTypes,
    isHardest,
    triggers,
    emotionalState,
    preContext,
    empiricalFrequency,
    avgIntensity,
    slipRate,
    triggerPosteriors,
    topInterventions,
    currentPeakStreak,
    bestPeakStreak,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PeakNode &&
          other.id == this.id &&
          other.label == this.label &&
          other.centerTime == this.centerTime &&
          other.windowRadiusMinutes == this.windowRadiusMinutes &&
          other.frequency == this.frequency &&
          other.dayTypes == this.dayTypes &&
          other.isHardest == this.isHardest &&
          other.triggers == this.triggers &&
          other.emotionalState == this.emotionalState &&
          other.preContext == this.preContext &&
          other.empiricalFrequency == this.empiricalFrequency &&
          other.avgIntensity == this.avgIntensity &&
          other.slipRate == this.slipRate &&
          other.triggerPosteriors == this.triggerPosteriors &&
          other.topInterventions == this.topInterventions &&
          other.currentPeakStreak == this.currentPeakStreak &&
          other.bestPeakStreak == this.bestPeakStreak &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PeakNodesCompanion extends UpdateCompanion<PeakNode> {
  final Value<int> id;
  final Value<String> label;
  final Value<String> centerTime;
  final Value<int> windowRadiusMinutes;
  final Value<String> frequency;
  final Value<String> dayTypes;
  final Value<bool> isHardest;
  final Value<String> triggers;
  final Value<String> emotionalState;
  final Value<String> preContext;
  final Value<double> empiricalFrequency;
  final Value<double> avgIntensity;
  final Value<double> slipRate;
  final Value<String> triggerPosteriors;
  final Value<String> topInterventions;
  final Value<int> currentPeakStreak;
  final Value<int> bestPeakStreak;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PeakNodesCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.centerTime = const Value.absent(),
    this.windowRadiusMinutes = const Value.absent(),
    this.frequency = const Value.absent(),
    this.dayTypes = const Value.absent(),
    this.isHardest = const Value.absent(),
    this.triggers = const Value.absent(),
    this.emotionalState = const Value.absent(),
    this.preContext = const Value.absent(),
    this.empiricalFrequency = const Value.absent(),
    this.avgIntensity = const Value.absent(),
    this.slipRate = const Value.absent(),
    this.triggerPosteriors = const Value.absent(),
    this.topInterventions = const Value.absent(),
    this.currentPeakStreak = const Value.absent(),
    this.bestPeakStreak = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PeakNodesCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    required String centerTime,
    this.windowRadiusMinutes = const Value.absent(),
    this.frequency = const Value.absent(),
    this.dayTypes = const Value.absent(),
    this.isHardest = const Value.absent(),
    this.triggers = const Value.absent(),
    this.emotionalState = const Value.absent(),
    this.preContext = const Value.absent(),
    this.empiricalFrequency = const Value.absent(),
    this.avgIntensity = const Value.absent(),
    this.slipRate = const Value.absent(),
    this.triggerPosteriors = const Value.absent(),
    this.topInterventions = const Value.absent(),
    this.currentPeakStreak = const Value.absent(),
    this.bestPeakStreak = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : label = Value(label),
       centerTime = Value(centerTime);
  static Insertable<PeakNode> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<String>? centerTime,
    Expression<int>? windowRadiusMinutes,
    Expression<String>? frequency,
    Expression<String>? dayTypes,
    Expression<bool>? isHardest,
    Expression<String>? triggers,
    Expression<String>? emotionalState,
    Expression<String>? preContext,
    Expression<double>? empiricalFrequency,
    Expression<double>? avgIntensity,
    Expression<double>? slipRate,
    Expression<String>? triggerPosteriors,
    Expression<String>? topInterventions,
    Expression<int>? currentPeakStreak,
    Expression<int>? bestPeakStreak,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (centerTime != null) 'center_time': centerTime,
      if (windowRadiusMinutes != null)
        'window_radius_minutes': windowRadiusMinutes,
      if (frequency != null) 'frequency': frequency,
      if (dayTypes != null) 'day_types': dayTypes,
      if (isHardest != null) 'is_hardest': isHardest,
      if (triggers != null) 'triggers': triggers,
      if (emotionalState != null) 'emotional_state': emotionalState,
      if (preContext != null) 'pre_context': preContext,
      if (empiricalFrequency != null) 'empirical_frequency': empiricalFrequency,
      if (avgIntensity != null) 'avg_intensity': avgIntensity,
      if (slipRate != null) 'slip_rate': slipRate,
      if (triggerPosteriors != null) 'trigger_posteriors': triggerPosteriors,
      if (topInterventions != null) 'top_interventions': topInterventions,
      if (currentPeakStreak != null) 'current_peak_streak': currentPeakStreak,
      if (bestPeakStreak != null) 'best_peak_streak': bestPeakStreak,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PeakNodesCompanion copyWith({
    Value<int>? id,
    Value<String>? label,
    Value<String>? centerTime,
    Value<int>? windowRadiusMinutes,
    Value<String>? frequency,
    Value<String>? dayTypes,
    Value<bool>? isHardest,
    Value<String>? triggers,
    Value<String>? emotionalState,
    Value<String>? preContext,
    Value<double>? empiricalFrequency,
    Value<double>? avgIntensity,
    Value<double>? slipRate,
    Value<String>? triggerPosteriors,
    Value<String>? topInterventions,
    Value<int>? currentPeakStreak,
    Value<int>? bestPeakStreak,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PeakNodesCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      centerTime: centerTime ?? this.centerTime,
      windowRadiusMinutes: windowRadiusMinutes ?? this.windowRadiusMinutes,
      frequency: frequency ?? this.frequency,
      dayTypes: dayTypes ?? this.dayTypes,
      isHardest: isHardest ?? this.isHardest,
      triggers: triggers ?? this.triggers,
      emotionalState: emotionalState ?? this.emotionalState,
      preContext: preContext ?? this.preContext,
      empiricalFrequency: empiricalFrequency ?? this.empiricalFrequency,
      avgIntensity: avgIntensity ?? this.avgIntensity,
      slipRate: slipRate ?? this.slipRate,
      triggerPosteriors: triggerPosteriors ?? this.triggerPosteriors,
      topInterventions: topInterventions ?? this.topInterventions,
      currentPeakStreak: currentPeakStreak ?? this.currentPeakStreak,
      bestPeakStreak: bestPeakStreak ?? this.bestPeakStreak,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (centerTime.present) {
      map['center_time'] = Variable<String>(centerTime.value);
    }
    if (windowRadiusMinutes.present) {
      map['window_radius_minutes'] = Variable<int>(windowRadiusMinutes.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (dayTypes.present) {
      map['day_types'] = Variable<String>(dayTypes.value);
    }
    if (isHardest.present) {
      map['is_hardest'] = Variable<bool>(isHardest.value);
    }
    if (triggers.present) {
      map['triggers'] = Variable<String>(triggers.value);
    }
    if (emotionalState.present) {
      map['emotional_state'] = Variable<String>(emotionalState.value);
    }
    if (preContext.present) {
      map['pre_context'] = Variable<String>(preContext.value);
    }
    if (empiricalFrequency.present) {
      map['empirical_frequency'] = Variable<double>(empiricalFrequency.value);
    }
    if (avgIntensity.present) {
      map['avg_intensity'] = Variable<double>(avgIntensity.value);
    }
    if (slipRate.present) {
      map['slip_rate'] = Variable<double>(slipRate.value);
    }
    if (triggerPosteriors.present) {
      map['trigger_posteriors'] = Variable<String>(triggerPosteriors.value);
    }
    if (topInterventions.present) {
      map['top_interventions'] = Variable<String>(topInterventions.value);
    }
    if (currentPeakStreak.present) {
      map['current_peak_streak'] = Variable<int>(currentPeakStreak.value);
    }
    if (bestPeakStreak.present) {
      map['best_peak_streak'] = Variable<int>(bestPeakStreak.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeakNodesCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('centerTime: $centerTime, ')
          ..write('windowRadiusMinutes: $windowRadiusMinutes, ')
          ..write('frequency: $frequency, ')
          ..write('dayTypes: $dayTypes, ')
          ..write('isHardest: $isHardest, ')
          ..write('triggers: $triggers, ')
          ..write('emotionalState: $emotionalState, ')
          ..write('preContext: $preContext, ')
          ..write('empiricalFrequency: $empiricalFrequency, ')
          ..write('avgIntensity: $avgIntensity, ')
          ..write('slipRate: $slipRate, ')
          ..write('triggerPosteriors: $triggerPosteriors, ')
          ..write('topInterventions: $topInterventions, ')
          ..write('currentPeakStreak: $currentPeakStreak, ')
          ..write('bestPeakStreak: $bestPeakStreak, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RiskWindowsTable extends RiskWindows
    with TableInfo<$RiskWindowsTable, RiskWindow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RiskWindowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dayTypeMeta = const VerificationMeta(
    'dayType',
  );
  @override
  late final GeneratedColumn<String> dayType = GeneratedColumn<String>(
    'day_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _blockStartMeta = const VerificationMeta(
    'blockStart',
  );
  @override
  late final GeneratedColumn<String> blockStart = GeneratedColumn<String>(
    'block_start',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _blockEndMeta = const VerificationMeta(
    'blockEnd',
  );
  @override
  late final GeneratedColumn<String> blockEnd = GeneratedColumn<String>(
    'block_end',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nearestPeakIdMeta = const VerificationMeta(
    'nearestPeakId',
  );
  @override
  late final GeneratedColumn<int> nearestPeakId = GeneratedColumn<int>(
    'nearest_peak_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heuristicScoreMeta = const VerificationMeta(
    'heuristicScore',
  );
  @override
  late final GeneratedColumn<double> heuristicScore = GeneratedColumn<double>(
    'heuristic_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _empiricalScoreMeta = const VerificationMeta(
    'empiricalScore',
  );
  @override
  late final GeneratedColumn<double> empiricalScore = GeneratedColumn<double>(
    'empirical_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _blendedScoreMeta = const VerificationMeta(
    'blendedScore',
  );
  @override
  late final GeneratedColumn<double> blendedScore = GeneratedColumn<double>(
    'blended_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _alphaMeta = const VerificationMeta('alpha');
  @override
  late final GeneratedColumn<double> alpha = GeneratedColumn<double>(
    'alpha',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _dominantTriggerMeta = const VerificationMeta(
    'dominantTrigger',
  );
  @override
  late final GeneratedColumn<String> dominantTrigger = GeneratedColumn<String>(
    'dominant_trigger',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _topInterventionsMeta = const VerificationMeta(
    'topInterventions',
  );
  @override
  late final GeneratedColumn<String> topInterventions = GeneratedColumn<String>(
    'top_interventions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _observationCountMeta = const VerificationMeta(
    'observationCount',
  );
  @override
  late final GeneratedColumn<int> observationCount = GeneratedColumn<int>(
    'observation_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _urgeCountMeta = const VerificationMeta(
    'urgeCount',
  );
  @override
  late final GeneratedColumn<int> urgeCount = GeneratedColumn<int>(
    'urge_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _slipCountMeta = const VerificationMeta(
    'slipCount',
  );
  @override
  late final GeneratedColumn<int> slipCount = GeneratedColumn<int>(
    'slip_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cascadeMultiplierMeta = const VerificationMeta(
    'cascadeMultiplier',
  );
  @override
  late final GeneratedColumn<double> cascadeMultiplier =
      GeneratedColumn<double>(
        'cascade_multiplier',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(1.0),
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayType,
    dayOfWeek,
    blockStart,
    blockEnd,
    nearestPeakId,
    heuristicScore,
    empiricalScore,
    blendedScore,
    alpha,
    dominantTrigger,
    topInterventions,
    observationCount,
    urgeCount,
    slipCount,
    cascadeMultiplier,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'risk_windows';
  @override
  VerificationContext validateIntegrity(
    Insertable<RiskWindow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_type')) {
      context.handle(
        _dayTypeMeta,
        dayType.isAcceptableOrUnknown(data['day_type']!, _dayTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_dayTypeMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('block_start')) {
      context.handle(
        _blockStartMeta,
        blockStart.isAcceptableOrUnknown(data['block_start']!, _blockStartMeta),
      );
    } else if (isInserting) {
      context.missing(_blockStartMeta);
    }
    if (data.containsKey('block_end')) {
      context.handle(
        _blockEndMeta,
        blockEnd.isAcceptableOrUnknown(data['block_end']!, _blockEndMeta),
      );
    } else if (isInserting) {
      context.missing(_blockEndMeta);
    }
    if (data.containsKey('nearest_peak_id')) {
      context.handle(
        _nearestPeakIdMeta,
        nearestPeakId.isAcceptableOrUnknown(
          data['nearest_peak_id']!,
          _nearestPeakIdMeta,
        ),
      );
    }
    if (data.containsKey('heuristic_score')) {
      context.handle(
        _heuristicScoreMeta,
        heuristicScore.isAcceptableOrUnknown(
          data['heuristic_score']!,
          _heuristicScoreMeta,
        ),
      );
    }
    if (data.containsKey('empirical_score')) {
      context.handle(
        _empiricalScoreMeta,
        empiricalScore.isAcceptableOrUnknown(
          data['empirical_score']!,
          _empiricalScoreMeta,
        ),
      );
    }
    if (data.containsKey('blended_score')) {
      context.handle(
        _blendedScoreMeta,
        blendedScore.isAcceptableOrUnknown(
          data['blended_score']!,
          _blendedScoreMeta,
        ),
      );
    }
    if (data.containsKey('alpha')) {
      context.handle(
        _alphaMeta,
        alpha.isAcceptableOrUnknown(data['alpha']!, _alphaMeta),
      );
    }
    if (data.containsKey('dominant_trigger')) {
      context.handle(
        _dominantTriggerMeta,
        dominantTrigger.isAcceptableOrUnknown(
          data['dominant_trigger']!,
          _dominantTriggerMeta,
        ),
      );
    }
    if (data.containsKey('top_interventions')) {
      context.handle(
        _topInterventionsMeta,
        topInterventions.isAcceptableOrUnknown(
          data['top_interventions']!,
          _topInterventionsMeta,
        ),
      );
    }
    if (data.containsKey('observation_count')) {
      context.handle(
        _observationCountMeta,
        observationCount.isAcceptableOrUnknown(
          data['observation_count']!,
          _observationCountMeta,
        ),
      );
    }
    if (data.containsKey('urge_count')) {
      context.handle(
        _urgeCountMeta,
        urgeCount.isAcceptableOrUnknown(data['urge_count']!, _urgeCountMeta),
      );
    }
    if (data.containsKey('slip_count')) {
      context.handle(
        _slipCountMeta,
        slipCount.isAcceptableOrUnknown(data['slip_count']!, _slipCountMeta),
      );
    }
    if (data.containsKey('cascade_multiplier')) {
      context.handle(
        _cascadeMultiplierMeta,
        cascadeMultiplier.isAcceptableOrUnknown(
          data['cascade_multiplier']!,
          _cascadeMultiplierMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RiskWindow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RiskWindow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dayType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_type'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_week'],
      )!,
      blockStart: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}block_start'],
      )!,
      blockEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}block_end'],
      )!,
      nearestPeakId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nearest_peak_id'],
      ),
      heuristicScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heuristic_score'],
      )!,
      empiricalScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}empirical_score'],
      )!,
      blendedScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}blended_score'],
      )!,
      alpha: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}alpha'],
      )!,
      dominantTrigger: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dominant_trigger'],
      ),
      topInterventions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}top_interventions'],
      )!,
      observationCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}observation_count'],
      )!,
      urgeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urge_count'],
      )!,
      slipCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slip_count'],
      )!,
      cascadeMultiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cascade_multiplier'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RiskWindowsTable createAlias(String alias) {
    return $RiskWindowsTable(attachedDatabase, alias);
  }
}

class RiskWindow extends DataClass implements Insertable<RiskWindow> {
  final int id;
  final String dayType;
  final int dayOfWeek;
  final String blockStart;
  final String blockEnd;
  final int? nearestPeakId;
  final double heuristicScore;
  final double empiricalScore;
  final double blendedScore;
  final double alpha;
  final String? dominantTrigger;
  final String topInterventions;
  final int observationCount;
  final int urgeCount;
  final int slipCount;
  final double cascadeMultiplier;
  final DateTime updatedAt;
  const RiskWindow({
    required this.id,
    required this.dayType,
    required this.dayOfWeek,
    required this.blockStart,
    required this.blockEnd,
    this.nearestPeakId,
    required this.heuristicScore,
    required this.empiricalScore,
    required this.blendedScore,
    required this.alpha,
    this.dominantTrigger,
    required this.topInterventions,
    required this.observationCount,
    required this.urgeCount,
    required this.slipCount,
    required this.cascadeMultiplier,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_type'] = Variable<String>(dayType);
    map['day_of_week'] = Variable<int>(dayOfWeek);
    map['block_start'] = Variable<String>(blockStart);
    map['block_end'] = Variable<String>(blockEnd);
    if (!nullToAbsent || nearestPeakId != null) {
      map['nearest_peak_id'] = Variable<int>(nearestPeakId);
    }
    map['heuristic_score'] = Variable<double>(heuristicScore);
    map['empirical_score'] = Variable<double>(empiricalScore);
    map['blended_score'] = Variable<double>(blendedScore);
    map['alpha'] = Variable<double>(alpha);
    if (!nullToAbsent || dominantTrigger != null) {
      map['dominant_trigger'] = Variable<String>(dominantTrigger);
    }
    map['top_interventions'] = Variable<String>(topInterventions);
    map['observation_count'] = Variable<int>(observationCount);
    map['urge_count'] = Variable<int>(urgeCount);
    map['slip_count'] = Variable<int>(slipCount);
    map['cascade_multiplier'] = Variable<double>(cascadeMultiplier);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RiskWindowsCompanion toCompanion(bool nullToAbsent) {
    return RiskWindowsCompanion(
      id: Value(id),
      dayType: Value(dayType),
      dayOfWeek: Value(dayOfWeek),
      blockStart: Value(blockStart),
      blockEnd: Value(blockEnd),
      nearestPeakId: nearestPeakId == null && nullToAbsent
          ? const Value.absent()
          : Value(nearestPeakId),
      heuristicScore: Value(heuristicScore),
      empiricalScore: Value(empiricalScore),
      blendedScore: Value(blendedScore),
      alpha: Value(alpha),
      dominantTrigger: dominantTrigger == null && nullToAbsent
          ? const Value.absent()
          : Value(dominantTrigger),
      topInterventions: Value(topInterventions),
      observationCount: Value(observationCount),
      urgeCount: Value(urgeCount),
      slipCount: Value(slipCount),
      cascadeMultiplier: Value(cascadeMultiplier),
      updatedAt: Value(updatedAt),
    );
  }

  factory RiskWindow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RiskWindow(
      id: serializer.fromJson<int>(json['id']),
      dayType: serializer.fromJson<String>(json['dayType']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      blockStart: serializer.fromJson<String>(json['blockStart']),
      blockEnd: serializer.fromJson<String>(json['blockEnd']),
      nearestPeakId: serializer.fromJson<int?>(json['nearestPeakId']),
      heuristicScore: serializer.fromJson<double>(json['heuristicScore']),
      empiricalScore: serializer.fromJson<double>(json['empiricalScore']),
      blendedScore: serializer.fromJson<double>(json['blendedScore']),
      alpha: serializer.fromJson<double>(json['alpha']),
      dominantTrigger: serializer.fromJson<String?>(json['dominantTrigger']),
      topInterventions: serializer.fromJson<String>(json['topInterventions']),
      observationCount: serializer.fromJson<int>(json['observationCount']),
      urgeCount: serializer.fromJson<int>(json['urgeCount']),
      slipCount: serializer.fromJson<int>(json['slipCount']),
      cascadeMultiplier: serializer.fromJson<double>(json['cascadeMultiplier']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayType': serializer.toJson<String>(dayType),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'blockStart': serializer.toJson<String>(blockStart),
      'blockEnd': serializer.toJson<String>(blockEnd),
      'nearestPeakId': serializer.toJson<int?>(nearestPeakId),
      'heuristicScore': serializer.toJson<double>(heuristicScore),
      'empiricalScore': serializer.toJson<double>(empiricalScore),
      'blendedScore': serializer.toJson<double>(blendedScore),
      'alpha': serializer.toJson<double>(alpha),
      'dominantTrigger': serializer.toJson<String?>(dominantTrigger),
      'topInterventions': serializer.toJson<String>(topInterventions),
      'observationCount': serializer.toJson<int>(observationCount),
      'urgeCount': serializer.toJson<int>(urgeCount),
      'slipCount': serializer.toJson<int>(slipCount),
      'cascadeMultiplier': serializer.toJson<double>(cascadeMultiplier),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RiskWindow copyWith({
    int? id,
    String? dayType,
    int? dayOfWeek,
    String? blockStart,
    String? blockEnd,
    Value<int?> nearestPeakId = const Value.absent(),
    double? heuristicScore,
    double? empiricalScore,
    double? blendedScore,
    double? alpha,
    Value<String?> dominantTrigger = const Value.absent(),
    String? topInterventions,
    int? observationCount,
    int? urgeCount,
    int? slipCount,
    double? cascadeMultiplier,
    DateTime? updatedAt,
  }) => RiskWindow(
    id: id ?? this.id,
    dayType: dayType ?? this.dayType,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    blockStart: blockStart ?? this.blockStart,
    blockEnd: blockEnd ?? this.blockEnd,
    nearestPeakId: nearestPeakId.present
        ? nearestPeakId.value
        : this.nearestPeakId,
    heuristicScore: heuristicScore ?? this.heuristicScore,
    empiricalScore: empiricalScore ?? this.empiricalScore,
    blendedScore: blendedScore ?? this.blendedScore,
    alpha: alpha ?? this.alpha,
    dominantTrigger: dominantTrigger.present
        ? dominantTrigger.value
        : this.dominantTrigger,
    topInterventions: topInterventions ?? this.topInterventions,
    observationCount: observationCount ?? this.observationCount,
    urgeCount: urgeCount ?? this.urgeCount,
    slipCount: slipCount ?? this.slipCount,
    cascadeMultiplier: cascadeMultiplier ?? this.cascadeMultiplier,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RiskWindow copyWithCompanion(RiskWindowsCompanion data) {
    return RiskWindow(
      id: data.id.present ? data.id.value : this.id,
      dayType: data.dayType.present ? data.dayType.value : this.dayType,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      blockStart: data.blockStart.present
          ? data.blockStart.value
          : this.blockStart,
      blockEnd: data.blockEnd.present ? data.blockEnd.value : this.blockEnd,
      nearestPeakId: data.nearestPeakId.present
          ? data.nearestPeakId.value
          : this.nearestPeakId,
      heuristicScore: data.heuristicScore.present
          ? data.heuristicScore.value
          : this.heuristicScore,
      empiricalScore: data.empiricalScore.present
          ? data.empiricalScore.value
          : this.empiricalScore,
      blendedScore: data.blendedScore.present
          ? data.blendedScore.value
          : this.blendedScore,
      alpha: data.alpha.present ? data.alpha.value : this.alpha,
      dominantTrigger: data.dominantTrigger.present
          ? data.dominantTrigger.value
          : this.dominantTrigger,
      topInterventions: data.topInterventions.present
          ? data.topInterventions.value
          : this.topInterventions,
      observationCount: data.observationCount.present
          ? data.observationCount.value
          : this.observationCount,
      urgeCount: data.urgeCount.present ? data.urgeCount.value : this.urgeCount,
      slipCount: data.slipCount.present ? data.slipCount.value : this.slipCount,
      cascadeMultiplier: data.cascadeMultiplier.present
          ? data.cascadeMultiplier.value
          : this.cascadeMultiplier,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RiskWindow(')
          ..write('id: $id, ')
          ..write('dayType: $dayType, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('blockStart: $blockStart, ')
          ..write('blockEnd: $blockEnd, ')
          ..write('nearestPeakId: $nearestPeakId, ')
          ..write('heuristicScore: $heuristicScore, ')
          ..write('empiricalScore: $empiricalScore, ')
          ..write('blendedScore: $blendedScore, ')
          ..write('alpha: $alpha, ')
          ..write('dominantTrigger: $dominantTrigger, ')
          ..write('topInterventions: $topInterventions, ')
          ..write('observationCount: $observationCount, ')
          ..write('urgeCount: $urgeCount, ')
          ..write('slipCount: $slipCount, ')
          ..write('cascadeMultiplier: $cascadeMultiplier, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dayType,
    dayOfWeek,
    blockStart,
    blockEnd,
    nearestPeakId,
    heuristicScore,
    empiricalScore,
    blendedScore,
    alpha,
    dominantTrigger,
    topInterventions,
    observationCount,
    urgeCount,
    slipCount,
    cascadeMultiplier,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RiskWindow &&
          other.id == this.id &&
          other.dayType == this.dayType &&
          other.dayOfWeek == this.dayOfWeek &&
          other.blockStart == this.blockStart &&
          other.blockEnd == this.blockEnd &&
          other.nearestPeakId == this.nearestPeakId &&
          other.heuristicScore == this.heuristicScore &&
          other.empiricalScore == this.empiricalScore &&
          other.blendedScore == this.blendedScore &&
          other.alpha == this.alpha &&
          other.dominantTrigger == this.dominantTrigger &&
          other.topInterventions == this.topInterventions &&
          other.observationCount == this.observationCount &&
          other.urgeCount == this.urgeCount &&
          other.slipCount == this.slipCount &&
          other.cascadeMultiplier == this.cascadeMultiplier &&
          other.updatedAt == this.updatedAt);
}

class RiskWindowsCompanion extends UpdateCompanion<RiskWindow> {
  final Value<int> id;
  final Value<String> dayType;
  final Value<int> dayOfWeek;
  final Value<String> blockStart;
  final Value<String> blockEnd;
  final Value<int?> nearestPeakId;
  final Value<double> heuristicScore;
  final Value<double> empiricalScore;
  final Value<double> blendedScore;
  final Value<double> alpha;
  final Value<String?> dominantTrigger;
  final Value<String> topInterventions;
  final Value<int> observationCount;
  final Value<int> urgeCount;
  final Value<int> slipCount;
  final Value<double> cascadeMultiplier;
  final Value<DateTime> updatedAt;
  const RiskWindowsCompanion({
    this.id = const Value.absent(),
    this.dayType = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.blockStart = const Value.absent(),
    this.blockEnd = const Value.absent(),
    this.nearestPeakId = const Value.absent(),
    this.heuristicScore = const Value.absent(),
    this.empiricalScore = const Value.absent(),
    this.blendedScore = const Value.absent(),
    this.alpha = const Value.absent(),
    this.dominantTrigger = const Value.absent(),
    this.topInterventions = const Value.absent(),
    this.observationCount = const Value.absent(),
    this.urgeCount = const Value.absent(),
    this.slipCount = const Value.absent(),
    this.cascadeMultiplier = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RiskWindowsCompanion.insert({
    this.id = const Value.absent(),
    required String dayType,
    required int dayOfWeek,
    required String blockStart,
    required String blockEnd,
    this.nearestPeakId = const Value.absent(),
    this.heuristicScore = const Value.absent(),
    this.empiricalScore = const Value.absent(),
    this.blendedScore = const Value.absent(),
    this.alpha = const Value.absent(),
    this.dominantTrigger = const Value.absent(),
    this.topInterventions = const Value.absent(),
    this.observationCount = const Value.absent(),
    this.urgeCount = const Value.absent(),
    this.slipCount = const Value.absent(),
    this.cascadeMultiplier = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : dayType = Value(dayType),
       dayOfWeek = Value(dayOfWeek),
       blockStart = Value(blockStart),
       blockEnd = Value(blockEnd);
  static Insertable<RiskWindow> custom({
    Expression<int>? id,
    Expression<String>? dayType,
    Expression<int>? dayOfWeek,
    Expression<String>? blockStart,
    Expression<String>? blockEnd,
    Expression<int>? nearestPeakId,
    Expression<double>? heuristicScore,
    Expression<double>? empiricalScore,
    Expression<double>? blendedScore,
    Expression<double>? alpha,
    Expression<String>? dominantTrigger,
    Expression<String>? topInterventions,
    Expression<int>? observationCount,
    Expression<int>? urgeCount,
    Expression<int>? slipCount,
    Expression<double>? cascadeMultiplier,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayType != null) 'day_type': dayType,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (blockStart != null) 'block_start': blockStart,
      if (blockEnd != null) 'block_end': blockEnd,
      if (nearestPeakId != null) 'nearest_peak_id': nearestPeakId,
      if (heuristicScore != null) 'heuristic_score': heuristicScore,
      if (empiricalScore != null) 'empirical_score': empiricalScore,
      if (blendedScore != null) 'blended_score': blendedScore,
      if (alpha != null) 'alpha': alpha,
      if (dominantTrigger != null) 'dominant_trigger': dominantTrigger,
      if (topInterventions != null) 'top_interventions': topInterventions,
      if (observationCount != null) 'observation_count': observationCount,
      if (urgeCount != null) 'urge_count': urgeCount,
      if (slipCount != null) 'slip_count': slipCount,
      if (cascadeMultiplier != null) 'cascade_multiplier': cascadeMultiplier,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RiskWindowsCompanion copyWith({
    Value<int>? id,
    Value<String>? dayType,
    Value<int>? dayOfWeek,
    Value<String>? blockStart,
    Value<String>? blockEnd,
    Value<int?>? nearestPeakId,
    Value<double>? heuristicScore,
    Value<double>? empiricalScore,
    Value<double>? blendedScore,
    Value<double>? alpha,
    Value<String?>? dominantTrigger,
    Value<String>? topInterventions,
    Value<int>? observationCount,
    Value<int>? urgeCount,
    Value<int>? slipCount,
    Value<double>? cascadeMultiplier,
    Value<DateTime>? updatedAt,
  }) {
    return RiskWindowsCompanion(
      id: id ?? this.id,
      dayType: dayType ?? this.dayType,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      blockStart: blockStart ?? this.blockStart,
      blockEnd: blockEnd ?? this.blockEnd,
      nearestPeakId: nearestPeakId ?? this.nearestPeakId,
      heuristicScore: heuristicScore ?? this.heuristicScore,
      empiricalScore: empiricalScore ?? this.empiricalScore,
      blendedScore: blendedScore ?? this.blendedScore,
      alpha: alpha ?? this.alpha,
      dominantTrigger: dominantTrigger ?? this.dominantTrigger,
      topInterventions: topInterventions ?? this.topInterventions,
      observationCount: observationCount ?? this.observationCount,
      urgeCount: urgeCount ?? this.urgeCount,
      slipCount: slipCount ?? this.slipCount,
      cascadeMultiplier: cascadeMultiplier ?? this.cascadeMultiplier,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayType.present) {
      map['day_type'] = Variable<String>(dayType.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (blockStart.present) {
      map['block_start'] = Variable<String>(blockStart.value);
    }
    if (blockEnd.present) {
      map['block_end'] = Variable<String>(blockEnd.value);
    }
    if (nearestPeakId.present) {
      map['nearest_peak_id'] = Variable<int>(nearestPeakId.value);
    }
    if (heuristicScore.present) {
      map['heuristic_score'] = Variable<double>(heuristicScore.value);
    }
    if (empiricalScore.present) {
      map['empirical_score'] = Variable<double>(empiricalScore.value);
    }
    if (blendedScore.present) {
      map['blended_score'] = Variable<double>(blendedScore.value);
    }
    if (alpha.present) {
      map['alpha'] = Variable<double>(alpha.value);
    }
    if (dominantTrigger.present) {
      map['dominant_trigger'] = Variable<String>(dominantTrigger.value);
    }
    if (topInterventions.present) {
      map['top_interventions'] = Variable<String>(topInterventions.value);
    }
    if (observationCount.present) {
      map['observation_count'] = Variable<int>(observationCount.value);
    }
    if (urgeCount.present) {
      map['urge_count'] = Variable<int>(urgeCount.value);
    }
    if (slipCount.present) {
      map['slip_count'] = Variable<int>(slipCount.value);
    }
    if (cascadeMultiplier.present) {
      map['cascade_multiplier'] = Variable<double>(cascadeMultiplier.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RiskWindowsCompanion(')
          ..write('id: $id, ')
          ..write('dayType: $dayType, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('blockStart: $blockStart, ')
          ..write('blockEnd: $blockEnd, ')
          ..write('nearestPeakId: $nearestPeakId, ')
          ..write('heuristicScore: $heuristicScore, ')
          ..write('empiricalScore: $empiricalScore, ')
          ..write('blendedScore: $blendedScore, ')
          ..write('alpha: $alpha, ')
          ..write('dominantTrigger: $dominantTrigger, ')
          ..write('topInterventions: $topInterventions, ')
          ..write('observationCount: $observationCount, ')
          ..write('urgeCount: $urgeCount, ')
          ..write('slipCount: $slipCount, ')
          ..write('cascadeMultiplier: $cascadeMultiplier, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyCheckinsTable extends DailyCheckins
    with TableInfo<$DailyCheckinsTable, DailyCheckin> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyCheckinsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hadUrgeMeta = const VerificationMeta(
    'hadUrge',
  );
  @override
  late final GeneratedColumn<bool> hadUrge = GeneratedColumn<bool>(
    'had_urge',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("had_urge" IN (0, 1))',
    ),
  );
  static const VerificationMeta _urgeMaxMeta = const VerificationMeta(
    'urgeMax',
  );
  @override
  late final GeneratedColumn<int> urgeMax = GeneratedColumn<int>(
    'urge_max',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mainTriggerMeta = const VerificationMeta(
    'mainTrigger',
  );
  @override
  late final GeneratedColumn<String> mainTrigger = GeneratedColumn<String>(
    'main_trigger',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _slippedMeta = const VerificationMeta(
    'slipped',
  );
  @override
  late final GeneratedColumn<bool> slipped = GeneratedColumn<bool>(
    'slipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("slipped" IN (0, 1))',
    ),
  );
  static const VerificationMeta _slipCountMeta = const VerificationMeta(
    'slipCount',
  );
  @override
  late final GeneratedColumn<int> slipCount = GeneratedColumn<int>(
    'slip_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sleepQualityMeta = const VerificationMeta(
    'sleepQuality',
  );
  @override
  late final GeneratedColumn<int> sleepQuality = GeneratedColumn<int>(
    'sleep_quality',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
    'mood',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stressMeta = const VerificationMeta('stress');
  @override
  late final GeneratedColumn<int> stress = GeneratedColumn<int>(
    'stress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceTomorrowMeta =
      const VerificationMeta('confidenceTomorrow');
  @override
  late final GeneratedColumn<int> confidenceTomorrow = GeneratedColumn<int>(
    'confidence_tomorrow',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    hadUrge,
    urgeMax,
    mainTrigger,
    slipped,
    slipCount,
    sleepQuality,
    mood,
    stress,
    confidenceTomorrow,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_checkins';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyCheckin> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('had_urge')) {
      context.handle(
        _hadUrgeMeta,
        hadUrge.isAcceptableOrUnknown(data['had_urge']!, _hadUrgeMeta),
      );
    } else if (isInserting) {
      context.missing(_hadUrgeMeta);
    }
    if (data.containsKey('urge_max')) {
      context.handle(
        _urgeMaxMeta,
        urgeMax.isAcceptableOrUnknown(data['urge_max']!, _urgeMaxMeta),
      );
    }
    if (data.containsKey('main_trigger')) {
      context.handle(
        _mainTriggerMeta,
        mainTrigger.isAcceptableOrUnknown(
          data['main_trigger']!,
          _mainTriggerMeta,
        ),
      );
    }
    if (data.containsKey('slipped')) {
      context.handle(
        _slippedMeta,
        slipped.isAcceptableOrUnknown(data['slipped']!, _slippedMeta),
      );
    } else if (isInserting) {
      context.missing(_slippedMeta);
    }
    if (data.containsKey('slip_count')) {
      context.handle(
        _slipCountMeta,
        slipCount.isAcceptableOrUnknown(data['slip_count']!, _slipCountMeta),
      );
    }
    if (data.containsKey('sleep_quality')) {
      context.handle(
        _sleepQualityMeta,
        sleepQuality.isAcceptableOrUnknown(
          data['sleep_quality']!,
          _sleepQualityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sleepQualityMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('stress')) {
      context.handle(
        _stressMeta,
        stress.isAcceptableOrUnknown(data['stress']!, _stressMeta),
      );
    } else if (isInserting) {
      context.missing(_stressMeta);
    }
    if (data.containsKey('confidence_tomorrow')) {
      context.handle(
        _confidenceTomorrowMeta,
        confidenceTomorrow.isAcceptableOrUnknown(
          data['confidence_tomorrow']!,
          _confidenceTomorrowMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_confidenceTomorrowMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyCheckin map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyCheckin(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      hadUrge: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}had_urge'],
      )!,
      urgeMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urge_max'],
      ),
      mainTrigger: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}main_trigger'],
      ),
      slipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}slipped'],
      )!,
      slipCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slip_count'],
      )!,
      sleepQuality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_quality'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood'],
      )!,
      stress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stress'],
      )!,
      confidenceTomorrow: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}confidence_tomorrow'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DailyCheckinsTable createAlias(String alias) {
    return $DailyCheckinsTable(attachedDatabase, alias);
  }
}

class DailyCheckin extends DataClass implements Insertable<DailyCheckin> {
  final int id;
  final DateTime date;
  final bool hadUrge;
  final int? urgeMax;
  final String? mainTrigger;
  final bool slipped;
  final int slipCount;
  final int sleepQuality;
  final int mood;
  final int stress;
  final int confidenceTomorrow;
  final String? notes;
  final DateTime createdAt;
  const DailyCheckin({
    required this.id,
    required this.date,
    required this.hadUrge,
    this.urgeMax,
    this.mainTrigger,
    required this.slipped,
    required this.slipCount,
    required this.sleepQuality,
    required this.mood,
    required this.stress,
    required this.confidenceTomorrow,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['had_urge'] = Variable<bool>(hadUrge);
    if (!nullToAbsent || urgeMax != null) {
      map['urge_max'] = Variable<int>(urgeMax);
    }
    if (!nullToAbsent || mainTrigger != null) {
      map['main_trigger'] = Variable<String>(mainTrigger);
    }
    map['slipped'] = Variable<bool>(slipped);
    map['slip_count'] = Variable<int>(slipCount);
    map['sleep_quality'] = Variable<int>(sleepQuality);
    map['mood'] = Variable<int>(mood);
    map['stress'] = Variable<int>(stress);
    map['confidence_tomorrow'] = Variable<int>(confidenceTomorrow);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DailyCheckinsCompanion toCompanion(bool nullToAbsent) {
    return DailyCheckinsCompanion(
      id: Value(id),
      date: Value(date),
      hadUrge: Value(hadUrge),
      urgeMax: urgeMax == null && nullToAbsent
          ? const Value.absent()
          : Value(urgeMax),
      mainTrigger: mainTrigger == null && nullToAbsent
          ? const Value.absent()
          : Value(mainTrigger),
      slipped: Value(slipped),
      slipCount: Value(slipCount),
      sleepQuality: Value(sleepQuality),
      mood: Value(mood),
      stress: Value(stress),
      confidenceTomorrow: Value(confidenceTomorrow),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory DailyCheckin.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyCheckin(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      hadUrge: serializer.fromJson<bool>(json['hadUrge']),
      urgeMax: serializer.fromJson<int?>(json['urgeMax']),
      mainTrigger: serializer.fromJson<String?>(json['mainTrigger']),
      slipped: serializer.fromJson<bool>(json['slipped']),
      slipCount: serializer.fromJson<int>(json['slipCount']),
      sleepQuality: serializer.fromJson<int>(json['sleepQuality']),
      mood: serializer.fromJson<int>(json['mood']),
      stress: serializer.fromJson<int>(json['stress']),
      confidenceTomorrow: serializer.fromJson<int>(json['confidenceTomorrow']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'hadUrge': serializer.toJson<bool>(hadUrge),
      'urgeMax': serializer.toJson<int?>(urgeMax),
      'mainTrigger': serializer.toJson<String?>(mainTrigger),
      'slipped': serializer.toJson<bool>(slipped),
      'slipCount': serializer.toJson<int>(slipCount),
      'sleepQuality': serializer.toJson<int>(sleepQuality),
      'mood': serializer.toJson<int>(mood),
      'stress': serializer.toJson<int>(stress),
      'confidenceTomorrow': serializer.toJson<int>(confidenceTomorrow),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DailyCheckin copyWith({
    int? id,
    DateTime? date,
    bool? hadUrge,
    Value<int?> urgeMax = const Value.absent(),
    Value<String?> mainTrigger = const Value.absent(),
    bool? slipped,
    int? slipCount,
    int? sleepQuality,
    int? mood,
    int? stress,
    int? confidenceTomorrow,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => DailyCheckin(
    id: id ?? this.id,
    date: date ?? this.date,
    hadUrge: hadUrge ?? this.hadUrge,
    urgeMax: urgeMax.present ? urgeMax.value : this.urgeMax,
    mainTrigger: mainTrigger.present ? mainTrigger.value : this.mainTrigger,
    slipped: slipped ?? this.slipped,
    slipCount: slipCount ?? this.slipCount,
    sleepQuality: sleepQuality ?? this.sleepQuality,
    mood: mood ?? this.mood,
    stress: stress ?? this.stress,
    confidenceTomorrow: confidenceTomorrow ?? this.confidenceTomorrow,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  DailyCheckin copyWithCompanion(DailyCheckinsCompanion data) {
    return DailyCheckin(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      hadUrge: data.hadUrge.present ? data.hadUrge.value : this.hadUrge,
      urgeMax: data.urgeMax.present ? data.urgeMax.value : this.urgeMax,
      mainTrigger: data.mainTrigger.present
          ? data.mainTrigger.value
          : this.mainTrigger,
      slipped: data.slipped.present ? data.slipped.value : this.slipped,
      slipCount: data.slipCount.present ? data.slipCount.value : this.slipCount,
      sleepQuality: data.sleepQuality.present
          ? data.sleepQuality.value
          : this.sleepQuality,
      mood: data.mood.present ? data.mood.value : this.mood,
      stress: data.stress.present ? data.stress.value : this.stress,
      confidenceTomorrow: data.confidenceTomorrow.present
          ? data.confidenceTomorrow.value
          : this.confidenceTomorrow,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyCheckin(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('hadUrge: $hadUrge, ')
          ..write('urgeMax: $urgeMax, ')
          ..write('mainTrigger: $mainTrigger, ')
          ..write('slipped: $slipped, ')
          ..write('slipCount: $slipCount, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('mood: $mood, ')
          ..write('stress: $stress, ')
          ..write('confidenceTomorrow: $confidenceTomorrow, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    hadUrge,
    urgeMax,
    mainTrigger,
    slipped,
    slipCount,
    sleepQuality,
    mood,
    stress,
    confidenceTomorrow,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyCheckin &&
          other.id == this.id &&
          other.date == this.date &&
          other.hadUrge == this.hadUrge &&
          other.urgeMax == this.urgeMax &&
          other.mainTrigger == this.mainTrigger &&
          other.slipped == this.slipped &&
          other.slipCount == this.slipCount &&
          other.sleepQuality == this.sleepQuality &&
          other.mood == this.mood &&
          other.stress == this.stress &&
          other.confidenceTomorrow == this.confidenceTomorrow &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class DailyCheckinsCompanion extends UpdateCompanion<DailyCheckin> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<bool> hadUrge;
  final Value<int?> urgeMax;
  final Value<String?> mainTrigger;
  final Value<bool> slipped;
  final Value<int> slipCount;
  final Value<int> sleepQuality;
  final Value<int> mood;
  final Value<int> stress;
  final Value<int> confidenceTomorrow;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const DailyCheckinsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.hadUrge = const Value.absent(),
    this.urgeMax = const Value.absent(),
    this.mainTrigger = const Value.absent(),
    this.slipped = const Value.absent(),
    this.slipCount = const Value.absent(),
    this.sleepQuality = const Value.absent(),
    this.mood = const Value.absent(),
    this.stress = const Value.absent(),
    this.confidenceTomorrow = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DailyCheckinsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required bool hadUrge,
    this.urgeMax = const Value.absent(),
    this.mainTrigger = const Value.absent(),
    required bool slipped,
    this.slipCount = const Value.absent(),
    required int sleepQuality,
    required int mood,
    required int stress,
    required int confidenceTomorrow,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : date = Value(date),
       hadUrge = Value(hadUrge),
       slipped = Value(slipped),
       sleepQuality = Value(sleepQuality),
       mood = Value(mood),
       stress = Value(stress),
       confidenceTomorrow = Value(confidenceTomorrow);
  static Insertable<DailyCheckin> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<bool>? hadUrge,
    Expression<int>? urgeMax,
    Expression<String>? mainTrigger,
    Expression<bool>? slipped,
    Expression<int>? slipCount,
    Expression<int>? sleepQuality,
    Expression<int>? mood,
    Expression<int>? stress,
    Expression<int>? confidenceTomorrow,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (hadUrge != null) 'had_urge': hadUrge,
      if (urgeMax != null) 'urge_max': urgeMax,
      if (mainTrigger != null) 'main_trigger': mainTrigger,
      if (slipped != null) 'slipped': slipped,
      if (slipCount != null) 'slip_count': slipCount,
      if (sleepQuality != null) 'sleep_quality': sleepQuality,
      if (mood != null) 'mood': mood,
      if (stress != null) 'stress': stress,
      if (confidenceTomorrow != null) 'confidence_tomorrow': confidenceTomorrow,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DailyCheckinsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<bool>? hadUrge,
    Value<int?>? urgeMax,
    Value<String?>? mainTrigger,
    Value<bool>? slipped,
    Value<int>? slipCount,
    Value<int>? sleepQuality,
    Value<int>? mood,
    Value<int>? stress,
    Value<int>? confidenceTomorrow,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return DailyCheckinsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      hadUrge: hadUrge ?? this.hadUrge,
      urgeMax: urgeMax ?? this.urgeMax,
      mainTrigger: mainTrigger ?? this.mainTrigger,
      slipped: slipped ?? this.slipped,
      slipCount: slipCount ?? this.slipCount,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      mood: mood ?? this.mood,
      stress: stress ?? this.stress,
      confidenceTomorrow: confidenceTomorrow ?? this.confidenceTomorrow,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (hadUrge.present) {
      map['had_urge'] = Variable<bool>(hadUrge.value);
    }
    if (urgeMax.present) {
      map['urge_max'] = Variable<int>(urgeMax.value);
    }
    if (mainTrigger.present) {
      map['main_trigger'] = Variable<String>(mainTrigger.value);
    }
    if (slipped.present) {
      map['slipped'] = Variable<bool>(slipped.value);
    }
    if (slipCount.present) {
      map['slip_count'] = Variable<int>(slipCount.value);
    }
    if (sleepQuality.present) {
      map['sleep_quality'] = Variable<int>(sleepQuality.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (stress.present) {
      map['stress'] = Variable<int>(stress.value);
    }
    if (confidenceTomorrow.present) {
      map['confidence_tomorrow'] = Variable<int>(confidenceTomorrow.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyCheckinsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('hadUrge: $hadUrge, ')
          ..write('urgeMax: $urgeMax, ')
          ..write('mainTrigger: $mainTrigger, ')
          ..write('slipped: $slipped, ')
          ..write('slipCount: $slipCount, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('mood: $mood, ')
          ..write('stress: $stress, ')
          ..write('confidenceTomorrow: $confidenceTomorrow, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UrgeEventsTable extends UrgeEvents
    with TableInfo<$UrgeEventsTable, UrgeEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UrgeEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('realtime'),
  );
  static const VerificationMeta _triggerMeta = const VerificationMeta(
    'trigger',
  );
  @override
  late final GeneratedColumn<String> trigger = GeneratedColumn<String>(
    'trigger',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextTagMeta = const VerificationMeta(
    'contextTag',
  );
  @override
  late final GeneratedColumn<String> contextTag = GeneratedColumn<String>(
    'context_tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intensityBeforeMeta = const VerificationMeta(
    'intensityBefore',
  );
  @override
  late final GeneratedColumn<int> intensityBefore = GeneratedColumn<int>(
    'intensity_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chosenRescueMeta = const VerificationMeta(
    'chosenRescue',
  );
  @override
  late final GeneratedColumn<String> chosenRescue = GeneratedColumn<String>(
    'chosen_rescue',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intensityAfterMeta = const VerificationMeta(
    'intensityAfter',
  );
  @override
  late final GeneratedColumn<int> intensityAfter = GeneratedColumn<int>(
    'intensity_after',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _slipFollowedMeta = const VerificationMeta(
    'slipFollowed',
  );
  @override
  late final GeneratedColumn<bool> slipFollowed = GeneratedColumn<bool>(
    'slip_followed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("slip_followed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rescueTasksUsedMeta = const VerificationMeta(
    'rescueTasksUsed',
  );
  @override
  late final GeneratedColumn<String> rescueTasksUsed = GeneratedColumn<String>(
    'rescue_tasks_used',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    source,
    trigger,
    contextTag,
    location,
    intensityBefore,
    chosenRescue,
    intensityAfter,
    slipFollowed,
    durationSeconds,
    rescueTasksUsed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'urge_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<UrgeEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('trigger')) {
      context.handle(
        _triggerMeta,
        trigger.isAcceptableOrUnknown(data['trigger']!, _triggerMeta),
      );
    } else if (isInserting) {
      context.missing(_triggerMeta);
    }
    if (data.containsKey('context_tag')) {
      context.handle(
        _contextTagMeta,
        contextTag.isAcceptableOrUnknown(data['context_tag']!, _contextTagMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('intensity_before')) {
      context.handle(
        _intensityBeforeMeta,
        intensityBefore.isAcceptableOrUnknown(
          data['intensity_before']!,
          _intensityBeforeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_intensityBeforeMeta);
    }
    if (data.containsKey('chosen_rescue')) {
      context.handle(
        _chosenRescueMeta,
        chosenRescue.isAcceptableOrUnknown(
          data['chosen_rescue']!,
          _chosenRescueMeta,
        ),
      );
    }
    if (data.containsKey('intensity_after')) {
      context.handle(
        _intensityAfterMeta,
        intensityAfter.isAcceptableOrUnknown(
          data['intensity_after']!,
          _intensityAfterMeta,
        ),
      );
    }
    if (data.containsKey('slip_followed')) {
      context.handle(
        _slipFollowedMeta,
        slipFollowed.isAcceptableOrUnknown(
          data['slip_followed']!,
          _slipFollowedMeta,
        ),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('rescue_tasks_used')) {
      context.handle(
        _rescueTasksUsedMeta,
        rescueTasksUsed.isAcceptableOrUnknown(
          data['rescue_tasks_used']!,
          _rescueTasksUsedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UrgeEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UrgeEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      trigger: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger'],
      )!,
      contextTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_tag'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      intensityBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity_before'],
      )!,
      chosenRescue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chosen_rescue'],
      ),
      intensityAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity_after'],
      ),
      slipFollowed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}slip_followed'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      rescueTasksUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rescue_tasks_used'],
      )!,
    );
  }

  @override
  $UrgeEventsTable createAlias(String alias) {
    return $UrgeEventsTable(attachedDatabase, alias);
  }
}

class UrgeEvent extends DataClass implements Insertable<UrgeEvent> {
  final int id;
  final DateTime timestamp;
  final String source;
  final String trigger;
  final String? contextTag;
  final String? location;
  final int intensityBefore;
  final String? chosenRescue;
  final int? intensityAfter;
  final bool slipFollowed;
  final int? durationSeconds;
  final String rescueTasksUsed;
  const UrgeEvent({
    required this.id,
    required this.timestamp,
    required this.source,
    required this.trigger,
    this.contextTag,
    this.location,
    required this.intensityBefore,
    this.chosenRescue,
    this.intensityAfter,
    required this.slipFollowed,
    this.durationSeconds,
    required this.rescueTasksUsed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['source'] = Variable<String>(source);
    map['trigger'] = Variable<String>(trigger);
    if (!nullToAbsent || contextTag != null) {
      map['context_tag'] = Variable<String>(contextTag);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['intensity_before'] = Variable<int>(intensityBefore);
    if (!nullToAbsent || chosenRescue != null) {
      map['chosen_rescue'] = Variable<String>(chosenRescue);
    }
    if (!nullToAbsent || intensityAfter != null) {
      map['intensity_after'] = Variable<int>(intensityAfter);
    }
    map['slip_followed'] = Variable<bool>(slipFollowed);
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    map['rescue_tasks_used'] = Variable<String>(rescueTasksUsed);
    return map;
  }

  UrgeEventsCompanion toCompanion(bool nullToAbsent) {
    return UrgeEventsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      source: Value(source),
      trigger: Value(trigger),
      contextTag: contextTag == null && nullToAbsent
          ? const Value.absent()
          : Value(contextTag),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      intensityBefore: Value(intensityBefore),
      chosenRescue: chosenRescue == null && nullToAbsent
          ? const Value.absent()
          : Value(chosenRescue),
      intensityAfter: intensityAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(intensityAfter),
      slipFollowed: Value(slipFollowed),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      rescueTasksUsed: Value(rescueTasksUsed),
    );
  }

  factory UrgeEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UrgeEvent(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      source: serializer.fromJson<String>(json['source']),
      trigger: serializer.fromJson<String>(json['trigger']),
      contextTag: serializer.fromJson<String?>(json['contextTag']),
      location: serializer.fromJson<String?>(json['location']),
      intensityBefore: serializer.fromJson<int>(json['intensityBefore']),
      chosenRescue: serializer.fromJson<String?>(json['chosenRescue']),
      intensityAfter: serializer.fromJson<int?>(json['intensityAfter']),
      slipFollowed: serializer.fromJson<bool>(json['slipFollowed']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      rescueTasksUsed: serializer.fromJson<String>(json['rescueTasksUsed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'source': serializer.toJson<String>(source),
      'trigger': serializer.toJson<String>(trigger),
      'contextTag': serializer.toJson<String?>(contextTag),
      'location': serializer.toJson<String?>(location),
      'intensityBefore': serializer.toJson<int>(intensityBefore),
      'chosenRescue': serializer.toJson<String?>(chosenRescue),
      'intensityAfter': serializer.toJson<int?>(intensityAfter),
      'slipFollowed': serializer.toJson<bool>(slipFollowed),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'rescueTasksUsed': serializer.toJson<String>(rescueTasksUsed),
    };
  }

  UrgeEvent copyWith({
    int? id,
    DateTime? timestamp,
    String? source,
    String? trigger,
    Value<String?> contextTag = const Value.absent(),
    Value<String?> location = const Value.absent(),
    int? intensityBefore,
    Value<String?> chosenRescue = const Value.absent(),
    Value<int?> intensityAfter = const Value.absent(),
    bool? slipFollowed,
    Value<int?> durationSeconds = const Value.absent(),
    String? rescueTasksUsed,
  }) => UrgeEvent(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    source: source ?? this.source,
    trigger: trigger ?? this.trigger,
    contextTag: contextTag.present ? contextTag.value : this.contextTag,
    location: location.present ? location.value : this.location,
    intensityBefore: intensityBefore ?? this.intensityBefore,
    chosenRescue: chosenRescue.present ? chosenRescue.value : this.chosenRescue,
    intensityAfter: intensityAfter.present
        ? intensityAfter.value
        : this.intensityAfter,
    slipFollowed: slipFollowed ?? this.slipFollowed,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    rescueTasksUsed: rescueTasksUsed ?? this.rescueTasksUsed,
  );
  UrgeEvent copyWithCompanion(UrgeEventsCompanion data) {
    return UrgeEvent(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      source: data.source.present ? data.source.value : this.source,
      trigger: data.trigger.present ? data.trigger.value : this.trigger,
      contextTag: data.contextTag.present
          ? data.contextTag.value
          : this.contextTag,
      location: data.location.present ? data.location.value : this.location,
      intensityBefore: data.intensityBefore.present
          ? data.intensityBefore.value
          : this.intensityBefore,
      chosenRescue: data.chosenRescue.present
          ? data.chosenRescue.value
          : this.chosenRescue,
      intensityAfter: data.intensityAfter.present
          ? data.intensityAfter.value
          : this.intensityAfter,
      slipFollowed: data.slipFollowed.present
          ? data.slipFollowed.value
          : this.slipFollowed,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      rescueTasksUsed: data.rescueTasksUsed.present
          ? data.rescueTasksUsed.value
          : this.rescueTasksUsed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UrgeEvent(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('source: $source, ')
          ..write('trigger: $trigger, ')
          ..write('contextTag: $contextTag, ')
          ..write('location: $location, ')
          ..write('intensityBefore: $intensityBefore, ')
          ..write('chosenRescue: $chosenRescue, ')
          ..write('intensityAfter: $intensityAfter, ')
          ..write('slipFollowed: $slipFollowed, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('rescueTasksUsed: $rescueTasksUsed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    timestamp,
    source,
    trigger,
    contextTag,
    location,
    intensityBefore,
    chosenRescue,
    intensityAfter,
    slipFollowed,
    durationSeconds,
    rescueTasksUsed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UrgeEvent &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.source == this.source &&
          other.trigger == this.trigger &&
          other.contextTag == this.contextTag &&
          other.location == this.location &&
          other.intensityBefore == this.intensityBefore &&
          other.chosenRescue == this.chosenRescue &&
          other.intensityAfter == this.intensityAfter &&
          other.slipFollowed == this.slipFollowed &&
          other.durationSeconds == this.durationSeconds &&
          other.rescueTasksUsed == this.rescueTasksUsed);
}

class UrgeEventsCompanion extends UpdateCompanion<UrgeEvent> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<String> source;
  final Value<String> trigger;
  final Value<String?> contextTag;
  final Value<String?> location;
  final Value<int> intensityBefore;
  final Value<String?> chosenRescue;
  final Value<int?> intensityAfter;
  final Value<bool> slipFollowed;
  final Value<int?> durationSeconds;
  final Value<String> rescueTasksUsed;
  const UrgeEventsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.source = const Value.absent(),
    this.trigger = const Value.absent(),
    this.contextTag = const Value.absent(),
    this.location = const Value.absent(),
    this.intensityBefore = const Value.absent(),
    this.chosenRescue = const Value.absent(),
    this.intensityAfter = const Value.absent(),
    this.slipFollowed = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.rescueTasksUsed = const Value.absent(),
  });
  UrgeEventsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    this.source = const Value.absent(),
    required String trigger,
    this.contextTag = const Value.absent(),
    this.location = const Value.absent(),
    required int intensityBefore,
    this.chosenRescue = const Value.absent(),
    this.intensityAfter = const Value.absent(),
    this.slipFollowed = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.rescueTasksUsed = const Value.absent(),
  }) : timestamp = Value(timestamp),
       trigger = Value(trigger),
       intensityBefore = Value(intensityBefore);
  static Insertable<UrgeEvent> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<String>? source,
    Expression<String>? trigger,
    Expression<String>? contextTag,
    Expression<String>? location,
    Expression<int>? intensityBefore,
    Expression<String>? chosenRescue,
    Expression<int>? intensityAfter,
    Expression<bool>? slipFollowed,
    Expression<int>? durationSeconds,
    Expression<String>? rescueTasksUsed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (source != null) 'source': source,
      if (trigger != null) 'trigger': trigger,
      if (contextTag != null) 'context_tag': contextTag,
      if (location != null) 'location': location,
      if (intensityBefore != null) 'intensity_before': intensityBefore,
      if (chosenRescue != null) 'chosen_rescue': chosenRescue,
      if (intensityAfter != null) 'intensity_after': intensityAfter,
      if (slipFollowed != null) 'slip_followed': slipFollowed,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (rescueTasksUsed != null) 'rescue_tasks_used': rescueTasksUsed,
    });
  }

  UrgeEventsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<String>? source,
    Value<String>? trigger,
    Value<String?>? contextTag,
    Value<String?>? location,
    Value<int>? intensityBefore,
    Value<String?>? chosenRescue,
    Value<int?>? intensityAfter,
    Value<bool>? slipFollowed,
    Value<int?>? durationSeconds,
    Value<String>? rescueTasksUsed,
  }) {
    return UrgeEventsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
      trigger: trigger ?? this.trigger,
      contextTag: contextTag ?? this.contextTag,
      location: location ?? this.location,
      intensityBefore: intensityBefore ?? this.intensityBefore,
      chosenRescue: chosenRescue ?? this.chosenRescue,
      intensityAfter: intensityAfter ?? this.intensityAfter,
      slipFollowed: slipFollowed ?? this.slipFollowed,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      rescueTasksUsed: rescueTasksUsed ?? this.rescueTasksUsed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (trigger.present) {
      map['trigger'] = Variable<String>(trigger.value);
    }
    if (contextTag.present) {
      map['context_tag'] = Variable<String>(contextTag.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (intensityBefore.present) {
      map['intensity_before'] = Variable<int>(intensityBefore.value);
    }
    if (chosenRescue.present) {
      map['chosen_rescue'] = Variable<String>(chosenRescue.value);
    }
    if (intensityAfter.present) {
      map['intensity_after'] = Variable<int>(intensityAfter.value);
    }
    if (slipFollowed.present) {
      map['slip_followed'] = Variable<bool>(slipFollowed.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (rescueTasksUsed.present) {
      map['rescue_tasks_used'] = Variable<String>(rescueTasksUsed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UrgeEventsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('source: $source, ')
          ..write('trigger: $trigger, ')
          ..write('contextTag: $contextTag, ')
          ..write('location: $location, ')
          ..write('intensityBefore: $intensityBefore, ')
          ..write('chosenRescue: $chosenRescue, ')
          ..write('intensityAfter: $intensityAfter, ')
          ..write('slipFollowed: $slipFollowed, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('rescueTasksUsed: $rescueTasksUsed')
          ..write(')'))
        .toString();
  }
}

class $SlipEventsTable extends SlipEvents
    with TableInfo<$SlipEventsTable, SlipEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SlipEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('realtime'),
  );
  static const VerificationMeta _behaviorTypeMeta = const VerificationMeta(
    'behaviorType',
  );
  @override
  late final GeneratedColumn<String> behaviorType = GeneratedColumn<String>(
    'behavior_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _triggerChainMeta = const VerificationMeta(
    'triggerChain',
  );
  @override
  late final GeneratedColumn<String> triggerChain = GeneratedColumn<String>(
    'trigger_chain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _locationContextMeta = const VerificationMeta(
    'locationContext',
  );
  @override
  late final GeneratedColumn<String> locationContext = GeneratedColumn<String>(
    'location_context',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _precededByScrollingMeta =
      const VerificationMeta('precededByScrolling');
  @override
  late final GeneratedColumn<bool> precededByScrolling = GeneratedColumn<bool>(
    'preceded_by_scrolling',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("preceded_by_scrolling" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reflectionTagMeta = const VerificationMeta(
    'reflectionTag',
  );
  @override
  late final GeneratedColumn<String> reflectionTag = GeneratedColumn<String>(
    'reflection_tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reflectionNoteMeta = const VerificationMeta(
    'reflectionNote',
  );
  @override
  late final GeneratedColumn<String> reflectionNote = GeneratedColumn<String>(
    'reflection_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    source,
    behaviorType,
    triggerChain,
    locationContext,
    precededByScrolling,
    reflectionTag,
    reflectionNote,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'slip_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<SlipEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('behavior_type')) {
      context.handle(
        _behaviorTypeMeta,
        behaviorType.isAcceptableOrUnknown(
          data['behavior_type']!,
          _behaviorTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_behaviorTypeMeta);
    }
    if (data.containsKey('trigger_chain')) {
      context.handle(
        _triggerChainMeta,
        triggerChain.isAcceptableOrUnknown(
          data['trigger_chain']!,
          _triggerChainMeta,
        ),
      );
    }
    if (data.containsKey('location_context')) {
      context.handle(
        _locationContextMeta,
        locationContext.isAcceptableOrUnknown(
          data['location_context']!,
          _locationContextMeta,
        ),
      );
    }
    if (data.containsKey('preceded_by_scrolling')) {
      context.handle(
        _precededByScrollingMeta,
        precededByScrolling.isAcceptableOrUnknown(
          data['preceded_by_scrolling']!,
          _precededByScrollingMeta,
        ),
      );
    }
    if (data.containsKey('reflection_tag')) {
      context.handle(
        _reflectionTagMeta,
        reflectionTag.isAcceptableOrUnknown(
          data['reflection_tag']!,
          _reflectionTagMeta,
        ),
      );
    }
    if (data.containsKey('reflection_note')) {
      context.handle(
        _reflectionNoteMeta,
        reflectionNote.isAcceptableOrUnknown(
          data['reflection_note']!,
          _reflectionNoteMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SlipEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SlipEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      behaviorType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}behavior_type'],
      )!,
      triggerChain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger_chain'],
      )!,
      locationContext: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_context'],
      ),
      precededByScrolling: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}preceded_by_scrolling'],
      )!,
      reflectionTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reflection_tag'],
      ),
      reflectionNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reflection_note'],
      ),
    );
  }

  @override
  $SlipEventsTable createAlias(String alias) {
    return $SlipEventsTable(attachedDatabase, alias);
  }
}

class SlipEvent extends DataClass implements Insertable<SlipEvent> {
  final int id;
  final DateTime timestamp;
  final String source;
  final String behaviorType;
  final String triggerChain;
  final String? locationContext;
  final bool precededByScrolling;
  final String? reflectionTag;
  final String? reflectionNote;
  const SlipEvent({
    required this.id,
    required this.timestamp,
    required this.source,
    required this.behaviorType,
    required this.triggerChain,
    this.locationContext,
    required this.precededByScrolling,
    this.reflectionTag,
    this.reflectionNote,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['source'] = Variable<String>(source);
    map['behavior_type'] = Variable<String>(behaviorType);
    map['trigger_chain'] = Variable<String>(triggerChain);
    if (!nullToAbsent || locationContext != null) {
      map['location_context'] = Variable<String>(locationContext);
    }
    map['preceded_by_scrolling'] = Variable<bool>(precededByScrolling);
    if (!nullToAbsent || reflectionTag != null) {
      map['reflection_tag'] = Variable<String>(reflectionTag);
    }
    if (!nullToAbsent || reflectionNote != null) {
      map['reflection_note'] = Variable<String>(reflectionNote);
    }
    return map;
  }

  SlipEventsCompanion toCompanion(bool nullToAbsent) {
    return SlipEventsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      source: Value(source),
      behaviorType: Value(behaviorType),
      triggerChain: Value(triggerChain),
      locationContext: locationContext == null && nullToAbsent
          ? const Value.absent()
          : Value(locationContext),
      precededByScrolling: Value(precededByScrolling),
      reflectionTag: reflectionTag == null && nullToAbsent
          ? const Value.absent()
          : Value(reflectionTag),
      reflectionNote: reflectionNote == null && nullToAbsent
          ? const Value.absent()
          : Value(reflectionNote),
    );
  }

  factory SlipEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SlipEvent(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      source: serializer.fromJson<String>(json['source']),
      behaviorType: serializer.fromJson<String>(json['behaviorType']),
      triggerChain: serializer.fromJson<String>(json['triggerChain']),
      locationContext: serializer.fromJson<String?>(json['locationContext']),
      precededByScrolling: serializer.fromJson<bool>(
        json['precededByScrolling'],
      ),
      reflectionTag: serializer.fromJson<String?>(json['reflectionTag']),
      reflectionNote: serializer.fromJson<String?>(json['reflectionNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'source': serializer.toJson<String>(source),
      'behaviorType': serializer.toJson<String>(behaviorType),
      'triggerChain': serializer.toJson<String>(triggerChain),
      'locationContext': serializer.toJson<String?>(locationContext),
      'precededByScrolling': serializer.toJson<bool>(precededByScrolling),
      'reflectionTag': serializer.toJson<String?>(reflectionTag),
      'reflectionNote': serializer.toJson<String?>(reflectionNote),
    };
  }

  SlipEvent copyWith({
    int? id,
    DateTime? timestamp,
    String? source,
    String? behaviorType,
    String? triggerChain,
    Value<String?> locationContext = const Value.absent(),
    bool? precededByScrolling,
    Value<String?> reflectionTag = const Value.absent(),
    Value<String?> reflectionNote = const Value.absent(),
  }) => SlipEvent(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    source: source ?? this.source,
    behaviorType: behaviorType ?? this.behaviorType,
    triggerChain: triggerChain ?? this.triggerChain,
    locationContext: locationContext.present
        ? locationContext.value
        : this.locationContext,
    precededByScrolling: precededByScrolling ?? this.precededByScrolling,
    reflectionTag: reflectionTag.present
        ? reflectionTag.value
        : this.reflectionTag,
    reflectionNote: reflectionNote.present
        ? reflectionNote.value
        : this.reflectionNote,
  );
  SlipEvent copyWithCompanion(SlipEventsCompanion data) {
    return SlipEvent(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      source: data.source.present ? data.source.value : this.source,
      behaviorType: data.behaviorType.present
          ? data.behaviorType.value
          : this.behaviorType,
      triggerChain: data.triggerChain.present
          ? data.triggerChain.value
          : this.triggerChain,
      locationContext: data.locationContext.present
          ? data.locationContext.value
          : this.locationContext,
      precededByScrolling: data.precededByScrolling.present
          ? data.precededByScrolling.value
          : this.precededByScrolling,
      reflectionTag: data.reflectionTag.present
          ? data.reflectionTag.value
          : this.reflectionTag,
      reflectionNote: data.reflectionNote.present
          ? data.reflectionNote.value
          : this.reflectionNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SlipEvent(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('source: $source, ')
          ..write('behaviorType: $behaviorType, ')
          ..write('triggerChain: $triggerChain, ')
          ..write('locationContext: $locationContext, ')
          ..write('precededByScrolling: $precededByScrolling, ')
          ..write('reflectionTag: $reflectionTag, ')
          ..write('reflectionNote: $reflectionNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    timestamp,
    source,
    behaviorType,
    triggerChain,
    locationContext,
    precededByScrolling,
    reflectionTag,
    reflectionNote,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SlipEvent &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.source == this.source &&
          other.behaviorType == this.behaviorType &&
          other.triggerChain == this.triggerChain &&
          other.locationContext == this.locationContext &&
          other.precededByScrolling == this.precededByScrolling &&
          other.reflectionTag == this.reflectionTag &&
          other.reflectionNote == this.reflectionNote);
}

class SlipEventsCompanion extends UpdateCompanion<SlipEvent> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<String> source;
  final Value<String> behaviorType;
  final Value<String> triggerChain;
  final Value<String?> locationContext;
  final Value<bool> precededByScrolling;
  final Value<String?> reflectionTag;
  final Value<String?> reflectionNote;
  const SlipEventsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.source = const Value.absent(),
    this.behaviorType = const Value.absent(),
    this.triggerChain = const Value.absent(),
    this.locationContext = const Value.absent(),
    this.precededByScrolling = const Value.absent(),
    this.reflectionTag = const Value.absent(),
    this.reflectionNote = const Value.absent(),
  });
  SlipEventsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    this.source = const Value.absent(),
    required String behaviorType,
    this.triggerChain = const Value.absent(),
    this.locationContext = const Value.absent(),
    this.precededByScrolling = const Value.absent(),
    this.reflectionTag = const Value.absent(),
    this.reflectionNote = const Value.absent(),
  }) : timestamp = Value(timestamp),
       behaviorType = Value(behaviorType);
  static Insertable<SlipEvent> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<String>? source,
    Expression<String>? behaviorType,
    Expression<String>? triggerChain,
    Expression<String>? locationContext,
    Expression<bool>? precededByScrolling,
    Expression<String>? reflectionTag,
    Expression<String>? reflectionNote,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (source != null) 'source': source,
      if (behaviorType != null) 'behavior_type': behaviorType,
      if (triggerChain != null) 'trigger_chain': triggerChain,
      if (locationContext != null) 'location_context': locationContext,
      if (precededByScrolling != null)
        'preceded_by_scrolling': precededByScrolling,
      if (reflectionTag != null) 'reflection_tag': reflectionTag,
      if (reflectionNote != null) 'reflection_note': reflectionNote,
    });
  }

  SlipEventsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<String>? source,
    Value<String>? behaviorType,
    Value<String>? triggerChain,
    Value<String?>? locationContext,
    Value<bool>? precededByScrolling,
    Value<String?>? reflectionTag,
    Value<String?>? reflectionNote,
  }) {
    return SlipEventsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
      behaviorType: behaviorType ?? this.behaviorType,
      triggerChain: triggerChain ?? this.triggerChain,
      locationContext: locationContext ?? this.locationContext,
      precededByScrolling: precededByScrolling ?? this.precededByScrolling,
      reflectionTag: reflectionTag ?? this.reflectionTag,
      reflectionNote: reflectionNote ?? this.reflectionNote,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (behaviorType.present) {
      map['behavior_type'] = Variable<String>(behaviorType.value);
    }
    if (triggerChain.present) {
      map['trigger_chain'] = Variable<String>(triggerChain.value);
    }
    if (locationContext.present) {
      map['location_context'] = Variable<String>(locationContext.value);
    }
    if (precededByScrolling.present) {
      map['preceded_by_scrolling'] = Variable<bool>(precededByScrolling.value);
    }
    if (reflectionTag.present) {
      map['reflection_tag'] = Variable<String>(reflectionTag.value);
    }
    if (reflectionNote.present) {
      map['reflection_note'] = Variable<String>(reflectionNote.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SlipEventsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('source: $source, ')
          ..write('behaviorType: $behaviorType, ')
          ..write('triggerChain: $triggerChain, ')
          ..write('locationContext: $locationContext, ')
          ..write('precededByScrolling: $precededByScrolling, ')
          ..write('reflectionTag: $reflectionTag, ')
          ..write('reflectionNote: $reflectionNote')
          ..write(')'))
        .toString();
  }
}

class $InterventionLogsTable extends InterventionLogs
    with TableInfo<$InterventionLogsTable, InterventionLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InterventionLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _urgeEventIdMeta = const VerificationMeta(
    'urgeEventId',
  );
  @override
  late final GeneratedColumn<int> urgeEventId = GeneratedColumn<int>(
    'urge_event_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _interventionTypeMeta = const VerificationMeta(
    'interventionType',
  );
  @override
  late final GeneratedColumn<String> interventionType = GeneratedColumn<String>(
    'intervention_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _successMeta = const VerificationMeta(
    'success',
  );
  @override
  late final GeneratedColumn<bool> success = GeneratedColumn<bool>(
    'success',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("success" IN (0, 1))',
    ),
  );
  static const VerificationMeta _intensityDropMeta = const VerificationMeta(
    'intensityDrop',
  );
  @override
  late final GeneratedColumn<int> intensityDrop = GeneratedColumn<int>(
    'intensity_drop',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contextTimeOfDayMeta = const VerificationMeta(
    'contextTimeOfDay',
  );
  @override
  late final GeneratedColumn<String> contextTimeOfDay = GeneratedColumn<String>(
    'context_time_of_day',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contextLocationMeta = const VerificationMeta(
    'contextLocation',
  );
  @override
  late final GeneratedColumn<String> contextLocation = GeneratedColumn<String>(
    'context_location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    urgeEventId,
    interventionType,
    success,
    intensityDrop,
    contextTimeOfDay,
    contextLocation,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'intervention_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<InterventionLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('urge_event_id')) {
      context.handle(
        _urgeEventIdMeta,
        urgeEventId.isAcceptableOrUnknown(
          data['urge_event_id']!,
          _urgeEventIdMeta,
        ),
      );
    }
    if (data.containsKey('intervention_type')) {
      context.handle(
        _interventionTypeMeta,
        interventionType.isAcceptableOrUnknown(
          data['intervention_type']!,
          _interventionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_interventionTypeMeta);
    }
    if (data.containsKey('success')) {
      context.handle(
        _successMeta,
        success.isAcceptableOrUnknown(data['success']!, _successMeta),
      );
    } else if (isInserting) {
      context.missing(_successMeta);
    }
    if (data.containsKey('intensity_drop')) {
      context.handle(
        _intensityDropMeta,
        intensityDrop.isAcceptableOrUnknown(
          data['intensity_drop']!,
          _intensityDropMeta,
        ),
      );
    }
    if (data.containsKey('context_time_of_day')) {
      context.handle(
        _contextTimeOfDayMeta,
        contextTimeOfDay.isAcceptableOrUnknown(
          data['context_time_of_day']!,
          _contextTimeOfDayMeta,
        ),
      );
    }
    if (data.containsKey('context_location')) {
      context.handle(
        _contextLocationMeta,
        contextLocation.isAcceptableOrUnknown(
          data['context_location']!,
          _contextLocationMeta,
        ),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InterventionLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InterventionLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      urgeEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urge_event_id'],
      ),
      interventionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}intervention_type'],
      )!,
      success: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}success'],
      )!,
      intensityDrop: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity_drop'],
      ),
      contextTimeOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_time_of_day'],
      ),
      contextLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_location'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $InterventionLogsTable createAlias(String alias) {
    return $InterventionLogsTable(attachedDatabase, alias);
  }
}

class InterventionLog extends DataClass implements Insertable<InterventionLog> {
  final int id;
  final int? urgeEventId;
  final String interventionType;
  final bool success;
  final int? intensityDrop;
  final String? contextTimeOfDay;
  final String? contextLocation;
  final DateTime timestamp;
  const InterventionLog({
    required this.id,
    this.urgeEventId,
    required this.interventionType,
    required this.success,
    this.intensityDrop,
    this.contextTimeOfDay,
    this.contextLocation,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || urgeEventId != null) {
      map['urge_event_id'] = Variable<int>(urgeEventId);
    }
    map['intervention_type'] = Variable<String>(interventionType);
    map['success'] = Variable<bool>(success);
    if (!nullToAbsent || intensityDrop != null) {
      map['intensity_drop'] = Variable<int>(intensityDrop);
    }
    if (!nullToAbsent || contextTimeOfDay != null) {
      map['context_time_of_day'] = Variable<String>(contextTimeOfDay);
    }
    if (!nullToAbsent || contextLocation != null) {
      map['context_location'] = Variable<String>(contextLocation);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  InterventionLogsCompanion toCompanion(bool nullToAbsent) {
    return InterventionLogsCompanion(
      id: Value(id),
      urgeEventId: urgeEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(urgeEventId),
      interventionType: Value(interventionType),
      success: Value(success),
      intensityDrop: intensityDrop == null && nullToAbsent
          ? const Value.absent()
          : Value(intensityDrop),
      contextTimeOfDay: contextTimeOfDay == null && nullToAbsent
          ? const Value.absent()
          : Value(contextTimeOfDay),
      contextLocation: contextLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(contextLocation),
      timestamp: Value(timestamp),
    );
  }

  factory InterventionLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InterventionLog(
      id: serializer.fromJson<int>(json['id']),
      urgeEventId: serializer.fromJson<int?>(json['urgeEventId']),
      interventionType: serializer.fromJson<String>(json['interventionType']),
      success: serializer.fromJson<bool>(json['success']),
      intensityDrop: serializer.fromJson<int?>(json['intensityDrop']),
      contextTimeOfDay: serializer.fromJson<String?>(json['contextTimeOfDay']),
      contextLocation: serializer.fromJson<String?>(json['contextLocation']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'urgeEventId': serializer.toJson<int?>(urgeEventId),
      'interventionType': serializer.toJson<String>(interventionType),
      'success': serializer.toJson<bool>(success),
      'intensityDrop': serializer.toJson<int?>(intensityDrop),
      'contextTimeOfDay': serializer.toJson<String?>(contextTimeOfDay),
      'contextLocation': serializer.toJson<String?>(contextLocation),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  InterventionLog copyWith({
    int? id,
    Value<int?> urgeEventId = const Value.absent(),
    String? interventionType,
    bool? success,
    Value<int?> intensityDrop = const Value.absent(),
    Value<String?> contextTimeOfDay = const Value.absent(),
    Value<String?> contextLocation = const Value.absent(),
    DateTime? timestamp,
  }) => InterventionLog(
    id: id ?? this.id,
    urgeEventId: urgeEventId.present ? urgeEventId.value : this.urgeEventId,
    interventionType: interventionType ?? this.interventionType,
    success: success ?? this.success,
    intensityDrop: intensityDrop.present
        ? intensityDrop.value
        : this.intensityDrop,
    contextTimeOfDay: contextTimeOfDay.present
        ? contextTimeOfDay.value
        : this.contextTimeOfDay,
    contextLocation: contextLocation.present
        ? contextLocation.value
        : this.contextLocation,
    timestamp: timestamp ?? this.timestamp,
  );
  InterventionLog copyWithCompanion(InterventionLogsCompanion data) {
    return InterventionLog(
      id: data.id.present ? data.id.value : this.id,
      urgeEventId: data.urgeEventId.present
          ? data.urgeEventId.value
          : this.urgeEventId,
      interventionType: data.interventionType.present
          ? data.interventionType.value
          : this.interventionType,
      success: data.success.present ? data.success.value : this.success,
      intensityDrop: data.intensityDrop.present
          ? data.intensityDrop.value
          : this.intensityDrop,
      contextTimeOfDay: data.contextTimeOfDay.present
          ? data.contextTimeOfDay.value
          : this.contextTimeOfDay,
      contextLocation: data.contextLocation.present
          ? data.contextLocation.value
          : this.contextLocation,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InterventionLog(')
          ..write('id: $id, ')
          ..write('urgeEventId: $urgeEventId, ')
          ..write('interventionType: $interventionType, ')
          ..write('success: $success, ')
          ..write('intensityDrop: $intensityDrop, ')
          ..write('contextTimeOfDay: $contextTimeOfDay, ')
          ..write('contextLocation: $contextLocation, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    urgeEventId,
    interventionType,
    success,
    intensityDrop,
    contextTimeOfDay,
    contextLocation,
    timestamp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InterventionLog &&
          other.id == this.id &&
          other.urgeEventId == this.urgeEventId &&
          other.interventionType == this.interventionType &&
          other.success == this.success &&
          other.intensityDrop == this.intensityDrop &&
          other.contextTimeOfDay == this.contextTimeOfDay &&
          other.contextLocation == this.contextLocation &&
          other.timestamp == this.timestamp);
}

class InterventionLogsCompanion extends UpdateCompanion<InterventionLog> {
  final Value<int> id;
  final Value<int?> urgeEventId;
  final Value<String> interventionType;
  final Value<bool> success;
  final Value<int?> intensityDrop;
  final Value<String?> contextTimeOfDay;
  final Value<String?> contextLocation;
  final Value<DateTime> timestamp;
  const InterventionLogsCompanion({
    this.id = const Value.absent(),
    this.urgeEventId = const Value.absent(),
    this.interventionType = const Value.absent(),
    this.success = const Value.absent(),
    this.intensityDrop = const Value.absent(),
    this.contextTimeOfDay = const Value.absent(),
    this.contextLocation = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  InterventionLogsCompanion.insert({
    this.id = const Value.absent(),
    this.urgeEventId = const Value.absent(),
    required String interventionType,
    required bool success,
    this.intensityDrop = const Value.absent(),
    this.contextTimeOfDay = const Value.absent(),
    this.contextLocation = const Value.absent(),
    this.timestamp = const Value.absent(),
  }) : interventionType = Value(interventionType),
       success = Value(success);
  static Insertable<InterventionLog> custom({
    Expression<int>? id,
    Expression<int>? urgeEventId,
    Expression<String>? interventionType,
    Expression<bool>? success,
    Expression<int>? intensityDrop,
    Expression<String>? contextTimeOfDay,
    Expression<String>? contextLocation,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (urgeEventId != null) 'urge_event_id': urgeEventId,
      if (interventionType != null) 'intervention_type': interventionType,
      if (success != null) 'success': success,
      if (intensityDrop != null) 'intensity_drop': intensityDrop,
      if (contextTimeOfDay != null) 'context_time_of_day': contextTimeOfDay,
      if (contextLocation != null) 'context_location': contextLocation,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  InterventionLogsCompanion copyWith({
    Value<int>? id,
    Value<int?>? urgeEventId,
    Value<String>? interventionType,
    Value<bool>? success,
    Value<int?>? intensityDrop,
    Value<String?>? contextTimeOfDay,
    Value<String?>? contextLocation,
    Value<DateTime>? timestamp,
  }) {
    return InterventionLogsCompanion(
      id: id ?? this.id,
      urgeEventId: urgeEventId ?? this.urgeEventId,
      interventionType: interventionType ?? this.interventionType,
      success: success ?? this.success,
      intensityDrop: intensityDrop ?? this.intensityDrop,
      contextTimeOfDay: contextTimeOfDay ?? this.contextTimeOfDay,
      contextLocation: contextLocation ?? this.contextLocation,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (urgeEventId.present) {
      map['urge_event_id'] = Variable<int>(urgeEventId.value);
    }
    if (interventionType.present) {
      map['intervention_type'] = Variable<String>(interventionType.value);
    }
    if (success.present) {
      map['success'] = Variable<bool>(success.value);
    }
    if (intensityDrop.present) {
      map['intensity_drop'] = Variable<int>(intensityDrop.value);
    }
    if (contextTimeOfDay.present) {
      map['context_time_of_day'] = Variable<String>(contextTimeOfDay.value);
    }
    if (contextLocation.present) {
      map['context_location'] = Variable<String>(contextLocation.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InterventionLogsCompanion(')
          ..write('id: $id, ')
          ..write('urgeEventId: $urgeEventId, ')
          ..write('interventionType: $interventionType, ')
          ..write('success: $success, ')
          ..write('intensityDrop: $intensityDrop, ')
          ..write('contextTimeOfDay: $contextTimeOfDay, ')
          ..write('contextLocation: $contextLocation, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $TriggerPosteriorsTable extends TriggerPosteriors
    with TableInfo<$TriggerPosteriorsTable, TriggerPosterior> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TriggerPosteriorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _triggerNameMeta = const VerificationMeta(
    'triggerName',
  );
  @override
  late final GeneratedColumn<String> triggerName = GeneratedColumn<String>(
    'trigger_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _urgeCountMeta = const VerificationMeta(
    'urgeCount',
  );
  @override
  late final GeneratedColumn<int> urgeCount = GeneratedColumn<int>(
    'urge_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _slipCountMeta = const VerificationMeta(
    'slipCount',
  );
  @override
  late final GeneratedColumn<int> slipCount = GeneratedColumn<int>(
    'slip_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _resistCountMeta = const VerificationMeta(
    'resistCount',
  );
  @override
  late final GeneratedColumn<int> resistCount = GeneratedColumn<int>(
    'resist_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pSlipGivenTriggerMeta = const VerificationMeta(
    'pSlipGivenTrigger',
  );
  @override
  late final GeneratedColumn<double> pSlipGivenTrigger =
      GeneratedColumn<double>(
        'p_slip_given_trigger',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.5),
      );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    triggerName,
    urgeCount,
    slipCount,
    resistCount,
    pSlipGivenTrigger,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trigger_posteriors';
  @override
  VerificationContext validateIntegrity(
    Insertable<TriggerPosterior> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trigger_name')) {
      context.handle(
        _triggerNameMeta,
        triggerName.isAcceptableOrUnknown(
          data['trigger_name']!,
          _triggerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_triggerNameMeta);
    }
    if (data.containsKey('urge_count')) {
      context.handle(
        _urgeCountMeta,
        urgeCount.isAcceptableOrUnknown(data['urge_count']!, _urgeCountMeta),
      );
    }
    if (data.containsKey('slip_count')) {
      context.handle(
        _slipCountMeta,
        slipCount.isAcceptableOrUnknown(data['slip_count']!, _slipCountMeta),
      );
    }
    if (data.containsKey('resist_count')) {
      context.handle(
        _resistCountMeta,
        resistCount.isAcceptableOrUnknown(
          data['resist_count']!,
          _resistCountMeta,
        ),
      );
    }
    if (data.containsKey('p_slip_given_trigger')) {
      context.handle(
        _pSlipGivenTriggerMeta,
        pSlipGivenTrigger.isAcceptableOrUnknown(
          data['p_slip_given_trigger']!,
          _pSlipGivenTriggerMeta,
        ),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TriggerPosterior map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TriggerPosterior(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      triggerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger_name'],
      )!,
      urgeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urge_count'],
      )!,
      slipCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slip_count'],
      )!,
      resistCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}resist_count'],
      )!,
      pSlipGivenTrigger: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}p_slip_given_trigger'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      )!,
    );
  }

  @override
  $TriggerPosteriorsTable createAlias(String alias) {
    return $TriggerPosteriorsTable(attachedDatabase, alias);
  }
}

class TriggerPosterior extends DataClass
    implements Insertable<TriggerPosterior> {
  final int id;
  final String triggerName;
  final int urgeCount;
  final int slipCount;
  final int resistCount;
  final double pSlipGivenTrigger;
  final DateTime lastUpdated;
  const TriggerPosterior({
    required this.id,
    required this.triggerName,
    required this.urgeCount,
    required this.slipCount,
    required this.resistCount,
    required this.pSlipGivenTrigger,
    required this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['trigger_name'] = Variable<String>(triggerName);
    map['urge_count'] = Variable<int>(urgeCount);
    map['slip_count'] = Variable<int>(slipCount);
    map['resist_count'] = Variable<int>(resistCount);
    map['p_slip_given_trigger'] = Variable<double>(pSlipGivenTrigger);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  TriggerPosteriorsCompanion toCompanion(bool nullToAbsent) {
    return TriggerPosteriorsCompanion(
      id: Value(id),
      triggerName: Value(triggerName),
      urgeCount: Value(urgeCount),
      slipCount: Value(slipCount),
      resistCount: Value(resistCount),
      pSlipGivenTrigger: Value(pSlipGivenTrigger),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory TriggerPosterior.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TriggerPosterior(
      id: serializer.fromJson<int>(json['id']),
      triggerName: serializer.fromJson<String>(json['triggerName']),
      urgeCount: serializer.fromJson<int>(json['urgeCount']),
      slipCount: serializer.fromJson<int>(json['slipCount']),
      resistCount: serializer.fromJson<int>(json['resistCount']),
      pSlipGivenTrigger: serializer.fromJson<double>(json['pSlipGivenTrigger']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'triggerName': serializer.toJson<String>(triggerName),
      'urgeCount': serializer.toJson<int>(urgeCount),
      'slipCount': serializer.toJson<int>(slipCount),
      'resistCount': serializer.toJson<int>(resistCount),
      'pSlipGivenTrigger': serializer.toJson<double>(pSlipGivenTrigger),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  TriggerPosterior copyWith({
    int? id,
    String? triggerName,
    int? urgeCount,
    int? slipCount,
    int? resistCount,
    double? pSlipGivenTrigger,
    DateTime? lastUpdated,
  }) => TriggerPosterior(
    id: id ?? this.id,
    triggerName: triggerName ?? this.triggerName,
    urgeCount: urgeCount ?? this.urgeCount,
    slipCount: slipCount ?? this.slipCount,
    resistCount: resistCount ?? this.resistCount,
    pSlipGivenTrigger: pSlipGivenTrigger ?? this.pSlipGivenTrigger,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );
  TriggerPosterior copyWithCompanion(TriggerPosteriorsCompanion data) {
    return TriggerPosterior(
      id: data.id.present ? data.id.value : this.id,
      triggerName: data.triggerName.present
          ? data.triggerName.value
          : this.triggerName,
      urgeCount: data.urgeCount.present ? data.urgeCount.value : this.urgeCount,
      slipCount: data.slipCount.present ? data.slipCount.value : this.slipCount,
      resistCount: data.resistCount.present
          ? data.resistCount.value
          : this.resistCount,
      pSlipGivenTrigger: data.pSlipGivenTrigger.present
          ? data.pSlipGivenTrigger.value
          : this.pSlipGivenTrigger,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TriggerPosterior(')
          ..write('id: $id, ')
          ..write('triggerName: $triggerName, ')
          ..write('urgeCount: $urgeCount, ')
          ..write('slipCount: $slipCount, ')
          ..write('resistCount: $resistCount, ')
          ..write('pSlipGivenTrigger: $pSlipGivenTrigger, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    triggerName,
    urgeCount,
    slipCount,
    resistCount,
    pSlipGivenTrigger,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TriggerPosterior &&
          other.id == this.id &&
          other.triggerName == this.triggerName &&
          other.urgeCount == this.urgeCount &&
          other.slipCount == this.slipCount &&
          other.resistCount == this.resistCount &&
          other.pSlipGivenTrigger == this.pSlipGivenTrigger &&
          other.lastUpdated == this.lastUpdated);
}

class TriggerPosteriorsCompanion extends UpdateCompanion<TriggerPosterior> {
  final Value<int> id;
  final Value<String> triggerName;
  final Value<int> urgeCount;
  final Value<int> slipCount;
  final Value<int> resistCount;
  final Value<double> pSlipGivenTrigger;
  final Value<DateTime> lastUpdated;
  const TriggerPosteriorsCompanion({
    this.id = const Value.absent(),
    this.triggerName = const Value.absent(),
    this.urgeCount = const Value.absent(),
    this.slipCount = const Value.absent(),
    this.resistCount = const Value.absent(),
    this.pSlipGivenTrigger = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  TriggerPosteriorsCompanion.insert({
    this.id = const Value.absent(),
    required String triggerName,
    this.urgeCount = const Value.absent(),
    this.slipCount = const Value.absent(),
    this.resistCount = const Value.absent(),
    this.pSlipGivenTrigger = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  }) : triggerName = Value(triggerName);
  static Insertable<TriggerPosterior> custom({
    Expression<int>? id,
    Expression<String>? triggerName,
    Expression<int>? urgeCount,
    Expression<int>? slipCount,
    Expression<int>? resistCount,
    Expression<double>? pSlipGivenTrigger,
    Expression<DateTime>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (triggerName != null) 'trigger_name': triggerName,
      if (urgeCount != null) 'urge_count': urgeCount,
      if (slipCount != null) 'slip_count': slipCount,
      if (resistCount != null) 'resist_count': resistCount,
      if (pSlipGivenTrigger != null) 'p_slip_given_trigger': pSlipGivenTrigger,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  TriggerPosteriorsCompanion copyWith({
    Value<int>? id,
    Value<String>? triggerName,
    Value<int>? urgeCount,
    Value<int>? slipCount,
    Value<int>? resistCount,
    Value<double>? pSlipGivenTrigger,
    Value<DateTime>? lastUpdated,
  }) {
    return TriggerPosteriorsCompanion(
      id: id ?? this.id,
      triggerName: triggerName ?? this.triggerName,
      urgeCount: urgeCount ?? this.urgeCount,
      slipCount: slipCount ?? this.slipCount,
      resistCount: resistCount ?? this.resistCount,
      pSlipGivenTrigger: pSlipGivenTrigger ?? this.pSlipGivenTrigger,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (triggerName.present) {
      map['trigger_name'] = Variable<String>(triggerName.value);
    }
    if (urgeCount.present) {
      map['urge_count'] = Variable<int>(urgeCount.value);
    }
    if (slipCount.present) {
      map['slip_count'] = Variable<int>(slipCount.value);
    }
    if (resistCount.present) {
      map['resist_count'] = Variable<int>(resistCount.value);
    }
    if (pSlipGivenTrigger.present) {
      map['p_slip_given_trigger'] = Variable<double>(pSlipGivenTrigger.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TriggerPosteriorsCompanion(')
          ..write('id: $id, ')
          ..write('triggerName: $triggerName, ')
          ..write('urgeCount: $urgeCount, ')
          ..write('slipCount: $slipCount, ')
          ..write('resistCount: $resistCount, ')
          ..write('pSlipGivenTrigger: $pSlipGivenTrigger, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $StreaksTable extends Streaks with TableInfo<$StreaksTable, Streak> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreaksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _streakTypeMeta = const VerificationMeta(
    'streakType',
  );
  @override
  late final GeneratedColumn<String> streakType = GeneratedColumn<String>(
    'streak_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _peakIdMeta = const VerificationMeta('peakId');
  @override
  late final GeneratedColumn<int> peakId = GeneratedColumn<int>(
    'peak_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentCountMeta = const VerificationMeta(
    'currentCount',
  );
  @override
  late final GeneratedColumn<int> currentCount = GeneratedColumn<int>(
    'current_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bestCountMeta = const VerificationMeta(
    'bestCount',
  );
  @override
  late final GeneratedColumn<int> bestCount = GeneratedColumn<int>(
    'best_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lifetimeTotalMeta = const VerificationMeta(
    'lifetimeTotal',
  );
  @override
  late final GeneratedColumn<int> lifetimeTotal = GeneratedColumn<int>(
    'lifetime_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _brokenAtMeta = const VerificationMeta(
    'brokenAt',
  );
  @override
  late final GeneratedColumn<DateTime> brokenAt = GeneratedColumn<DateTime>(
    'broken_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    streakType,
    peakId,
    currentCount,
    bestCount,
    lifetimeTotal,
    startedAt,
    brokenAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streaks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Streak> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('streak_type')) {
      context.handle(
        _streakTypeMeta,
        streakType.isAcceptableOrUnknown(data['streak_type']!, _streakTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_streakTypeMeta);
    }
    if (data.containsKey('peak_id')) {
      context.handle(
        _peakIdMeta,
        peakId.isAcceptableOrUnknown(data['peak_id']!, _peakIdMeta),
      );
    }
    if (data.containsKey('current_count')) {
      context.handle(
        _currentCountMeta,
        currentCount.isAcceptableOrUnknown(
          data['current_count']!,
          _currentCountMeta,
        ),
      );
    }
    if (data.containsKey('best_count')) {
      context.handle(
        _bestCountMeta,
        bestCount.isAcceptableOrUnknown(data['best_count']!, _bestCountMeta),
      );
    }
    if (data.containsKey('lifetime_total')) {
      context.handle(
        _lifetimeTotalMeta,
        lifetimeTotal.isAcceptableOrUnknown(
          data['lifetime_total']!,
          _lifetimeTotalMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('broken_at')) {
      context.handle(
        _brokenAtMeta,
        brokenAt.isAcceptableOrUnknown(data['broken_at']!, _brokenAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Streak map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Streak(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      streakType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}streak_type'],
      )!,
      peakId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}peak_id'],
      ),
      currentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_count'],
      )!,
      bestCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_count'],
      )!,
      lifetimeTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lifetime_total'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      brokenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}broken_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StreaksTable createAlias(String alias) {
    return $StreaksTable(attachedDatabase, alias);
  }
}

class Streak extends DataClass implements Insertable<Streak> {
  final int id;
  final String streakType;
  final int? peakId;
  final int currentCount;
  final int bestCount;
  final int lifetimeTotal;
  final DateTime startedAt;
  final DateTime? brokenAt;
  final DateTime updatedAt;
  const Streak({
    required this.id,
    required this.streakType,
    this.peakId,
    required this.currentCount,
    required this.bestCount,
    required this.lifetimeTotal,
    required this.startedAt,
    this.brokenAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['streak_type'] = Variable<String>(streakType);
    if (!nullToAbsent || peakId != null) {
      map['peak_id'] = Variable<int>(peakId);
    }
    map['current_count'] = Variable<int>(currentCount);
    map['best_count'] = Variable<int>(bestCount);
    map['lifetime_total'] = Variable<int>(lifetimeTotal);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || brokenAt != null) {
      map['broken_at'] = Variable<DateTime>(brokenAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StreaksCompanion toCompanion(bool nullToAbsent) {
    return StreaksCompanion(
      id: Value(id),
      streakType: Value(streakType),
      peakId: peakId == null && nullToAbsent
          ? const Value.absent()
          : Value(peakId),
      currentCount: Value(currentCount),
      bestCount: Value(bestCount),
      lifetimeTotal: Value(lifetimeTotal),
      startedAt: Value(startedAt),
      brokenAt: brokenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(brokenAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Streak.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Streak(
      id: serializer.fromJson<int>(json['id']),
      streakType: serializer.fromJson<String>(json['streakType']),
      peakId: serializer.fromJson<int?>(json['peakId']),
      currentCount: serializer.fromJson<int>(json['currentCount']),
      bestCount: serializer.fromJson<int>(json['bestCount']),
      lifetimeTotal: serializer.fromJson<int>(json['lifetimeTotal']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      brokenAt: serializer.fromJson<DateTime?>(json['brokenAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'streakType': serializer.toJson<String>(streakType),
      'peakId': serializer.toJson<int?>(peakId),
      'currentCount': serializer.toJson<int>(currentCount),
      'bestCount': serializer.toJson<int>(bestCount),
      'lifetimeTotal': serializer.toJson<int>(lifetimeTotal),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'brokenAt': serializer.toJson<DateTime?>(brokenAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Streak copyWith({
    int? id,
    String? streakType,
    Value<int?> peakId = const Value.absent(),
    int? currentCount,
    int? bestCount,
    int? lifetimeTotal,
    DateTime? startedAt,
    Value<DateTime?> brokenAt = const Value.absent(),
    DateTime? updatedAt,
  }) => Streak(
    id: id ?? this.id,
    streakType: streakType ?? this.streakType,
    peakId: peakId.present ? peakId.value : this.peakId,
    currentCount: currentCount ?? this.currentCount,
    bestCount: bestCount ?? this.bestCount,
    lifetimeTotal: lifetimeTotal ?? this.lifetimeTotal,
    startedAt: startedAt ?? this.startedAt,
    brokenAt: brokenAt.present ? brokenAt.value : this.brokenAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Streak copyWithCompanion(StreaksCompanion data) {
    return Streak(
      id: data.id.present ? data.id.value : this.id,
      streakType: data.streakType.present
          ? data.streakType.value
          : this.streakType,
      peakId: data.peakId.present ? data.peakId.value : this.peakId,
      currentCount: data.currentCount.present
          ? data.currentCount.value
          : this.currentCount,
      bestCount: data.bestCount.present ? data.bestCount.value : this.bestCount,
      lifetimeTotal: data.lifetimeTotal.present
          ? data.lifetimeTotal.value
          : this.lifetimeTotal,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      brokenAt: data.brokenAt.present ? data.brokenAt.value : this.brokenAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Streak(')
          ..write('id: $id, ')
          ..write('streakType: $streakType, ')
          ..write('peakId: $peakId, ')
          ..write('currentCount: $currentCount, ')
          ..write('bestCount: $bestCount, ')
          ..write('lifetimeTotal: $lifetimeTotal, ')
          ..write('startedAt: $startedAt, ')
          ..write('brokenAt: $brokenAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    streakType,
    peakId,
    currentCount,
    bestCount,
    lifetimeTotal,
    startedAt,
    brokenAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Streak &&
          other.id == this.id &&
          other.streakType == this.streakType &&
          other.peakId == this.peakId &&
          other.currentCount == this.currentCount &&
          other.bestCount == this.bestCount &&
          other.lifetimeTotal == this.lifetimeTotal &&
          other.startedAt == this.startedAt &&
          other.brokenAt == this.brokenAt &&
          other.updatedAt == this.updatedAt);
}

class StreaksCompanion extends UpdateCompanion<Streak> {
  final Value<int> id;
  final Value<String> streakType;
  final Value<int?> peakId;
  final Value<int> currentCount;
  final Value<int> bestCount;
  final Value<int> lifetimeTotal;
  final Value<DateTime> startedAt;
  final Value<DateTime?> brokenAt;
  final Value<DateTime> updatedAt;
  const StreaksCompanion({
    this.id = const Value.absent(),
    this.streakType = const Value.absent(),
    this.peakId = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.bestCount = const Value.absent(),
    this.lifetimeTotal = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.brokenAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  StreaksCompanion.insert({
    this.id = const Value.absent(),
    required String streakType,
    this.peakId = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.bestCount = const Value.absent(),
    this.lifetimeTotal = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.brokenAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : streakType = Value(streakType);
  static Insertable<Streak> custom({
    Expression<int>? id,
    Expression<String>? streakType,
    Expression<int>? peakId,
    Expression<int>? currentCount,
    Expression<int>? bestCount,
    Expression<int>? lifetimeTotal,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? brokenAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (streakType != null) 'streak_type': streakType,
      if (peakId != null) 'peak_id': peakId,
      if (currentCount != null) 'current_count': currentCount,
      if (bestCount != null) 'best_count': bestCount,
      if (lifetimeTotal != null) 'lifetime_total': lifetimeTotal,
      if (startedAt != null) 'started_at': startedAt,
      if (brokenAt != null) 'broken_at': brokenAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  StreaksCompanion copyWith({
    Value<int>? id,
    Value<String>? streakType,
    Value<int?>? peakId,
    Value<int>? currentCount,
    Value<int>? bestCount,
    Value<int>? lifetimeTotal,
    Value<DateTime>? startedAt,
    Value<DateTime?>? brokenAt,
    Value<DateTime>? updatedAt,
  }) {
    return StreaksCompanion(
      id: id ?? this.id,
      streakType: streakType ?? this.streakType,
      peakId: peakId ?? this.peakId,
      currentCount: currentCount ?? this.currentCount,
      bestCount: bestCount ?? this.bestCount,
      lifetimeTotal: lifetimeTotal ?? this.lifetimeTotal,
      startedAt: startedAt ?? this.startedAt,
      brokenAt: brokenAt ?? this.brokenAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (streakType.present) {
      map['streak_type'] = Variable<String>(streakType.value);
    }
    if (peakId.present) {
      map['peak_id'] = Variable<int>(peakId.value);
    }
    if (currentCount.present) {
      map['current_count'] = Variable<int>(currentCount.value);
    }
    if (bestCount.present) {
      map['best_count'] = Variable<int>(bestCount.value);
    }
    if (lifetimeTotal.present) {
      map['lifetime_total'] = Variable<int>(lifetimeTotal.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (brokenAt.present) {
      map['broken_at'] = Variable<DateTime>(brokenAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreaksCompanion(')
          ..write('id: $id, ')
          ..write('streakType: $streakType, ')
          ..write('peakId: $peakId, ')
          ..write('currentCount: $currentCount, ')
          ..write('bestCount: $bestCount, ')
          ..write('lifetimeTotal: $lifetimeTotal, ')
          ..write('startedAt: $startedAt, ')
          ..write('brokenAt: $brokenAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $StreakHistoriesTable extends StreakHistories
    with TableInfo<$StreakHistoriesTable, StreakHistory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreakHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _streakTypeMeta = const VerificationMeta(
    'streakType',
  );
  @override
  late final GeneratedColumn<String> streakType = GeneratedColumn<String>(
    'streak_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _peakIdMeta = const VerificationMeta('peakId');
  @override
  late final GeneratedColumn<int> peakId = GeneratedColumn<int>(
    'peak_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lengthMeta = const VerificationMeta('length');
  @override
  late final GeneratedColumn<int> length = GeneratedColumn<int>(
    'length',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brokenByMeta = const VerificationMeta(
    'brokenBy',
  );
  @override
  late final GeneratedColumn<int> brokenBy = GeneratedColumn<int>(
    'broken_by',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    streakType,
    peakId,
    length,
    startedAt,
    endedAt,
    brokenBy,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streak_histories';
  @override
  VerificationContext validateIntegrity(
    Insertable<StreakHistory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('streak_type')) {
      context.handle(
        _streakTypeMeta,
        streakType.isAcceptableOrUnknown(data['streak_type']!, _streakTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_streakTypeMeta);
    }
    if (data.containsKey('peak_id')) {
      context.handle(
        _peakIdMeta,
        peakId.isAcceptableOrUnknown(data['peak_id']!, _peakIdMeta),
      );
    }
    if (data.containsKey('length')) {
      context.handle(
        _lengthMeta,
        length.isAcceptableOrUnknown(data['length']!, _lengthMeta),
      );
    } else if (isInserting) {
      context.missing(_lengthMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('broken_by')) {
      context.handle(
        _brokenByMeta,
        brokenBy.isAcceptableOrUnknown(data['broken_by']!, _brokenByMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StreakHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreakHistory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      streakType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}streak_type'],
      )!,
      peakId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}peak_id'],
      ),
      length: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}length'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      )!,
      brokenBy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}broken_by'],
      ),
    );
  }

  @override
  $StreakHistoriesTable createAlias(String alias) {
    return $StreakHistoriesTable(attachedDatabase, alias);
  }
}

class StreakHistory extends DataClass implements Insertable<StreakHistory> {
  final int id;
  final String streakType;
  final int? peakId;
  final int length;
  final DateTime startedAt;
  final DateTime endedAt;
  final int? brokenBy;
  const StreakHistory({
    required this.id,
    required this.streakType,
    this.peakId,
    required this.length,
    required this.startedAt,
    required this.endedAt,
    this.brokenBy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['streak_type'] = Variable<String>(streakType);
    if (!nullToAbsent || peakId != null) {
      map['peak_id'] = Variable<int>(peakId);
    }
    map['length'] = Variable<int>(length);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    if (!nullToAbsent || brokenBy != null) {
      map['broken_by'] = Variable<int>(brokenBy);
    }
    return map;
  }

  StreakHistoriesCompanion toCompanion(bool nullToAbsent) {
    return StreakHistoriesCompanion(
      id: Value(id),
      streakType: Value(streakType),
      peakId: peakId == null && nullToAbsent
          ? const Value.absent()
          : Value(peakId),
      length: Value(length),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      brokenBy: brokenBy == null && nullToAbsent
          ? const Value.absent()
          : Value(brokenBy),
    );
  }

  factory StreakHistory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreakHistory(
      id: serializer.fromJson<int>(json['id']),
      streakType: serializer.fromJson<String>(json['streakType']),
      peakId: serializer.fromJson<int?>(json['peakId']),
      length: serializer.fromJson<int>(json['length']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      brokenBy: serializer.fromJson<int?>(json['brokenBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'streakType': serializer.toJson<String>(streakType),
      'peakId': serializer.toJson<int?>(peakId),
      'length': serializer.toJson<int>(length),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'brokenBy': serializer.toJson<int?>(brokenBy),
    };
  }

  StreakHistory copyWith({
    int? id,
    String? streakType,
    Value<int?> peakId = const Value.absent(),
    int? length,
    DateTime? startedAt,
    DateTime? endedAt,
    Value<int?> brokenBy = const Value.absent(),
  }) => StreakHistory(
    id: id ?? this.id,
    streakType: streakType ?? this.streakType,
    peakId: peakId.present ? peakId.value : this.peakId,
    length: length ?? this.length,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    brokenBy: brokenBy.present ? brokenBy.value : this.brokenBy,
  );
  StreakHistory copyWithCompanion(StreakHistoriesCompanion data) {
    return StreakHistory(
      id: data.id.present ? data.id.value : this.id,
      streakType: data.streakType.present
          ? data.streakType.value
          : this.streakType,
      peakId: data.peakId.present ? data.peakId.value : this.peakId,
      length: data.length.present ? data.length.value : this.length,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      brokenBy: data.brokenBy.present ? data.brokenBy.value : this.brokenBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StreakHistory(')
          ..write('id: $id, ')
          ..write('streakType: $streakType, ')
          ..write('peakId: $peakId, ')
          ..write('length: $length, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('brokenBy: $brokenBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, streakType, peakId, length, startedAt, endedAt, brokenBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreakHistory &&
          other.id == this.id &&
          other.streakType == this.streakType &&
          other.peakId == this.peakId &&
          other.length == this.length &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.brokenBy == this.brokenBy);
}

class StreakHistoriesCompanion extends UpdateCompanion<StreakHistory> {
  final Value<int> id;
  final Value<String> streakType;
  final Value<int?> peakId;
  final Value<int> length;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int?> brokenBy;
  const StreakHistoriesCompanion({
    this.id = const Value.absent(),
    this.streakType = const Value.absent(),
    this.peakId = const Value.absent(),
    this.length = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.brokenBy = const Value.absent(),
  });
  StreakHistoriesCompanion.insert({
    this.id = const Value.absent(),
    required String streakType,
    this.peakId = const Value.absent(),
    required int length,
    required DateTime startedAt,
    required DateTime endedAt,
    this.brokenBy = const Value.absent(),
  }) : streakType = Value(streakType),
       length = Value(length),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt);
  static Insertable<StreakHistory> custom({
    Expression<int>? id,
    Expression<String>? streakType,
    Expression<int>? peakId,
    Expression<int>? length,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? brokenBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (streakType != null) 'streak_type': streakType,
      if (peakId != null) 'peak_id': peakId,
      if (length != null) 'length': length,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (brokenBy != null) 'broken_by': brokenBy,
    });
  }

  StreakHistoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? streakType,
    Value<int?>? peakId,
    Value<int>? length,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int?>? brokenBy,
  }) {
    return StreakHistoriesCompanion(
      id: id ?? this.id,
      streakType: streakType ?? this.streakType,
      peakId: peakId ?? this.peakId,
      length: length ?? this.length,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      brokenBy: brokenBy ?? this.brokenBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (streakType.present) {
      map['streak_type'] = Variable<String>(streakType.value);
    }
    if (peakId.present) {
      map['peak_id'] = Variable<int>(peakId.value);
    }
    if (length.present) {
      map['length'] = Variable<int>(length.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (brokenBy.present) {
      map['broken_by'] = Variable<int>(brokenBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreakHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('streakType: $streakType, ')
          ..write('peakId: $peakId, ')
          ..write('length: $length, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('brokenBy: $brokenBy')
          ..write(')'))
        .toString();
  }
}

class $DailyScoresTable extends DailyScores
    with TableInfo<$DailyScoresTable, DailyScore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _streakScoreMeta = const VerificationMeta(
    'streakScore',
  );
  @override
  late final GeneratedColumn<double> streakScore = GeneratedColumn<double>(
    'streak_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _confidenceIndexMeta = const VerificationMeta(
    'confidenceIndex',
  );
  @override
  late final GeneratedColumn<double> confidenceIndex = GeneratedColumn<double>(
    'confidence_index',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _selfControlRatingMeta = const VerificationMeta(
    'selfControlRating',
  );
  @override
  late final GeneratedColumn<double> selfControlRating =
      GeneratedColumn<double>(
        'self_control_rating',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _vulnerabilityIndexMeta =
      const VerificationMeta('vulnerabilityIndex');
  @override
  late final GeneratedColumn<double> vulnerabilityIndex =
      GeneratedColumn<double>(
        'vulnerability_index',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _triggerSensitivityMeta =
      const VerificationMeta('triggerSensitivity');
  @override
  late final GeneratedColumn<String> triggerSensitivity =
      GeneratedColumn<String>(
        'trigger_sensitivity',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      );
  static const VerificationMeta _recoveryMomentumMeta = const VerificationMeta(
    'recoveryMomentum',
  );
  @override
  late final GeneratedColumn<double> recoveryMomentum = GeneratedColumn<double>(
    'recovery_momentum',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _downstreamImpactMeta = const VerificationMeta(
    'downstreamImpact',
  );
  @override
  late final GeneratedColumn<String> downstreamImpact = GeneratedColumn<String>(
    'downstream_impact',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _riskProfileHashMeta = const VerificationMeta(
    'riskProfileHash',
  );
  @override
  late final GeneratedColumn<String> riskProfileHash = GeneratedColumn<String>(
    'risk_profile_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dayTypeMeta = const VerificationMeta(
    'dayType',
  );
  @override
  late final GeneratedColumn<String> dayType = GeneratedColumn<String>(
    'day_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slipsTodayMeta = const VerificationMeta(
    'slipsToday',
  );
  @override
  late final GeneratedColumn<int> slipsToday = GeneratedColumn<int>(
    'slips_today',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _urgesTodayMeta = const VerificationMeta(
    'urgesToday',
  );
  @override
  late final GeneratedColumn<int> urgesToday = GeneratedColumn<int>(
    'urges_today',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hadSlipYesterdayMeta = const VerificationMeta(
    'hadSlipYesterday',
  );
  @override
  late final GeneratedColumn<bool> hadSlipYesterday = GeneratedColumn<bool>(
    'had_slip_yesterday',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("had_slip_yesterday" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    dayOfWeek,
    streakScore,
    confidenceIndex,
    selfControlRating,
    vulnerabilityIndex,
    triggerSensitivity,
    recoveryMomentum,
    downstreamImpact,
    riskProfileHash,
    dayType,
    slipsToday,
    urgesToday,
    hadSlipYesterday,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_scores';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyScore> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('streak_score')) {
      context.handle(
        _streakScoreMeta,
        streakScore.isAcceptableOrUnknown(
          data['streak_score']!,
          _streakScoreMeta,
        ),
      );
    }
    if (data.containsKey('confidence_index')) {
      context.handle(
        _confidenceIndexMeta,
        confidenceIndex.isAcceptableOrUnknown(
          data['confidence_index']!,
          _confidenceIndexMeta,
        ),
      );
    }
    if (data.containsKey('self_control_rating')) {
      context.handle(
        _selfControlRatingMeta,
        selfControlRating.isAcceptableOrUnknown(
          data['self_control_rating']!,
          _selfControlRatingMeta,
        ),
      );
    }
    if (data.containsKey('vulnerability_index')) {
      context.handle(
        _vulnerabilityIndexMeta,
        vulnerabilityIndex.isAcceptableOrUnknown(
          data['vulnerability_index']!,
          _vulnerabilityIndexMeta,
        ),
      );
    }
    if (data.containsKey('trigger_sensitivity')) {
      context.handle(
        _triggerSensitivityMeta,
        triggerSensitivity.isAcceptableOrUnknown(
          data['trigger_sensitivity']!,
          _triggerSensitivityMeta,
        ),
      );
    }
    if (data.containsKey('recovery_momentum')) {
      context.handle(
        _recoveryMomentumMeta,
        recoveryMomentum.isAcceptableOrUnknown(
          data['recovery_momentum']!,
          _recoveryMomentumMeta,
        ),
      );
    }
    if (data.containsKey('downstream_impact')) {
      context.handle(
        _downstreamImpactMeta,
        downstreamImpact.isAcceptableOrUnknown(
          data['downstream_impact']!,
          _downstreamImpactMeta,
        ),
      );
    }
    if (data.containsKey('risk_profile_hash')) {
      context.handle(
        _riskProfileHashMeta,
        riskProfileHash.isAcceptableOrUnknown(
          data['risk_profile_hash']!,
          _riskProfileHashMeta,
        ),
      );
    }
    if (data.containsKey('day_type')) {
      context.handle(
        _dayTypeMeta,
        dayType.isAcceptableOrUnknown(data['day_type']!, _dayTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_dayTypeMeta);
    }
    if (data.containsKey('slips_today')) {
      context.handle(
        _slipsTodayMeta,
        slipsToday.isAcceptableOrUnknown(data['slips_today']!, _slipsTodayMeta),
      );
    }
    if (data.containsKey('urges_today')) {
      context.handle(
        _urgesTodayMeta,
        urgesToday.isAcceptableOrUnknown(data['urges_today']!, _urgesTodayMeta),
      );
    }
    if (data.containsKey('had_slip_yesterday')) {
      context.handle(
        _hadSlipYesterdayMeta,
        hadSlipYesterday.isAcceptableOrUnknown(
          data['had_slip_yesterday']!,
          _hadSlipYesterdayMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyScore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyScore(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_week'],
      )!,
      streakScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}streak_score'],
      )!,
      confidenceIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence_index'],
      )!,
      selfControlRating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}self_control_rating'],
      )!,
      vulnerabilityIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vulnerability_index'],
      )!,
      triggerSensitivity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger_sensitivity'],
      )!,
      recoveryMomentum: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}recovery_momentum'],
      )!,
      downstreamImpact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}downstream_impact'],
      )!,
      riskProfileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}risk_profile_hash'],
      ),
      dayType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_type'],
      )!,
      slipsToday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slips_today'],
      )!,
      urgesToday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urges_today'],
      )!,
      hadSlipYesterday: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}had_slip_yesterday'],
      )!,
    );
  }

  @override
  $DailyScoresTable createAlias(String alias) {
    return $DailyScoresTable(attachedDatabase, alias);
  }
}

class DailyScore extends DataClass implements Insertable<DailyScore> {
  final int id;
  final DateTime date;
  final int dayOfWeek;
  final double streakScore;
  final double confidenceIndex;
  final double selfControlRating;
  final double vulnerabilityIndex;
  final String triggerSensitivity;
  final double recoveryMomentum;
  final String downstreamImpact;
  final String? riskProfileHash;
  final String dayType;
  final int slipsToday;
  final int urgesToday;
  final bool hadSlipYesterday;
  const DailyScore({
    required this.id,
    required this.date,
    required this.dayOfWeek,
    required this.streakScore,
    required this.confidenceIndex,
    required this.selfControlRating,
    required this.vulnerabilityIndex,
    required this.triggerSensitivity,
    required this.recoveryMomentum,
    required this.downstreamImpact,
    this.riskProfileHash,
    required this.dayType,
    required this.slipsToday,
    required this.urgesToday,
    required this.hadSlipYesterday,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['day_of_week'] = Variable<int>(dayOfWeek);
    map['streak_score'] = Variable<double>(streakScore);
    map['confidence_index'] = Variable<double>(confidenceIndex);
    map['self_control_rating'] = Variable<double>(selfControlRating);
    map['vulnerability_index'] = Variable<double>(vulnerabilityIndex);
    map['trigger_sensitivity'] = Variable<String>(triggerSensitivity);
    map['recovery_momentum'] = Variable<double>(recoveryMomentum);
    map['downstream_impact'] = Variable<String>(downstreamImpact);
    if (!nullToAbsent || riskProfileHash != null) {
      map['risk_profile_hash'] = Variable<String>(riskProfileHash);
    }
    map['day_type'] = Variable<String>(dayType);
    map['slips_today'] = Variable<int>(slipsToday);
    map['urges_today'] = Variable<int>(urgesToday);
    map['had_slip_yesterday'] = Variable<bool>(hadSlipYesterday);
    return map;
  }

  DailyScoresCompanion toCompanion(bool nullToAbsent) {
    return DailyScoresCompanion(
      id: Value(id),
      date: Value(date),
      dayOfWeek: Value(dayOfWeek),
      streakScore: Value(streakScore),
      confidenceIndex: Value(confidenceIndex),
      selfControlRating: Value(selfControlRating),
      vulnerabilityIndex: Value(vulnerabilityIndex),
      triggerSensitivity: Value(triggerSensitivity),
      recoveryMomentum: Value(recoveryMomentum),
      downstreamImpact: Value(downstreamImpact),
      riskProfileHash: riskProfileHash == null && nullToAbsent
          ? const Value.absent()
          : Value(riskProfileHash),
      dayType: Value(dayType),
      slipsToday: Value(slipsToday),
      urgesToday: Value(urgesToday),
      hadSlipYesterday: Value(hadSlipYesterday),
    );
  }

  factory DailyScore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyScore(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      streakScore: serializer.fromJson<double>(json['streakScore']),
      confidenceIndex: serializer.fromJson<double>(json['confidenceIndex']),
      selfControlRating: serializer.fromJson<double>(json['selfControlRating']),
      vulnerabilityIndex: serializer.fromJson<double>(
        json['vulnerabilityIndex'],
      ),
      triggerSensitivity: serializer.fromJson<String>(
        json['triggerSensitivity'],
      ),
      recoveryMomentum: serializer.fromJson<double>(json['recoveryMomentum']),
      downstreamImpact: serializer.fromJson<String>(json['downstreamImpact']),
      riskProfileHash: serializer.fromJson<String?>(json['riskProfileHash']),
      dayType: serializer.fromJson<String>(json['dayType']),
      slipsToday: serializer.fromJson<int>(json['slipsToday']),
      urgesToday: serializer.fromJson<int>(json['urgesToday']),
      hadSlipYesterday: serializer.fromJson<bool>(json['hadSlipYesterday']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'streakScore': serializer.toJson<double>(streakScore),
      'confidenceIndex': serializer.toJson<double>(confidenceIndex),
      'selfControlRating': serializer.toJson<double>(selfControlRating),
      'vulnerabilityIndex': serializer.toJson<double>(vulnerabilityIndex),
      'triggerSensitivity': serializer.toJson<String>(triggerSensitivity),
      'recoveryMomentum': serializer.toJson<double>(recoveryMomentum),
      'downstreamImpact': serializer.toJson<String>(downstreamImpact),
      'riskProfileHash': serializer.toJson<String?>(riskProfileHash),
      'dayType': serializer.toJson<String>(dayType),
      'slipsToday': serializer.toJson<int>(slipsToday),
      'urgesToday': serializer.toJson<int>(urgesToday),
      'hadSlipYesterday': serializer.toJson<bool>(hadSlipYesterday),
    };
  }

  DailyScore copyWith({
    int? id,
    DateTime? date,
    int? dayOfWeek,
    double? streakScore,
    double? confidenceIndex,
    double? selfControlRating,
    double? vulnerabilityIndex,
    String? triggerSensitivity,
    double? recoveryMomentum,
    String? downstreamImpact,
    Value<String?> riskProfileHash = const Value.absent(),
    String? dayType,
    int? slipsToday,
    int? urgesToday,
    bool? hadSlipYesterday,
  }) => DailyScore(
    id: id ?? this.id,
    date: date ?? this.date,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    streakScore: streakScore ?? this.streakScore,
    confidenceIndex: confidenceIndex ?? this.confidenceIndex,
    selfControlRating: selfControlRating ?? this.selfControlRating,
    vulnerabilityIndex: vulnerabilityIndex ?? this.vulnerabilityIndex,
    triggerSensitivity: triggerSensitivity ?? this.triggerSensitivity,
    recoveryMomentum: recoveryMomentum ?? this.recoveryMomentum,
    downstreamImpact: downstreamImpact ?? this.downstreamImpact,
    riskProfileHash: riskProfileHash.present
        ? riskProfileHash.value
        : this.riskProfileHash,
    dayType: dayType ?? this.dayType,
    slipsToday: slipsToday ?? this.slipsToday,
    urgesToday: urgesToday ?? this.urgesToday,
    hadSlipYesterday: hadSlipYesterday ?? this.hadSlipYesterday,
  );
  DailyScore copyWithCompanion(DailyScoresCompanion data) {
    return DailyScore(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      streakScore: data.streakScore.present
          ? data.streakScore.value
          : this.streakScore,
      confidenceIndex: data.confidenceIndex.present
          ? data.confidenceIndex.value
          : this.confidenceIndex,
      selfControlRating: data.selfControlRating.present
          ? data.selfControlRating.value
          : this.selfControlRating,
      vulnerabilityIndex: data.vulnerabilityIndex.present
          ? data.vulnerabilityIndex.value
          : this.vulnerabilityIndex,
      triggerSensitivity: data.triggerSensitivity.present
          ? data.triggerSensitivity.value
          : this.triggerSensitivity,
      recoveryMomentum: data.recoveryMomentum.present
          ? data.recoveryMomentum.value
          : this.recoveryMomentum,
      downstreamImpact: data.downstreamImpact.present
          ? data.downstreamImpact.value
          : this.downstreamImpact,
      riskProfileHash: data.riskProfileHash.present
          ? data.riskProfileHash.value
          : this.riskProfileHash,
      dayType: data.dayType.present ? data.dayType.value : this.dayType,
      slipsToday: data.slipsToday.present
          ? data.slipsToday.value
          : this.slipsToday,
      urgesToday: data.urgesToday.present
          ? data.urgesToday.value
          : this.urgesToday,
      hadSlipYesterday: data.hadSlipYesterday.present
          ? data.hadSlipYesterday.value
          : this.hadSlipYesterday,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyScore(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('streakScore: $streakScore, ')
          ..write('confidenceIndex: $confidenceIndex, ')
          ..write('selfControlRating: $selfControlRating, ')
          ..write('vulnerabilityIndex: $vulnerabilityIndex, ')
          ..write('triggerSensitivity: $triggerSensitivity, ')
          ..write('recoveryMomentum: $recoveryMomentum, ')
          ..write('downstreamImpact: $downstreamImpact, ')
          ..write('riskProfileHash: $riskProfileHash, ')
          ..write('dayType: $dayType, ')
          ..write('slipsToday: $slipsToday, ')
          ..write('urgesToday: $urgesToday, ')
          ..write('hadSlipYesterday: $hadSlipYesterday')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    dayOfWeek,
    streakScore,
    confidenceIndex,
    selfControlRating,
    vulnerabilityIndex,
    triggerSensitivity,
    recoveryMomentum,
    downstreamImpact,
    riskProfileHash,
    dayType,
    slipsToday,
    urgesToday,
    hadSlipYesterday,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyScore &&
          other.id == this.id &&
          other.date == this.date &&
          other.dayOfWeek == this.dayOfWeek &&
          other.streakScore == this.streakScore &&
          other.confidenceIndex == this.confidenceIndex &&
          other.selfControlRating == this.selfControlRating &&
          other.vulnerabilityIndex == this.vulnerabilityIndex &&
          other.triggerSensitivity == this.triggerSensitivity &&
          other.recoveryMomentum == this.recoveryMomentum &&
          other.downstreamImpact == this.downstreamImpact &&
          other.riskProfileHash == this.riskProfileHash &&
          other.dayType == this.dayType &&
          other.slipsToday == this.slipsToday &&
          other.urgesToday == this.urgesToday &&
          other.hadSlipYesterday == this.hadSlipYesterday);
}

class DailyScoresCompanion extends UpdateCompanion<DailyScore> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> dayOfWeek;
  final Value<double> streakScore;
  final Value<double> confidenceIndex;
  final Value<double> selfControlRating;
  final Value<double> vulnerabilityIndex;
  final Value<String> triggerSensitivity;
  final Value<double> recoveryMomentum;
  final Value<String> downstreamImpact;
  final Value<String?> riskProfileHash;
  final Value<String> dayType;
  final Value<int> slipsToday;
  final Value<int> urgesToday;
  final Value<bool> hadSlipYesterday;
  const DailyScoresCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.streakScore = const Value.absent(),
    this.confidenceIndex = const Value.absent(),
    this.selfControlRating = const Value.absent(),
    this.vulnerabilityIndex = const Value.absent(),
    this.triggerSensitivity = const Value.absent(),
    this.recoveryMomentum = const Value.absent(),
    this.downstreamImpact = const Value.absent(),
    this.riskProfileHash = const Value.absent(),
    this.dayType = const Value.absent(),
    this.slipsToday = const Value.absent(),
    this.urgesToday = const Value.absent(),
    this.hadSlipYesterday = const Value.absent(),
  });
  DailyScoresCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int dayOfWeek,
    this.streakScore = const Value.absent(),
    this.confidenceIndex = const Value.absent(),
    this.selfControlRating = const Value.absent(),
    this.vulnerabilityIndex = const Value.absent(),
    this.triggerSensitivity = const Value.absent(),
    this.recoveryMomentum = const Value.absent(),
    this.downstreamImpact = const Value.absent(),
    this.riskProfileHash = const Value.absent(),
    required String dayType,
    this.slipsToday = const Value.absent(),
    this.urgesToday = const Value.absent(),
    this.hadSlipYesterday = const Value.absent(),
  }) : date = Value(date),
       dayOfWeek = Value(dayOfWeek),
       dayType = Value(dayType);
  static Insertable<DailyScore> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? dayOfWeek,
    Expression<double>? streakScore,
    Expression<double>? confidenceIndex,
    Expression<double>? selfControlRating,
    Expression<double>? vulnerabilityIndex,
    Expression<String>? triggerSensitivity,
    Expression<double>? recoveryMomentum,
    Expression<String>? downstreamImpact,
    Expression<String>? riskProfileHash,
    Expression<String>? dayType,
    Expression<int>? slipsToday,
    Expression<int>? urgesToday,
    Expression<bool>? hadSlipYesterday,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (streakScore != null) 'streak_score': streakScore,
      if (confidenceIndex != null) 'confidence_index': confidenceIndex,
      if (selfControlRating != null) 'self_control_rating': selfControlRating,
      if (vulnerabilityIndex != null) 'vulnerability_index': vulnerabilityIndex,
      if (triggerSensitivity != null) 'trigger_sensitivity': triggerSensitivity,
      if (recoveryMomentum != null) 'recovery_momentum': recoveryMomentum,
      if (downstreamImpact != null) 'downstream_impact': downstreamImpact,
      if (riskProfileHash != null) 'risk_profile_hash': riskProfileHash,
      if (dayType != null) 'day_type': dayType,
      if (slipsToday != null) 'slips_today': slipsToday,
      if (urgesToday != null) 'urges_today': urgesToday,
      if (hadSlipYesterday != null) 'had_slip_yesterday': hadSlipYesterday,
    });
  }

  DailyScoresCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? dayOfWeek,
    Value<double>? streakScore,
    Value<double>? confidenceIndex,
    Value<double>? selfControlRating,
    Value<double>? vulnerabilityIndex,
    Value<String>? triggerSensitivity,
    Value<double>? recoveryMomentum,
    Value<String>? downstreamImpact,
    Value<String?>? riskProfileHash,
    Value<String>? dayType,
    Value<int>? slipsToday,
    Value<int>? urgesToday,
    Value<bool>? hadSlipYesterday,
  }) {
    return DailyScoresCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      streakScore: streakScore ?? this.streakScore,
      confidenceIndex: confidenceIndex ?? this.confidenceIndex,
      selfControlRating: selfControlRating ?? this.selfControlRating,
      vulnerabilityIndex: vulnerabilityIndex ?? this.vulnerabilityIndex,
      triggerSensitivity: triggerSensitivity ?? this.triggerSensitivity,
      recoveryMomentum: recoveryMomentum ?? this.recoveryMomentum,
      downstreamImpact: downstreamImpact ?? this.downstreamImpact,
      riskProfileHash: riskProfileHash ?? this.riskProfileHash,
      dayType: dayType ?? this.dayType,
      slipsToday: slipsToday ?? this.slipsToday,
      urgesToday: urgesToday ?? this.urgesToday,
      hadSlipYesterday: hadSlipYesterday ?? this.hadSlipYesterday,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (streakScore.present) {
      map['streak_score'] = Variable<double>(streakScore.value);
    }
    if (confidenceIndex.present) {
      map['confidence_index'] = Variable<double>(confidenceIndex.value);
    }
    if (selfControlRating.present) {
      map['self_control_rating'] = Variable<double>(selfControlRating.value);
    }
    if (vulnerabilityIndex.present) {
      map['vulnerability_index'] = Variable<double>(vulnerabilityIndex.value);
    }
    if (triggerSensitivity.present) {
      map['trigger_sensitivity'] = Variable<String>(triggerSensitivity.value);
    }
    if (recoveryMomentum.present) {
      map['recovery_momentum'] = Variable<double>(recoveryMomentum.value);
    }
    if (downstreamImpact.present) {
      map['downstream_impact'] = Variable<String>(downstreamImpact.value);
    }
    if (riskProfileHash.present) {
      map['risk_profile_hash'] = Variable<String>(riskProfileHash.value);
    }
    if (dayType.present) {
      map['day_type'] = Variable<String>(dayType.value);
    }
    if (slipsToday.present) {
      map['slips_today'] = Variable<int>(slipsToday.value);
    }
    if (urgesToday.present) {
      map['urges_today'] = Variable<int>(urgesToday.value);
    }
    if (hadSlipYesterday.present) {
      map['had_slip_yesterday'] = Variable<bool>(hadSlipYesterday.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyScoresCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('streakScore: $streakScore, ')
          ..write('confidenceIndex: $confidenceIndex, ')
          ..write('selfControlRating: $selfControlRating, ')
          ..write('vulnerabilityIndex: $vulnerabilityIndex, ')
          ..write('triggerSensitivity: $triggerSensitivity, ')
          ..write('recoveryMomentum: $recoveryMomentum, ')
          ..write('downstreamImpact: $downstreamImpact, ')
          ..write('riskProfileHash: $riskProfileHash, ')
          ..write('dayType: $dayType, ')
          ..write('slipsToday: $slipsToday, ')
          ..write('urgesToday: $urgesToday, ')
          ..write('hadSlipYesterday: $hadSlipYesterday')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTable extends Achievements
    with TableInfo<$AchievementsTable, Achievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _achievementKeyMeta = const VerificationMeta(
    'achievementKey',
  );
  @override
  late final GeneratedColumn<String> achievementKey = GeneratedColumn<String>(
    'achievement_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  @override
  late final GeneratedColumn<String> tier = GeneratedColumn<String>(
    'tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockedMeta = const VerificationMeta(
    'unlocked',
  );
  @override
  late final GeneratedColumn<bool> unlocked = GeneratedColumn<bool>(
    'unlocked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("unlocked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
    'unlocked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pausedMeta = const VerificationMeta('paused');
  @override
  late final GeneratedColumn<bool> paused = GeneratedColumn<bool>(
    'paused',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("paused" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _timesEarnedMeta = const VerificationMeta(
    'timesEarned',
  );
  @override
  late final GeneratedColumn<int> timesEarned = GeneratedColumn<int>(
    'times_earned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    achievementKey,
    title,
    description,
    tier,
    unlocked,
    unlockedAt,
    paused,
    timesEarned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Achievement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('achievement_key')) {
      context.handle(
        _achievementKeyMeta,
        achievementKey.isAcceptableOrUnknown(
          data['achievement_key']!,
          _achievementKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_achievementKeyMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('tier')) {
      context.handle(
        _tierMeta,
        tier.isAcceptableOrUnknown(data['tier']!, _tierMeta),
      );
    } else if (isInserting) {
      context.missing(_tierMeta);
    }
    if (data.containsKey('unlocked')) {
      context.handle(
        _unlockedMeta,
        unlocked.isAcceptableOrUnknown(data['unlocked']!, _unlockedMeta),
      );
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    }
    if (data.containsKey('paused')) {
      context.handle(
        _pausedMeta,
        paused.isAcceptableOrUnknown(data['paused']!, _pausedMeta),
      );
    }
    if (data.containsKey('times_earned')) {
      context.handle(
        _timesEarnedMeta,
        timesEarned.isAcceptableOrUnknown(
          data['times_earned']!,
          _timesEarnedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Achievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Achievement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      achievementKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achievement_key'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      tier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tier'],
      )!,
      unlocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}unlocked'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
      ),
      paused: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}paused'],
      )!,
      timesEarned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_earned'],
      )!,
    );
  }

  @override
  $AchievementsTable createAlias(String alias) {
    return $AchievementsTable(attachedDatabase, alias);
  }
}

class Achievement extends DataClass implements Insertable<Achievement> {
  final int id;
  final String achievementKey;
  final String title;
  final String description;
  final String tier;
  final bool unlocked;
  final DateTime? unlockedAt;
  final bool paused;
  final int timesEarned;
  const Achievement({
    required this.id,
    required this.achievementKey,
    required this.title,
    required this.description,
    required this.tier,
    required this.unlocked,
    this.unlockedAt,
    required this.paused,
    required this.timesEarned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['achievement_key'] = Variable<String>(achievementKey);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['tier'] = Variable<String>(tier);
    map['unlocked'] = Variable<bool>(unlocked);
    if (!nullToAbsent || unlockedAt != null) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    }
    map['paused'] = Variable<bool>(paused);
    map['times_earned'] = Variable<int>(timesEarned);
    return map;
  }

  AchievementsCompanion toCompanion(bool nullToAbsent) {
    return AchievementsCompanion(
      id: Value(id),
      achievementKey: Value(achievementKey),
      title: Value(title),
      description: Value(description),
      tier: Value(tier),
      unlocked: Value(unlocked),
      unlockedAt: unlockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockedAt),
      paused: Value(paused),
      timesEarned: Value(timesEarned),
    );
  }

  factory Achievement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Achievement(
      id: serializer.fromJson<int>(json['id']),
      achievementKey: serializer.fromJson<String>(json['achievementKey']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      tier: serializer.fromJson<String>(json['tier']),
      unlocked: serializer.fromJson<bool>(json['unlocked']),
      unlockedAt: serializer.fromJson<DateTime?>(json['unlockedAt']),
      paused: serializer.fromJson<bool>(json['paused']),
      timesEarned: serializer.fromJson<int>(json['timesEarned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'achievementKey': serializer.toJson<String>(achievementKey),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'tier': serializer.toJson<String>(tier),
      'unlocked': serializer.toJson<bool>(unlocked),
      'unlockedAt': serializer.toJson<DateTime?>(unlockedAt),
      'paused': serializer.toJson<bool>(paused),
      'timesEarned': serializer.toJson<int>(timesEarned),
    };
  }

  Achievement copyWith({
    int? id,
    String? achievementKey,
    String? title,
    String? description,
    String? tier,
    bool? unlocked,
    Value<DateTime?> unlockedAt = const Value.absent(),
    bool? paused,
    int? timesEarned,
  }) => Achievement(
    id: id ?? this.id,
    achievementKey: achievementKey ?? this.achievementKey,
    title: title ?? this.title,
    description: description ?? this.description,
    tier: tier ?? this.tier,
    unlocked: unlocked ?? this.unlocked,
    unlockedAt: unlockedAt.present ? unlockedAt.value : this.unlockedAt,
    paused: paused ?? this.paused,
    timesEarned: timesEarned ?? this.timesEarned,
  );
  Achievement copyWithCompanion(AchievementsCompanion data) {
    return Achievement(
      id: data.id.present ? data.id.value : this.id,
      achievementKey: data.achievementKey.present
          ? data.achievementKey.value
          : this.achievementKey,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      tier: data.tier.present ? data.tier.value : this.tier,
      unlocked: data.unlocked.present ? data.unlocked.value : this.unlocked,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
      paused: data.paused.present ? data.paused.value : this.paused,
      timesEarned: data.timesEarned.present
          ? data.timesEarned.value
          : this.timesEarned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Achievement(')
          ..write('id: $id, ')
          ..write('achievementKey: $achievementKey, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('tier: $tier, ')
          ..write('unlocked: $unlocked, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('paused: $paused, ')
          ..write('timesEarned: $timesEarned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    achievementKey,
    title,
    description,
    tier,
    unlocked,
    unlockedAt,
    paused,
    timesEarned,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Achievement &&
          other.id == this.id &&
          other.achievementKey == this.achievementKey &&
          other.title == this.title &&
          other.description == this.description &&
          other.tier == this.tier &&
          other.unlocked == this.unlocked &&
          other.unlockedAt == this.unlockedAt &&
          other.paused == this.paused &&
          other.timesEarned == this.timesEarned);
}

class AchievementsCompanion extends UpdateCompanion<Achievement> {
  final Value<int> id;
  final Value<String> achievementKey;
  final Value<String> title;
  final Value<String> description;
  final Value<String> tier;
  final Value<bool> unlocked;
  final Value<DateTime?> unlockedAt;
  final Value<bool> paused;
  final Value<int> timesEarned;
  const AchievementsCompanion({
    this.id = const Value.absent(),
    this.achievementKey = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.tier = const Value.absent(),
    this.unlocked = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.paused = const Value.absent(),
    this.timesEarned = const Value.absent(),
  });
  AchievementsCompanion.insert({
    this.id = const Value.absent(),
    required String achievementKey,
    required String title,
    required String description,
    required String tier,
    this.unlocked = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.paused = const Value.absent(),
    this.timesEarned = const Value.absent(),
  }) : achievementKey = Value(achievementKey),
       title = Value(title),
       description = Value(description),
       tier = Value(tier);
  static Insertable<Achievement> custom({
    Expression<int>? id,
    Expression<String>? achievementKey,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? tier,
    Expression<bool>? unlocked,
    Expression<DateTime>? unlockedAt,
    Expression<bool>? paused,
    Expression<int>? timesEarned,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (achievementKey != null) 'achievement_key': achievementKey,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (tier != null) 'tier': tier,
      if (unlocked != null) 'unlocked': unlocked,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (paused != null) 'paused': paused,
      if (timesEarned != null) 'times_earned': timesEarned,
    });
  }

  AchievementsCompanion copyWith({
    Value<int>? id,
    Value<String>? achievementKey,
    Value<String>? title,
    Value<String>? description,
    Value<String>? tier,
    Value<bool>? unlocked,
    Value<DateTime?>? unlockedAt,
    Value<bool>? paused,
    Value<int>? timesEarned,
  }) {
    return AchievementsCompanion(
      id: id ?? this.id,
      achievementKey: achievementKey ?? this.achievementKey,
      title: title ?? this.title,
      description: description ?? this.description,
      tier: tier ?? this.tier,
      unlocked: unlocked ?? this.unlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      paused: paused ?? this.paused,
      timesEarned: timesEarned ?? this.timesEarned,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (achievementKey.present) {
      map['achievement_key'] = Variable<String>(achievementKey.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(tier.value);
    }
    if (unlocked.present) {
      map['unlocked'] = Variable<bool>(unlocked.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (paused.present) {
      map['paused'] = Variable<bool>(paused.value);
    }
    if (timesEarned.present) {
      map['times_earned'] = Variable<int>(timesEarned.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsCompanion(')
          ..write('id: $id, ')
          ..write('achievementKey: $achievementKey, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('tier: $tier, ')
          ..write('unlocked: $unlocked, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('paused: $paused, ')
          ..write('timesEarned: $timesEarned')
          ..write(')'))
        .toString();
  }
}

class $DiversionTasksTable extends DiversionTasks
    with TableInfo<$DiversionTasksTable, DiversionTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiversionTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _taskNameMeta = const VerificationMeta(
    'taskName',
  );
  @override
  late final GeneratedColumn<String> taskName = GeneratedColumn<String>(
    'task_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minDurationSecondsMeta =
      const VerificationMeta('minDurationSeconds');
  @override
  late final GeneratedColumn<int> minDurationSeconds = GeneratedColumn<int>(
    'min_duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxDurationSecondsMeta =
      const VerificationMeta('maxDurationSeconds');
  @override
  late final GeneratedColumn<int> maxDurationSeconds = GeneratedColumn<int>(
    'max_duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextFitMeta = const VerificationMeta(
    'contextFit',
  );
  @override
  late final GeneratedColumn<String> contextFit = GeneratedColumn<String>(
    'context_fit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _timesUsedMeta = const VerificationMeta(
    'timesUsed',
  );
  @override
  late final GeneratedColumn<int> timesUsed = GeneratedColumn<int>(
    'times_used',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _timesSucceededMeta = const VerificationMeta(
    'timesSucceeded',
  );
  @override
  late final GeneratedColumn<int> timesSucceeded = GeneratedColumn<int>(
    'times_succeeded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _effectivenessRateMeta = const VerificationMeta(
    'effectivenessRate',
  );
  @override
  late final GeneratedColumn<double> effectivenessRate =
      GeneratedColumn<double>(
        'effectiveness_rate',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskName,
    category,
    minDurationSeconds,
    maxDurationSeconds,
    contextFit,
    timesUsed,
    timesSucceeded,
    effectivenessRate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diversion_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiversionTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('task_name')) {
      context.handle(
        _taskNameMeta,
        taskName.isAcceptableOrUnknown(data['task_name']!, _taskNameMeta),
      );
    } else if (isInserting) {
      context.missing(_taskNameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('min_duration_seconds')) {
      context.handle(
        _minDurationSecondsMeta,
        minDurationSeconds.isAcceptableOrUnknown(
          data['min_duration_seconds']!,
          _minDurationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minDurationSecondsMeta);
    }
    if (data.containsKey('max_duration_seconds')) {
      context.handle(
        _maxDurationSecondsMeta,
        maxDurationSeconds.isAcceptableOrUnknown(
          data['max_duration_seconds']!,
          _maxDurationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maxDurationSecondsMeta);
    }
    if (data.containsKey('context_fit')) {
      context.handle(
        _contextFitMeta,
        contextFit.isAcceptableOrUnknown(data['context_fit']!, _contextFitMeta),
      );
    }
    if (data.containsKey('times_used')) {
      context.handle(
        _timesUsedMeta,
        timesUsed.isAcceptableOrUnknown(data['times_used']!, _timesUsedMeta),
      );
    }
    if (data.containsKey('times_succeeded')) {
      context.handle(
        _timesSucceededMeta,
        timesSucceeded.isAcceptableOrUnknown(
          data['times_succeeded']!,
          _timesSucceededMeta,
        ),
      );
    }
    if (data.containsKey('effectiveness_rate')) {
      context.handle(
        _effectivenessRateMeta,
        effectivenessRate.isAcceptableOrUnknown(
          data['effectiveness_rate']!,
          _effectivenessRateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiversionTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiversionTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      taskName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      minDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_duration_seconds'],
      )!,
      maxDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_duration_seconds'],
      )!,
      contextFit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_fit'],
      )!,
      timesUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_used'],
      )!,
      timesSucceeded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_succeeded'],
      )!,
      effectivenessRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}effectiveness_rate'],
      )!,
    );
  }

  @override
  $DiversionTasksTable createAlias(String alias) {
    return $DiversionTasksTable(attachedDatabase, alias);
  }
}

class DiversionTask extends DataClass implements Insertable<DiversionTask> {
  final int id;
  final String taskName;
  final String category;
  final int minDurationSeconds;
  final int maxDurationSeconds;
  final String contextFit;
  final int timesUsed;
  final int timesSucceeded;
  final double effectivenessRate;
  const DiversionTask({
    required this.id,
    required this.taskName,
    required this.category,
    required this.minDurationSeconds,
    required this.maxDurationSeconds,
    required this.contextFit,
    required this.timesUsed,
    required this.timesSucceeded,
    required this.effectivenessRate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['task_name'] = Variable<String>(taskName);
    map['category'] = Variable<String>(category);
    map['min_duration_seconds'] = Variable<int>(minDurationSeconds);
    map['max_duration_seconds'] = Variable<int>(maxDurationSeconds);
    map['context_fit'] = Variable<String>(contextFit);
    map['times_used'] = Variable<int>(timesUsed);
    map['times_succeeded'] = Variable<int>(timesSucceeded);
    map['effectiveness_rate'] = Variable<double>(effectivenessRate);
    return map;
  }

  DiversionTasksCompanion toCompanion(bool nullToAbsent) {
    return DiversionTasksCompanion(
      id: Value(id),
      taskName: Value(taskName),
      category: Value(category),
      minDurationSeconds: Value(minDurationSeconds),
      maxDurationSeconds: Value(maxDurationSeconds),
      contextFit: Value(contextFit),
      timesUsed: Value(timesUsed),
      timesSucceeded: Value(timesSucceeded),
      effectivenessRate: Value(effectivenessRate),
    );
  }

  factory DiversionTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiversionTask(
      id: serializer.fromJson<int>(json['id']),
      taskName: serializer.fromJson<String>(json['taskName']),
      category: serializer.fromJson<String>(json['category']),
      minDurationSeconds: serializer.fromJson<int>(json['minDurationSeconds']),
      maxDurationSeconds: serializer.fromJson<int>(json['maxDurationSeconds']),
      contextFit: serializer.fromJson<String>(json['contextFit']),
      timesUsed: serializer.fromJson<int>(json['timesUsed']),
      timesSucceeded: serializer.fromJson<int>(json['timesSucceeded']),
      effectivenessRate: serializer.fromJson<double>(json['effectivenessRate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taskName': serializer.toJson<String>(taskName),
      'category': serializer.toJson<String>(category),
      'minDurationSeconds': serializer.toJson<int>(minDurationSeconds),
      'maxDurationSeconds': serializer.toJson<int>(maxDurationSeconds),
      'contextFit': serializer.toJson<String>(contextFit),
      'timesUsed': serializer.toJson<int>(timesUsed),
      'timesSucceeded': serializer.toJson<int>(timesSucceeded),
      'effectivenessRate': serializer.toJson<double>(effectivenessRate),
    };
  }

  DiversionTask copyWith({
    int? id,
    String? taskName,
    String? category,
    int? minDurationSeconds,
    int? maxDurationSeconds,
    String? contextFit,
    int? timesUsed,
    int? timesSucceeded,
    double? effectivenessRate,
  }) => DiversionTask(
    id: id ?? this.id,
    taskName: taskName ?? this.taskName,
    category: category ?? this.category,
    minDurationSeconds: minDurationSeconds ?? this.minDurationSeconds,
    maxDurationSeconds: maxDurationSeconds ?? this.maxDurationSeconds,
    contextFit: contextFit ?? this.contextFit,
    timesUsed: timesUsed ?? this.timesUsed,
    timesSucceeded: timesSucceeded ?? this.timesSucceeded,
    effectivenessRate: effectivenessRate ?? this.effectivenessRate,
  );
  DiversionTask copyWithCompanion(DiversionTasksCompanion data) {
    return DiversionTask(
      id: data.id.present ? data.id.value : this.id,
      taskName: data.taskName.present ? data.taskName.value : this.taskName,
      category: data.category.present ? data.category.value : this.category,
      minDurationSeconds: data.minDurationSeconds.present
          ? data.minDurationSeconds.value
          : this.minDurationSeconds,
      maxDurationSeconds: data.maxDurationSeconds.present
          ? data.maxDurationSeconds.value
          : this.maxDurationSeconds,
      contextFit: data.contextFit.present
          ? data.contextFit.value
          : this.contextFit,
      timesUsed: data.timesUsed.present ? data.timesUsed.value : this.timesUsed,
      timesSucceeded: data.timesSucceeded.present
          ? data.timesSucceeded.value
          : this.timesSucceeded,
      effectivenessRate: data.effectivenessRate.present
          ? data.effectivenessRate.value
          : this.effectivenessRate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiversionTask(')
          ..write('id: $id, ')
          ..write('taskName: $taskName, ')
          ..write('category: $category, ')
          ..write('minDurationSeconds: $minDurationSeconds, ')
          ..write('maxDurationSeconds: $maxDurationSeconds, ')
          ..write('contextFit: $contextFit, ')
          ..write('timesUsed: $timesUsed, ')
          ..write('timesSucceeded: $timesSucceeded, ')
          ..write('effectivenessRate: $effectivenessRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskName,
    category,
    minDurationSeconds,
    maxDurationSeconds,
    contextFit,
    timesUsed,
    timesSucceeded,
    effectivenessRate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiversionTask &&
          other.id == this.id &&
          other.taskName == this.taskName &&
          other.category == this.category &&
          other.minDurationSeconds == this.minDurationSeconds &&
          other.maxDurationSeconds == this.maxDurationSeconds &&
          other.contextFit == this.contextFit &&
          other.timesUsed == this.timesUsed &&
          other.timesSucceeded == this.timesSucceeded &&
          other.effectivenessRate == this.effectivenessRate);
}

class DiversionTasksCompanion extends UpdateCompanion<DiversionTask> {
  final Value<int> id;
  final Value<String> taskName;
  final Value<String> category;
  final Value<int> minDurationSeconds;
  final Value<int> maxDurationSeconds;
  final Value<String> contextFit;
  final Value<int> timesUsed;
  final Value<int> timesSucceeded;
  final Value<double> effectivenessRate;
  const DiversionTasksCompanion({
    this.id = const Value.absent(),
    this.taskName = const Value.absent(),
    this.category = const Value.absent(),
    this.minDurationSeconds = const Value.absent(),
    this.maxDurationSeconds = const Value.absent(),
    this.contextFit = const Value.absent(),
    this.timesUsed = const Value.absent(),
    this.timesSucceeded = const Value.absent(),
    this.effectivenessRate = const Value.absent(),
  });
  DiversionTasksCompanion.insert({
    this.id = const Value.absent(),
    required String taskName,
    required String category,
    required int minDurationSeconds,
    required int maxDurationSeconds,
    this.contextFit = const Value.absent(),
    this.timesUsed = const Value.absent(),
    this.timesSucceeded = const Value.absent(),
    this.effectivenessRate = const Value.absent(),
  }) : taskName = Value(taskName),
       category = Value(category),
       minDurationSeconds = Value(minDurationSeconds),
       maxDurationSeconds = Value(maxDurationSeconds);
  static Insertable<DiversionTask> custom({
    Expression<int>? id,
    Expression<String>? taskName,
    Expression<String>? category,
    Expression<int>? minDurationSeconds,
    Expression<int>? maxDurationSeconds,
    Expression<String>? contextFit,
    Expression<int>? timesUsed,
    Expression<int>? timesSucceeded,
    Expression<double>? effectivenessRate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskName != null) 'task_name': taskName,
      if (category != null) 'category': category,
      if (minDurationSeconds != null)
        'min_duration_seconds': minDurationSeconds,
      if (maxDurationSeconds != null)
        'max_duration_seconds': maxDurationSeconds,
      if (contextFit != null) 'context_fit': contextFit,
      if (timesUsed != null) 'times_used': timesUsed,
      if (timesSucceeded != null) 'times_succeeded': timesSucceeded,
      if (effectivenessRate != null) 'effectiveness_rate': effectivenessRate,
    });
  }

  DiversionTasksCompanion copyWith({
    Value<int>? id,
    Value<String>? taskName,
    Value<String>? category,
    Value<int>? minDurationSeconds,
    Value<int>? maxDurationSeconds,
    Value<String>? contextFit,
    Value<int>? timesUsed,
    Value<int>? timesSucceeded,
    Value<double>? effectivenessRate,
  }) {
    return DiversionTasksCompanion(
      id: id ?? this.id,
      taskName: taskName ?? this.taskName,
      category: category ?? this.category,
      minDurationSeconds: minDurationSeconds ?? this.minDurationSeconds,
      maxDurationSeconds: maxDurationSeconds ?? this.maxDurationSeconds,
      contextFit: contextFit ?? this.contextFit,
      timesUsed: timesUsed ?? this.timesUsed,
      timesSucceeded: timesSucceeded ?? this.timesSucceeded,
      effectivenessRate: effectivenessRate ?? this.effectivenessRate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taskName.present) {
      map['task_name'] = Variable<String>(taskName.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (minDurationSeconds.present) {
      map['min_duration_seconds'] = Variable<int>(minDurationSeconds.value);
    }
    if (maxDurationSeconds.present) {
      map['max_duration_seconds'] = Variable<int>(maxDurationSeconds.value);
    }
    if (contextFit.present) {
      map['context_fit'] = Variable<String>(contextFit.value);
    }
    if (timesUsed.present) {
      map['times_used'] = Variable<int>(timesUsed.value);
    }
    if (timesSucceeded.present) {
      map['times_succeeded'] = Variable<int>(timesSucceeded.value);
    }
    if (effectivenessRate.present) {
      map['effectiveness_rate'] = Variable<double>(effectivenessRate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiversionTasksCompanion(')
          ..write('id: $id, ')
          ..write('taskName: $taskName, ')
          ..write('category: $category, ')
          ..write('minDurationSeconds: $minDurationSeconds, ')
          ..write('maxDurationSeconds: $maxDurationSeconds, ')
          ..write('contextFit: $contextFit, ')
          ..write('timesUsed: $timesUsed, ')
          ..write('timesSucceeded: $timesSucceeded, ')
          ..write('effectivenessRate: $effectivenessRate')
          ..write(')'))
        .toString();
  }
}

class $WeeklyReviewsTable extends WeeklyReviews
    with TableInfo<$WeeklyReviewsTable, WeeklyReview> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyReviewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _weekStartMeta = const VerificationMeta(
    'weekStart',
  );
  @override
  late final GeneratedColumn<DateTime> weekStart = GeneratedColumn<DateTime>(
    'week_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urgeCountMeta = const VerificationMeta(
    'urgeCount',
  );
  @override
  late final GeneratedColumn<int> urgeCount = GeneratedColumn<int>(
    'urge_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _slipCountMeta = const VerificationMeta(
    'slipCount',
  );
  @override
  late final GeneratedColumn<int> slipCount = GeneratedColumn<int>(
    'slip_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _avgSleepMeta = const VerificationMeta(
    'avgSleep',
  );
  @override
  late final GeneratedColumn<double> avgSleep = GeneratedColumn<double>(
    'avg_sleep',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _avgStressMeta = const VerificationMeta(
    'avgStress',
  );
  @override
  late final GeneratedColumn<double> avgStress = GeneratedColumn<double>(
    'avg_stress',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _streakScoreStartMeta = const VerificationMeta(
    'streakScoreStart',
  );
  @override
  late final GeneratedColumn<double> streakScoreStart = GeneratedColumn<double>(
    'streak_score_start',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _streakScoreEndMeta = const VerificationMeta(
    'streakScoreEnd',
  );
  @override
  late final GeneratedColumn<double> streakScoreEnd = GeneratedColumn<double>(
    'streak_score_end',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _confidenceStartMeta = const VerificationMeta(
    'confidenceStart',
  );
  @override
  late final GeneratedColumn<double> confidenceStart = GeneratedColumn<double>(
    'confidence_start',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _confidenceEndMeta = const VerificationMeta(
    'confidenceEnd',
  );
  @override
  late final GeneratedColumn<double> confidenceEnd = GeneratedColumn<double>(
    'confidence_end',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _topTriggersMeta = const VerificationMeta(
    'topTriggers',
  );
  @override
  late final GeneratedColumn<String> topTriggers = GeneratedColumn<String>(
    'top_triggers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _topInterventionsMeta = const VerificationMeta(
    'topInterventions',
  );
  @override
  late final GeneratedColumn<String> topInterventions = GeneratedColumn<String>(
    'top_interventions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _riskWindowsChangedMeta =
      const VerificationMeta('riskWindowsChanged');
  @override
  late final GeneratedColumn<String> riskWindowsChanged =
      GeneratedColumn<String>(
        'risk_windows_changed',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _planAdjustmentsMeta = const VerificationMeta(
    'planAdjustments',
  );
  @override
  late final GeneratedColumn<String> planAdjustments = GeneratedColumn<String>(
    'plan_adjustments',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _planTextMeta = const VerificationMeta(
    'planText',
  );
  @override
  late final GeneratedColumn<String> planText = GeneratedColumn<String>(
    'plan_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _momentumMeta = const VerificationMeta(
    'momentum',
  );
  @override
  late final GeneratedColumn<String> momentum = GeneratedColumn<String>(
    'momentum',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('flat'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    weekStart,
    urgeCount,
    slipCount,
    avgSleep,
    avgStress,
    streakScoreStart,
    streakScoreEnd,
    confidenceStart,
    confidenceEnd,
    topTriggers,
    topInterventions,
    riskWindowsChanged,
    planAdjustments,
    planText,
    momentum,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_reviews';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyReview> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('week_start')) {
      context.handle(
        _weekStartMeta,
        weekStart.isAcceptableOrUnknown(data['week_start']!, _weekStartMeta),
      );
    } else if (isInserting) {
      context.missing(_weekStartMeta);
    }
    if (data.containsKey('urge_count')) {
      context.handle(
        _urgeCountMeta,
        urgeCount.isAcceptableOrUnknown(data['urge_count']!, _urgeCountMeta),
      );
    }
    if (data.containsKey('slip_count')) {
      context.handle(
        _slipCountMeta,
        slipCount.isAcceptableOrUnknown(data['slip_count']!, _slipCountMeta),
      );
    }
    if (data.containsKey('avg_sleep')) {
      context.handle(
        _avgSleepMeta,
        avgSleep.isAcceptableOrUnknown(data['avg_sleep']!, _avgSleepMeta),
      );
    }
    if (data.containsKey('avg_stress')) {
      context.handle(
        _avgStressMeta,
        avgStress.isAcceptableOrUnknown(data['avg_stress']!, _avgStressMeta),
      );
    }
    if (data.containsKey('streak_score_start')) {
      context.handle(
        _streakScoreStartMeta,
        streakScoreStart.isAcceptableOrUnknown(
          data['streak_score_start']!,
          _streakScoreStartMeta,
        ),
      );
    }
    if (data.containsKey('streak_score_end')) {
      context.handle(
        _streakScoreEndMeta,
        streakScoreEnd.isAcceptableOrUnknown(
          data['streak_score_end']!,
          _streakScoreEndMeta,
        ),
      );
    }
    if (data.containsKey('confidence_start')) {
      context.handle(
        _confidenceStartMeta,
        confidenceStart.isAcceptableOrUnknown(
          data['confidence_start']!,
          _confidenceStartMeta,
        ),
      );
    }
    if (data.containsKey('confidence_end')) {
      context.handle(
        _confidenceEndMeta,
        confidenceEnd.isAcceptableOrUnknown(
          data['confidence_end']!,
          _confidenceEndMeta,
        ),
      );
    }
    if (data.containsKey('top_triggers')) {
      context.handle(
        _topTriggersMeta,
        topTriggers.isAcceptableOrUnknown(
          data['top_triggers']!,
          _topTriggersMeta,
        ),
      );
    }
    if (data.containsKey('top_interventions')) {
      context.handle(
        _topInterventionsMeta,
        topInterventions.isAcceptableOrUnknown(
          data['top_interventions']!,
          _topInterventionsMeta,
        ),
      );
    }
    if (data.containsKey('risk_windows_changed')) {
      context.handle(
        _riskWindowsChangedMeta,
        riskWindowsChanged.isAcceptableOrUnknown(
          data['risk_windows_changed']!,
          _riskWindowsChangedMeta,
        ),
      );
    }
    if (data.containsKey('plan_adjustments')) {
      context.handle(
        _planAdjustmentsMeta,
        planAdjustments.isAcceptableOrUnknown(
          data['plan_adjustments']!,
          _planAdjustmentsMeta,
        ),
      );
    }
    if (data.containsKey('plan_text')) {
      context.handle(
        _planTextMeta,
        planText.isAcceptableOrUnknown(data['plan_text']!, _planTextMeta),
      );
    }
    if (data.containsKey('momentum')) {
      context.handle(
        _momentumMeta,
        momentum.isAcceptableOrUnknown(data['momentum']!, _momentumMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeeklyReview map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyReview(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weekStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}week_start'],
      )!,
      urgeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urge_count'],
      )!,
      slipCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slip_count'],
      )!,
      avgSleep: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_sleep'],
      )!,
      avgStress: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_stress'],
      )!,
      streakScoreStart: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}streak_score_start'],
      )!,
      streakScoreEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}streak_score_end'],
      )!,
      confidenceStart: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence_start'],
      )!,
      confidenceEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence_end'],
      )!,
      topTriggers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}top_triggers'],
      )!,
      topInterventions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}top_interventions'],
      )!,
      riskWindowsChanged: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}risk_windows_changed'],
      )!,
      planAdjustments: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_adjustments'],
      )!,
      planText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_text'],
      ),
      momentum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}momentum'],
      )!,
    );
  }

  @override
  $WeeklyReviewsTable createAlias(String alias) {
    return $WeeklyReviewsTable(attachedDatabase, alias);
  }
}

class WeeklyReview extends DataClass implements Insertable<WeeklyReview> {
  final int id;
  final DateTime weekStart;
  final int urgeCount;
  final int slipCount;
  final double avgSleep;
  final double avgStress;
  final double streakScoreStart;
  final double streakScoreEnd;
  final double confidenceStart;
  final double confidenceEnd;
  final String topTriggers;
  final String topInterventions;
  final String riskWindowsChanged;
  final String planAdjustments;
  final String? planText;
  final String momentum;
  const WeeklyReview({
    required this.id,
    required this.weekStart,
    required this.urgeCount,
    required this.slipCount,
    required this.avgSleep,
    required this.avgStress,
    required this.streakScoreStart,
    required this.streakScoreEnd,
    required this.confidenceStart,
    required this.confidenceEnd,
    required this.topTriggers,
    required this.topInterventions,
    required this.riskWindowsChanged,
    required this.planAdjustments,
    this.planText,
    required this.momentum,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['week_start'] = Variable<DateTime>(weekStart);
    map['urge_count'] = Variable<int>(urgeCount);
    map['slip_count'] = Variable<int>(slipCount);
    map['avg_sleep'] = Variable<double>(avgSleep);
    map['avg_stress'] = Variable<double>(avgStress);
    map['streak_score_start'] = Variable<double>(streakScoreStart);
    map['streak_score_end'] = Variable<double>(streakScoreEnd);
    map['confidence_start'] = Variable<double>(confidenceStart);
    map['confidence_end'] = Variable<double>(confidenceEnd);
    map['top_triggers'] = Variable<String>(topTriggers);
    map['top_interventions'] = Variable<String>(topInterventions);
    map['risk_windows_changed'] = Variable<String>(riskWindowsChanged);
    map['plan_adjustments'] = Variable<String>(planAdjustments);
    if (!nullToAbsent || planText != null) {
      map['plan_text'] = Variable<String>(planText);
    }
    map['momentum'] = Variable<String>(momentum);
    return map;
  }

  WeeklyReviewsCompanion toCompanion(bool nullToAbsent) {
    return WeeklyReviewsCompanion(
      id: Value(id),
      weekStart: Value(weekStart),
      urgeCount: Value(urgeCount),
      slipCount: Value(slipCount),
      avgSleep: Value(avgSleep),
      avgStress: Value(avgStress),
      streakScoreStart: Value(streakScoreStart),
      streakScoreEnd: Value(streakScoreEnd),
      confidenceStart: Value(confidenceStart),
      confidenceEnd: Value(confidenceEnd),
      topTriggers: Value(topTriggers),
      topInterventions: Value(topInterventions),
      riskWindowsChanged: Value(riskWindowsChanged),
      planAdjustments: Value(planAdjustments),
      planText: planText == null && nullToAbsent
          ? const Value.absent()
          : Value(planText),
      momentum: Value(momentum),
    );
  }

  factory WeeklyReview.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyReview(
      id: serializer.fromJson<int>(json['id']),
      weekStart: serializer.fromJson<DateTime>(json['weekStart']),
      urgeCount: serializer.fromJson<int>(json['urgeCount']),
      slipCount: serializer.fromJson<int>(json['slipCount']),
      avgSleep: serializer.fromJson<double>(json['avgSleep']),
      avgStress: serializer.fromJson<double>(json['avgStress']),
      streakScoreStart: serializer.fromJson<double>(json['streakScoreStart']),
      streakScoreEnd: serializer.fromJson<double>(json['streakScoreEnd']),
      confidenceStart: serializer.fromJson<double>(json['confidenceStart']),
      confidenceEnd: serializer.fromJson<double>(json['confidenceEnd']),
      topTriggers: serializer.fromJson<String>(json['topTriggers']),
      topInterventions: serializer.fromJson<String>(json['topInterventions']),
      riskWindowsChanged: serializer.fromJson<String>(
        json['riskWindowsChanged'],
      ),
      planAdjustments: serializer.fromJson<String>(json['planAdjustments']),
      planText: serializer.fromJson<String?>(json['planText']),
      momentum: serializer.fromJson<String>(json['momentum']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weekStart': serializer.toJson<DateTime>(weekStart),
      'urgeCount': serializer.toJson<int>(urgeCount),
      'slipCount': serializer.toJson<int>(slipCount),
      'avgSleep': serializer.toJson<double>(avgSleep),
      'avgStress': serializer.toJson<double>(avgStress),
      'streakScoreStart': serializer.toJson<double>(streakScoreStart),
      'streakScoreEnd': serializer.toJson<double>(streakScoreEnd),
      'confidenceStart': serializer.toJson<double>(confidenceStart),
      'confidenceEnd': serializer.toJson<double>(confidenceEnd),
      'topTriggers': serializer.toJson<String>(topTriggers),
      'topInterventions': serializer.toJson<String>(topInterventions),
      'riskWindowsChanged': serializer.toJson<String>(riskWindowsChanged),
      'planAdjustments': serializer.toJson<String>(planAdjustments),
      'planText': serializer.toJson<String?>(planText),
      'momentum': serializer.toJson<String>(momentum),
    };
  }

  WeeklyReview copyWith({
    int? id,
    DateTime? weekStart,
    int? urgeCount,
    int? slipCount,
    double? avgSleep,
    double? avgStress,
    double? streakScoreStart,
    double? streakScoreEnd,
    double? confidenceStart,
    double? confidenceEnd,
    String? topTriggers,
    String? topInterventions,
    String? riskWindowsChanged,
    String? planAdjustments,
    Value<String?> planText = const Value.absent(),
    String? momentum,
  }) => WeeklyReview(
    id: id ?? this.id,
    weekStart: weekStart ?? this.weekStart,
    urgeCount: urgeCount ?? this.urgeCount,
    slipCount: slipCount ?? this.slipCount,
    avgSleep: avgSleep ?? this.avgSleep,
    avgStress: avgStress ?? this.avgStress,
    streakScoreStart: streakScoreStart ?? this.streakScoreStart,
    streakScoreEnd: streakScoreEnd ?? this.streakScoreEnd,
    confidenceStart: confidenceStart ?? this.confidenceStart,
    confidenceEnd: confidenceEnd ?? this.confidenceEnd,
    topTriggers: topTriggers ?? this.topTriggers,
    topInterventions: topInterventions ?? this.topInterventions,
    riskWindowsChanged: riskWindowsChanged ?? this.riskWindowsChanged,
    planAdjustments: planAdjustments ?? this.planAdjustments,
    planText: planText.present ? planText.value : this.planText,
    momentum: momentum ?? this.momentum,
  );
  WeeklyReview copyWithCompanion(WeeklyReviewsCompanion data) {
    return WeeklyReview(
      id: data.id.present ? data.id.value : this.id,
      weekStart: data.weekStart.present ? data.weekStart.value : this.weekStart,
      urgeCount: data.urgeCount.present ? data.urgeCount.value : this.urgeCount,
      slipCount: data.slipCount.present ? data.slipCount.value : this.slipCount,
      avgSleep: data.avgSleep.present ? data.avgSleep.value : this.avgSleep,
      avgStress: data.avgStress.present ? data.avgStress.value : this.avgStress,
      streakScoreStart: data.streakScoreStart.present
          ? data.streakScoreStart.value
          : this.streakScoreStart,
      streakScoreEnd: data.streakScoreEnd.present
          ? data.streakScoreEnd.value
          : this.streakScoreEnd,
      confidenceStart: data.confidenceStart.present
          ? data.confidenceStart.value
          : this.confidenceStart,
      confidenceEnd: data.confidenceEnd.present
          ? data.confidenceEnd.value
          : this.confidenceEnd,
      topTriggers: data.topTriggers.present
          ? data.topTriggers.value
          : this.topTriggers,
      topInterventions: data.topInterventions.present
          ? data.topInterventions.value
          : this.topInterventions,
      riskWindowsChanged: data.riskWindowsChanged.present
          ? data.riskWindowsChanged.value
          : this.riskWindowsChanged,
      planAdjustments: data.planAdjustments.present
          ? data.planAdjustments.value
          : this.planAdjustments,
      planText: data.planText.present ? data.planText.value : this.planText,
      momentum: data.momentum.present ? data.momentum.value : this.momentum,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyReview(')
          ..write('id: $id, ')
          ..write('weekStart: $weekStart, ')
          ..write('urgeCount: $urgeCount, ')
          ..write('slipCount: $slipCount, ')
          ..write('avgSleep: $avgSleep, ')
          ..write('avgStress: $avgStress, ')
          ..write('streakScoreStart: $streakScoreStart, ')
          ..write('streakScoreEnd: $streakScoreEnd, ')
          ..write('confidenceStart: $confidenceStart, ')
          ..write('confidenceEnd: $confidenceEnd, ')
          ..write('topTriggers: $topTriggers, ')
          ..write('topInterventions: $topInterventions, ')
          ..write('riskWindowsChanged: $riskWindowsChanged, ')
          ..write('planAdjustments: $planAdjustments, ')
          ..write('planText: $planText, ')
          ..write('momentum: $momentum')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    weekStart,
    urgeCount,
    slipCount,
    avgSleep,
    avgStress,
    streakScoreStart,
    streakScoreEnd,
    confidenceStart,
    confidenceEnd,
    topTriggers,
    topInterventions,
    riskWindowsChanged,
    planAdjustments,
    planText,
    momentum,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyReview &&
          other.id == this.id &&
          other.weekStart == this.weekStart &&
          other.urgeCount == this.urgeCount &&
          other.slipCount == this.slipCount &&
          other.avgSleep == this.avgSleep &&
          other.avgStress == this.avgStress &&
          other.streakScoreStart == this.streakScoreStart &&
          other.streakScoreEnd == this.streakScoreEnd &&
          other.confidenceStart == this.confidenceStart &&
          other.confidenceEnd == this.confidenceEnd &&
          other.topTriggers == this.topTriggers &&
          other.topInterventions == this.topInterventions &&
          other.riskWindowsChanged == this.riskWindowsChanged &&
          other.planAdjustments == this.planAdjustments &&
          other.planText == this.planText &&
          other.momentum == this.momentum);
}

class WeeklyReviewsCompanion extends UpdateCompanion<WeeklyReview> {
  final Value<int> id;
  final Value<DateTime> weekStart;
  final Value<int> urgeCount;
  final Value<int> slipCount;
  final Value<double> avgSleep;
  final Value<double> avgStress;
  final Value<double> streakScoreStart;
  final Value<double> streakScoreEnd;
  final Value<double> confidenceStart;
  final Value<double> confidenceEnd;
  final Value<String> topTriggers;
  final Value<String> topInterventions;
  final Value<String> riskWindowsChanged;
  final Value<String> planAdjustments;
  final Value<String?> planText;
  final Value<String> momentum;
  const WeeklyReviewsCompanion({
    this.id = const Value.absent(),
    this.weekStart = const Value.absent(),
    this.urgeCount = const Value.absent(),
    this.slipCount = const Value.absent(),
    this.avgSleep = const Value.absent(),
    this.avgStress = const Value.absent(),
    this.streakScoreStart = const Value.absent(),
    this.streakScoreEnd = const Value.absent(),
    this.confidenceStart = const Value.absent(),
    this.confidenceEnd = const Value.absent(),
    this.topTriggers = const Value.absent(),
    this.topInterventions = const Value.absent(),
    this.riskWindowsChanged = const Value.absent(),
    this.planAdjustments = const Value.absent(),
    this.planText = const Value.absent(),
    this.momentum = const Value.absent(),
  });
  WeeklyReviewsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime weekStart,
    this.urgeCount = const Value.absent(),
    this.slipCount = const Value.absent(),
    this.avgSleep = const Value.absent(),
    this.avgStress = const Value.absent(),
    this.streakScoreStart = const Value.absent(),
    this.streakScoreEnd = const Value.absent(),
    this.confidenceStart = const Value.absent(),
    this.confidenceEnd = const Value.absent(),
    this.topTriggers = const Value.absent(),
    this.topInterventions = const Value.absent(),
    this.riskWindowsChanged = const Value.absent(),
    this.planAdjustments = const Value.absent(),
    this.planText = const Value.absent(),
    this.momentum = const Value.absent(),
  }) : weekStart = Value(weekStart);
  static Insertable<WeeklyReview> custom({
    Expression<int>? id,
    Expression<DateTime>? weekStart,
    Expression<int>? urgeCount,
    Expression<int>? slipCount,
    Expression<double>? avgSleep,
    Expression<double>? avgStress,
    Expression<double>? streakScoreStart,
    Expression<double>? streakScoreEnd,
    Expression<double>? confidenceStart,
    Expression<double>? confidenceEnd,
    Expression<String>? topTriggers,
    Expression<String>? topInterventions,
    Expression<String>? riskWindowsChanged,
    Expression<String>? planAdjustments,
    Expression<String>? planText,
    Expression<String>? momentum,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weekStart != null) 'week_start': weekStart,
      if (urgeCount != null) 'urge_count': urgeCount,
      if (slipCount != null) 'slip_count': slipCount,
      if (avgSleep != null) 'avg_sleep': avgSleep,
      if (avgStress != null) 'avg_stress': avgStress,
      if (streakScoreStart != null) 'streak_score_start': streakScoreStart,
      if (streakScoreEnd != null) 'streak_score_end': streakScoreEnd,
      if (confidenceStart != null) 'confidence_start': confidenceStart,
      if (confidenceEnd != null) 'confidence_end': confidenceEnd,
      if (topTriggers != null) 'top_triggers': topTriggers,
      if (topInterventions != null) 'top_interventions': topInterventions,
      if (riskWindowsChanged != null)
        'risk_windows_changed': riskWindowsChanged,
      if (planAdjustments != null) 'plan_adjustments': planAdjustments,
      if (planText != null) 'plan_text': planText,
      if (momentum != null) 'momentum': momentum,
    });
  }

  WeeklyReviewsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? weekStart,
    Value<int>? urgeCount,
    Value<int>? slipCount,
    Value<double>? avgSleep,
    Value<double>? avgStress,
    Value<double>? streakScoreStart,
    Value<double>? streakScoreEnd,
    Value<double>? confidenceStart,
    Value<double>? confidenceEnd,
    Value<String>? topTriggers,
    Value<String>? topInterventions,
    Value<String>? riskWindowsChanged,
    Value<String>? planAdjustments,
    Value<String?>? planText,
    Value<String>? momentum,
  }) {
    return WeeklyReviewsCompanion(
      id: id ?? this.id,
      weekStart: weekStart ?? this.weekStart,
      urgeCount: urgeCount ?? this.urgeCount,
      slipCount: slipCount ?? this.slipCount,
      avgSleep: avgSleep ?? this.avgSleep,
      avgStress: avgStress ?? this.avgStress,
      streakScoreStart: streakScoreStart ?? this.streakScoreStart,
      streakScoreEnd: streakScoreEnd ?? this.streakScoreEnd,
      confidenceStart: confidenceStart ?? this.confidenceStart,
      confidenceEnd: confidenceEnd ?? this.confidenceEnd,
      topTriggers: topTriggers ?? this.topTriggers,
      topInterventions: topInterventions ?? this.topInterventions,
      riskWindowsChanged: riskWindowsChanged ?? this.riskWindowsChanged,
      planAdjustments: planAdjustments ?? this.planAdjustments,
      planText: planText ?? this.planText,
      momentum: momentum ?? this.momentum,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weekStart.present) {
      map['week_start'] = Variable<DateTime>(weekStart.value);
    }
    if (urgeCount.present) {
      map['urge_count'] = Variable<int>(urgeCount.value);
    }
    if (slipCount.present) {
      map['slip_count'] = Variable<int>(slipCount.value);
    }
    if (avgSleep.present) {
      map['avg_sleep'] = Variable<double>(avgSleep.value);
    }
    if (avgStress.present) {
      map['avg_stress'] = Variable<double>(avgStress.value);
    }
    if (streakScoreStart.present) {
      map['streak_score_start'] = Variable<double>(streakScoreStart.value);
    }
    if (streakScoreEnd.present) {
      map['streak_score_end'] = Variable<double>(streakScoreEnd.value);
    }
    if (confidenceStart.present) {
      map['confidence_start'] = Variable<double>(confidenceStart.value);
    }
    if (confidenceEnd.present) {
      map['confidence_end'] = Variable<double>(confidenceEnd.value);
    }
    if (topTriggers.present) {
      map['top_triggers'] = Variable<String>(topTriggers.value);
    }
    if (topInterventions.present) {
      map['top_interventions'] = Variable<String>(topInterventions.value);
    }
    if (riskWindowsChanged.present) {
      map['risk_windows_changed'] = Variable<String>(riskWindowsChanged.value);
    }
    if (planAdjustments.present) {
      map['plan_adjustments'] = Variable<String>(planAdjustments.value);
    }
    if (planText.present) {
      map['plan_text'] = Variable<String>(planText.value);
    }
    if (momentum.present) {
      map['momentum'] = Variable<String>(momentum.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyReviewsCompanion(')
          ..write('id: $id, ')
          ..write('weekStart: $weekStart, ')
          ..write('urgeCount: $urgeCount, ')
          ..write('slipCount: $slipCount, ')
          ..write('avgSleep: $avgSleep, ')
          ..write('avgStress: $avgStress, ')
          ..write('streakScoreStart: $streakScoreStart, ')
          ..write('streakScoreEnd: $streakScoreEnd, ')
          ..write('confidenceStart: $confidenceStart, ')
          ..write('confidenceEnd: $confidenceEnd, ')
          ..write('topTriggers: $topTriggers, ')
          ..write('topInterventions: $topInterventions, ')
          ..write('riskWindowsChanged: $riskWindowsChanged, ')
          ..write('planAdjustments: $planAdjustments, ')
          ..write('planText: $planText, ')
          ..write('momentum: $momentum')
          ..write(')'))
        .toString();
  }
}

class $ProgressiveProfilesTable extends ProgressiveProfiles
    with TableInfo<$ProgressiveProfilesTable, ProgressiveProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressiveProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _relationshipStatusMeta =
      const VerificationMeta('relationshipStatus');
  @override
  late final GeneratedColumn<String> relationshipStatus =
      GeneratedColumn<String>(
        'relationship_status',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _mentalHealthFlagMeta = const VerificationMeta(
    'mentalHealthFlag',
  );
  @override
  late final GeneratedColumn<String> mentalHealthFlag = GeneratedColumn<String>(
    'mental_health_flag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exerciseLevelMeta = const VerificationMeta(
    'exerciseLevel',
  );
  @override
  late final GeneratedColumn<String> exerciseLevel = GeneratedColumn<String>(
    'exercise_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _previousQuitMethodsMeta =
      const VerificationMeta('previousQuitMethods');
  @override
  late final GeneratedColumn<String> previousQuitMethods =
      GeneratedColumn<String>(
        'previous_quit_methods',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _collectedAtMeta = const VerificationMeta(
    'collectedAt',
  );
  @override
  late final GeneratedColumn<String> collectedAt = GeneratedColumn<String>(
    'collected_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    relationshipStatus,
    mentalHealthFlag,
    exerciseLevel,
    previousQuitMethods,
    collectedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progressive_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgressiveProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('relationship_status')) {
      context.handle(
        _relationshipStatusMeta,
        relationshipStatus.isAcceptableOrUnknown(
          data['relationship_status']!,
          _relationshipStatusMeta,
        ),
      );
    }
    if (data.containsKey('mental_health_flag')) {
      context.handle(
        _mentalHealthFlagMeta,
        mentalHealthFlag.isAcceptableOrUnknown(
          data['mental_health_flag']!,
          _mentalHealthFlagMeta,
        ),
      );
    }
    if (data.containsKey('exercise_level')) {
      context.handle(
        _exerciseLevelMeta,
        exerciseLevel.isAcceptableOrUnknown(
          data['exercise_level']!,
          _exerciseLevelMeta,
        ),
      );
    }
    if (data.containsKey('previous_quit_methods')) {
      context.handle(
        _previousQuitMethodsMeta,
        previousQuitMethods.isAcceptableOrUnknown(
          data['previous_quit_methods']!,
          _previousQuitMethodsMeta,
        ),
      );
    }
    if (data.containsKey('collected_at')) {
      context.handle(
        _collectedAtMeta,
        collectedAt.isAcceptableOrUnknown(
          data['collected_at']!,
          _collectedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgressiveProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressiveProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      relationshipStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relationship_status'],
      ),
      mentalHealthFlag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mental_health_flag'],
      ),
      exerciseLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_level'],
      ),
      previousQuitMethods: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_quit_methods'],
      )!,
      collectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collected_at'],
      )!,
    );
  }

  @override
  $ProgressiveProfilesTable createAlias(String alias) {
    return $ProgressiveProfilesTable(attachedDatabase, alias);
  }
}

class ProgressiveProfile extends DataClass
    implements Insertable<ProgressiveProfile> {
  final int id;
  final String? relationshipStatus;
  final String? mentalHealthFlag;
  final String? exerciseLevel;
  final String previousQuitMethods;
  final String collectedAt;
  const ProgressiveProfile({
    required this.id,
    this.relationshipStatus,
    this.mentalHealthFlag,
    this.exerciseLevel,
    required this.previousQuitMethods,
    required this.collectedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || relationshipStatus != null) {
      map['relationship_status'] = Variable<String>(relationshipStatus);
    }
    if (!nullToAbsent || mentalHealthFlag != null) {
      map['mental_health_flag'] = Variable<String>(mentalHealthFlag);
    }
    if (!nullToAbsent || exerciseLevel != null) {
      map['exercise_level'] = Variable<String>(exerciseLevel);
    }
    map['previous_quit_methods'] = Variable<String>(previousQuitMethods);
    map['collected_at'] = Variable<String>(collectedAt);
    return map;
  }

  ProgressiveProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProgressiveProfilesCompanion(
      id: Value(id),
      relationshipStatus: relationshipStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(relationshipStatus),
      mentalHealthFlag: mentalHealthFlag == null && nullToAbsent
          ? const Value.absent()
          : Value(mentalHealthFlag),
      exerciseLevel: exerciseLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseLevel),
      previousQuitMethods: Value(previousQuitMethods),
      collectedAt: Value(collectedAt),
    );
  }

  factory ProgressiveProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressiveProfile(
      id: serializer.fromJson<int>(json['id']),
      relationshipStatus: serializer.fromJson<String?>(
        json['relationshipStatus'],
      ),
      mentalHealthFlag: serializer.fromJson<String?>(json['mentalHealthFlag']),
      exerciseLevel: serializer.fromJson<String?>(json['exerciseLevel']),
      previousQuitMethods: serializer.fromJson<String>(
        json['previousQuitMethods'],
      ),
      collectedAt: serializer.fromJson<String>(json['collectedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'relationshipStatus': serializer.toJson<String?>(relationshipStatus),
      'mentalHealthFlag': serializer.toJson<String?>(mentalHealthFlag),
      'exerciseLevel': serializer.toJson<String?>(exerciseLevel),
      'previousQuitMethods': serializer.toJson<String>(previousQuitMethods),
      'collectedAt': serializer.toJson<String>(collectedAt),
    };
  }

  ProgressiveProfile copyWith({
    int? id,
    Value<String?> relationshipStatus = const Value.absent(),
    Value<String?> mentalHealthFlag = const Value.absent(),
    Value<String?> exerciseLevel = const Value.absent(),
    String? previousQuitMethods,
    String? collectedAt,
  }) => ProgressiveProfile(
    id: id ?? this.id,
    relationshipStatus: relationshipStatus.present
        ? relationshipStatus.value
        : this.relationshipStatus,
    mentalHealthFlag: mentalHealthFlag.present
        ? mentalHealthFlag.value
        : this.mentalHealthFlag,
    exerciseLevel: exerciseLevel.present
        ? exerciseLevel.value
        : this.exerciseLevel,
    previousQuitMethods: previousQuitMethods ?? this.previousQuitMethods,
    collectedAt: collectedAt ?? this.collectedAt,
  );
  ProgressiveProfile copyWithCompanion(ProgressiveProfilesCompanion data) {
    return ProgressiveProfile(
      id: data.id.present ? data.id.value : this.id,
      relationshipStatus: data.relationshipStatus.present
          ? data.relationshipStatus.value
          : this.relationshipStatus,
      mentalHealthFlag: data.mentalHealthFlag.present
          ? data.mentalHealthFlag.value
          : this.mentalHealthFlag,
      exerciseLevel: data.exerciseLevel.present
          ? data.exerciseLevel.value
          : this.exerciseLevel,
      previousQuitMethods: data.previousQuitMethods.present
          ? data.previousQuitMethods.value
          : this.previousQuitMethods,
      collectedAt: data.collectedAt.present
          ? data.collectedAt.value
          : this.collectedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressiveProfile(')
          ..write('id: $id, ')
          ..write('relationshipStatus: $relationshipStatus, ')
          ..write('mentalHealthFlag: $mentalHealthFlag, ')
          ..write('exerciseLevel: $exerciseLevel, ')
          ..write('previousQuitMethods: $previousQuitMethods, ')
          ..write('collectedAt: $collectedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    relationshipStatus,
    mentalHealthFlag,
    exerciseLevel,
    previousQuitMethods,
    collectedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressiveProfile &&
          other.id == this.id &&
          other.relationshipStatus == this.relationshipStatus &&
          other.mentalHealthFlag == this.mentalHealthFlag &&
          other.exerciseLevel == this.exerciseLevel &&
          other.previousQuitMethods == this.previousQuitMethods &&
          other.collectedAt == this.collectedAt);
}

class ProgressiveProfilesCompanion extends UpdateCompanion<ProgressiveProfile> {
  final Value<int> id;
  final Value<String?> relationshipStatus;
  final Value<String?> mentalHealthFlag;
  final Value<String?> exerciseLevel;
  final Value<String> previousQuitMethods;
  final Value<String> collectedAt;
  const ProgressiveProfilesCompanion({
    this.id = const Value.absent(),
    this.relationshipStatus = const Value.absent(),
    this.mentalHealthFlag = const Value.absent(),
    this.exerciseLevel = const Value.absent(),
    this.previousQuitMethods = const Value.absent(),
    this.collectedAt = const Value.absent(),
  });
  ProgressiveProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.relationshipStatus = const Value.absent(),
    this.mentalHealthFlag = const Value.absent(),
    this.exerciseLevel = const Value.absent(),
    this.previousQuitMethods = const Value.absent(),
    this.collectedAt = const Value.absent(),
  });
  static Insertable<ProgressiveProfile> custom({
    Expression<int>? id,
    Expression<String>? relationshipStatus,
    Expression<String>? mentalHealthFlag,
    Expression<String>? exerciseLevel,
    Expression<String>? previousQuitMethods,
    Expression<String>? collectedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (relationshipStatus != null) 'relationship_status': relationshipStatus,
      if (mentalHealthFlag != null) 'mental_health_flag': mentalHealthFlag,
      if (exerciseLevel != null) 'exercise_level': exerciseLevel,
      if (previousQuitMethods != null)
        'previous_quit_methods': previousQuitMethods,
      if (collectedAt != null) 'collected_at': collectedAt,
    });
  }

  ProgressiveProfilesCompanion copyWith({
    Value<int>? id,
    Value<String?>? relationshipStatus,
    Value<String?>? mentalHealthFlag,
    Value<String?>? exerciseLevel,
    Value<String>? previousQuitMethods,
    Value<String>? collectedAt,
  }) {
    return ProgressiveProfilesCompanion(
      id: id ?? this.id,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      mentalHealthFlag: mentalHealthFlag ?? this.mentalHealthFlag,
      exerciseLevel: exerciseLevel ?? this.exerciseLevel,
      previousQuitMethods: previousQuitMethods ?? this.previousQuitMethods,
      collectedAt: collectedAt ?? this.collectedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (relationshipStatus.present) {
      map['relationship_status'] = Variable<String>(relationshipStatus.value);
    }
    if (mentalHealthFlag.present) {
      map['mental_health_flag'] = Variable<String>(mentalHealthFlag.value);
    }
    if (exerciseLevel.present) {
      map['exercise_level'] = Variable<String>(exerciseLevel.value);
    }
    if (previousQuitMethods.present) {
      map['previous_quit_methods'] = Variable<String>(
        previousQuitMethods.value,
      );
    }
    if (collectedAt.present) {
      map['collected_at'] = Variable<String>(collectedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressiveProfilesCompanion(')
          ..write('id: $id, ')
          ..write('relationshipStatus: $relationshipStatus, ')
          ..write('mentalHealthFlag: $mentalHealthFlag, ')
          ..write('exerciseLevel: $exerciseLevel, ')
          ..write('previousQuitMethods: $previousQuitMethods, ')
          ..write('collectedAt: $collectedAt')
          ..write(')'))
        .toString();
  }
}

class $ProgramProgressesTable extends ProgramProgresses
    with TableInfo<$ProgramProgressesTable, ProgramProgressesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramProgressesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _currentWeekMeta = const VerificationMeta(
    'currentWeek',
  );
  @override
  late final GeneratedColumn<int> currentWeek = GeneratedColumn<int>(
    'current_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _currentPhaseMeta = const VerificationMeta(
    'currentPhase',
  );
  @override
  late final GeneratedColumn<String> currentPhase = GeneratedColumn<String>(
    'current_phase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('baseline'),
  );
  static const VerificationMeta _programTypeMeta = const VerificationMeta(
    'programType',
  );
  @override
  late final GeneratedColumn<String> programType = GeneratedColumn<String>(
    'program_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('initial12Week'),
  );
  static const VerificationMeta _modulesCompletedMeta = const VerificationMeta(
    'modulesCompleted',
  );
  @override
  late final GeneratedColumn<String> modulesCompleted = GeneratedColumn<String>(
    'modules_completed',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _boundariesSetMeta = const VerificationMeta(
    'boundariesSet',
  );
  @override
  late final GeneratedColumn<String> boundariesSet = GeneratedColumn<String>(
    'boundaries_set',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _adherenceRateMeta = const VerificationMeta(
    'adherenceRate',
  );
  @override
  late final GeneratedColumn<double> adherenceRate = GeneratedColumn<double>(
    'adherence_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _paceModifierMeta = const VerificationMeta(
    'paceModifier',
  );
  @override
  late final GeneratedColumn<double> paceModifier = GeneratedColumn<double>(
    'pace_modifier',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _adjustmentsLogMeta = const VerificationMeta(
    'adjustmentsLog',
  );
  @override
  late final GeneratedColumn<String> adjustmentsLog = GeneratedColumn<String>(
    'adjustments_log',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _graduatedAtMeta = const VerificationMeta(
    'graduatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> graduatedAt = GeneratedColumn<DateTime>(
    'graduated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _graduationOutcomeMeta = const VerificationMeta(
    'graduationOutcome',
  );
  @override
  late final GeneratedColumn<String> graduationOutcome =
      GeneratedColumn<String>(
        'graduation_outcome',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    currentWeek,
    currentPhase,
    programType,
    modulesCompleted,
    boundariesSet,
    adherenceRate,
    paceModifier,
    adjustmentsLog,
    graduatedAt,
    graduationOutcome,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'program_progresses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgramProgressesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current_week')) {
      context.handle(
        _currentWeekMeta,
        currentWeek.isAcceptableOrUnknown(
          data['current_week']!,
          _currentWeekMeta,
        ),
      );
    }
    if (data.containsKey('current_phase')) {
      context.handle(
        _currentPhaseMeta,
        currentPhase.isAcceptableOrUnknown(
          data['current_phase']!,
          _currentPhaseMeta,
        ),
      );
    }
    if (data.containsKey('program_type')) {
      context.handle(
        _programTypeMeta,
        programType.isAcceptableOrUnknown(
          data['program_type']!,
          _programTypeMeta,
        ),
      );
    }
    if (data.containsKey('modules_completed')) {
      context.handle(
        _modulesCompletedMeta,
        modulesCompleted.isAcceptableOrUnknown(
          data['modules_completed']!,
          _modulesCompletedMeta,
        ),
      );
    }
    if (data.containsKey('boundaries_set')) {
      context.handle(
        _boundariesSetMeta,
        boundariesSet.isAcceptableOrUnknown(
          data['boundaries_set']!,
          _boundariesSetMeta,
        ),
      );
    }
    if (data.containsKey('adherence_rate')) {
      context.handle(
        _adherenceRateMeta,
        adherenceRate.isAcceptableOrUnknown(
          data['adherence_rate']!,
          _adherenceRateMeta,
        ),
      );
    }
    if (data.containsKey('pace_modifier')) {
      context.handle(
        _paceModifierMeta,
        paceModifier.isAcceptableOrUnknown(
          data['pace_modifier']!,
          _paceModifierMeta,
        ),
      );
    }
    if (data.containsKey('adjustments_log')) {
      context.handle(
        _adjustmentsLogMeta,
        adjustmentsLog.isAcceptableOrUnknown(
          data['adjustments_log']!,
          _adjustmentsLogMeta,
        ),
      );
    }
    if (data.containsKey('graduated_at')) {
      context.handle(
        _graduatedAtMeta,
        graduatedAt.isAcceptableOrUnknown(
          data['graduated_at']!,
          _graduatedAtMeta,
        ),
      );
    }
    if (data.containsKey('graduation_outcome')) {
      context.handle(
        _graduationOutcomeMeta,
        graduationOutcome.isAcceptableOrUnknown(
          data['graduation_outcome']!,
          _graduationOutcomeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgramProgressesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgramProgressesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      currentWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_week'],
      )!,
      currentPhase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_phase'],
      )!,
      programType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_type'],
      )!,
      modulesCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modules_completed'],
      )!,
      boundariesSet: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}boundaries_set'],
      )!,
      adherenceRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}adherence_rate'],
      )!,
      paceModifier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pace_modifier'],
      )!,
      adjustmentsLog: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adjustments_log'],
      )!,
      graduatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}graduated_at'],
      ),
      graduationOutcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}graduation_outcome'],
      ),
    );
  }

  @override
  $ProgramProgressesTable createAlias(String alias) {
    return $ProgramProgressesTable(attachedDatabase, alias);
  }
}

class ProgramProgressesData extends DataClass
    implements Insertable<ProgramProgressesData> {
  final int id;
  final int currentWeek;
  final String currentPhase;
  final String programType;
  final String modulesCompleted;
  final String boundariesSet;
  final double adherenceRate;
  final double paceModifier;
  final String adjustmentsLog;
  final DateTime? graduatedAt;
  final String? graduationOutcome;
  const ProgramProgressesData({
    required this.id,
    required this.currentWeek,
    required this.currentPhase,
    required this.programType,
    required this.modulesCompleted,
    required this.boundariesSet,
    required this.adherenceRate,
    required this.paceModifier,
    required this.adjustmentsLog,
    this.graduatedAt,
    this.graduationOutcome,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['current_week'] = Variable<int>(currentWeek);
    map['current_phase'] = Variable<String>(currentPhase);
    map['program_type'] = Variable<String>(programType);
    map['modules_completed'] = Variable<String>(modulesCompleted);
    map['boundaries_set'] = Variable<String>(boundariesSet);
    map['adherence_rate'] = Variable<double>(adherenceRate);
    map['pace_modifier'] = Variable<double>(paceModifier);
    map['adjustments_log'] = Variable<String>(adjustmentsLog);
    if (!nullToAbsent || graduatedAt != null) {
      map['graduated_at'] = Variable<DateTime>(graduatedAt);
    }
    if (!nullToAbsent || graduationOutcome != null) {
      map['graduation_outcome'] = Variable<String>(graduationOutcome);
    }
    return map;
  }

  ProgramProgressesCompanion toCompanion(bool nullToAbsent) {
    return ProgramProgressesCompanion(
      id: Value(id),
      currentWeek: Value(currentWeek),
      currentPhase: Value(currentPhase),
      programType: Value(programType),
      modulesCompleted: Value(modulesCompleted),
      boundariesSet: Value(boundariesSet),
      adherenceRate: Value(adherenceRate),
      paceModifier: Value(paceModifier),
      adjustmentsLog: Value(adjustmentsLog),
      graduatedAt: graduatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(graduatedAt),
      graduationOutcome: graduationOutcome == null && nullToAbsent
          ? const Value.absent()
          : Value(graduationOutcome),
    );
  }

  factory ProgramProgressesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgramProgressesData(
      id: serializer.fromJson<int>(json['id']),
      currentWeek: serializer.fromJson<int>(json['currentWeek']),
      currentPhase: serializer.fromJson<String>(json['currentPhase']),
      programType: serializer.fromJson<String>(json['programType']),
      modulesCompleted: serializer.fromJson<String>(json['modulesCompleted']),
      boundariesSet: serializer.fromJson<String>(json['boundariesSet']),
      adherenceRate: serializer.fromJson<double>(json['adherenceRate']),
      paceModifier: serializer.fromJson<double>(json['paceModifier']),
      adjustmentsLog: serializer.fromJson<String>(json['adjustmentsLog']),
      graduatedAt: serializer.fromJson<DateTime?>(json['graduatedAt']),
      graduationOutcome: serializer.fromJson<String?>(
        json['graduationOutcome'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currentWeek': serializer.toJson<int>(currentWeek),
      'currentPhase': serializer.toJson<String>(currentPhase),
      'programType': serializer.toJson<String>(programType),
      'modulesCompleted': serializer.toJson<String>(modulesCompleted),
      'boundariesSet': serializer.toJson<String>(boundariesSet),
      'adherenceRate': serializer.toJson<double>(adherenceRate),
      'paceModifier': serializer.toJson<double>(paceModifier),
      'adjustmentsLog': serializer.toJson<String>(adjustmentsLog),
      'graduatedAt': serializer.toJson<DateTime?>(graduatedAt),
      'graduationOutcome': serializer.toJson<String?>(graduationOutcome),
    };
  }

  ProgramProgressesData copyWith({
    int? id,
    int? currentWeek,
    String? currentPhase,
    String? programType,
    String? modulesCompleted,
    String? boundariesSet,
    double? adherenceRate,
    double? paceModifier,
    String? adjustmentsLog,
    Value<DateTime?> graduatedAt = const Value.absent(),
    Value<String?> graduationOutcome = const Value.absent(),
  }) => ProgramProgressesData(
    id: id ?? this.id,
    currentWeek: currentWeek ?? this.currentWeek,
    currentPhase: currentPhase ?? this.currentPhase,
    programType: programType ?? this.programType,
    modulesCompleted: modulesCompleted ?? this.modulesCompleted,
    boundariesSet: boundariesSet ?? this.boundariesSet,
    adherenceRate: adherenceRate ?? this.adherenceRate,
    paceModifier: paceModifier ?? this.paceModifier,
    adjustmentsLog: adjustmentsLog ?? this.adjustmentsLog,
    graduatedAt: graduatedAt.present ? graduatedAt.value : this.graduatedAt,
    graduationOutcome: graduationOutcome.present
        ? graduationOutcome.value
        : this.graduationOutcome,
  );
  ProgramProgressesData copyWithCompanion(ProgramProgressesCompanion data) {
    return ProgramProgressesData(
      id: data.id.present ? data.id.value : this.id,
      currentWeek: data.currentWeek.present
          ? data.currentWeek.value
          : this.currentWeek,
      currentPhase: data.currentPhase.present
          ? data.currentPhase.value
          : this.currentPhase,
      programType: data.programType.present
          ? data.programType.value
          : this.programType,
      modulesCompleted: data.modulesCompleted.present
          ? data.modulesCompleted.value
          : this.modulesCompleted,
      boundariesSet: data.boundariesSet.present
          ? data.boundariesSet.value
          : this.boundariesSet,
      adherenceRate: data.adherenceRate.present
          ? data.adherenceRate.value
          : this.adherenceRate,
      paceModifier: data.paceModifier.present
          ? data.paceModifier.value
          : this.paceModifier,
      adjustmentsLog: data.adjustmentsLog.present
          ? data.adjustmentsLog.value
          : this.adjustmentsLog,
      graduatedAt: data.graduatedAt.present
          ? data.graduatedAt.value
          : this.graduatedAt,
      graduationOutcome: data.graduationOutcome.present
          ? data.graduationOutcome.value
          : this.graduationOutcome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgramProgressesData(')
          ..write('id: $id, ')
          ..write('currentWeek: $currentWeek, ')
          ..write('currentPhase: $currentPhase, ')
          ..write('programType: $programType, ')
          ..write('modulesCompleted: $modulesCompleted, ')
          ..write('boundariesSet: $boundariesSet, ')
          ..write('adherenceRate: $adherenceRate, ')
          ..write('paceModifier: $paceModifier, ')
          ..write('adjustmentsLog: $adjustmentsLog, ')
          ..write('graduatedAt: $graduatedAt, ')
          ..write('graduationOutcome: $graduationOutcome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    currentWeek,
    currentPhase,
    programType,
    modulesCompleted,
    boundariesSet,
    adherenceRate,
    paceModifier,
    adjustmentsLog,
    graduatedAt,
    graduationOutcome,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgramProgressesData &&
          other.id == this.id &&
          other.currentWeek == this.currentWeek &&
          other.currentPhase == this.currentPhase &&
          other.programType == this.programType &&
          other.modulesCompleted == this.modulesCompleted &&
          other.boundariesSet == this.boundariesSet &&
          other.adherenceRate == this.adherenceRate &&
          other.paceModifier == this.paceModifier &&
          other.adjustmentsLog == this.adjustmentsLog &&
          other.graduatedAt == this.graduatedAt &&
          other.graduationOutcome == this.graduationOutcome);
}

class ProgramProgressesCompanion
    extends UpdateCompanion<ProgramProgressesData> {
  final Value<int> id;
  final Value<int> currentWeek;
  final Value<String> currentPhase;
  final Value<String> programType;
  final Value<String> modulesCompleted;
  final Value<String> boundariesSet;
  final Value<double> adherenceRate;
  final Value<double> paceModifier;
  final Value<String> adjustmentsLog;
  final Value<DateTime?> graduatedAt;
  final Value<String?> graduationOutcome;
  const ProgramProgressesCompanion({
    this.id = const Value.absent(),
    this.currentWeek = const Value.absent(),
    this.currentPhase = const Value.absent(),
    this.programType = const Value.absent(),
    this.modulesCompleted = const Value.absent(),
    this.boundariesSet = const Value.absent(),
    this.adherenceRate = const Value.absent(),
    this.paceModifier = const Value.absent(),
    this.adjustmentsLog = const Value.absent(),
    this.graduatedAt = const Value.absent(),
    this.graduationOutcome = const Value.absent(),
  });
  ProgramProgressesCompanion.insert({
    this.id = const Value.absent(),
    this.currentWeek = const Value.absent(),
    this.currentPhase = const Value.absent(),
    this.programType = const Value.absent(),
    this.modulesCompleted = const Value.absent(),
    this.boundariesSet = const Value.absent(),
    this.adherenceRate = const Value.absent(),
    this.paceModifier = const Value.absent(),
    this.adjustmentsLog = const Value.absent(),
    this.graduatedAt = const Value.absent(),
    this.graduationOutcome = const Value.absent(),
  });
  static Insertable<ProgramProgressesData> custom({
    Expression<int>? id,
    Expression<int>? currentWeek,
    Expression<String>? currentPhase,
    Expression<String>? programType,
    Expression<String>? modulesCompleted,
    Expression<String>? boundariesSet,
    Expression<double>? adherenceRate,
    Expression<double>? paceModifier,
    Expression<String>? adjustmentsLog,
    Expression<DateTime>? graduatedAt,
    Expression<String>? graduationOutcome,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentWeek != null) 'current_week': currentWeek,
      if (currentPhase != null) 'current_phase': currentPhase,
      if (programType != null) 'program_type': programType,
      if (modulesCompleted != null) 'modules_completed': modulesCompleted,
      if (boundariesSet != null) 'boundaries_set': boundariesSet,
      if (adherenceRate != null) 'adherence_rate': adherenceRate,
      if (paceModifier != null) 'pace_modifier': paceModifier,
      if (adjustmentsLog != null) 'adjustments_log': adjustmentsLog,
      if (graduatedAt != null) 'graduated_at': graduatedAt,
      if (graduationOutcome != null) 'graduation_outcome': graduationOutcome,
    });
  }

  ProgramProgressesCompanion copyWith({
    Value<int>? id,
    Value<int>? currentWeek,
    Value<String>? currentPhase,
    Value<String>? programType,
    Value<String>? modulesCompleted,
    Value<String>? boundariesSet,
    Value<double>? adherenceRate,
    Value<double>? paceModifier,
    Value<String>? adjustmentsLog,
    Value<DateTime?>? graduatedAt,
    Value<String?>? graduationOutcome,
  }) {
    return ProgramProgressesCompanion(
      id: id ?? this.id,
      currentWeek: currentWeek ?? this.currentWeek,
      currentPhase: currentPhase ?? this.currentPhase,
      programType: programType ?? this.programType,
      modulesCompleted: modulesCompleted ?? this.modulesCompleted,
      boundariesSet: boundariesSet ?? this.boundariesSet,
      adherenceRate: adherenceRate ?? this.adherenceRate,
      paceModifier: paceModifier ?? this.paceModifier,
      adjustmentsLog: adjustmentsLog ?? this.adjustmentsLog,
      graduatedAt: graduatedAt ?? this.graduatedAt,
      graduationOutcome: graduationOutcome ?? this.graduationOutcome,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currentWeek.present) {
      map['current_week'] = Variable<int>(currentWeek.value);
    }
    if (currentPhase.present) {
      map['current_phase'] = Variable<String>(currentPhase.value);
    }
    if (programType.present) {
      map['program_type'] = Variable<String>(programType.value);
    }
    if (modulesCompleted.present) {
      map['modules_completed'] = Variable<String>(modulesCompleted.value);
    }
    if (boundariesSet.present) {
      map['boundaries_set'] = Variable<String>(boundariesSet.value);
    }
    if (adherenceRate.present) {
      map['adherence_rate'] = Variable<double>(adherenceRate.value);
    }
    if (paceModifier.present) {
      map['pace_modifier'] = Variable<double>(paceModifier.value);
    }
    if (adjustmentsLog.present) {
      map['adjustments_log'] = Variable<String>(adjustmentsLog.value);
    }
    if (graduatedAt.present) {
      map['graduated_at'] = Variable<DateTime>(graduatedAt.value);
    }
    if (graduationOutcome.present) {
      map['graduation_outcome'] = Variable<String>(graduationOutcome.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramProgressesCompanion(')
          ..write('id: $id, ')
          ..write('currentWeek: $currentWeek, ')
          ..write('currentPhase: $currentPhase, ')
          ..write('programType: $programType, ')
          ..write('modulesCompleted: $modulesCompleted, ')
          ..write('boundariesSet: $boundariesSet, ')
          ..write('adherenceRate: $adherenceRate, ')
          ..write('paceModifier: $paceModifier, ')
          ..write('adjustmentsLog: $adjustmentsLog, ')
          ..write('graduatedAt: $graduatedAt, ')
          ..write('graduationOutcome: $graduationOutcome')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceStatesTable extends MaintenanceStates
    with TableInfo<$MaintenanceStatesTable, MaintenanceState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('fullMaintenance'),
  );
  static const VerificationMeta _checkinCadenceMeta = const VerificationMeta(
    'checkinCadence',
  );
  @override
  late final GeneratedColumn<String> checkinCadence = GeneratedColumn<String>(
    'checkin_cadence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('daily'),
  );
  static const VerificationMeta _notificationLevelMeta = const VerificationMeta(
    'notificationLevel',
  );
  @override
  late final GeneratedColumn<String> notificationLevel =
      GeneratedColumn<String>(
        'notification_level',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('moderate'),
      );
  static const VerificationMeta _regressionFlagsMeta = const VerificationMeta(
    'regressionFlags',
  );
  @override
  late final GeneratedColumn<String> regressionFlags = GeneratedColumn<String>(
    'regression_flags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _lastQuarterlyReviewMeta =
      const VerificationMeta('lastQuarterlyReview');
  @override
  late final GeneratedColumn<DateTime> lastQuarterlyReview =
      GeneratedColumn<DateTime>(
        'last_quarterly_review',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lifetimeCleanDaysMeta = const VerificationMeta(
    'lifetimeCleanDays',
  );
  @override
  late final GeneratedColumn<int> lifetimeCleanDays = GeneratedColumn<int>(
    'lifetime_clean_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lifetimeUrgesResistedMeta =
      const VerificationMeta('lifetimeUrgesResisted');
  @override
  late final GeneratedColumn<int> lifetimeUrgesResisted = GeneratedColumn<int>(
    'lifetime_urges_resisted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lifetimeRescuesCompletedMeta =
      const VerificationMeta('lifetimeRescuesCompleted');
  @override
  late final GeneratedColumn<int> lifetimeRescuesCompleted =
      GeneratedColumn<int>(
        'lifetime_rescues_completed',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _recoveryScoreMeta = const VerificationMeta(
    'recoveryScore',
  );
  @override
  late final GeneratedColumn<double> recoveryScore = GeneratedColumn<double>(
    'recovery_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mode,
    checkinCadence,
    notificationLevel,
    regressionFlags,
    lastQuarterlyReview,
    lifetimeCleanDays,
    lifetimeUrgesResisted,
    lifetimeRescuesCompleted,
    recoveryScore,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaintenanceState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('checkin_cadence')) {
      context.handle(
        _checkinCadenceMeta,
        checkinCadence.isAcceptableOrUnknown(
          data['checkin_cadence']!,
          _checkinCadenceMeta,
        ),
      );
    }
    if (data.containsKey('notification_level')) {
      context.handle(
        _notificationLevelMeta,
        notificationLevel.isAcceptableOrUnknown(
          data['notification_level']!,
          _notificationLevelMeta,
        ),
      );
    }
    if (data.containsKey('regression_flags')) {
      context.handle(
        _regressionFlagsMeta,
        regressionFlags.isAcceptableOrUnknown(
          data['regression_flags']!,
          _regressionFlagsMeta,
        ),
      );
    }
    if (data.containsKey('last_quarterly_review')) {
      context.handle(
        _lastQuarterlyReviewMeta,
        lastQuarterlyReview.isAcceptableOrUnknown(
          data['last_quarterly_review']!,
          _lastQuarterlyReviewMeta,
        ),
      );
    }
    if (data.containsKey('lifetime_clean_days')) {
      context.handle(
        _lifetimeCleanDaysMeta,
        lifetimeCleanDays.isAcceptableOrUnknown(
          data['lifetime_clean_days']!,
          _lifetimeCleanDaysMeta,
        ),
      );
    }
    if (data.containsKey('lifetime_urges_resisted')) {
      context.handle(
        _lifetimeUrgesResistedMeta,
        lifetimeUrgesResisted.isAcceptableOrUnknown(
          data['lifetime_urges_resisted']!,
          _lifetimeUrgesResistedMeta,
        ),
      );
    }
    if (data.containsKey('lifetime_rescues_completed')) {
      context.handle(
        _lifetimeRescuesCompletedMeta,
        lifetimeRescuesCompleted.isAcceptableOrUnknown(
          data['lifetime_rescues_completed']!,
          _lifetimeRescuesCompletedMeta,
        ),
      );
    }
    if (data.containsKey('recovery_score')) {
      context.handle(
        _recoveryScoreMeta,
        recoveryScore.isAcceptableOrUnknown(
          data['recovery_score']!,
          _recoveryScoreMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      checkinCadence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checkin_cadence'],
      )!,
      notificationLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notification_level'],
      )!,
      regressionFlags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}regression_flags'],
      )!,
      lastQuarterlyReview: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_quarterly_review'],
      ),
      lifetimeCleanDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lifetime_clean_days'],
      )!,
      lifetimeUrgesResisted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lifetime_urges_resisted'],
      )!,
      lifetimeRescuesCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lifetime_rescues_completed'],
      )!,
      recoveryScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}recovery_score'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MaintenanceStatesTable createAlias(String alias) {
    return $MaintenanceStatesTable(attachedDatabase, alias);
  }
}

class MaintenanceState extends DataClass
    implements Insertable<MaintenanceState> {
  final int id;
  final String mode;
  final String checkinCadence;
  final String notificationLevel;
  final String regressionFlags;
  final DateTime? lastQuarterlyReview;
  final int lifetimeCleanDays;
  final int lifetimeUrgesResisted;
  final int lifetimeRescuesCompleted;
  final double recoveryScore;
  final DateTime updatedAt;
  const MaintenanceState({
    required this.id,
    required this.mode,
    required this.checkinCadence,
    required this.notificationLevel,
    required this.regressionFlags,
    this.lastQuarterlyReview,
    required this.lifetimeCleanDays,
    required this.lifetimeUrgesResisted,
    required this.lifetimeRescuesCompleted,
    required this.recoveryScore,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mode'] = Variable<String>(mode);
    map['checkin_cadence'] = Variable<String>(checkinCadence);
    map['notification_level'] = Variable<String>(notificationLevel);
    map['regression_flags'] = Variable<String>(regressionFlags);
    if (!nullToAbsent || lastQuarterlyReview != null) {
      map['last_quarterly_review'] = Variable<DateTime>(lastQuarterlyReview);
    }
    map['lifetime_clean_days'] = Variable<int>(lifetimeCleanDays);
    map['lifetime_urges_resisted'] = Variable<int>(lifetimeUrgesResisted);
    map['lifetime_rescues_completed'] = Variable<int>(lifetimeRescuesCompleted);
    map['recovery_score'] = Variable<double>(recoveryScore);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MaintenanceStatesCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceStatesCompanion(
      id: Value(id),
      mode: Value(mode),
      checkinCadence: Value(checkinCadence),
      notificationLevel: Value(notificationLevel),
      regressionFlags: Value(regressionFlags),
      lastQuarterlyReview: lastQuarterlyReview == null && nullToAbsent
          ? const Value.absent()
          : Value(lastQuarterlyReview),
      lifetimeCleanDays: Value(lifetimeCleanDays),
      lifetimeUrgesResisted: Value(lifetimeUrgesResisted),
      lifetimeRescuesCompleted: Value(lifetimeRescuesCompleted),
      recoveryScore: Value(recoveryScore),
      updatedAt: Value(updatedAt),
    );
  }

  factory MaintenanceState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceState(
      id: serializer.fromJson<int>(json['id']),
      mode: serializer.fromJson<String>(json['mode']),
      checkinCadence: serializer.fromJson<String>(json['checkinCadence']),
      notificationLevel: serializer.fromJson<String>(json['notificationLevel']),
      regressionFlags: serializer.fromJson<String>(json['regressionFlags']),
      lastQuarterlyReview: serializer.fromJson<DateTime?>(
        json['lastQuarterlyReview'],
      ),
      lifetimeCleanDays: serializer.fromJson<int>(json['lifetimeCleanDays']),
      lifetimeUrgesResisted: serializer.fromJson<int>(
        json['lifetimeUrgesResisted'],
      ),
      lifetimeRescuesCompleted: serializer.fromJson<int>(
        json['lifetimeRescuesCompleted'],
      ),
      recoveryScore: serializer.fromJson<double>(json['recoveryScore']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mode': serializer.toJson<String>(mode),
      'checkinCadence': serializer.toJson<String>(checkinCadence),
      'notificationLevel': serializer.toJson<String>(notificationLevel),
      'regressionFlags': serializer.toJson<String>(regressionFlags),
      'lastQuarterlyReview': serializer.toJson<DateTime?>(lastQuarterlyReview),
      'lifetimeCleanDays': serializer.toJson<int>(lifetimeCleanDays),
      'lifetimeUrgesResisted': serializer.toJson<int>(lifetimeUrgesResisted),
      'lifetimeRescuesCompleted': serializer.toJson<int>(
        lifetimeRescuesCompleted,
      ),
      'recoveryScore': serializer.toJson<double>(recoveryScore),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MaintenanceState copyWith({
    int? id,
    String? mode,
    String? checkinCadence,
    String? notificationLevel,
    String? regressionFlags,
    Value<DateTime?> lastQuarterlyReview = const Value.absent(),
    int? lifetimeCleanDays,
    int? lifetimeUrgesResisted,
    int? lifetimeRescuesCompleted,
    double? recoveryScore,
    DateTime? updatedAt,
  }) => MaintenanceState(
    id: id ?? this.id,
    mode: mode ?? this.mode,
    checkinCadence: checkinCadence ?? this.checkinCadence,
    notificationLevel: notificationLevel ?? this.notificationLevel,
    regressionFlags: regressionFlags ?? this.regressionFlags,
    lastQuarterlyReview: lastQuarterlyReview.present
        ? lastQuarterlyReview.value
        : this.lastQuarterlyReview,
    lifetimeCleanDays: lifetimeCleanDays ?? this.lifetimeCleanDays,
    lifetimeUrgesResisted: lifetimeUrgesResisted ?? this.lifetimeUrgesResisted,
    lifetimeRescuesCompleted:
        lifetimeRescuesCompleted ?? this.lifetimeRescuesCompleted,
    recoveryScore: recoveryScore ?? this.recoveryScore,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MaintenanceState copyWithCompanion(MaintenanceStatesCompanion data) {
    return MaintenanceState(
      id: data.id.present ? data.id.value : this.id,
      mode: data.mode.present ? data.mode.value : this.mode,
      checkinCadence: data.checkinCadence.present
          ? data.checkinCadence.value
          : this.checkinCadence,
      notificationLevel: data.notificationLevel.present
          ? data.notificationLevel.value
          : this.notificationLevel,
      regressionFlags: data.regressionFlags.present
          ? data.regressionFlags.value
          : this.regressionFlags,
      lastQuarterlyReview: data.lastQuarterlyReview.present
          ? data.lastQuarterlyReview.value
          : this.lastQuarterlyReview,
      lifetimeCleanDays: data.lifetimeCleanDays.present
          ? data.lifetimeCleanDays.value
          : this.lifetimeCleanDays,
      lifetimeUrgesResisted: data.lifetimeUrgesResisted.present
          ? data.lifetimeUrgesResisted.value
          : this.lifetimeUrgesResisted,
      lifetimeRescuesCompleted: data.lifetimeRescuesCompleted.present
          ? data.lifetimeRescuesCompleted.value
          : this.lifetimeRescuesCompleted,
      recoveryScore: data.recoveryScore.present
          ? data.recoveryScore.value
          : this.recoveryScore,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceState(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('checkinCadence: $checkinCadence, ')
          ..write('notificationLevel: $notificationLevel, ')
          ..write('regressionFlags: $regressionFlags, ')
          ..write('lastQuarterlyReview: $lastQuarterlyReview, ')
          ..write('lifetimeCleanDays: $lifetimeCleanDays, ')
          ..write('lifetimeUrgesResisted: $lifetimeUrgesResisted, ')
          ..write('lifetimeRescuesCompleted: $lifetimeRescuesCompleted, ')
          ..write('recoveryScore: $recoveryScore, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mode,
    checkinCadence,
    notificationLevel,
    regressionFlags,
    lastQuarterlyReview,
    lifetimeCleanDays,
    lifetimeUrgesResisted,
    lifetimeRescuesCompleted,
    recoveryScore,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceState &&
          other.id == this.id &&
          other.mode == this.mode &&
          other.checkinCadence == this.checkinCadence &&
          other.notificationLevel == this.notificationLevel &&
          other.regressionFlags == this.regressionFlags &&
          other.lastQuarterlyReview == this.lastQuarterlyReview &&
          other.lifetimeCleanDays == this.lifetimeCleanDays &&
          other.lifetimeUrgesResisted == this.lifetimeUrgesResisted &&
          other.lifetimeRescuesCompleted == this.lifetimeRescuesCompleted &&
          other.recoveryScore == this.recoveryScore &&
          other.updatedAt == this.updatedAt);
}

class MaintenanceStatesCompanion extends UpdateCompanion<MaintenanceState> {
  final Value<int> id;
  final Value<String> mode;
  final Value<String> checkinCadence;
  final Value<String> notificationLevel;
  final Value<String> regressionFlags;
  final Value<DateTime?> lastQuarterlyReview;
  final Value<int> lifetimeCleanDays;
  final Value<int> lifetimeUrgesResisted;
  final Value<int> lifetimeRescuesCompleted;
  final Value<double> recoveryScore;
  final Value<DateTime> updatedAt;
  const MaintenanceStatesCompanion({
    this.id = const Value.absent(),
    this.mode = const Value.absent(),
    this.checkinCadence = const Value.absent(),
    this.notificationLevel = const Value.absent(),
    this.regressionFlags = const Value.absent(),
    this.lastQuarterlyReview = const Value.absent(),
    this.lifetimeCleanDays = const Value.absent(),
    this.lifetimeUrgesResisted = const Value.absent(),
    this.lifetimeRescuesCompleted = const Value.absent(),
    this.recoveryScore = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MaintenanceStatesCompanion.insert({
    this.id = const Value.absent(),
    this.mode = const Value.absent(),
    this.checkinCadence = const Value.absent(),
    this.notificationLevel = const Value.absent(),
    this.regressionFlags = const Value.absent(),
    this.lastQuarterlyReview = const Value.absent(),
    this.lifetimeCleanDays = const Value.absent(),
    this.lifetimeUrgesResisted = const Value.absent(),
    this.lifetimeRescuesCompleted = const Value.absent(),
    this.recoveryScore = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<MaintenanceState> custom({
    Expression<int>? id,
    Expression<String>? mode,
    Expression<String>? checkinCadence,
    Expression<String>? notificationLevel,
    Expression<String>? regressionFlags,
    Expression<DateTime>? lastQuarterlyReview,
    Expression<int>? lifetimeCleanDays,
    Expression<int>? lifetimeUrgesResisted,
    Expression<int>? lifetimeRescuesCompleted,
    Expression<double>? recoveryScore,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mode != null) 'mode': mode,
      if (checkinCadence != null) 'checkin_cadence': checkinCadence,
      if (notificationLevel != null) 'notification_level': notificationLevel,
      if (regressionFlags != null) 'regression_flags': regressionFlags,
      if (lastQuarterlyReview != null)
        'last_quarterly_review': lastQuarterlyReview,
      if (lifetimeCleanDays != null) 'lifetime_clean_days': lifetimeCleanDays,
      if (lifetimeUrgesResisted != null)
        'lifetime_urges_resisted': lifetimeUrgesResisted,
      if (lifetimeRescuesCompleted != null)
        'lifetime_rescues_completed': lifetimeRescuesCompleted,
      if (recoveryScore != null) 'recovery_score': recoveryScore,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MaintenanceStatesCompanion copyWith({
    Value<int>? id,
    Value<String>? mode,
    Value<String>? checkinCadence,
    Value<String>? notificationLevel,
    Value<String>? regressionFlags,
    Value<DateTime?>? lastQuarterlyReview,
    Value<int>? lifetimeCleanDays,
    Value<int>? lifetimeUrgesResisted,
    Value<int>? lifetimeRescuesCompleted,
    Value<double>? recoveryScore,
    Value<DateTime>? updatedAt,
  }) {
    return MaintenanceStatesCompanion(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      checkinCadence: checkinCadence ?? this.checkinCadence,
      notificationLevel: notificationLevel ?? this.notificationLevel,
      regressionFlags: regressionFlags ?? this.regressionFlags,
      lastQuarterlyReview: lastQuarterlyReview ?? this.lastQuarterlyReview,
      lifetimeCleanDays: lifetimeCleanDays ?? this.lifetimeCleanDays,
      lifetimeUrgesResisted:
          lifetimeUrgesResisted ?? this.lifetimeUrgesResisted,
      lifetimeRescuesCompleted:
          lifetimeRescuesCompleted ?? this.lifetimeRescuesCompleted,
      recoveryScore: recoveryScore ?? this.recoveryScore,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (checkinCadence.present) {
      map['checkin_cadence'] = Variable<String>(checkinCadence.value);
    }
    if (notificationLevel.present) {
      map['notification_level'] = Variable<String>(notificationLevel.value);
    }
    if (regressionFlags.present) {
      map['regression_flags'] = Variable<String>(regressionFlags.value);
    }
    if (lastQuarterlyReview.present) {
      map['last_quarterly_review'] = Variable<DateTime>(
        lastQuarterlyReview.value,
      );
    }
    if (lifetimeCleanDays.present) {
      map['lifetime_clean_days'] = Variable<int>(lifetimeCleanDays.value);
    }
    if (lifetimeUrgesResisted.present) {
      map['lifetime_urges_resisted'] = Variable<int>(
        lifetimeUrgesResisted.value,
      );
    }
    if (lifetimeRescuesCompleted.present) {
      map['lifetime_rescues_completed'] = Variable<int>(
        lifetimeRescuesCompleted.value,
      );
    }
    if (recoveryScore.present) {
      map['recovery_score'] = Variable<double>(recoveryScore.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceStatesCompanion(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('checkinCadence: $checkinCadence, ')
          ..write('notificationLevel: $notificationLevel, ')
          ..write('regressionFlags: $regressionFlags, ')
          ..write('lastQuarterlyReview: $lastQuarterlyReview, ')
          ..write('lifetimeCleanDays: $lifetimeCleanDays, ')
          ..write('lifetimeUrgesResisted: $lifetimeUrgesResisted, ')
          ..write('lifetimeRescuesCompleted: $lifetimeRescuesCompleted, ')
          ..write('recoveryScore: $recoveryScore, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ModelStatesTable extends ModelStates
    with TableInfo<$ModelStatesTable, ModelState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModelStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'model_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<ModelState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModelState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModelState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ModelStatesTable createAlias(String alias) {
    return $ModelStatesTable(attachedDatabase, alias);
  }
}

class ModelState extends DataClass implements Insertable<ModelState> {
  final int id;
  final String key;
  final String value;
  final DateTime updatedAt;
  const ModelState({
    required this.id,
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ModelStatesCompanion toCompanion(bool nullToAbsent) {
    return ModelStatesCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory ModelState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModelState(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ModelState copyWith({
    int? id,
    String? key,
    String? value,
    DateTime? updatedAt,
  }) => ModelState(
    id: id ?? this.id,
    key: key ?? this.key,
    value: value ?? this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ModelState copyWithCompanion(ModelStatesCompanion data) {
    return ModelState(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModelState(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModelState &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class ModelStatesCompanion extends UpdateCompanion<ModelState> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  const ModelStatesCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ModelStatesCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<ModelState> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ModelStatesCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
  }) {
    return ModelStatesCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModelStatesCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PassiveUsagesTable extends PassiveUsages
    with TableInfo<$PassiveUsagesTable, PassiveUsage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PassiveUsagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAppMinutesMeta = const VerificationMeta(
    'targetAppMinutes',
  );
  @override
  late final GeneratedColumn<int> targetAppMinutes = GeneratedColumn<int>(
    'target_app_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lateNightMinutesMeta = const VerificationMeta(
    'lateNightMinutes',
  );
  @override
  late final GeneratedColumn<int> lateNightMinutes = GeneratedColumn<int>(
    'late_night_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _firstPickupDelayMinutesMeta =
      const VerificationMeta('firstPickupDelayMinutes');
  @override
  late final GeneratedColumn<int> firstPickupDelayMinutes =
      GeneratedColumn<int>(
        'first_pickup_delay_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _sessionCountMeta = const VerificationMeta(
    'sessionCount',
  );
  @override
  late final GeneratedColumn<int> sessionCount = GeneratedColumn<int>(
    'session_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reopenRateMeta = const VerificationMeta(
    'reopenRate',
  );
  @override
  late final GeneratedColumn<double> reopenRate = GeneratedColumn<double>(
    'reopen_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    targetAppMinutes,
    lateNightMinutes,
    firstPickupDelayMinutes,
    sessionCount,
    reopenRate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'passive_usages';
  @override
  VerificationContext validateIntegrity(
    Insertable<PassiveUsage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('target_app_minutes')) {
      context.handle(
        _targetAppMinutesMeta,
        targetAppMinutes.isAcceptableOrUnknown(
          data['target_app_minutes']!,
          _targetAppMinutesMeta,
        ),
      );
    }
    if (data.containsKey('late_night_minutes')) {
      context.handle(
        _lateNightMinutesMeta,
        lateNightMinutes.isAcceptableOrUnknown(
          data['late_night_minutes']!,
          _lateNightMinutesMeta,
        ),
      );
    }
    if (data.containsKey('first_pickup_delay_minutes')) {
      context.handle(
        _firstPickupDelayMinutesMeta,
        firstPickupDelayMinutes.isAcceptableOrUnknown(
          data['first_pickup_delay_minutes']!,
          _firstPickupDelayMinutesMeta,
        ),
      );
    }
    if (data.containsKey('session_count')) {
      context.handle(
        _sessionCountMeta,
        sessionCount.isAcceptableOrUnknown(
          data['session_count']!,
          _sessionCountMeta,
        ),
      );
    }
    if (data.containsKey('reopen_rate')) {
      context.handle(
        _reopenRateMeta,
        reopenRate.isAcceptableOrUnknown(data['reopen_rate']!, _reopenRateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PassiveUsage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PassiveUsage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      targetAppMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_app_minutes'],
      )!,
      lateNightMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}late_night_minutes'],
      )!,
      firstPickupDelayMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_pickup_delay_minutes'],
      )!,
      sessionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_count'],
      )!,
      reopenRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reopen_rate'],
      )!,
    );
  }

  @override
  $PassiveUsagesTable createAlias(String alias) {
    return $PassiveUsagesTable(attachedDatabase, alias);
  }
}

class PassiveUsage extends DataClass implements Insertable<PassiveUsage> {
  final int id;
  final DateTime date;
  final int targetAppMinutes;
  final int lateNightMinutes;
  final int firstPickupDelayMinutes;
  final int sessionCount;
  final double reopenRate;
  const PassiveUsage({
    required this.id,
    required this.date,
    required this.targetAppMinutes,
    required this.lateNightMinutes,
    required this.firstPickupDelayMinutes,
    required this.sessionCount,
    required this.reopenRate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['target_app_minutes'] = Variable<int>(targetAppMinutes);
    map['late_night_minutes'] = Variable<int>(lateNightMinutes);
    map['first_pickup_delay_minutes'] = Variable<int>(firstPickupDelayMinutes);
    map['session_count'] = Variable<int>(sessionCount);
    map['reopen_rate'] = Variable<double>(reopenRate);
    return map;
  }

  PassiveUsagesCompanion toCompanion(bool nullToAbsent) {
    return PassiveUsagesCompanion(
      id: Value(id),
      date: Value(date),
      targetAppMinutes: Value(targetAppMinutes),
      lateNightMinutes: Value(lateNightMinutes),
      firstPickupDelayMinutes: Value(firstPickupDelayMinutes),
      sessionCount: Value(sessionCount),
      reopenRate: Value(reopenRate),
    );
  }

  factory PassiveUsage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PassiveUsage(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      targetAppMinutes: serializer.fromJson<int>(json['targetAppMinutes']),
      lateNightMinutes: serializer.fromJson<int>(json['lateNightMinutes']),
      firstPickupDelayMinutes: serializer.fromJson<int>(
        json['firstPickupDelayMinutes'],
      ),
      sessionCount: serializer.fromJson<int>(json['sessionCount']),
      reopenRate: serializer.fromJson<double>(json['reopenRate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'targetAppMinutes': serializer.toJson<int>(targetAppMinutes),
      'lateNightMinutes': serializer.toJson<int>(lateNightMinutes),
      'firstPickupDelayMinutes': serializer.toJson<int>(
        firstPickupDelayMinutes,
      ),
      'sessionCount': serializer.toJson<int>(sessionCount),
      'reopenRate': serializer.toJson<double>(reopenRate),
    };
  }

  PassiveUsage copyWith({
    int? id,
    DateTime? date,
    int? targetAppMinutes,
    int? lateNightMinutes,
    int? firstPickupDelayMinutes,
    int? sessionCount,
    double? reopenRate,
  }) => PassiveUsage(
    id: id ?? this.id,
    date: date ?? this.date,
    targetAppMinutes: targetAppMinutes ?? this.targetAppMinutes,
    lateNightMinutes: lateNightMinutes ?? this.lateNightMinutes,
    firstPickupDelayMinutes:
        firstPickupDelayMinutes ?? this.firstPickupDelayMinutes,
    sessionCount: sessionCount ?? this.sessionCount,
    reopenRate: reopenRate ?? this.reopenRate,
  );
  PassiveUsage copyWithCompanion(PassiveUsagesCompanion data) {
    return PassiveUsage(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      targetAppMinutes: data.targetAppMinutes.present
          ? data.targetAppMinutes.value
          : this.targetAppMinutes,
      lateNightMinutes: data.lateNightMinutes.present
          ? data.lateNightMinutes.value
          : this.lateNightMinutes,
      firstPickupDelayMinutes: data.firstPickupDelayMinutes.present
          ? data.firstPickupDelayMinutes.value
          : this.firstPickupDelayMinutes,
      sessionCount: data.sessionCount.present
          ? data.sessionCount.value
          : this.sessionCount,
      reopenRate: data.reopenRate.present
          ? data.reopenRate.value
          : this.reopenRate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PassiveUsage(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('targetAppMinutes: $targetAppMinutes, ')
          ..write('lateNightMinutes: $lateNightMinutes, ')
          ..write('firstPickupDelayMinutes: $firstPickupDelayMinutes, ')
          ..write('sessionCount: $sessionCount, ')
          ..write('reopenRate: $reopenRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    targetAppMinutes,
    lateNightMinutes,
    firstPickupDelayMinutes,
    sessionCount,
    reopenRate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PassiveUsage &&
          other.id == this.id &&
          other.date == this.date &&
          other.targetAppMinutes == this.targetAppMinutes &&
          other.lateNightMinutes == this.lateNightMinutes &&
          other.firstPickupDelayMinutes == this.firstPickupDelayMinutes &&
          other.sessionCount == this.sessionCount &&
          other.reopenRate == this.reopenRate);
}

class PassiveUsagesCompanion extends UpdateCompanion<PassiveUsage> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> targetAppMinutes;
  final Value<int> lateNightMinutes;
  final Value<int> firstPickupDelayMinutes;
  final Value<int> sessionCount;
  final Value<double> reopenRate;
  const PassiveUsagesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.targetAppMinutes = const Value.absent(),
    this.lateNightMinutes = const Value.absent(),
    this.firstPickupDelayMinutes = const Value.absent(),
    this.sessionCount = const Value.absent(),
    this.reopenRate = const Value.absent(),
  });
  PassiveUsagesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.targetAppMinutes = const Value.absent(),
    this.lateNightMinutes = const Value.absent(),
    this.firstPickupDelayMinutes = const Value.absent(),
    this.sessionCount = const Value.absent(),
    this.reopenRate = const Value.absent(),
  }) : date = Value(date);
  static Insertable<PassiveUsage> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? targetAppMinutes,
    Expression<int>? lateNightMinutes,
    Expression<int>? firstPickupDelayMinutes,
    Expression<int>? sessionCount,
    Expression<double>? reopenRate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (targetAppMinutes != null) 'target_app_minutes': targetAppMinutes,
      if (lateNightMinutes != null) 'late_night_minutes': lateNightMinutes,
      if (firstPickupDelayMinutes != null)
        'first_pickup_delay_minutes': firstPickupDelayMinutes,
      if (sessionCount != null) 'session_count': sessionCount,
      if (reopenRate != null) 'reopen_rate': reopenRate,
    });
  }

  PassiveUsagesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? targetAppMinutes,
    Value<int>? lateNightMinutes,
    Value<int>? firstPickupDelayMinutes,
    Value<int>? sessionCount,
    Value<double>? reopenRate,
  }) {
    return PassiveUsagesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      targetAppMinutes: targetAppMinutes ?? this.targetAppMinutes,
      lateNightMinutes: lateNightMinutes ?? this.lateNightMinutes,
      firstPickupDelayMinutes:
          firstPickupDelayMinutes ?? this.firstPickupDelayMinutes,
      sessionCount: sessionCount ?? this.sessionCount,
      reopenRate: reopenRate ?? this.reopenRate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (targetAppMinutes.present) {
      map['target_app_minutes'] = Variable<int>(targetAppMinutes.value);
    }
    if (lateNightMinutes.present) {
      map['late_night_minutes'] = Variable<int>(lateNightMinutes.value);
    }
    if (firstPickupDelayMinutes.present) {
      map['first_pickup_delay_minutes'] = Variable<int>(
        firstPickupDelayMinutes.value,
      );
    }
    if (sessionCount.present) {
      map['session_count'] = Variable<int>(sessionCount.value);
    }
    if (reopenRate.present) {
      map['reopen_rate'] = Variable<double>(reopenRate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PassiveUsagesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('targetAppMinutes: $targetAppMinutes, ')
          ..write('lateNightMinutes: $lateNightMinutes, ')
          ..write('firstPickupDelayMinutes: $firstPickupDelayMinutes, ')
          ..write('sessionCount: $sessionCount, ')
          ..write('reopenRate: $reopenRate')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $PeakNodesTable peakNodes = $PeakNodesTable(this);
  late final $RiskWindowsTable riskWindows = $RiskWindowsTable(this);
  late final $DailyCheckinsTable dailyCheckins = $DailyCheckinsTable(this);
  late final $UrgeEventsTable urgeEvents = $UrgeEventsTable(this);
  late final $SlipEventsTable slipEvents = $SlipEventsTable(this);
  late final $InterventionLogsTable interventionLogs = $InterventionLogsTable(
    this,
  );
  late final $TriggerPosteriorsTable triggerPosteriors =
      $TriggerPosteriorsTable(this);
  late final $StreaksTable streaks = $StreaksTable(this);
  late final $StreakHistoriesTable streakHistories = $StreakHistoriesTable(
    this,
  );
  late final $DailyScoresTable dailyScores = $DailyScoresTable(this);
  late final $AchievementsTable achievements = $AchievementsTable(this);
  late final $DiversionTasksTable diversionTasks = $DiversionTasksTable(this);
  late final $WeeklyReviewsTable weeklyReviews = $WeeklyReviewsTable(this);
  late final $ProgressiveProfilesTable progressiveProfiles =
      $ProgressiveProfilesTable(this);
  late final $ProgramProgressesTable programProgresses =
      $ProgramProgressesTable(this);
  late final $MaintenanceStatesTable maintenanceStates =
      $MaintenanceStatesTable(this);
  late final $ModelStatesTable modelStates = $ModelStatesTable(this);
  late final $PassiveUsagesTable passiveUsages = $PassiveUsagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    peakNodes,
    riskWindows,
    dailyCheckins,
    urgeEvents,
    slipEvents,
    interventionLogs,
    triggerPosteriors,
    streaks,
    streakHistories,
    dailyScores,
    achievements,
    diversionTasks,
    weeklyReviews,
    progressiveProfiles,
    programProgresses,
    maintenanceStates,
    modelStates,
    passiveUsages,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> email,
      Value<String> phone,
      Value<String> country,
      Value<bool> checkedInToday,
      required String roleType,
      Value<String> workDays,
      Value<String?> workStart,
      Value<String?> workEnd,
      required String weekdayWakeTime,
      required String weekdaySleepTime,
      required String offdayWakeTime,
      required String offdaySleepTime,
      Value<String> struggles,
      Value<String> scrollingTriggersSexual,
      Value<String> triggers,
      required String struggleDuration,
      required String resistAbility,
      required String goalType,
      Value<String> motivations,
      Value<bool> weekendDifferent,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> email,
      Value<String> phone,
      Value<String> country,
      Value<bool> checkedInToday,
      Value<String> roleType,
      Value<String> workDays,
      Value<String?> workStart,
      Value<String?> workEnd,
      Value<String> weekdayWakeTime,
      Value<String> weekdaySleepTime,
      Value<String> offdayWakeTime,
      Value<String> offdaySleepTime,
      Value<String> struggles,
      Value<String> scrollingTriggersSexual,
      Value<String> triggers,
      Value<String> struggleDuration,
      Value<String> resistAbility,
      Value<String> goalType,
      Value<String> motivations,
      Value<bool> weekendDifferent,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get checkedInToday => $composableBuilder(
    column: $table.checkedInToday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roleType => $composableBuilder(
    column: $table.roleType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workDays => $composableBuilder(
    column: $table.workDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workStart => $composableBuilder(
    column: $table.workStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workEnd => $composableBuilder(
    column: $table.workEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekdayWakeTime => $composableBuilder(
    column: $table.weekdayWakeTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekdaySleepTime => $composableBuilder(
    column: $table.weekdaySleepTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get offdayWakeTime => $composableBuilder(
    column: $table.offdayWakeTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get offdaySleepTime => $composableBuilder(
    column: $table.offdaySleepTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get struggles => $composableBuilder(
    column: $table.struggles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scrollingTriggersSexual => $composableBuilder(
    column: $table.scrollingTriggersSexual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggers => $composableBuilder(
    column: $table.triggers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get struggleDuration => $composableBuilder(
    column: $table.struggleDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resistAbility => $composableBuilder(
    column: $table.resistAbility,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motivations => $composableBuilder(
    column: $table.motivations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get weekendDifferent => $composableBuilder(
    column: $table.weekendDifferent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get checkedInToday => $composableBuilder(
    column: $table.checkedInToday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roleType => $composableBuilder(
    column: $table.roleType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workDays => $composableBuilder(
    column: $table.workDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workStart => $composableBuilder(
    column: $table.workStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workEnd => $composableBuilder(
    column: $table.workEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekdayWakeTime => $composableBuilder(
    column: $table.weekdayWakeTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekdaySleepTime => $composableBuilder(
    column: $table.weekdaySleepTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get offdayWakeTime => $composableBuilder(
    column: $table.offdayWakeTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get offdaySleepTime => $composableBuilder(
    column: $table.offdaySleepTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get struggles => $composableBuilder(
    column: $table.struggles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scrollingTriggersSexual => $composableBuilder(
    column: $table.scrollingTriggersSexual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggers => $composableBuilder(
    column: $table.triggers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get struggleDuration => $composableBuilder(
    column: $table.struggleDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resistAbility => $composableBuilder(
    column: $table.resistAbility,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motivations => $composableBuilder(
    column: $table.motivations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get weekendDifferent => $composableBuilder(
    column: $table.weekendDifferent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<bool> get checkedInToday => $composableBuilder(
    column: $table.checkedInToday,
    builder: (column) => column,
  );

  GeneratedColumn<String> get roleType =>
      $composableBuilder(column: $table.roleType, builder: (column) => column);

  GeneratedColumn<String> get workDays =>
      $composableBuilder(column: $table.workDays, builder: (column) => column);

  GeneratedColumn<String> get workStart =>
      $composableBuilder(column: $table.workStart, builder: (column) => column);

  GeneratedColumn<String> get workEnd =>
      $composableBuilder(column: $table.workEnd, builder: (column) => column);

  GeneratedColumn<String> get weekdayWakeTime => $composableBuilder(
    column: $table.weekdayWakeTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weekdaySleepTime => $composableBuilder(
    column: $table.weekdaySleepTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get offdayWakeTime => $composableBuilder(
    column: $table.offdayWakeTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get offdaySleepTime => $composableBuilder(
    column: $table.offdaySleepTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get struggles =>
      $composableBuilder(column: $table.struggles, builder: (column) => column);

  GeneratedColumn<String> get scrollingTriggersSexual => $composableBuilder(
    column: $table.scrollingTriggersSexual,
    builder: (column) => column,
  );

  GeneratedColumn<String> get triggers =>
      $composableBuilder(column: $table.triggers, builder: (column) => column);

  GeneratedColumn<String> get struggleDuration => $composableBuilder(
    column: $table.struggleDuration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resistAbility => $composableBuilder(
    column: $table.resistAbility,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<String> get motivations => $composableBuilder(
    column: $table.motivations,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get weekendDifferent => $composableBuilder(
    column: $table.weekendDifferent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<bool> checkedInToday = const Value.absent(),
                Value<String> roleType = const Value.absent(),
                Value<String> workDays = const Value.absent(),
                Value<String?> workStart = const Value.absent(),
                Value<String?> workEnd = const Value.absent(),
                Value<String> weekdayWakeTime = const Value.absent(),
                Value<String> weekdaySleepTime = const Value.absent(),
                Value<String> offdayWakeTime = const Value.absent(),
                Value<String> offdaySleepTime = const Value.absent(),
                Value<String> struggles = const Value.absent(),
                Value<String> scrollingTriggersSexual = const Value.absent(),
                Value<String> triggers = const Value.absent(),
                Value<String> struggleDuration = const Value.absent(),
                Value<String> resistAbility = const Value.absent(),
                Value<String> goalType = const Value.absent(),
                Value<String> motivations = const Value.absent(),
                Value<bool> weekendDifferent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                email: email,
                phone: phone,
                country: country,
                checkedInToday: checkedInToday,
                roleType: roleType,
                workDays: workDays,
                workStart: workStart,
                workEnd: workEnd,
                weekdayWakeTime: weekdayWakeTime,
                weekdaySleepTime: weekdaySleepTime,
                offdayWakeTime: offdayWakeTime,
                offdaySleepTime: offdaySleepTime,
                struggles: struggles,
                scrollingTriggersSexual: scrollingTriggersSexual,
                triggers: triggers,
                struggleDuration: struggleDuration,
                resistAbility: resistAbility,
                goalType: goalType,
                motivations: motivations,
                weekendDifferent: weekendDifferent,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<bool> checkedInToday = const Value.absent(),
                required String roleType,
                Value<String> workDays = const Value.absent(),
                Value<String?> workStart = const Value.absent(),
                Value<String?> workEnd = const Value.absent(),
                required String weekdayWakeTime,
                required String weekdaySleepTime,
                required String offdayWakeTime,
                required String offdaySleepTime,
                Value<String> struggles = const Value.absent(),
                Value<String> scrollingTriggersSexual = const Value.absent(),
                Value<String> triggers = const Value.absent(),
                required String struggleDuration,
                required String resistAbility,
                required String goalType,
                Value<String> motivations = const Value.absent(),
                Value<bool> weekendDifferent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                email: email,
                phone: phone,
                country: country,
                checkedInToday: checkedInToday,
                roleType: roleType,
                workDays: workDays,
                workStart: workStart,
                workEnd: workEnd,
                weekdayWakeTime: weekdayWakeTime,
                weekdaySleepTime: weekdaySleepTime,
                offdayWakeTime: offdayWakeTime,
                offdaySleepTime: offdaySleepTime,
                struggles: struggles,
                scrollingTriggersSexual: scrollingTriggersSexual,
                triggers: triggers,
                struggleDuration: struggleDuration,
                resistAbility: resistAbility,
                goalType: goalType,
                motivations: motivations,
                weekendDifferent: weekendDifferent,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$PeakNodesTableCreateCompanionBuilder =
    PeakNodesCompanion Function({
      Value<int> id,
      required String label,
      required String centerTime,
      Value<int> windowRadiusMinutes,
      Value<String> frequency,
      Value<String> dayTypes,
      Value<bool> isHardest,
      Value<String> triggers,
      Value<String> emotionalState,
      Value<String> preContext,
      Value<double> empiricalFrequency,
      Value<double> avgIntensity,
      Value<double> slipRate,
      Value<String> triggerPosteriors,
      Value<String> topInterventions,
      Value<int> currentPeakStreak,
      Value<int> bestPeakStreak,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PeakNodesTableUpdateCompanionBuilder =
    PeakNodesCompanion Function({
      Value<int> id,
      Value<String> label,
      Value<String> centerTime,
      Value<int> windowRadiusMinutes,
      Value<String> frequency,
      Value<String> dayTypes,
      Value<bool> isHardest,
      Value<String> triggers,
      Value<String> emotionalState,
      Value<String> preContext,
      Value<double> empiricalFrequency,
      Value<double> avgIntensity,
      Value<double> slipRate,
      Value<String> triggerPosteriors,
      Value<String> topInterventions,
      Value<int> currentPeakStreak,
      Value<int> bestPeakStreak,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$PeakNodesTableFilterComposer
    extends Composer<_$AppDatabase, $PeakNodesTable> {
  $$PeakNodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get centerTime => $composableBuilder(
    column: $table.centerTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get windowRadiusMinutes => $composableBuilder(
    column: $table.windowRadiusMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayTypes => $composableBuilder(
    column: $table.dayTypes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHardest => $composableBuilder(
    column: $table.isHardest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggers => $composableBuilder(
    column: $table.triggers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emotionalState => $composableBuilder(
    column: $table.emotionalState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preContext => $composableBuilder(
    column: $table.preContext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get empiricalFrequency => $composableBuilder(
    column: $table.empiricalFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgIntensity => $composableBuilder(
    column: $table.avgIntensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get slipRate => $composableBuilder(
    column: $table.slipRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggerPosteriors => $composableBuilder(
    column: $table.triggerPosteriors,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topInterventions => $composableBuilder(
    column: $table.topInterventions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentPeakStreak => $composableBuilder(
    column: $table.currentPeakStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestPeakStreak => $composableBuilder(
    column: $table.bestPeakStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PeakNodesTableOrderingComposer
    extends Composer<_$AppDatabase, $PeakNodesTable> {
  $$PeakNodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get centerTime => $composableBuilder(
    column: $table.centerTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get windowRadiusMinutes => $composableBuilder(
    column: $table.windowRadiusMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayTypes => $composableBuilder(
    column: $table.dayTypes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHardest => $composableBuilder(
    column: $table.isHardest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggers => $composableBuilder(
    column: $table.triggers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emotionalState => $composableBuilder(
    column: $table.emotionalState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preContext => $composableBuilder(
    column: $table.preContext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get empiricalFrequency => $composableBuilder(
    column: $table.empiricalFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgIntensity => $composableBuilder(
    column: $table.avgIntensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get slipRate => $composableBuilder(
    column: $table.slipRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggerPosteriors => $composableBuilder(
    column: $table.triggerPosteriors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topInterventions => $composableBuilder(
    column: $table.topInterventions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentPeakStreak => $composableBuilder(
    column: $table.currentPeakStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestPeakStreak => $composableBuilder(
    column: $table.bestPeakStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PeakNodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeakNodesTable> {
  $$PeakNodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get centerTime => $composableBuilder(
    column: $table.centerTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get windowRadiusMinutes => $composableBuilder(
    column: $table.windowRadiusMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get dayTypes =>
      $composableBuilder(column: $table.dayTypes, builder: (column) => column);

  GeneratedColumn<bool> get isHardest =>
      $composableBuilder(column: $table.isHardest, builder: (column) => column);

  GeneratedColumn<String> get triggers =>
      $composableBuilder(column: $table.triggers, builder: (column) => column);

  GeneratedColumn<String> get emotionalState => $composableBuilder(
    column: $table.emotionalState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preContext => $composableBuilder(
    column: $table.preContext,
    builder: (column) => column,
  );

  GeneratedColumn<double> get empiricalFrequency => $composableBuilder(
    column: $table.empiricalFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgIntensity => $composableBuilder(
    column: $table.avgIntensity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get slipRate =>
      $composableBuilder(column: $table.slipRate, builder: (column) => column);

  GeneratedColumn<String> get triggerPosteriors => $composableBuilder(
    column: $table.triggerPosteriors,
    builder: (column) => column,
  );

  GeneratedColumn<String> get topInterventions => $composableBuilder(
    column: $table.topInterventions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentPeakStreak => $composableBuilder(
    column: $table.currentPeakStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bestPeakStreak => $composableBuilder(
    column: $table.bestPeakStreak,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PeakNodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PeakNodesTable,
          PeakNode,
          $$PeakNodesTableFilterComposer,
          $$PeakNodesTableOrderingComposer,
          $$PeakNodesTableAnnotationComposer,
          $$PeakNodesTableCreateCompanionBuilder,
          $$PeakNodesTableUpdateCompanionBuilder,
          (PeakNode, BaseReferences<_$AppDatabase, $PeakNodesTable, PeakNode>),
          PeakNode,
          PrefetchHooks Function()
        > {
  $$PeakNodesTableTableManager(_$AppDatabase db, $PeakNodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeakNodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeakNodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeakNodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> centerTime = const Value.absent(),
                Value<int> windowRadiusMinutes = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<String> dayTypes = const Value.absent(),
                Value<bool> isHardest = const Value.absent(),
                Value<String> triggers = const Value.absent(),
                Value<String> emotionalState = const Value.absent(),
                Value<String> preContext = const Value.absent(),
                Value<double> empiricalFrequency = const Value.absent(),
                Value<double> avgIntensity = const Value.absent(),
                Value<double> slipRate = const Value.absent(),
                Value<String> triggerPosteriors = const Value.absent(),
                Value<String> topInterventions = const Value.absent(),
                Value<int> currentPeakStreak = const Value.absent(),
                Value<int> bestPeakStreak = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PeakNodesCompanion(
                id: id,
                label: label,
                centerTime: centerTime,
                windowRadiusMinutes: windowRadiusMinutes,
                frequency: frequency,
                dayTypes: dayTypes,
                isHardest: isHardest,
                triggers: triggers,
                emotionalState: emotionalState,
                preContext: preContext,
                empiricalFrequency: empiricalFrequency,
                avgIntensity: avgIntensity,
                slipRate: slipRate,
                triggerPosteriors: triggerPosteriors,
                topInterventions: topInterventions,
                currentPeakStreak: currentPeakStreak,
                bestPeakStreak: bestPeakStreak,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String label,
                required String centerTime,
                Value<int> windowRadiusMinutes = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<String> dayTypes = const Value.absent(),
                Value<bool> isHardest = const Value.absent(),
                Value<String> triggers = const Value.absent(),
                Value<String> emotionalState = const Value.absent(),
                Value<String> preContext = const Value.absent(),
                Value<double> empiricalFrequency = const Value.absent(),
                Value<double> avgIntensity = const Value.absent(),
                Value<double> slipRate = const Value.absent(),
                Value<String> triggerPosteriors = const Value.absent(),
                Value<String> topInterventions = const Value.absent(),
                Value<int> currentPeakStreak = const Value.absent(),
                Value<int> bestPeakStreak = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PeakNodesCompanion.insert(
                id: id,
                label: label,
                centerTime: centerTime,
                windowRadiusMinutes: windowRadiusMinutes,
                frequency: frequency,
                dayTypes: dayTypes,
                isHardest: isHardest,
                triggers: triggers,
                emotionalState: emotionalState,
                preContext: preContext,
                empiricalFrequency: empiricalFrequency,
                avgIntensity: avgIntensity,
                slipRate: slipRate,
                triggerPosteriors: triggerPosteriors,
                topInterventions: topInterventions,
                currentPeakStreak: currentPeakStreak,
                bestPeakStreak: bestPeakStreak,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PeakNodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PeakNodesTable,
      PeakNode,
      $$PeakNodesTableFilterComposer,
      $$PeakNodesTableOrderingComposer,
      $$PeakNodesTableAnnotationComposer,
      $$PeakNodesTableCreateCompanionBuilder,
      $$PeakNodesTableUpdateCompanionBuilder,
      (PeakNode, BaseReferences<_$AppDatabase, $PeakNodesTable, PeakNode>),
      PeakNode,
      PrefetchHooks Function()
    >;
typedef $$RiskWindowsTableCreateCompanionBuilder =
    RiskWindowsCompanion Function({
      Value<int> id,
      required String dayType,
      required int dayOfWeek,
      required String blockStart,
      required String blockEnd,
      Value<int?> nearestPeakId,
      Value<double> heuristicScore,
      Value<double> empiricalScore,
      Value<double> blendedScore,
      Value<double> alpha,
      Value<String?> dominantTrigger,
      Value<String> topInterventions,
      Value<int> observationCount,
      Value<int> urgeCount,
      Value<int> slipCount,
      Value<double> cascadeMultiplier,
      Value<DateTime> updatedAt,
    });
typedef $$RiskWindowsTableUpdateCompanionBuilder =
    RiskWindowsCompanion Function({
      Value<int> id,
      Value<String> dayType,
      Value<int> dayOfWeek,
      Value<String> blockStart,
      Value<String> blockEnd,
      Value<int?> nearestPeakId,
      Value<double> heuristicScore,
      Value<double> empiricalScore,
      Value<double> blendedScore,
      Value<double> alpha,
      Value<String?> dominantTrigger,
      Value<String> topInterventions,
      Value<int> observationCount,
      Value<int> urgeCount,
      Value<int> slipCount,
      Value<double> cascadeMultiplier,
      Value<DateTime> updatedAt,
    });

class $$RiskWindowsTableFilterComposer
    extends Composer<_$AppDatabase, $RiskWindowsTable> {
  $$RiskWindowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayType => $composableBuilder(
    column: $table.dayType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get blockStart => $composableBuilder(
    column: $table.blockStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get blockEnd => $composableBuilder(
    column: $table.blockEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nearestPeakId => $composableBuilder(
    column: $table.nearestPeakId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heuristicScore => $composableBuilder(
    column: $table.heuristicScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get empiricalScore => $composableBuilder(
    column: $table.empiricalScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get blendedScore => $composableBuilder(
    column: $table.blendedScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get alpha => $composableBuilder(
    column: $table.alpha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dominantTrigger => $composableBuilder(
    column: $table.dominantTrigger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topInterventions => $composableBuilder(
    column: $table.topInterventions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get observationCount => $composableBuilder(
    column: $table.observationCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urgeCount => $composableBuilder(
    column: $table.urgeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get slipCount => $composableBuilder(
    column: $table.slipCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cascadeMultiplier => $composableBuilder(
    column: $table.cascadeMultiplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RiskWindowsTableOrderingComposer
    extends Composer<_$AppDatabase, $RiskWindowsTable> {
  $$RiskWindowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayType => $composableBuilder(
    column: $table.dayType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get blockStart => $composableBuilder(
    column: $table.blockStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get blockEnd => $composableBuilder(
    column: $table.blockEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nearestPeakId => $composableBuilder(
    column: $table.nearestPeakId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heuristicScore => $composableBuilder(
    column: $table.heuristicScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get empiricalScore => $composableBuilder(
    column: $table.empiricalScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get blendedScore => $composableBuilder(
    column: $table.blendedScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get alpha => $composableBuilder(
    column: $table.alpha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dominantTrigger => $composableBuilder(
    column: $table.dominantTrigger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topInterventions => $composableBuilder(
    column: $table.topInterventions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get observationCount => $composableBuilder(
    column: $table.observationCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urgeCount => $composableBuilder(
    column: $table.urgeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get slipCount => $composableBuilder(
    column: $table.slipCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cascadeMultiplier => $composableBuilder(
    column: $table.cascadeMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RiskWindowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RiskWindowsTable> {
  $$RiskWindowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dayType =>
      $composableBuilder(column: $table.dayType, builder: (column) => column);

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<String> get blockStart => $composableBuilder(
    column: $table.blockStart,
    builder: (column) => column,
  );

  GeneratedColumn<String> get blockEnd =>
      $composableBuilder(column: $table.blockEnd, builder: (column) => column);

  GeneratedColumn<int> get nearestPeakId => $composableBuilder(
    column: $table.nearestPeakId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get heuristicScore => $composableBuilder(
    column: $table.heuristicScore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get empiricalScore => $composableBuilder(
    column: $table.empiricalScore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get blendedScore => $composableBuilder(
    column: $table.blendedScore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get alpha =>
      $composableBuilder(column: $table.alpha, builder: (column) => column);

  GeneratedColumn<String> get dominantTrigger => $composableBuilder(
    column: $table.dominantTrigger,
    builder: (column) => column,
  );

  GeneratedColumn<String> get topInterventions => $composableBuilder(
    column: $table.topInterventions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get observationCount => $composableBuilder(
    column: $table.observationCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get urgeCount =>
      $composableBuilder(column: $table.urgeCount, builder: (column) => column);

  GeneratedColumn<int> get slipCount =>
      $composableBuilder(column: $table.slipCount, builder: (column) => column);

  GeneratedColumn<double> get cascadeMultiplier => $composableBuilder(
    column: $table.cascadeMultiplier,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RiskWindowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RiskWindowsTable,
          RiskWindow,
          $$RiskWindowsTableFilterComposer,
          $$RiskWindowsTableOrderingComposer,
          $$RiskWindowsTableAnnotationComposer,
          $$RiskWindowsTableCreateCompanionBuilder,
          $$RiskWindowsTableUpdateCompanionBuilder,
          (
            RiskWindow,
            BaseReferences<_$AppDatabase, $RiskWindowsTable, RiskWindow>,
          ),
          RiskWindow,
          PrefetchHooks Function()
        > {
  $$RiskWindowsTableTableManager(_$AppDatabase db, $RiskWindowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RiskWindowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RiskWindowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RiskWindowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dayType = const Value.absent(),
                Value<int> dayOfWeek = const Value.absent(),
                Value<String> blockStart = const Value.absent(),
                Value<String> blockEnd = const Value.absent(),
                Value<int?> nearestPeakId = const Value.absent(),
                Value<double> heuristicScore = const Value.absent(),
                Value<double> empiricalScore = const Value.absent(),
                Value<double> blendedScore = const Value.absent(),
                Value<double> alpha = const Value.absent(),
                Value<String?> dominantTrigger = const Value.absent(),
                Value<String> topInterventions = const Value.absent(),
                Value<int> observationCount = const Value.absent(),
                Value<int> urgeCount = const Value.absent(),
                Value<int> slipCount = const Value.absent(),
                Value<double> cascadeMultiplier = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RiskWindowsCompanion(
                id: id,
                dayType: dayType,
                dayOfWeek: dayOfWeek,
                blockStart: blockStart,
                blockEnd: blockEnd,
                nearestPeakId: nearestPeakId,
                heuristicScore: heuristicScore,
                empiricalScore: empiricalScore,
                blendedScore: blendedScore,
                alpha: alpha,
                dominantTrigger: dominantTrigger,
                topInterventions: topInterventions,
                observationCount: observationCount,
                urgeCount: urgeCount,
                slipCount: slipCount,
                cascadeMultiplier: cascadeMultiplier,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dayType,
                required int dayOfWeek,
                required String blockStart,
                required String blockEnd,
                Value<int?> nearestPeakId = const Value.absent(),
                Value<double> heuristicScore = const Value.absent(),
                Value<double> empiricalScore = const Value.absent(),
                Value<double> blendedScore = const Value.absent(),
                Value<double> alpha = const Value.absent(),
                Value<String?> dominantTrigger = const Value.absent(),
                Value<String> topInterventions = const Value.absent(),
                Value<int> observationCount = const Value.absent(),
                Value<int> urgeCount = const Value.absent(),
                Value<int> slipCount = const Value.absent(),
                Value<double> cascadeMultiplier = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RiskWindowsCompanion.insert(
                id: id,
                dayType: dayType,
                dayOfWeek: dayOfWeek,
                blockStart: blockStart,
                blockEnd: blockEnd,
                nearestPeakId: nearestPeakId,
                heuristicScore: heuristicScore,
                empiricalScore: empiricalScore,
                blendedScore: blendedScore,
                alpha: alpha,
                dominantTrigger: dominantTrigger,
                topInterventions: topInterventions,
                observationCount: observationCount,
                urgeCount: urgeCount,
                slipCount: slipCount,
                cascadeMultiplier: cascadeMultiplier,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RiskWindowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RiskWindowsTable,
      RiskWindow,
      $$RiskWindowsTableFilterComposer,
      $$RiskWindowsTableOrderingComposer,
      $$RiskWindowsTableAnnotationComposer,
      $$RiskWindowsTableCreateCompanionBuilder,
      $$RiskWindowsTableUpdateCompanionBuilder,
      (
        RiskWindow,
        BaseReferences<_$AppDatabase, $RiskWindowsTable, RiskWindow>,
      ),
      RiskWindow,
      PrefetchHooks Function()
    >;
typedef $$DailyCheckinsTableCreateCompanionBuilder =
    DailyCheckinsCompanion Function({
      Value<int> id,
      required DateTime date,
      required bool hadUrge,
      Value<int?> urgeMax,
      Value<String?> mainTrigger,
      required bool slipped,
      Value<int> slipCount,
      required int sleepQuality,
      required int mood,
      required int stress,
      required int confidenceTomorrow,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$DailyCheckinsTableUpdateCompanionBuilder =
    DailyCheckinsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<bool> hadUrge,
      Value<int?> urgeMax,
      Value<String?> mainTrigger,
      Value<bool> slipped,
      Value<int> slipCount,
      Value<int> sleepQuality,
      Value<int> mood,
      Value<int> stress,
      Value<int> confidenceTomorrow,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

class $$DailyCheckinsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyCheckinsTable> {
  $$DailyCheckinsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hadUrge => $composableBuilder(
    column: $table.hadUrge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urgeMax => $composableBuilder(
    column: $table.urgeMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mainTrigger => $composableBuilder(
    column: $table.mainTrigger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get slipped => $composableBuilder(
    column: $table.slipped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get slipCount => $composableBuilder(
    column: $table.slipCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stress => $composableBuilder(
    column: $table.stress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get confidenceTomorrow => $composableBuilder(
    column: $table.confidenceTomorrow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyCheckinsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyCheckinsTable> {
  $$DailyCheckinsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hadUrge => $composableBuilder(
    column: $table.hadUrge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urgeMax => $composableBuilder(
    column: $table.urgeMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mainTrigger => $composableBuilder(
    column: $table.mainTrigger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get slipped => $composableBuilder(
    column: $table.slipped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get slipCount => $composableBuilder(
    column: $table.slipCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stress => $composableBuilder(
    column: $table.stress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get confidenceTomorrow => $composableBuilder(
    column: $table.confidenceTomorrow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyCheckinsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyCheckinsTable> {
  $$DailyCheckinsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get hadUrge =>
      $composableBuilder(column: $table.hadUrge, builder: (column) => column);

  GeneratedColumn<int> get urgeMax =>
      $composableBuilder(column: $table.urgeMax, builder: (column) => column);

  GeneratedColumn<String> get mainTrigger => $composableBuilder(
    column: $table.mainTrigger,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get slipped =>
      $composableBuilder(column: $table.slipped, builder: (column) => column);

  GeneratedColumn<int> get slipCount =>
      $composableBuilder(column: $table.slipCount, builder: (column) => column);

  GeneratedColumn<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<int> get stress =>
      $composableBuilder(column: $table.stress, builder: (column) => column);

  GeneratedColumn<int> get confidenceTomorrow => $composableBuilder(
    column: $table.confidenceTomorrow,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DailyCheckinsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyCheckinsTable,
          DailyCheckin,
          $$DailyCheckinsTableFilterComposer,
          $$DailyCheckinsTableOrderingComposer,
          $$DailyCheckinsTableAnnotationComposer,
          $$DailyCheckinsTableCreateCompanionBuilder,
          $$DailyCheckinsTableUpdateCompanionBuilder,
          (
            DailyCheckin,
            BaseReferences<_$AppDatabase, $DailyCheckinsTable, DailyCheckin>,
          ),
          DailyCheckin,
          PrefetchHooks Function()
        > {
  $$DailyCheckinsTableTableManager(_$AppDatabase db, $DailyCheckinsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyCheckinsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyCheckinsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyCheckinsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> hadUrge = const Value.absent(),
                Value<int?> urgeMax = const Value.absent(),
                Value<String?> mainTrigger = const Value.absent(),
                Value<bool> slipped = const Value.absent(),
                Value<int> slipCount = const Value.absent(),
                Value<int> sleepQuality = const Value.absent(),
                Value<int> mood = const Value.absent(),
                Value<int> stress = const Value.absent(),
                Value<int> confidenceTomorrow = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailyCheckinsCompanion(
                id: id,
                date: date,
                hadUrge: hadUrge,
                urgeMax: urgeMax,
                mainTrigger: mainTrigger,
                slipped: slipped,
                slipCount: slipCount,
                sleepQuality: sleepQuality,
                mood: mood,
                stress: stress,
                confidenceTomorrow: confidenceTomorrow,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required bool hadUrge,
                Value<int?> urgeMax = const Value.absent(),
                Value<String?> mainTrigger = const Value.absent(),
                required bool slipped,
                Value<int> slipCount = const Value.absent(),
                required int sleepQuality,
                required int mood,
                required int stress,
                required int confidenceTomorrow,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailyCheckinsCompanion.insert(
                id: id,
                date: date,
                hadUrge: hadUrge,
                urgeMax: urgeMax,
                mainTrigger: mainTrigger,
                slipped: slipped,
                slipCount: slipCount,
                sleepQuality: sleepQuality,
                mood: mood,
                stress: stress,
                confidenceTomorrow: confidenceTomorrow,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyCheckinsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyCheckinsTable,
      DailyCheckin,
      $$DailyCheckinsTableFilterComposer,
      $$DailyCheckinsTableOrderingComposer,
      $$DailyCheckinsTableAnnotationComposer,
      $$DailyCheckinsTableCreateCompanionBuilder,
      $$DailyCheckinsTableUpdateCompanionBuilder,
      (
        DailyCheckin,
        BaseReferences<_$AppDatabase, $DailyCheckinsTable, DailyCheckin>,
      ),
      DailyCheckin,
      PrefetchHooks Function()
    >;
typedef $$UrgeEventsTableCreateCompanionBuilder =
    UrgeEventsCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      Value<String> source,
      required String trigger,
      Value<String?> contextTag,
      Value<String?> location,
      required int intensityBefore,
      Value<String?> chosenRescue,
      Value<int?> intensityAfter,
      Value<bool> slipFollowed,
      Value<int?> durationSeconds,
      Value<String> rescueTasksUsed,
    });
typedef $$UrgeEventsTableUpdateCompanionBuilder =
    UrgeEventsCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<String> source,
      Value<String> trigger,
      Value<String?> contextTag,
      Value<String?> location,
      Value<int> intensityBefore,
      Value<String?> chosenRescue,
      Value<int?> intensityAfter,
      Value<bool> slipFollowed,
      Value<int?> durationSeconds,
      Value<String> rescueTasksUsed,
    });

class $$UrgeEventsTableFilterComposer
    extends Composer<_$AppDatabase, $UrgeEventsTable> {
  $$UrgeEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextTag => $composableBuilder(
    column: $table.contextTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensityBefore => $composableBuilder(
    column: $table.intensityBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chosenRescue => $composableBuilder(
    column: $table.chosenRescue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensityAfter => $composableBuilder(
    column: $table.intensityAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get slipFollowed => $composableBuilder(
    column: $table.slipFollowed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rescueTasksUsed => $composableBuilder(
    column: $table.rescueTasksUsed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UrgeEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $UrgeEventsTable> {
  $$UrgeEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextTag => $composableBuilder(
    column: $table.contextTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensityBefore => $composableBuilder(
    column: $table.intensityBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chosenRescue => $composableBuilder(
    column: $table.chosenRescue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensityAfter => $composableBuilder(
    column: $table.intensityAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get slipFollowed => $composableBuilder(
    column: $table.slipFollowed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rescueTasksUsed => $composableBuilder(
    column: $table.rescueTasksUsed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UrgeEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UrgeEventsTable> {
  $$UrgeEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get trigger =>
      $composableBuilder(column: $table.trigger, builder: (column) => column);

  GeneratedColumn<String> get contextTag => $composableBuilder(
    column: $table.contextTag,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<int> get intensityBefore => $composableBuilder(
    column: $table.intensityBefore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chosenRescue => $composableBuilder(
    column: $table.chosenRescue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intensityAfter => $composableBuilder(
    column: $table.intensityAfter,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get slipFollowed => $composableBuilder(
    column: $table.slipFollowed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rescueTasksUsed => $composableBuilder(
    column: $table.rescueTasksUsed,
    builder: (column) => column,
  );
}

class $$UrgeEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UrgeEventsTable,
          UrgeEvent,
          $$UrgeEventsTableFilterComposer,
          $$UrgeEventsTableOrderingComposer,
          $$UrgeEventsTableAnnotationComposer,
          $$UrgeEventsTableCreateCompanionBuilder,
          $$UrgeEventsTableUpdateCompanionBuilder,
          (
            UrgeEvent,
            BaseReferences<_$AppDatabase, $UrgeEventsTable, UrgeEvent>,
          ),
          UrgeEvent,
          PrefetchHooks Function()
        > {
  $$UrgeEventsTableTableManager(_$AppDatabase db, $UrgeEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UrgeEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UrgeEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UrgeEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> trigger = const Value.absent(),
                Value<String?> contextTag = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<int> intensityBefore = const Value.absent(),
                Value<String?> chosenRescue = const Value.absent(),
                Value<int?> intensityAfter = const Value.absent(),
                Value<bool> slipFollowed = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String> rescueTasksUsed = const Value.absent(),
              }) => UrgeEventsCompanion(
                id: id,
                timestamp: timestamp,
                source: source,
                trigger: trigger,
                contextTag: contextTag,
                location: location,
                intensityBefore: intensityBefore,
                chosenRescue: chosenRescue,
                intensityAfter: intensityAfter,
                slipFollowed: slipFollowed,
                durationSeconds: durationSeconds,
                rescueTasksUsed: rescueTasksUsed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                Value<String> source = const Value.absent(),
                required String trigger,
                Value<String?> contextTag = const Value.absent(),
                Value<String?> location = const Value.absent(),
                required int intensityBefore,
                Value<String?> chosenRescue = const Value.absent(),
                Value<int?> intensityAfter = const Value.absent(),
                Value<bool> slipFollowed = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String> rescueTasksUsed = const Value.absent(),
              }) => UrgeEventsCompanion.insert(
                id: id,
                timestamp: timestamp,
                source: source,
                trigger: trigger,
                contextTag: contextTag,
                location: location,
                intensityBefore: intensityBefore,
                chosenRescue: chosenRescue,
                intensityAfter: intensityAfter,
                slipFollowed: slipFollowed,
                durationSeconds: durationSeconds,
                rescueTasksUsed: rescueTasksUsed,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UrgeEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UrgeEventsTable,
      UrgeEvent,
      $$UrgeEventsTableFilterComposer,
      $$UrgeEventsTableOrderingComposer,
      $$UrgeEventsTableAnnotationComposer,
      $$UrgeEventsTableCreateCompanionBuilder,
      $$UrgeEventsTableUpdateCompanionBuilder,
      (UrgeEvent, BaseReferences<_$AppDatabase, $UrgeEventsTable, UrgeEvent>),
      UrgeEvent,
      PrefetchHooks Function()
    >;
typedef $$SlipEventsTableCreateCompanionBuilder =
    SlipEventsCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      Value<String> source,
      required String behaviorType,
      Value<String> triggerChain,
      Value<String?> locationContext,
      Value<bool> precededByScrolling,
      Value<String?> reflectionTag,
      Value<String?> reflectionNote,
    });
typedef $$SlipEventsTableUpdateCompanionBuilder =
    SlipEventsCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<String> source,
      Value<String> behaviorType,
      Value<String> triggerChain,
      Value<String?> locationContext,
      Value<bool> precededByScrolling,
      Value<String?> reflectionTag,
      Value<String?> reflectionNote,
    });

class $$SlipEventsTableFilterComposer
    extends Composer<_$AppDatabase, $SlipEventsTable> {
  $$SlipEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get behaviorType => $composableBuilder(
    column: $table.behaviorType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggerChain => $composableBuilder(
    column: $table.triggerChain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationContext => $composableBuilder(
    column: $table.locationContext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get precededByScrolling => $composableBuilder(
    column: $table.precededByScrolling,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reflectionTag => $composableBuilder(
    column: $table.reflectionTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reflectionNote => $composableBuilder(
    column: $table.reflectionNote,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SlipEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $SlipEventsTable> {
  $$SlipEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get behaviorType => $composableBuilder(
    column: $table.behaviorType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggerChain => $composableBuilder(
    column: $table.triggerChain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationContext => $composableBuilder(
    column: $table.locationContext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get precededByScrolling => $composableBuilder(
    column: $table.precededByScrolling,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reflectionTag => $composableBuilder(
    column: $table.reflectionTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reflectionNote => $composableBuilder(
    column: $table.reflectionNote,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SlipEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SlipEventsTable> {
  $$SlipEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get behaviorType => $composableBuilder(
    column: $table.behaviorType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get triggerChain => $composableBuilder(
    column: $table.triggerChain,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locationContext => $composableBuilder(
    column: $table.locationContext,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get precededByScrolling => $composableBuilder(
    column: $table.precededByScrolling,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reflectionTag => $composableBuilder(
    column: $table.reflectionTag,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reflectionNote => $composableBuilder(
    column: $table.reflectionNote,
    builder: (column) => column,
  );
}

class $$SlipEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SlipEventsTable,
          SlipEvent,
          $$SlipEventsTableFilterComposer,
          $$SlipEventsTableOrderingComposer,
          $$SlipEventsTableAnnotationComposer,
          $$SlipEventsTableCreateCompanionBuilder,
          $$SlipEventsTableUpdateCompanionBuilder,
          (
            SlipEvent,
            BaseReferences<_$AppDatabase, $SlipEventsTable, SlipEvent>,
          ),
          SlipEvent,
          PrefetchHooks Function()
        > {
  $$SlipEventsTableTableManager(_$AppDatabase db, $SlipEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SlipEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SlipEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SlipEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> behaviorType = const Value.absent(),
                Value<String> triggerChain = const Value.absent(),
                Value<String?> locationContext = const Value.absent(),
                Value<bool> precededByScrolling = const Value.absent(),
                Value<String?> reflectionTag = const Value.absent(),
                Value<String?> reflectionNote = const Value.absent(),
              }) => SlipEventsCompanion(
                id: id,
                timestamp: timestamp,
                source: source,
                behaviorType: behaviorType,
                triggerChain: triggerChain,
                locationContext: locationContext,
                precededByScrolling: precededByScrolling,
                reflectionTag: reflectionTag,
                reflectionNote: reflectionNote,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                Value<String> source = const Value.absent(),
                required String behaviorType,
                Value<String> triggerChain = const Value.absent(),
                Value<String?> locationContext = const Value.absent(),
                Value<bool> precededByScrolling = const Value.absent(),
                Value<String?> reflectionTag = const Value.absent(),
                Value<String?> reflectionNote = const Value.absent(),
              }) => SlipEventsCompanion.insert(
                id: id,
                timestamp: timestamp,
                source: source,
                behaviorType: behaviorType,
                triggerChain: triggerChain,
                locationContext: locationContext,
                precededByScrolling: precededByScrolling,
                reflectionTag: reflectionTag,
                reflectionNote: reflectionNote,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SlipEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SlipEventsTable,
      SlipEvent,
      $$SlipEventsTableFilterComposer,
      $$SlipEventsTableOrderingComposer,
      $$SlipEventsTableAnnotationComposer,
      $$SlipEventsTableCreateCompanionBuilder,
      $$SlipEventsTableUpdateCompanionBuilder,
      (SlipEvent, BaseReferences<_$AppDatabase, $SlipEventsTable, SlipEvent>),
      SlipEvent,
      PrefetchHooks Function()
    >;
typedef $$InterventionLogsTableCreateCompanionBuilder =
    InterventionLogsCompanion Function({
      Value<int> id,
      Value<int?> urgeEventId,
      required String interventionType,
      required bool success,
      Value<int?> intensityDrop,
      Value<String?> contextTimeOfDay,
      Value<String?> contextLocation,
      Value<DateTime> timestamp,
    });
typedef $$InterventionLogsTableUpdateCompanionBuilder =
    InterventionLogsCompanion Function({
      Value<int> id,
      Value<int?> urgeEventId,
      Value<String> interventionType,
      Value<bool> success,
      Value<int?> intensityDrop,
      Value<String?> contextTimeOfDay,
      Value<String?> contextLocation,
      Value<DateTime> timestamp,
    });

class $$InterventionLogsTableFilterComposer
    extends Composer<_$AppDatabase, $InterventionLogsTable> {
  $$InterventionLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urgeEventId => $composableBuilder(
    column: $table.urgeEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get interventionType => $composableBuilder(
    column: $table.interventionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get success => $composableBuilder(
    column: $table.success,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensityDrop => $composableBuilder(
    column: $table.intensityDrop,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextTimeOfDay => $composableBuilder(
    column: $table.contextTimeOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextLocation => $composableBuilder(
    column: $table.contextLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InterventionLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $InterventionLogsTable> {
  $$InterventionLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urgeEventId => $composableBuilder(
    column: $table.urgeEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get interventionType => $composableBuilder(
    column: $table.interventionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get success => $composableBuilder(
    column: $table.success,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensityDrop => $composableBuilder(
    column: $table.intensityDrop,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextTimeOfDay => $composableBuilder(
    column: $table.contextTimeOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextLocation => $composableBuilder(
    column: $table.contextLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InterventionLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InterventionLogsTable> {
  $$InterventionLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get urgeEventId => $composableBuilder(
    column: $table.urgeEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get interventionType => $composableBuilder(
    column: $table.interventionType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get success =>
      $composableBuilder(column: $table.success, builder: (column) => column);

  GeneratedColumn<int> get intensityDrop => $composableBuilder(
    column: $table.intensityDrop,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contextTimeOfDay => $composableBuilder(
    column: $table.contextTimeOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contextLocation => $composableBuilder(
    column: $table.contextLocation,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$InterventionLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InterventionLogsTable,
          InterventionLog,
          $$InterventionLogsTableFilterComposer,
          $$InterventionLogsTableOrderingComposer,
          $$InterventionLogsTableAnnotationComposer,
          $$InterventionLogsTableCreateCompanionBuilder,
          $$InterventionLogsTableUpdateCompanionBuilder,
          (
            InterventionLog,
            BaseReferences<
              _$AppDatabase,
              $InterventionLogsTable,
              InterventionLog
            >,
          ),
          InterventionLog,
          PrefetchHooks Function()
        > {
  $$InterventionLogsTableTableManager(
    _$AppDatabase db,
    $InterventionLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InterventionLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InterventionLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InterventionLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> urgeEventId = const Value.absent(),
                Value<String> interventionType = const Value.absent(),
                Value<bool> success = const Value.absent(),
                Value<int?> intensityDrop = const Value.absent(),
                Value<String?> contextTimeOfDay = const Value.absent(),
                Value<String?> contextLocation = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => InterventionLogsCompanion(
                id: id,
                urgeEventId: urgeEventId,
                interventionType: interventionType,
                success: success,
                intensityDrop: intensityDrop,
                contextTimeOfDay: contextTimeOfDay,
                contextLocation: contextLocation,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> urgeEventId = const Value.absent(),
                required String interventionType,
                required bool success,
                Value<int?> intensityDrop = const Value.absent(),
                Value<String?> contextTimeOfDay = const Value.absent(),
                Value<String?> contextLocation = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => InterventionLogsCompanion.insert(
                id: id,
                urgeEventId: urgeEventId,
                interventionType: interventionType,
                success: success,
                intensityDrop: intensityDrop,
                contextTimeOfDay: contextTimeOfDay,
                contextLocation: contextLocation,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InterventionLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InterventionLogsTable,
      InterventionLog,
      $$InterventionLogsTableFilterComposer,
      $$InterventionLogsTableOrderingComposer,
      $$InterventionLogsTableAnnotationComposer,
      $$InterventionLogsTableCreateCompanionBuilder,
      $$InterventionLogsTableUpdateCompanionBuilder,
      (
        InterventionLog,
        BaseReferences<_$AppDatabase, $InterventionLogsTable, InterventionLog>,
      ),
      InterventionLog,
      PrefetchHooks Function()
    >;
typedef $$TriggerPosteriorsTableCreateCompanionBuilder =
    TriggerPosteriorsCompanion Function({
      Value<int> id,
      required String triggerName,
      Value<int> urgeCount,
      Value<int> slipCount,
      Value<int> resistCount,
      Value<double> pSlipGivenTrigger,
      Value<DateTime> lastUpdated,
    });
typedef $$TriggerPosteriorsTableUpdateCompanionBuilder =
    TriggerPosteriorsCompanion Function({
      Value<int> id,
      Value<String> triggerName,
      Value<int> urgeCount,
      Value<int> slipCount,
      Value<int> resistCount,
      Value<double> pSlipGivenTrigger,
      Value<DateTime> lastUpdated,
    });

class $$TriggerPosteriorsTableFilterComposer
    extends Composer<_$AppDatabase, $TriggerPosteriorsTable> {
  $$TriggerPosteriorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggerName => $composableBuilder(
    column: $table.triggerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urgeCount => $composableBuilder(
    column: $table.urgeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get slipCount => $composableBuilder(
    column: $table.slipCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get resistCount => $composableBuilder(
    column: $table.resistCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pSlipGivenTrigger => $composableBuilder(
    column: $table.pSlipGivenTrigger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TriggerPosteriorsTableOrderingComposer
    extends Composer<_$AppDatabase, $TriggerPosteriorsTable> {
  $$TriggerPosteriorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggerName => $composableBuilder(
    column: $table.triggerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urgeCount => $composableBuilder(
    column: $table.urgeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get slipCount => $composableBuilder(
    column: $table.slipCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get resistCount => $composableBuilder(
    column: $table.resistCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pSlipGivenTrigger => $composableBuilder(
    column: $table.pSlipGivenTrigger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TriggerPosteriorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TriggerPosteriorsTable> {
  $$TriggerPosteriorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get triggerName => $composableBuilder(
    column: $table.triggerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get urgeCount =>
      $composableBuilder(column: $table.urgeCount, builder: (column) => column);

  GeneratedColumn<int> get slipCount =>
      $composableBuilder(column: $table.slipCount, builder: (column) => column);

  GeneratedColumn<int> get resistCount => $composableBuilder(
    column: $table.resistCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pSlipGivenTrigger => $composableBuilder(
    column: $table.pSlipGivenTrigger,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );
}

class $$TriggerPosteriorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TriggerPosteriorsTable,
          TriggerPosterior,
          $$TriggerPosteriorsTableFilterComposer,
          $$TriggerPosteriorsTableOrderingComposer,
          $$TriggerPosteriorsTableAnnotationComposer,
          $$TriggerPosteriorsTableCreateCompanionBuilder,
          $$TriggerPosteriorsTableUpdateCompanionBuilder,
          (
            TriggerPosterior,
            BaseReferences<
              _$AppDatabase,
              $TriggerPosteriorsTable,
              TriggerPosterior
            >,
          ),
          TriggerPosterior,
          PrefetchHooks Function()
        > {
  $$TriggerPosteriorsTableTableManager(
    _$AppDatabase db,
    $TriggerPosteriorsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TriggerPosteriorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TriggerPosteriorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TriggerPosteriorsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> triggerName = const Value.absent(),
                Value<int> urgeCount = const Value.absent(),
                Value<int> slipCount = const Value.absent(),
                Value<int> resistCount = const Value.absent(),
                Value<double> pSlipGivenTrigger = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
              }) => TriggerPosteriorsCompanion(
                id: id,
                triggerName: triggerName,
                urgeCount: urgeCount,
                slipCount: slipCount,
                resistCount: resistCount,
                pSlipGivenTrigger: pSlipGivenTrigger,
                lastUpdated: lastUpdated,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String triggerName,
                Value<int> urgeCount = const Value.absent(),
                Value<int> slipCount = const Value.absent(),
                Value<int> resistCount = const Value.absent(),
                Value<double> pSlipGivenTrigger = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
              }) => TriggerPosteriorsCompanion.insert(
                id: id,
                triggerName: triggerName,
                urgeCount: urgeCount,
                slipCount: slipCount,
                resistCount: resistCount,
                pSlipGivenTrigger: pSlipGivenTrigger,
                lastUpdated: lastUpdated,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TriggerPosteriorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TriggerPosteriorsTable,
      TriggerPosterior,
      $$TriggerPosteriorsTableFilterComposer,
      $$TriggerPosteriorsTableOrderingComposer,
      $$TriggerPosteriorsTableAnnotationComposer,
      $$TriggerPosteriorsTableCreateCompanionBuilder,
      $$TriggerPosteriorsTableUpdateCompanionBuilder,
      (
        TriggerPosterior,
        BaseReferences<
          _$AppDatabase,
          $TriggerPosteriorsTable,
          TriggerPosterior
        >,
      ),
      TriggerPosterior,
      PrefetchHooks Function()
    >;
typedef $$StreaksTableCreateCompanionBuilder =
    StreaksCompanion Function({
      Value<int> id,
      required String streakType,
      Value<int?> peakId,
      Value<int> currentCount,
      Value<int> bestCount,
      Value<int> lifetimeTotal,
      Value<DateTime> startedAt,
      Value<DateTime?> brokenAt,
      Value<DateTime> updatedAt,
    });
typedef $$StreaksTableUpdateCompanionBuilder =
    StreaksCompanion Function({
      Value<int> id,
      Value<String> streakType,
      Value<int?> peakId,
      Value<int> currentCount,
      Value<int> bestCount,
      Value<int> lifetimeTotal,
      Value<DateTime> startedAt,
      Value<DateTime?> brokenAt,
      Value<DateTime> updatedAt,
    });

class $$StreaksTableFilterComposer
    extends Composer<_$AppDatabase, $StreaksTable> {
  $$StreaksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get streakType => $composableBuilder(
    column: $table.streakType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get peakId => $composableBuilder(
    column: $table.peakId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestCount => $composableBuilder(
    column: $table.bestCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lifetimeTotal => $composableBuilder(
    column: $table.lifetimeTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get brokenAt => $composableBuilder(
    column: $table.brokenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StreaksTableOrderingComposer
    extends Composer<_$AppDatabase, $StreaksTable> {
  $$StreaksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get streakType => $composableBuilder(
    column: $table.streakType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get peakId => $composableBuilder(
    column: $table.peakId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestCount => $composableBuilder(
    column: $table.bestCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lifetimeTotal => $composableBuilder(
    column: $table.lifetimeTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get brokenAt => $composableBuilder(
    column: $table.brokenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StreaksTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreaksTable> {
  $$StreaksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get streakType => $composableBuilder(
    column: $table.streakType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get peakId =>
      $composableBuilder(column: $table.peakId, builder: (column) => column);

  GeneratedColumn<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bestCount =>
      $composableBuilder(column: $table.bestCount, builder: (column) => column);

  GeneratedColumn<int> get lifetimeTotal => $composableBuilder(
    column: $table.lifetimeTotal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get brokenAt =>
      $composableBuilder(column: $table.brokenAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StreaksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StreaksTable,
          Streak,
          $$StreaksTableFilterComposer,
          $$StreaksTableOrderingComposer,
          $$StreaksTableAnnotationComposer,
          $$StreaksTableCreateCompanionBuilder,
          $$StreaksTableUpdateCompanionBuilder,
          (Streak, BaseReferences<_$AppDatabase, $StreaksTable, Streak>),
          Streak,
          PrefetchHooks Function()
        > {
  $$StreaksTableTableManager(_$AppDatabase db, $StreaksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreaksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreaksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreaksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> streakType = const Value.absent(),
                Value<int?> peakId = const Value.absent(),
                Value<int> currentCount = const Value.absent(),
                Value<int> bestCount = const Value.absent(),
                Value<int> lifetimeTotal = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> brokenAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => StreaksCompanion(
                id: id,
                streakType: streakType,
                peakId: peakId,
                currentCount: currentCount,
                bestCount: bestCount,
                lifetimeTotal: lifetimeTotal,
                startedAt: startedAt,
                brokenAt: brokenAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String streakType,
                Value<int?> peakId = const Value.absent(),
                Value<int> currentCount = const Value.absent(),
                Value<int> bestCount = const Value.absent(),
                Value<int> lifetimeTotal = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> brokenAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => StreaksCompanion.insert(
                id: id,
                streakType: streakType,
                peakId: peakId,
                currentCount: currentCount,
                bestCount: bestCount,
                lifetimeTotal: lifetimeTotal,
                startedAt: startedAt,
                brokenAt: brokenAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StreaksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StreaksTable,
      Streak,
      $$StreaksTableFilterComposer,
      $$StreaksTableOrderingComposer,
      $$StreaksTableAnnotationComposer,
      $$StreaksTableCreateCompanionBuilder,
      $$StreaksTableUpdateCompanionBuilder,
      (Streak, BaseReferences<_$AppDatabase, $StreaksTable, Streak>),
      Streak,
      PrefetchHooks Function()
    >;
typedef $$StreakHistoriesTableCreateCompanionBuilder =
    StreakHistoriesCompanion Function({
      Value<int> id,
      required String streakType,
      Value<int?> peakId,
      required int length,
      required DateTime startedAt,
      required DateTime endedAt,
      Value<int?> brokenBy,
    });
typedef $$StreakHistoriesTableUpdateCompanionBuilder =
    StreakHistoriesCompanion Function({
      Value<int> id,
      Value<String> streakType,
      Value<int?> peakId,
      Value<int> length,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<int?> brokenBy,
    });

class $$StreakHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $StreakHistoriesTable> {
  $$StreakHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get streakType => $composableBuilder(
    column: $table.streakType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get peakId => $composableBuilder(
    column: $table.peakId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get length => $composableBuilder(
    column: $table.length,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get brokenBy => $composableBuilder(
    column: $table.brokenBy,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StreakHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StreakHistoriesTable> {
  $$StreakHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get streakType => $composableBuilder(
    column: $table.streakType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get peakId => $composableBuilder(
    column: $table.peakId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get length => $composableBuilder(
    column: $table.length,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get brokenBy => $composableBuilder(
    column: $table.brokenBy,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StreakHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreakHistoriesTable> {
  $$StreakHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get streakType => $composableBuilder(
    column: $table.streakType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get peakId =>
      $composableBuilder(column: $table.peakId, builder: (column) => column);

  GeneratedColumn<int> get length =>
      $composableBuilder(column: $table.length, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get brokenBy =>
      $composableBuilder(column: $table.brokenBy, builder: (column) => column);
}

class $$StreakHistoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StreakHistoriesTable,
          StreakHistory,
          $$StreakHistoriesTableFilterComposer,
          $$StreakHistoriesTableOrderingComposer,
          $$StreakHistoriesTableAnnotationComposer,
          $$StreakHistoriesTableCreateCompanionBuilder,
          $$StreakHistoriesTableUpdateCompanionBuilder,
          (
            StreakHistory,
            BaseReferences<_$AppDatabase, $StreakHistoriesTable, StreakHistory>,
          ),
          StreakHistory,
          PrefetchHooks Function()
        > {
  $$StreakHistoriesTableTableManager(
    _$AppDatabase db,
    $StreakHistoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreakHistoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreakHistoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreakHistoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> streakType = const Value.absent(),
                Value<int?> peakId = const Value.absent(),
                Value<int> length = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int?> brokenBy = const Value.absent(),
              }) => StreakHistoriesCompanion(
                id: id,
                streakType: streakType,
                peakId: peakId,
                length: length,
                startedAt: startedAt,
                endedAt: endedAt,
                brokenBy: brokenBy,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String streakType,
                Value<int?> peakId = const Value.absent(),
                required int length,
                required DateTime startedAt,
                required DateTime endedAt,
                Value<int?> brokenBy = const Value.absent(),
              }) => StreakHistoriesCompanion.insert(
                id: id,
                streakType: streakType,
                peakId: peakId,
                length: length,
                startedAt: startedAt,
                endedAt: endedAt,
                brokenBy: brokenBy,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StreakHistoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StreakHistoriesTable,
      StreakHistory,
      $$StreakHistoriesTableFilterComposer,
      $$StreakHistoriesTableOrderingComposer,
      $$StreakHistoriesTableAnnotationComposer,
      $$StreakHistoriesTableCreateCompanionBuilder,
      $$StreakHistoriesTableUpdateCompanionBuilder,
      (
        StreakHistory,
        BaseReferences<_$AppDatabase, $StreakHistoriesTable, StreakHistory>,
      ),
      StreakHistory,
      PrefetchHooks Function()
    >;
typedef $$DailyScoresTableCreateCompanionBuilder =
    DailyScoresCompanion Function({
      Value<int> id,
      required DateTime date,
      required int dayOfWeek,
      Value<double> streakScore,
      Value<double> confidenceIndex,
      Value<double> selfControlRating,
      Value<double> vulnerabilityIndex,
      Value<String> triggerSensitivity,
      Value<double> recoveryMomentum,
      Value<String> downstreamImpact,
      Value<String?> riskProfileHash,
      required String dayType,
      Value<int> slipsToday,
      Value<int> urgesToday,
      Value<bool> hadSlipYesterday,
    });
typedef $$DailyScoresTableUpdateCompanionBuilder =
    DailyScoresCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> dayOfWeek,
      Value<double> streakScore,
      Value<double> confidenceIndex,
      Value<double> selfControlRating,
      Value<double> vulnerabilityIndex,
      Value<String> triggerSensitivity,
      Value<double> recoveryMomentum,
      Value<String> downstreamImpact,
      Value<String?> riskProfileHash,
      Value<String> dayType,
      Value<int> slipsToday,
      Value<int> urgesToday,
      Value<bool> hadSlipYesterday,
    });

class $$DailyScoresTableFilterComposer
    extends Composer<_$AppDatabase, $DailyScoresTable> {
  $$DailyScoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get streakScore => $composableBuilder(
    column: $table.streakScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidenceIndex => $composableBuilder(
    column: $table.confidenceIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get selfControlRating => $composableBuilder(
    column: $table.selfControlRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get vulnerabilityIndex => $composableBuilder(
    column: $table.vulnerabilityIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggerSensitivity => $composableBuilder(
    column: $table.triggerSensitivity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get recoveryMomentum => $composableBuilder(
    column: $table.recoveryMomentum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get downstreamImpact => $composableBuilder(
    column: $table.downstreamImpact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get riskProfileHash => $composableBuilder(
    column: $table.riskProfileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayType => $composableBuilder(
    column: $table.dayType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get slipsToday => $composableBuilder(
    column: $table.slipsToday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urgesToday => $composableBuilder(
    column: $table.urgesToday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hadSlipYesterday => $composableBuilder(
    column: $table.hadSlipYesterday,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyScoresTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyScoresTable> {
  $$DailyScoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get streakScore => $composableBuilder(
    column: $table.streakScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidenceIndex => $composableBuilder(
    column: $table.confidenceIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get selfControlRating => $composableBuilder(
    column: $table.selfControlRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get vulnerabilityIndex => $composableBuilder(
    column: $table.vulnerabilityIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggerSensitivity => $composableBuilder(
    column: $table.triggerSensitivity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get recoveryMomentum => $composableBuilder(
    column: $table.recoveryMomentum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get downstreamImpact => $composableBuilder(
    column: $table.downstreamImpact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get riskProfileHash => $composableBuilder(
    column: $table.riskProfileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayType => $composableBuilder(
    column: $table.dayType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get slipsToday => $composableBuilder(
    column: $table.slipsToday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urgesToday => $composableBuilder(
    column: $table.urgesToday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hadSlipYesterday => $composableBuilder(
    column: $table.hadSlipYesterday,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyScoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyScoresTable> {
  $$DailyScoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<double> get streakScore => $composableBuilder(
    column: $table.streakScore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidenceIndex => $composableBuilder(
    column: $table.confidenceIndex,
    builder: (column) => column,
  );

  GeneratedColumn<double> get selfControlRating => $composableBuilder(
    column: $table.selfControlRating,
    builder: (column) => column,
  );

  GeneratedColumn<double> get vulnerabilityIndex => $composableBuilder(
    column: $table.vulnerabilityIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get triggerSensitivity => $composableBuilder(
    column: $table.triggerSensitivity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get recoveryMomentum => $composableBuilder(
    column: $table.recoveryMomentum,
    builder: (column) => column,
  );

  GeneratedColumn<String> get downstreamImpact => $composableBuilder(
    column: $table.downstreamImpact,
    builder: (column) => column,
  );

  GeneratedColumn<String> get riskProfileHash => $composableBuilder(
    column: $table.riskProfileHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dayType =>
      $composableBuilder(column: $table.dayType, builder: (column) => column);

  GeneratedColumn<int> get slipsToday => $composableBuilder(
    column: $table.slipsToday,
    builder: (column) => column,
  );

  GeneratedColumn<int> get urgesToday => $composableBuilder(
    column: $table.urgesToday,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hadSlipYesterday => $composableBuilder(
    column: $table.hadSlipYesterday,
    builder: (column) => column,
  );
}

class $$DailyScoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyScoresTable,
          DailyScore,
          $$DailyScoresTableFilterComposer,
          $$DailyScoresTableOrderingComposer,
          $$DailyScoresTableAnnotationComposer,
          $$DailyScoresTableCreateCompanionBuilder,
          $$DailyScoresTableUpdateCompanionBuilder,
          (
            DailyScore,
            BaseReferences<_$AppDatabase, $DailyScoresTable, DailyScore>,
          ),
          DailyScore,
          PrefetchHooks Function()
        > {
  $$DailyScoresTableTableManager(_$AppDatabase db, $DailyScoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyScoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyScoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyScoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> dayOfWeek = const Value.absent(),
                Value<double> streakScore = const Value.absent(),
                Value<double> confidenceIndex = const Value.absent(),
                Value<double> selfControlRating = const Value.absent(),
                Value<double> vulnerabilityIndex = const Value.absent(),
                Value<String> triggerSensitivity = const Value.absent(),
                Value<double> recoveryMomentum = const Value.absent(),
                Value<String> downstreamImpact = const Value.absent(),
                Value<String?> riskProfileHash = const Value.absent(),
                Value<String> dayType = const Value.absent(),
                Value<int> slipsToday = const Value.absent(),
                Value<int> urgesToday = const Value.absent(),
                Value<bool> hadSlipYesterday = const Value.absent(),
              }) => DailyScoresCompanion(
                id: id,
                date: date,
                dayOfWeek: dayOfWeek,
                streakScore: streakScore,
                confidenceIndex: confidenceIndex,
                selfControlRating: selfControlRating,
                vulnerabilityIndex: vulnerabilityIndex,
                triggerSensitivity: triggerSensitivity,
                recoveryMomentum: recoveryMomentum,
                downstreamImpact: downstreamImpact,
                riskProfileHash: riskProfileHash,
                dayType: dayType,
                slipsToday: slipsToday,
                urgesToday: urgesToday,
                hadSlipYesterday: hadSlipYesterday,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required int dayOfWeek,
                Value<double> streakScore = const Value.absent(),
                Value<double> confidenceIndex = const Value.absent(),
                Value<double> selfControlRating = const Value.absent(),
                Value<double> vulnerabilityIndex = const Value.absent(),
                Value<String> triggerSensitivity = const Value.absent(),
                Value<double> recoveryMomentum = const Value.absent(),
                Value<String> downstreamImpact = const Value.absent(),
                Value<String?> riskProfileHash = const Value.absent(),
                required String dayType,
                Value<int> slipsToday = const Value.absent(),
                Value<int> urgesToday = const Value.absent(),
                Value<bool> hadSlipYesterday = const Value.absent(),
              }) => DailyScoresCompanion.insert(
                id: id,
                date: date,
                dayOfWeek: dayOfWeek,
                streakScore: streakScore,
                confidenceIndex: confidenceIndex,
                selfControlRating: selfControlRating,
                vulnerabilityIndex: vulnerabilityIndex,
                triggerSensitivity: triggerSensitivity,
                recoveryMomentum: recoveryMomentum,
                downstreamImpact: downstreamImpact,
                riskProfileHash: riskProfileHash,
                dayType: dayType,
                slipsToday: slipsToday,
                urgesToday: urgesToday,
                hadSlipYesterday: hadSlipYesterday,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyScoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyScoresTable,
      DailyScore,
      $$DailyScoresTableFilterComposer,
      $$DailyScoresTableOrderingComposer,
      $$DailyScoresTableAnnotationComposer,
      $$DailyScoresTableCreateCompanionBuilder,
      $$DailyScoresTableUpdateCompanionBuilder,
      (
        DailyScore,
        BaseReferences<_$AppDatabase, $DailyScoresTable, DailyScore>,
      ),
      DailyScore,
      PrefetchHooks Function()
    >;
typedef $$AchievementsTableCreateCompanionBuilder =
    AchievementsCompanion Function({
      Value<int> id,
      required String achievementKey,
      required String title,
      required String description,
      required String tier,
      Value<bool> unlocked,
      Value<DateTime?> unlockedAt,
      Value<bool> paused,
      Value<int> timesEarned,
    });
typedef $$AchievementsTableUpdateCompanionBuilder =
    AchievementsCompanion Function({
      Value<int> id,
      Value<String> achievementKey,
      Value<String> title,
      Value<String> description,
      Value<String> tier,
      Value<bool> unlocked,
      Value<DateTime?> unlockedAt,
      Value<bool> paused,
      Value<int> timesEarned,
    });

class $$AchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get achievementKey => $composableBuilder(
    column: $table.achievementKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get unlocked => $composableBuilder(
    column: $table.unlocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get paused => $composableBuilder(
    column: $table.paused,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesEarned => $composableBuilder(
    column: $table.timesEarned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get achievementKey => $composableBuilder(
    column: $table.achievementKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get unlocked => $composableBuilder(
    column: $table.unlocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get paused => $composableBuilder(
    column: $table.paused,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesEarned => $composableBuilder(
    column: $table.timesEarned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get achievementKey => $composableBuilder(
    column: $table.achievementKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<bool> get unlocked =>
      $composableBuilder(column: $table.unlocked, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get paused =>
      $composableBuilder(column: $table.paused, builder: (column) => column);

  GeneratedColumn<int> get timesEarned => $composableBuilder(
    column: $table.timesEarned,
    builder: (column) => column,
  );
}

class $$AchievementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AchievementsTable,
          Achievement,
          $$AchievementsTableFilterComposer,
          $$AchievementsTableOrderingComposer,
          $$AchievementsTableAnnotationComposer,
          $$AchievementsTableCreateCompanionBuilder,
          $$AchievementsTableUpdateCompanionBuilder,
          (
            Achievement,
            BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>,
          ),
          Achievement,
          PrefetchHooks Function()
        > {
  $$AchievementsTableTableManager(_$AppDatabase db, $AchievementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> achievementKey = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> tier = const Value.absent(),
                Value<bool> unlocked = const Value.absent(),
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<bool> paused = const Value.absent(),
                Value<int> timesEarned = const Value.absent(),
              }) => AchievementsCompanion(
                id: id,
                achievementKey: achievementKey,
                title: title,
                description: description,
                tier: tier,
                unlocked: unlocked,
                unlockedAt: unlockedAt,
                paused: paused,
                timesEarned: timesEarned,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String achievementKey,
                required String title,
                required String description,
                required String tier,
                Value<bool> unlocked = const Value.absent(),
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<bool> paused = const Value.absent(),
                Value<int> timesEarned = const Value.absent(),
              }) => AchievementsCompanion.insert(
                id: id,
                achievementKey: achievementKey,
                title: title,
                description: description,
                tier: tier,
                unlocked: unlocked,
                unlockedAt: unlockedAt,
                paused: paused,
                timesEarned: timesEarned,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AchievementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AchievementsTable,
      Achievement,
      $$AchievementsTableFilterComposer,
      $$AchievementsTableOrderingComposer,
      $$AchievementsTableAnnotationComposer,
      $$AchievementsTableCreateCompanionBuilder,
      $$AchievementsTableUpdateCompanionBuilder,
      (
        Achievement,
        BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>,
      ),
      Achievement,
      PrefetchHooks Function()
    >;
typedef $$DiversionTasksTableCreateCompanionBuilder =
    DiversionTasksCompanion Function({
      Value<int> id,
      required String taskName,
      required String category,
      required int minDurationSeconds,
      required int maxDurationSeconds,
      Value<String> contextFit,
      Value<int> timesUsed,
      Value<int> timesSucceeded,
      Value<double> effectivenessRate,
    });
typedef $$DiversionTasksTableUpdateCompanionBuilder =
    DiversionTasksCompanion Function({
      Value<int> id,
      Value<String> taskName,
      Value<String> category,
      Value<int> minDurationSeconds,
      Value<int> maxDurationSeconds,
      Value<String> contextFit,
      Value<int> timesUsed,
      Value<int> timesSucceeded,
      Value<double> effectivenessRate,
    });

class $$DiversionTasksTableFilterComposer
    extends Composer<_$AppDatabase, $DiversionTasksTable> {
  $$DiversionTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskName => $composableBuilder(
    column: $table.taskName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minDurationSeconds => $composableBuilder(
    column: $table.minDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxDurationSeconds => $composableBuilder(
    column: $table.maxDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextFit => $composableBuilder(
    column: $table.contextFit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesUsed => $composableBuilder(
    column: $table.timesUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesSucceeded => $composableBuilder(
    column: $table.timesSucceeded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get effectivenessRate => $composableBuilder(
    column: $table.effectivenessRate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiversionTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $DiversionTasksTable> {
  $$DiversionTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskName => $composableBuilder(
    column: $table.taskName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minDurationSeconds => $composableBuilder(
    column: $table.minDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxDurationSeconds => $composableBuilder(
    column: $table.maxDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextFit => $composableBuilder(
    column: $table.contextFit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesUsed => $composableBuilder(
    column: $table.timesUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesSucceeded => $composableBuilder(
    column: $table.timesSucceeded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get effectivenessRate => $composableBuilder(
    column: $table.effectivenessRate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiversionTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiversionTasksTable> {
  $$DiversionTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskName =>
      $composableBuilder(column: $table.taskName, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get minDurationSeconds => $composableBuilder(
    column: $table.minDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxDurationSeconds => $composableBuilder(
    column: $table.maxDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contextFit => $composableBuilder(
    column: $table.contextFit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timesUsed =>
      $composableBuilder(column: $table.timesUsed, builder: (column) => column);

  GeneratedColumn<int> get timesSucceeded => $composableBuilder(
    column: $table.timesSucceeded,
    builder: (column) => column,
  );

  GeneratedColumn<double> get effectivenessRate => $composableBuilder(
    column: $table.effectivenessRate,
    builder: (column) => column,
  );
}

class $$DiversionTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiversionTasksTable,
          DiversionTask,
          $$DiversionTasksTableFilterComposer,
          $$DiversionTasksTableOrderingComposer,
          $$DiversionTasksTableAnnotationComposer,
          $$DiversionTasksTableCreateCompanionBuilder,
          $$DiversionTasksTableUpdateCompanionBuilder,
          (
            DiversionTask,
            BaseReferences<_$AppDatabase, $DiversionTasksTable, DiversionTask>,
          ),
          DiversionTask,
          PrefetchHooks Function()
        > {
  $$DiversionTasksTableTableManager(
    _$AppDatabase db,
    $DiversionTasksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiversionTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiversionTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiversionTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> taskName = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> minDurationSeconds = const Value.absent(),
                Value<int> maxDurationSeconds = const Value.absent(),
                Value<String> contextFit = const Value.absent(),
                Value<int> timesUsed = const Value.absent(),
                Value<int> timesSucceeded = const Value.absent(),
                Value<double> effectivenessRate = const Value.absent(),
              }) => DiversionTasksCompanion(
                id: id,
                taskName: taskName,
                category: category,
                minDurationSeconds: minDurationSeconds,
                maxDurationSeconds: maxDurationSeconds,
                contextFit: contextFit,
                timesUsed: timesUsed,
                timesSucceeded: timesSucceeded,
                effectivenessRate: effectivenessRate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String taskName,
                required String category,
                required int minDurationSeconds,
                required int maxDurationSeconds,
                Value<String> contextFit = const Value.absent(),
                Value<int> timesUsed = const Value.absent(),
                Value<int> timesSucceeded = const Value.absent(),
                Value<double> effectivenessRate = const Value.absent(),
              }) => DiversionTasksCompanion.insert(
                id: id,
                taskName: taskName,
                category: category,
                minDurationSeconds: minDurationSeconds,
                maxDurationSeconds: maxDurationSeconds,
                contextFit: contextFit,
                timesUsed: timesUsed,
                timesSucceeded: timesSucceeded,
                effectivenessRate: effectivenessRate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiversionTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiversionTasksTable,
      DiversionTask,
      $$DiversionTasksTableFilterComposer,
      $$DiversionTasksTableOrderingComposer,
      $$DiversionTasksTableAnnotationComposer,
      $$DiversionTasksTableCreateCompanionBuilder,
      $$DiversionTasksTableUpdateCompanionBuilder,
      (
        DiversionTask,
        BaseReferences<_$AppDatabase, $DiversionTasksTable, DiversionTask>,
      ),
      DiversionTask,
      PrefetchHooks Function()
    >;
typedef $$WeeklyReviewsTableCreateCompanionBuilder =
    WeeklyReviewsCompanion Function({
      Value<int> id,
      required DateTime weekStart,
      Value<int> urgeCount,
      Value<int> slipCount,
      Value<double> avgSleep,
      Value<double> avgStress,
      Value<double> streakScoreStart,
      Value<double> streakScoreEnd,
      Value<double> confidenceStart,
      Value<double> confidenceEnd,
      Value<String> topTriggers,
      Value<String> topInterventions,
      Value<String> riskWindowsChanged,
      Value<String> planAdjustments,
      Value<String?> planText,
      Value<String> momentum,
    });
typedef $$WeeklyReviewsTableUpdateCompanionBuilder =
    WeeklyReviewsCompanion Function({
      Value<int> id,
      Value<DateTime> weekStart,
      Value<int> urgeCount,
      Value<int> slipCount,
      Value<double> avgSleep,
      Value<double> avgStress,
      Value<double> streakScoreStart,
      Value<double> streakScoreEnd,
      Value<double> confidenceStart,
      Value<double> confidenceEnd,
      Value<String> topTriggers,
      Value<String> topInterventions,
      Value<String> riskWindowsChanged,
      Value<String> planAdjustments,
      Value<String?> planText,
      Value<String> momentum,
    });

class $$WeeklyReviewsTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyReviewsTable> {
  $$WeeklyReviewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urgeCount => $composableBuilder(
    column: $table.urgeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get slipCount => $composableBuilder(
    column: $table.slipCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgSleep => $composableBuilder(
    column: $table.avgSleep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgStress => $composableBuilder(
    column: $table.avgStress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get streakScoreStart => $composableBuilder(
    column: $table.streakScoreStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get streakScoreEnd => $composableBuilder(
    column: $table.streakScoreEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidenceStart => $composableBuilder(
    column: $table.confidenceStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidenceEnd => $composableBuilder(
    column: $table.confidenceEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topTriggers => $composableBuilder(
    column: $table.topTriggers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topInterventions => $composableBuilder(
    column: $table.topInterventions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get riskWindowsChanged => $composableBuilder(
    column: $table.riskWindowsChanged,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planAdjustments => $composableBuilder(
    column: $table.planAdjustments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planText => $composableBuilder(
    column: $table.planText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get momentum => $composableBuilder(
    column: $table.momentum,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyReviewsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyReviewsTable> {
  $$WeeklyReviewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urgeCount => $composableBuilder(
    column: $table.urgeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get slipCount => $composableBuilder(
    column: $table.slipCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgSleep => $composableBuilder(
    column: $table.avgSleep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgStress => $composableBuilder(
    column: $table.avgStress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get streakScoreStart => $composableBuilder(
    column: $table.streakScoreStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get streakScoreEnd => $composableBuilder(
    column: $table.streakScoreEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidenceStart => $composableBuilder(
    column: $table.confidenceStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidenceEnd => $composableBuilder(
    column: $table.confidenceEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topTriggers => $composableBuilder(
    column: $table.topTriggers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topInterventions => $composableBuilder(
    column: $table.topInterventions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get riskWindowsChanged => $composableBuilder(
    column: $table.riskWindowsChanged,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planAdjustments => $composableBuilder(
    column: $table.planAdjustments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planText => $composableBuilder(
    column: $table.planText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get momentum => $composableBuilder(
    column: $table.momentum,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyReviewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyReviewsTable> {
  $$WeeklyReviewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get weekStart =>
      $composableBuilder(column: $table.weekStart, builder: (column) => column);

  GeneratedColumn<int> get urgeCount =>
      $composableBuilder(column: $table.urgeCount, builder: (column) => column);

  GeneratedColumn<int> get slipCount =>
      $composableBuilder(column: $table.slipCount, builder: (column) => column);

  GeneratedColumn<double> get avgSleep =>
      $composableBuilder(column: $table.avgSleep, builder: (column) => column);

  GeneratedColumn<double> get avgStress =>
      $composableBuilder(column: $table.avgStress, builder: (column) => column);

  GeneratedColumn<double> get streakScoreStart => $composableBuilder(
    column: $table.streakScoreStart,
    builder: (column) => column,
  );

  GeneratedColumn<double> get streakScoreEnd => $composableBuilder(
    column: $table.streakScoreEnd,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidenceStart => $composableBuilder(
    column: $table.confidenceStart,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidenceEnd => $composableBuilder(
    column: $table.confidenceEnd,
    builder: (column) => column,
  );

  GeneratedColumn<String> get topTriggers => $composableBuilder(
    column: $table.topTriggers,
    builder: (column) => column,
  );

  GeneratedColumn<String> get topInterventions => $composableBuilder(
    column: $table.topInterventions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get riskWindowsChanged => $composableBuilder(
    column: $table.riskWindowsChanged,
    builder: (column) => column,
  );

  GeneratedColumn<String> get planAdjustments => $composableBuilder(
    column: $table.planAdjustments,
    builder: (column) => column,
  );

  GeneratedColumn<String> get planText =>
      $composableBuilder(column: $table.planText, builder: (column) => column);

  GeneratedColumn<String> get momentum =>
      $composableBuilder(column: $table.momentum, builder: (column) => column);
}

class $$WeeklyReviewsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyReviewsTable,
          WeeklyReview,
          $$WeeklyReviewsTableFilterComposer,
          $$WeeklyReviewsTableOrderingComposer,
          $$WeeklyReviewsTableAnnotationComposer,
          $$WeeklyReviewsTableCreateCompanionBuilder,
          $$WeeklyReviewsTableUpdateCompanionBuilder,
          (
            WeeklyReview,
            BaseReferences<_$AppDatabase, $WeeklyReviewsTable, WeeklyReview>,
          ),
          WeeklyReview,
          PrefetchHooks Function()
        > {
  $$WeeklyReviewsTableTableManager(_$AppDatabase db, $WeeklyReviewsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyReviewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyReviewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyReviewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> weekStart = const Value.absent(),
                Value<int> urgeCount = const Value.absent(),
                Value<int> slipCount = const Value.absent(),
                Value<double> avgSleep = const Value.absent(),
                Value<double> avgStress = const Value.absent(),
                Value<double> streakScoreStart = const Value.absent(),
                Value<double> streakScoreEnd = const Value.absent(),
                Value<double> confidenceStart = const Value.absent(),
                Value<double> confidenceEnd = const Value.absent(),
                Value<String> topTriggers = const Value.absent(),
                Value<String> topInterventions = const Value.absent(),
                Value<String> riskWindowsChanged = const Value.absent(),
                Value<String> planAdjustments = const Value.absent(),
                Value<String?> planText = const Value.absent(),
                Value<String> momentum = const Value.absent(),
              }) => WeeklyReviewsCompanion(
                id: id,
                weekStart: weekStart,
                urgeCount: urgeCount,
                slipCount: slipCount,
                avgSleep: avgSleep,
                avgStress: avgStress,
                streakScoreStart: streakScoreStart,
                streakScoreEnd: streakScoreEnd,
                confidenceStart: confidenceStart,
                confidenceEnd: confidenceEnd,
                topTriggers: topTriggers,
                topInterventions: topInterventions,
                riskWindowsChanged: riskWindowsChanged,
                planAdjustments: planAdjustments,
                planText: planText,
                momentum: momentum,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime weekStart,
                Value<int> urgeCount = const Value.absent(),
                Value<int> slipCount = const Value.absent(),
                Value<double> avgSleep = const Value.absent(),
                Value<double> avgStress = const Value.absent(),
                Value<double> streakScoreStart = const Value.absent(),
                Value<double> streakScoreEnd = const Value.absent(),
                Value<double> confidenceStart = const Value.absent(),
                Value<double> confidenceEnd = const Value.absent(),
                Value<String> topTriggers = const Value.absent(),
                Value<String> topInterventions = const Value.absent(),
                Value<String> riskWindowsChanged = const Value.absent(),
                Value<String> planAdjustments = const Value.absent(),
                Value<String?> planText = const Value.absent(),
                Value<String> momentum = const Value.absent(),
              }) => WeeklyReviewsCompanion.insert(
                id: id,
                weekStart: weekStart,
                urgeCount: urgeCount,
                slipCount: slipCount,
                avgSleep: avgSleep,
                avgStress: avgStress,
                streakScoreStart: streakScoreStart,
                streakScoreEnd: streakScoreEnd,
                confidenceStart: confidenceStart,
                confidenceEnd: confidenceEnd,
                topTriggers: topTriggers,
                topInterventions: topInterventions,
                riskWindowsChanged: riskWindowsChanged,
                planAdjustments: planAdjustments,
                planText: planText,
                momentum: momentum,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyReviewsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyReviewsTable,
      WeeklyReview,
      $$WeeklyReviewsTableFilterComposer,
      $$WeeklyReviewsTableOrderingComposer,
      $$WeeklyReviewsTableAnnotationComposer,
      $$WeeklyReviewsTableCreateCompanionBuilder,
      $$WeeklyReviewsTableUpdateCompanionBuilder,
      (
        WeeklyReview,
        BaseReferences<_$AppDatabase, $WeeklyReviewsTable, WeeklyReview>,
      ),
      WeeklyReview,
      PrefetchHooks Function()
    >;
typedef $$ProgressiveProfilesTableCreateCompanionBuilder =
    ProgressiveProfilesCompanion Function({
      Value<int> id,
      Value<String?> relationshipStatus,
      Value<String?> mentalHealthFlag,
      Value<String?> exerciseLevel,
      Value<String> previousQuitMethods,
      Value<String> collectedAt,
    });
typedef $$ProgressiveProfilesTableUpdateCompanionBuilder =
    ProgressiveProfilesCompanion Function({
      Value<int> id,
      Value<String?> relationshipStatus,
      Value<String?> mentalHealthFlag,
      Value<String?> exerciseLevel,
      Value<String> previousQuitMethods,
      Value<String> collectedAt,
    });

class $$ProgressiveProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressiveProfilesTable> {
  $$ProgressiveProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relationshipStatus => $composableBuilder(
    column: $table.relationshipStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mentalHealthFlag => $composableBuilder(
    column: $table.mentalHealthFlag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseLevel => $composableBuilder(
    column: $table.exerciseLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previousQuitMethods => $composableBuilder(
    column: $table.previousQuitMethods,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get collectedAt => $composableBuilder(
    column: $table.collectedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProgressiveProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressiveProfilesTable> {
  $$ProgressiveProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationshipStatus => $composableBuilder(
    column: $table.relationshipStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mentalHealthFlag => $composableBuilder(
    column: $table.mentalHealthFlag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseLevel => $composableBuilder(
    column: $table.exerciseLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousQuitMethods => $composableBuilder(
    column: $table.previousQuitMethods,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get collectedAt => $composableBuilder(
    column: $table.collectedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgressiveProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressiveProfilesTable> {
  $$ProgressiveProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get relationshipStatus => $composableBuilder(
    column: $table.relationshipStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mentalHealthFlag => $composableBuilder(
    column: $table.mentalHealthFlag,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseLevel => $composableBuilder(
    column: $table.exerciseLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get previousQuitMethods => $composableBuilder(
    column: $table.previousQuitMethods,
    builder: (column) => column,
  );

  GeneratedColumn<String> get collectedAt => $composableBuilder(
    column: $table.collectedAt,
    builder: (column) => column,
  );
}

class $$ProgressiveProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgressiveProfilesTable,
          ProgressiveProfile,
          $$ProgressiveProfilesTableFilterComposer,
          $$ProgressiveProfilesTableOrderingComposer,
          $$ProgressiveProfilesTableAnnotationComposer,
          $$ProgressiveProfilesTableCreateCompanionBuilder,
          $$ProgressiveProfilesTableUpdateCompanionBuilder,
          (
            ProgressiveProfile,
            BaseReferences<
              _$AppDatabase,
              $ProgressiveProfilesTable,
              ProgressiveProfile
            >,
          ),
          ProgressiveProfile,
          PrefetchHooks Function()
        > {
  $$ProgressiveProfilesTableTableManager(
    _$AppDatabase db,
    $ProgressiveProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressiveProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressiveProfilesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ProgressiveProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> relationshipStatus = const Value.absent(),
                Value<String?> mentalHealthFlag = const Value.absent(),
                Value<String?> exerciseLevel = const Value.absent(),
                Value<String> previousQuitMethods = const Value.absent(),
                Value<String> collectedAt = const Value.absent(),
              }) => ProgressiveProfilesCompanion(
                id: id,
                relationshipStatus: relationshipStatus,
                mentalHealthFlag: mentalHealthFlag,
                exerciseLevel: exerciseLevel,
                previousQuitMethods: previousQuitMethods,
                collectedAt: collectedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> relationshipStatus = const Value.absent(),
                Value<String?> mentalHealthFlag = const Value.absent(),
                Value<String?> exerciseLevel = const Value.absent(),
                Value<String> previousQuitMethods = const Value.absent(),
                Value<String> collectedAt = const Value.absent(),
              }) => ProgressiveProfilesCompanion.insert(
                id: id,
                relationshipStatus: relationshipStatus,
                mentalHealthFlag: mentalHealthFlag,
                exerciseLevel: exerciseLevel,
                previousQuitMethods: previousQuitMethods,
                collectedAt: collectedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProgressiveProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgressiveProfilesTable,
      ProgressiveProfile,
      $$ProgressiveProfilesTableFilterComposer,
      $$ProgressiveProfilesTableOrderingComposer,
      $$ProgressiveProfilesTableAnnotationComposer,
      $$ProgressiveProfilesTableCreateCompanionBuilder,
      $$ProgressiveProfilesTableUpdateCompanionBuilder,
      (
        ProgressiveProfile,
        BaseReferences<
          _$AppDatabase,
          $ProgressiveProfilesTable,
          ProgressiveProfile
        >,
      ),
      ProgressiveProfile,
      PrefetchHooks Function()
    >;
typedef $$ProgramProgressesTableCreateCompanionBuilder =
    ProgramProgressesCompanion Function({
      Value<int> id,
      Value<int> currentWeek,
      Value<String> currentPhase,
      Value<String> programType,
      Value<String> modulesCompleted,
      Value<String> boundariesSet,
      Value<double> adherenceRate,
      Value<double> paceModifier,
      Value<String> adjustmentsLog,
      Value<DateTime?> graduatedAt,
      Value<String?> graduationOutcome,
    });
typedef $$ProgramProgressesTableUpdateCompanionBuilder =
    ProgramProgressesCompanion Function({
      Value<int> id,
      Value<int> currentWeek,
      Value<String> currentPhase,
      Value<String> programType,
      Value<String> modulesCompleted,
      Value<String> boundariesSet,
      Value<double> adherenceRate,
      Value<double> paceModifier,
      Value<String> adjustmentsLog,
      Value<DateTime?> graduatedAt,
      Value<String?> graduationOutcome,
    });

class $$ProgramProgressesTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramProgressesTable> {
  $$ProgramProgressesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentWeek => $composableBuilder(
    column: $table.currentWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentPhase => $composableBuilder(
    column: $table.currentPhase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get programType => $composableBuilder(
    column: $table.programType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modulesCompleted => $composableBuilder(
    column: $table.modulesCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get boundariesSet => $composableBuilder(
    column: $table.boundariesSet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get adherenceRate => $composableBuilder(
    column: $table.adherenceRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paceModifier => $composableBuilder(
    column: $table.paceModifier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adjustmentsLog => $composableBuilder(
    column: $table.adjustmentsLog,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get graduatedAt => $composableBuilder(
    column: $table.graduatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get graduationOutcome => $composableBuilder(
    column: $table.graduationOutcome,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProgramProgressesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramProgressesTable> {
  $$ProgramProgressesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentWeek => $composableBuilder(
    column: $table.currentWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentPhase => $composableBuilder(
    column: $table.currentPhase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get programType => $composableBuilder(
    column: $table.programType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modulesCompleted => $composableBuilder(
    column: $table.modulesCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get boundariesSet => $composableBuilder(
    column: $table.boundariesSet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get adherenceRate => $composableBuilder(
    column: $table.adherenceRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paceModifier => $composableBuilder(
    column: $table.paceModifier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adjustmentsLog => $composableBuilder(
    column: $table.adjustmentsLog,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get graduatedAt => $composableBuilder(
    column: $table.graduatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get graduationOutcome => $composableBuilder(
    column: $table.graduationOutcome,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgramProgressesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramProgressesTable> {
  $$ProgramProgressesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentWeek => $composableBuilder(
    column: $table.currentWeek,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentPhase => $composableBuilder(
    column: $table.currentPhase,
    builder: (column) => column,
  );

  GeneratedColumn<String> get programType => $composableBuilder(
    column: $table.programType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modulesCompleted => $composableBuilder(
    column: $table.modulesCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get boundariesSet => $composableBuilder(
    column: $table.boundariesSet,
    builder: (column) => column,
  );

  GeneratedColumn<double> get adherenceRate => $composableBuilder(
    column: $table.adherenceRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get paceModifier => $composableBuilder(
    column: $table.paceModifier,
    builder: (column) => column,
  );

  GeneratedColumn<String> get adjustmentsLog => $composableBuilder(
    column: $table.adjustmentsLog,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get graduatedAt => $composableBuilder(
    column: $table.graduatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get graduationOutcome => $composableBuilder(
    column: $table.graduationOutcome,
    builder: (column) => column,
  );
}

class $$ProgramProgressesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgramProgressesTable,
          ProgramProgressesData,
          $$ProgramProgressesTableFilterComposer,
          $$ProgramProgressesTableOrderingComposer,
          $$ProgramProgressesTableAnnotationComposer,
          $$ProgramProgressesTableCreateCompanionBuilder,
          $$ProgramProgressesTableUpdateCompanionBuilder,
          (
            ProgramProgressesData,
            BaseReferences<
              _$AppDatabase,
              $ProgramProgressesTable,
              ProgramProgressesData
            >,
          ),
          ProgramProgressesData,
          PrefetchHooks Function()
        > {
  $$ProgramProgressesTableTableManager(
    _$AppDatabase db,
    $ProgramProgressesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramProgressesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramProgressesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramProgressesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> currentWeek = const Value.absent(),
                Value<String> currentPhase = const Value.absent(),
                Value<String> programType = const Value.absent(),
                Value<String> modulesCompleted = const Value.absent(),
                Value<String> boundariesSet = const Value.absent(),
                Value<double> adherenceRate = const Value.absent(),
                Value<double> paceModifier = const Value.absent(),
                Value<String> adjustmentsLog = const Value.absent(),
                Value<DateTime?> graduatedAt = const Value.absent(),
                Value<String?> graduationOutcome = const Value.absent(),
              }) => ProgramProgressesCompanion(
                id: id,
                currentWeek: currentWeek,
                currentPhase: currentPhase,
                programType: programType,
                modulesCompleted: modulesCompleted,
                boundariesSet: boundariesSet,
                adherenceRate: adherenceRate,
                paceModifier: paceModifier,
                adjustmentsLog: adjustmentsLog,
                graduatedAt: graduatedAt,
                graduationOutcome: graduationOutcome,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> currentWeek = const Value.absent(),
                Value<String> currentPhase = const Value.absent(),
                Value<String> programType = const Value.absent(),
                Value<String> modulesCompleted = const Value.absent(),
                Value<String> boundariesSet = const Value.absent(),
                Value<double> adherenceRate = const Value.absent(),
                Value<double> paceModifier = const Value.absent(),
                Value<String> adjustmentsLog = const Value.absent(),
                Value<DateTime?> graduatedAt = const Value.absent(),
                Value<String?> graduationOutcome = const Value.absent(),
              }) => ProgramProgressesCompanion.insert(
                id: id,
                currentWeek: currentWeek,
                currentPhase: currentPhase,
                programType: programType,
                modulesCompleted: modulesCompleted,
                boundariesSet: boundariesSet,
                adherenceRate: adherenceRate,
                paceModifier: paceModifier,
                adjustmentsLog: adjustmentsLog,
                graduatedAt: graduatedAt,
                graduationOutcome: graduationOutcome,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProgramProgressesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgramProgressesTable,
      ProgramProgressesData,
      $$ProgramProgressesTableFilterComposer,
      $$ProgramProgressesTableOrderingComposer,
      $$ProgramProgressesTableAnnotationComposer,
      $$ProgramProgressesTableCreateCompanionBuilder,
      $$ProgramProgressesTableUpdateCompanionBuilder,
      (
        ProgramProgressesData,
        BaseReferences<
          _$AppDatabase,
          $ProgramProgressesTable,
          ProgramProgressesData
        >,
      ),
      ProgramProgressesData,
      PrefetchHooks Function()
    >;
typedef $$MaintenanceStatesTableCreateCompanionBuilder =
    MaintenanceStatesCompanion Function({
      Value<int> id,
      Value<String> mode,
      Value<String> checkinCadence,
      Value<String> notificationLevel,
      Value<String> regressionFlags,
      Value<DateTime?> lastQuarterlyReview,
      Value<int> lifetimeCleanDays,
      Value<int> lifetimeUrgesResisted,
      Value<int> lifetimeRescuesCompleted,
      Value<double> recoveryScore,
      Value<DateTime> updatedAt,
    });
typedef $$MaintenanceStatesTableUpdateCompanionBuilder =
    MaintenanceStatesCompanion Function({
      Value<int> id,
      Value<String> mode,
      Value<String> checkinCadence,
      Value<String> notificationLevel,
      Value<String> regressionFlags,
      Value<DateTime?> lastQuarterlyReview,
      Value<int> lifetimeCleanDays,
      Value<int> lifetimeUrgesResisted,
      Value<int> lifetimeRescuesCompleted,
      Value<double> recoveryScore,
      Value<DateTime> updatedAt,
    });

class $$MaintenanceStatesTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceStatesTable> {
  $$MaintenanceStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkinCadence => $composableBuilder(
    column: $table.checkinCadence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notificationLevel => $composableBuilder(
    column: $table.notificationLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regressionFlags => $composableBuilder(
    column: $table.regressionFlags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastQuarterlyReview => $composableBuilder(
    column: $table.lastQuarterlyReview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lifetimeCleanDays => $composableBuilder(
    column: $table.lifetimeCleanDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lifetimeUrgesResisted => $composableBuilder(
    column: $table.lifetimeUrgesResisted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lifetimeRescuesCompleted => $composableBuilder(
    column: $table.lifetimeRescuesCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get recoveryScore => $composableBuilder(
    column: $table.recoveryScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MaintenanceStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceStatesTable> {
  $$MaintenanceStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkinCadence => $composableBuilder(
    column: $table.checkinCadence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notificationLevel => $composableBuilder(
    column: $table.notificationLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regressionFlags => $composableBuilder(
    column: $table.regressionFlags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastQuarterlyReview => $composableBuilder(
    column: $table.lastQuarterlyReview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lifetimeCleanDays => $composableBuilder(
    column: $table.lifetimeCleanDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lifetimeUrgesResisted => $composableBuilder(
    column: $table.lifetimeUrgesResisted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lifetimeRescuesCompleted => $composableBuilder(
    column: $table.lifetimeRescuesCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get recoveryScore => $composableBuilder(
    column: $table.recoveryScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MaintenanceStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceStatesTable> {
  $$MaintenanceStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get checkinCadence => $composableBuilder(
    column: $table.checkinCadence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notificationLevel => $composableBuilder(
    column: $table.notificationLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get regressionFlags => $composableBuilder(
    column: $table.regressionFlags,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastQuarterlyReview => $composableBuilder(
    column: $table.lastQuarterlyReview,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lifetimeCleanDays => $composableBuilder(
    column: $table.lifetimeCleanDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lifetimeUrgesResisted => $composableBuilder(
    column: $table.lifetimeUrgesResisted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lifetimeRescuesCompleted => $composableBuilder(
    column: $table.lifetimeRescuesCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<double> get recoveryScore => $composableBuilder(
    column: $table.recoveryScore,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MaintenanceStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaintenanceStatesTable,
          MaintenanceState,
          $$MaintenanceStatesTableFilterComposer,
          $$MaintenanceStatesTableOrderingComposer,
          $$MaintenanceStatesTableAnnotationComposer,
          $$MaintenanceStatesTableCreateCompanionBuilder,
          $$MaintenanceStatesTableUpdateCompanionBuilder,
          (
            MaintenanceState,
            BaseReferences<
              _$AppDatabase,
              $MaintenanceStatesTable,
              MaintenanceState
            >,
          ),
          MaintenanceState,
          PrefetchHooks Function()
        > {
  $$MaintenanceStatesTableTableManager(
    _$AppDatabase db,
    $MaintenanceStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceStatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String> checkinCadence = const Value.absent(),
                Value<String> notificationLevel = const Value.absent(),
                Value<String> regressionFlags = const Value.absent(),
                Value<DateTime?> lastQuarterlyReview = const Value.absent(),
                Value<int> lifetimeCleanDays = const Value.absent(),
                Value<int> lifetimeUrgesResisted = const Value.absent(),
                Value<int> lifetimeRescuesCompleted = const Value.absent(),
                Value<double> recoveryScore = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MaintenanceStatesCompanion(
                id: id,
                mode: mode,
                checkinCadence: checkinCadence,
                notificationLevel: notificationLevel,
                regressionFlags: regressionFlags,
                lastQuarterlyReview: lastQuarterlyReview,
                lifetimeCleanDays: lifetimeCleanDays,
                lifetimeUrgesResisted: lifetimeUrgesResisted,
                lifetimeRescuesCompleted: lifetimeRescuesCompleted,
                recoveryScore: recoveryScore,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String> checkinCadence = const Value.absent(),
                Value<String> notificationLevel = const Value.absent(),
                Value<String> regressionFlags = const Value.absent(),
                Value<DateTime?> lastQuarterlyReview = const Value.absent(),
                Value<int> lifetimeCleanDays = const Value.absent(),
                Value<int> lifetimeUrgesResisted = const Value.absent(),
                Value<int> lifetimeRescuesCompleted = const Value.absent(),
                Value<double> recoveryScore = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MaintenanceStatesCompanion.insert(
                id: id,
                mode: mode,
                checkinCadence: checkinCadence,
                notificationLevel: notificationLevel,
                regressionFlags: regressionFlags,
                lastQuarterlyReview: lastQuarterlyReview,
                lifetimeCleanDays: lifetimeCleanDays,
                lifetimeUrgesResisted: lifetimeUrgesResisted,
                lifetimeRescuesCompleted: lifetimeRescuesCompleted,
                recoveryScore: recoveryScore,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MaintenanceStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaintenanceStatesTable,
      MaintenanceState,
      $$MaintenanceStatesTableFilterComposer,
      $$MaintenanceStatesTableOrderingComposer,
      $$MaintenanceStatesTableAnnotationComposer,
      $$MaintenanceStatesTableCreateCompanionBuilder,
      $$MaintenanceStatesTableUpdateCompanionBuilder,
      (
        MaintenanceState,
        BaseReferences<
          _$AppDatabase,
          $MaintenanceStatesTable,
          MaintenanceState
        >,
      ),
      MaintenanceState,
      PrefetchHooks Function()
    >;
typedef $$ModelStatesTableCreateCompanionBuilder =
    ModelStatesCompanion Function({
      Value<int> id,
      required String key,
      required String value,
      Value<DateTime> updatedAt,
    });
typedef $$ModelStatesTableUpdateCompanionBuilder =
    ModelStatesCompanion Function({
      Value<int> id,
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
    });

class $$ModelStatesTableFilterComposer
    extends Composer<_$AppDatabase, $ModelStatesTable> {
  $$ModelStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ModelStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ModelStatesTable> {
  $$ModelStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ModelStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModelStatesTable> {
  $$ModelStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ModelStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ModelStatesTable,
          ModelState,
          $$ModelStatesTableFilterComposer,
          $$ModelStatesTableOrderingComposer,
          $$ModelStatesTableAnnotationComposer,
          $$ModelStatesTableCreateCompanionBuilder,
          $$ModelStatesTableUpdateCompanionBuilder,
          (
            ModelState,
            BaseReferences<_$AppDatabase, $ModelStatesTable, ModelState>,
          ),
          ModelState,
          PrefetchHooks Function()
        > {
  $$ModelStatesTableTableManager(_$AppDatabase db, $ModelStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModelStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModelStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModelStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ModelStatesCompanion(
                id: id,
                key: key,
                value: value,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                required String value,
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ModelStatesCompanion.insert(
                id: id,
                key: key,
                value: value,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ModelStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ModelStatesTable,
      ModelState,
      $$ModelStatesTableFilterComposer,
      $$ModelStatesTableOrderingComposer,
      $$ModelStatesTableAnnotationComposer,
      $$ModelStatesTableCreateCompanionBuilder,
      $$ModelStatesTableUpdateCompanionBuilder,
      (
        ModelState,
        BaseReferences<_$AppDatabase, $ModelStatesTable, ModelState>,
      ),
      ModelState,
      PrefetchHooks Function()
    >;
typedef $$PassiveUsagesTableCreateCompanionBuilder =
    PassiveUsagesCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<int> targetAppMinutes,
      Value<int> lateNightMinutes,
      Value<int> firstPickupDelayMinutes,
      Value<int> sessionCount,
      Value<double> reopenRate,
    });
typedef $$PassiveUsagesTableUpdateCompanionBuilder =
    PassiveUsagesCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> targetAppMinutes,
      Value<int> lateNightMinutes,
      Value<int> firstPickupDelayMinutes,
      Value<int> sessionCount,
      Value<double> reopenRate,
    });

class $$PassiveUsagesTableFilterComposer
    extends Composer<_$AppDatabase, $PassiveUsagesTable> {
  $$PassiveUsagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetAppMinutes => $composableBuilder(
    column: $table.targetAppMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lateNightMinutes => $composableBuilder(
    column: $table.lateNightMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstPickupDelayMinutes => $composableBuilder(
    column: $table.firstPickupDelayMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionCount => $composableBuilder(
    column: $table.sessionCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get reopenRate => $composableBuilder(
    column: $table.reopenRate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PassiveUsagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PassiveUsagesTable> {
  $$PassiveUsagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetAppMinutes => $composableBuilder(
    column: $table.targetAppMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lateNightMinutes => $composableBuilder(
    column: $table.lateNightMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstPickupDelayMinutes => $composableBuilder(
    column: $table.firstPickupDelayMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionCount => $composableBuilder(
    column: $table.sessionCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get reopenRate => $composableBuilder(
    column: $table.reopenRate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PassiveUsagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PassiveUsagesTable> {
  $$PassiveUsagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get targetAppMinutes => $composableBuilder(
    column: $table.targetAppMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lateNightMinutes => $composableBuilder(
    column: $table.lateNightMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get firstPickupDelayMinutes => $composableBuilder(
    column: $table.firstPickupDelayMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sessionCount => $composableBuilder(
    column: $table.sessionCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get reopenRate => $composableBuilder(
    column: $table.reopenRate,
    builder: (column) => column,
  );
}

class $$PassiveUsagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PassiveUsagesTable,
          PassiveUsage,
          $$PassiveUsagesTableFilterComposer,
          $$PassiveUsagesTableOrderingComposer,
          $$PassiveUsagesTableAnnotationComposer,
          $$PassiveUsagesTableCreateCompanionBuilder,
          $$PassiveUsagesTableUpdateCompanionBuilder,
          (
            PassiveUsage,
            BaseReferences<_$AppDatabase, $PassiveUsagesTable, PassiveUsage>,
          ),
          PassiveUsage,
          PrefetchHooks Function()
        > {
  $$PassiveUsagesTableTableManager(_$AppDatabase db, $PassiveUsagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PassiveUsagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PassiveUsagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PassiveUsagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> targetAppMinutes = const Value.absent(),
                Value<int> lateNightMinutes = const Value.absent(),
                Value<int> firstPickupDelayMinutes = const Value.absent(),
                Value<int> sessionCount = const Value.absent(),
                Value<double> reopenRate = const Value.absent(),
              }) => PassiveUsagesCompanion(
                id: id,
                date: date,
                targetAppMinutes: targetAppMinutes,
                lateNightMinutes: lateNightMinutes,
                firstPickupDelayMinutes: firstPickupDelayMinutes,
                sessionCount: sessionCount,
                reopenRate: reopenRate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<int> targetAppMinutes = const Value.absent(),
                Value<int> lateNightMinutes = const Value.absent(),
                Value<int> firstPickupDelayMinutes = const Value.absent(),
                Value<int> sessionCount = const Value.absent(),
                Value<double> reopenRate = const Value.absent(),
              }) => PassiveUsagesCompanion.insert(
                id: id,
                date: date,
                targetAppMinutes: targetAppMinutes,
                lateNightMinutes: lateNightMinutes,
                firstPickupDelayMinutes: firstPickupDelayMinutes,
                sessionCount: sessionCount,
                reopenRate: reopenRate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PassiveUsagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PassiveUsagesTable,
      PassiveUsage,
      $$PassiveUsagesTableFilterComposer,
      $$PassiveUsagesTableOrderingComposer,
      $$PassiveUsagesTableAnnotationComposer,
      $$PassiveUsagesTableCreateCompanionBuilder,
      $$PassiveUsagesTableUpdateCompanionBuilder,
      (
        PassiveUsage,
        BaseReferences<_$AppDatabase, $PassiveUsagesTable, PassiveUsage>,
      ),
      PassiveUsage,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$PeakNodesTableTableManager get peakNodes =>
      $$PeakNodesTableTableManager(_db, _db.peakNodes);
  $$RiskWindowsTableTableManager get riskWindows =>
      $$RiskWindowsTableTableManager(_db, _db.riskWindows);
  $$DailyCheckinsTableTableManager get dailyCheckins =>
      $$DailyCheckinsTableTableManager(_db, _db.dailyCheckins);
  $$UrgeEventsTableTableManager get urgeEvents =>
      $$UrgeEventsTableTableManager(_db, _db.urgeEvents);
  $$SlipEventsTableTableManager get slipEvents =>
      $$SlipEventsTableTableManager(_db, _db.slipEvents);
  $$InterventionLogsTableTableManager get interventionLogs =>
      $$InterventionLogsTableTableManager(_db, _db.interventionLogs);
  $$TriggerPosteriorsTableTableManager get triggerPosteriors =>
      $$TriggerPosteriorsTableTableManager(_db, _db.triggerPosteriors);
  $$StreaksTableTableManager get streaks =>
      $$StreaksTableTableManager(_db, _db.streaks);
  $$StreakHistoriesTableTableManager get streakHistories =>
      $$StreakHistoriesTableTableManager(_db, _db.streakHistories);
  $$DailyScoresTableTableManager get dailyScores =>
      $$DailyScoresTableTableManager(_db, _db.dailyScores);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
  $$DiversionTasksTableTableManager get diversionTasks =>
      $$DiversionTasksTableTableManager(_db, _db.diversionTasks);
  $$WeeklyReviewsTableTableManager get weeklyReviews =>
      $$WeeklyReviewsTableTableManager(_db, _db.weeklyReviews);
  $$ProgressiveProfilesTableTableManager get progressiveProfiles =>
      $$ProgressiveProfilesTableTableManager(_db, _db.progressiveProfiles);
  $$ProgramProgressesTableTableManager get programProgresses =>
      $$ProgramProgressesTableTableManager(_db, _db.programProgresses);
  $$MaintenanceStatesTableTableManager get maintenanceStates =>
      $$MaintenanceStatesTableTableManager(_db, _db.maintenanceStates);
  $$ModelStatesTableTableManager get modelStates =>
      $$ModelStatesTableTableManager(_db, _db.modelStates);
  $$PassiveUsagesTableTableManager get passiveUsages =>
      $$PassiveUsagesTableTableManager(_db, _db.passiveUsages);
}
