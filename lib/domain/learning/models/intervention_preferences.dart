class InterventionPreferences {
  final bool physicalReset;
  final bool breathingGrounding;
  final bool appFrictionDelay;
  final bool journalingThoughtDump;
  final bool focusSprint;
  final bool sleepShutdown;
  final bool spiritualValuesReset;
  final bool lowPressureTask;
  final String directnessLevel;

  const InterventionPreferences({
    required this.physicalReset,
    required this.breathingGrounding,
    required this.appFrictionDelay,
    required this.journalingThoughtDump,
    required this.focusSprint,
    required this.sleepShutdown,
    required this.spiritualValuesReset,
    required this.lowPressureTask,
    required this.directnessLevel,
  });

  factory InterventionPreferences.fromJson(Map<String, dynamic> json) {
    return InterventionPreferences(
      physicalReset: json['physicalReset'] as bool,
      breathingGrounding: json['breathingGrounding'] as bool,
      appFrictionDelay: json['appFrictionDelay'] as bool,
      journalingThoughtDump: json['journalingThoughtDump'] as bool,
      focusSprint: json['focusSprint'] as bool,
      sleepShutdown: json['sleepShutdown'] as bool,
      spiritualValuesReset: json['spiritualValuesReset'] as bool,
      lowPressureTask: json['lowPressureTask'] as bool,
      directnessLevel: json['directnessLevel'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'physicalReset': physicalReset,
      'breathingGrounding': breathingGrounding,
      'appFrictionDelay': appFrictionDelay,
      'journalingThoughtDump': journalingThoughtDump,
      'focusSprint': focusSprint,
      'sleepShutdown': sleepShutdown,
      'spiritualValuesReset': spiritualValuesReset,
      'lowPressureTask': lowPressureTask,
      'directnessLevel': directnessLevel,
    };
  }
}
