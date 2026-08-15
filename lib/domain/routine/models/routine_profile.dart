class RoutineProfile {
  final String wakeWindow;
  final String sleepAttemptWindow;
  final String sleepLatencyRange;
  final String? schoolWorkArrivalWindow;
  final String? busyStartWindow;
  final String? busyEndWindow;
  final int? commuteToDuration;
  final int? commuteBackDuration;
  final String? commuteMode;
  final int commutePhoneUseScore;
  final List<String> freeWindows;
  final List<String> aloneWindows;
  final int phoneInBedScore;
  final List<String> vulnerableWindows;

  const RoutineProfile({
    required this.wakeWindow,
    required this.sleepAttemptWindow,
    required this.sleepLatencyRange,
    this.schoolWorkArrivalWindow,
    this.busyStartWindow,
    this.busyEndWindow,
    this.commuteToDuration,
    this.commuteBackDuration,
    this.commuteMode,
    required this.commutePhoneUseScore,
    required this.freeWindows,
    required this.aloneWindows,
    required this.phoneInBedScore,
    required this.vulnerableWindows,
  });

  factory RoutineProfile.fromJson(Map<String, dynamic> json) {
    return RoutineProfile(
      wakeWindow: json['wakeWindow'] as String,
      sleepAttemptWindow: json['sleepAttemptWindow'] as String,
      sleepLatencyRange: json['sleepLatencyRange'] as String,
      schoolWorkArrivalWindow: json['schoolWorkArrivalWindow'] as String?,
      busyStartWindow: json['busyStartWindow'] as String?,
      busyEndWindow: json['busyEndWindow'] as String?,
      commuteToDuration: json['commuteToDuration'] as int?,
      commuteBackDuration: json['commuteBackDuration'] as int?,
      commuteMode: json['commuteMode'] as String?,
      commutePhoneUseScore: json['commutePhoneUseScore'] as int,
      freeWindows: List<String>.from(json['freeWindows'] as List),
      aloneWindows: List<String>.from(json['aloneWindows'] as List),
      phoneInBedScore: json['phoneInBedScore'] as int,
      vulnerableWindows: List<String>.from(json['vulnerableWindows'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'wakeWindow': wakeWindow,
      'sleepAttemptWindow': sleepAttemptWindow,
      'sleepLatencyRange': sleepLatencyRange,
      'schoolWorkArrivalWindow': schoolWorkArrivalWindow,
      'busyStartWindow': busyStartWindow,
      'busyEndWindow': busyEndWindow,
      'commuteToDuration': commuteToDuration,
      'commuteBackDuration': commuteBackDuration,
      'commuteMode': commuteMode,
      'commutePhoneUseScore': commutePhoneUseScore,
      'freeWindows': freeWindows,
      'aloneWindows': aloneWindows,
      'phoneInBedScore': phoneInBedScore,
      'vulnerableWindows': vulnerableWindows,
    };
    return json;
  }
}
