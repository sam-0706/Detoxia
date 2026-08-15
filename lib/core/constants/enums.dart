enum RoleType { student, working, freelancer, notWorking }

enum BehaviorType { scrolling, porn, masturbation, combined }

enum ScrollingLinkage { always, sometimes, rarely, never }

enum Frequency { almostDaily, fewPerWeek, sometimes, weekendsOnly }

enum DayType { workDay, offDay, transitionEvening, transitionMorning }

enum StruggleDuration { lessThan6Months, sixToTwoYears, twoToFiveYears, fivePlusYears }

enum ResistAbility { rarely, sometimes, aboutHalf, usually }

enum GoalType { quit, control, reduce }

enum TriggerType {
  boredom,
  stress,
  loneliness,
  cantSleep,
  scrolling,
  justAHabit,
  other,
}

enum MotivationType {
  health,
  relationships,
  selfRespect,
  productivity,
  sleep,
  faith,
  mentalClarity,
  confidence,
}

enum StreakType { clean, scrollingControl, sleepBoundary, checkin, perPeak }

enum NotificationMode { strict, balanced, gentle }

enum ProgramPhase { baseline, interrupt, rebuild, maintain }

enum ProgramType { initial12Week, booster4Week, extended, maintenance }

enum GraduationOutcome { strong, moderate, struggling }

enum MaintenanceMode { fullMaintenance, booster, reEntry, escalated }

enum CheckinCadence { daily, optionalDaily, weekly }

enum NotificationLevel { preventionOnly, moderate, high }

enum Momentum { positive, flat, negative }

enum EventSource { realtime, checkin, backfill }

enum RelationshipStatus { single, inRelationship, married, preferNotToSay }

enum MentalHealthFlag { often, sometimes, rarely }

enum ExerciseLevel { sedentary, light, moderate, active }

enum TaskCategory {
  physical,
  breathing,
  cognitive,
  environmental,
  productive,
  social,
  valuesAnchor,
}

enum AchievementTier { streak, behavioral, milestone }

enum UrgeOutcome { passed, reduced, same, slipped }

// ─── Multi-Condition Module System ───

enum ConditionType {
  detoxRecovery,
  periodTracking,
  depression,
  anxiety,
  adhd,
  moodTracking,
}

// ─── Unified Registration / Questionnaire Gate ───

enum RegistrationAgeBand { teen13To15, teen16To17, adult18Plus }

enum RegistrationGender { male, female, preferNotToSay }

enum WebhookSyncStatus { notAttempted, success, failed, disabled }

// ─── Mood Module ───

enum MoodLevel { terrible, bad, meh, okay, good, great, amazing }

enum EnergyLevel { exhausted, tired, low, neutral, moderate, energized, wired }

// ─── Anxiety Module ───

enum BreathingTechnique {
  boxBreathing,
  breathing478,
  physiologicalSigh,
  cyclicSighing,
  extendedExhale,
  bellyBreathing,
  alternateNostril,
  resonanceBreathing,
  starfishBreathing,
  squareBreathing,
  lionsBreath,
  hummingBeeBreath,
}

enum GroundingExercise {
  sensory54321,
  bodyScan,
  progressiveMuscleRelaxation,
  iceCubeTechnique,
  butterflyHug,
  safePlaceVisualization,
  countingBackwards,
  colorFinding,
  textureTouching,
  mindfulWalking,
}

// ─── Depression Module ───

enum ActivityCategory {
  physicalActivity,
  socialConnection,
  creative,
  selfCare,
  productive,
  leisure,
  routine,
  nature,
}

enum CognitiveDistortion {
  allOrNothing,
  catastrophizing,
  mindReading,
  fortuneTelling,
  emotionalReasoning,
  shouldStatements,
  labeling,
  overgeneralization,
  discountingPositives,
  magnification,
}

// ─── ADHD Module ───

enum FocusSessionType { pomodoro25, short15, deep50, micro5 }

enum ADHDTaskPriority { mustDo, shouldDo, couldDo }

// ─── Period Module ───

enum CyclePhase { menstrual, follicular, ovulation, luteal }

enum FlowIntensity { spotting, light, medium, heavy, veryHeavy }

// ─── Daily Task Engine ───

enum WellnessTaskCategory {
  breathingExercise,
  cognitiveTask,
  physicalTask,
  socialTask,
  creativeTask,
  organizationalTask,
  selfCareTask,
  groundingExercise,
  journalingTask,
  focusTask,
  dopamineBoost,
  mindfulness,
}

enum TaskDifficulty { easy, medium, challenge }

enum TaskTimeOfDay { morning, afternoon, evening, anytime }
