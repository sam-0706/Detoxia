class AppConstants {
  AppConstants._();

  static const String appName = 'Detoxia';
  static const int blockDurationMinutes = 30;
  static const int blocksPerDay = 48;
  static const int daysPerWeek = 7;
  static const int totalWeeklyBlocks = blocksPerDay * daysPerWeek;

  static const double initialAlpha = 0.0;
  static const double day7Alpha = 0.3;
  static const double day14Alpha = 0.5;
  static const double day21Alpha = 0.7;
  static const double day30Alpha = 0.85;

  static const double w1TimeWindow = 0.30;
  static const double w2Trigger = 0.25;
  static const double w3Context = 0.20;
  static const double w4Habit = 0.15;
  static const double w5State = 0.10;

  static const double baseDecayRate = 0.12;
  static const double cascadeMultiplierStep = 0.25;
  static const double streakHabitReductionMax = 0.30;
  static const double vulnerabilityMultiplier = 1.3;

  static const int maxNotificationsStrict = 5;
  static const int maxNotificationsBalanced = 3;
  static const int maxNotificationsGentle = 1;

  static const int onboardingMaxTaps = 22;
  static const int rescueFlowMaxTaps = 3;
  static const int programWeeks = 12;
  static const int boosterWeeks = 4;
}
