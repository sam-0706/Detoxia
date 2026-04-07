import 'package:detoxia/core/constants/enums.dart';

class AchievementDef {
  final String key;
  final String title;
  final String description;
  final String insight;
  final AchievementTier tier;
  final bool Function(AchievementContext ctx) condition;

  const AchievementDef({
    required this.key,
    required this.title,
    required this.description,
    required this.insight,
    required this.tier,
    required this.condition,
  });
}

class AchievementContext {
  final int cleanStreak;
  final int urgesResisted;
  final int sleepBoundaryStreak;
  final int checkinStreak;
  final int rescuesCompleted;
  final int weekendCleanCount;
  final int coldWaterSuccesses;
  final double confidenceIndex;
  final double sleepQualityAvg;

  const AchievementContext({
    this.cleanStreak = 0,
    this.urgesResisted = 0,
    this.sleepBoundaryStreak = 0,
    this.checkinStreak = 0,
    this.rescuesCompleted = 0,
    this.weekendCleanCount = 0,
    this.coldWaterSuccesses = 0,
    this.confidenceIndex = 0,
    this.sleepQualityAvg = 0,
  });
}

class AchievementRegistry {
  static List<AchievementDef> get all => [
        AchievementDef(
          key: 'first_step',
          title: 'First Step',
          description: 'Completed onboarding and first check-in',
          insight: 'The hardest part is starting. You did it.',
          tier: AchievementTier.milestone,
          condition: (ctx) => ctx.checkinStreak >= 1,
        ),
        AchievementDef(
          key: 'day_3',
          title: 'Getting Started',
          description: '3 consecutive clean days',
          insight:
              'Your brain is beginning to notice the change in pattern.',
          tier: AchievementTier.streak,
          condition: (ctx) => ctx.cleanStreak >= 3,
        ),
        AchievementDef(
          key: 'day_7',
          title: 'One Week Strong',
          description: '7-day clean streak',
          insight:
              'Research shows cue-reactivity begins to weaken after '
              'the first week.',
          tier: AchievementTier.streak,
          condition: (ctx) => ctx.cleanStreak >= 7,
        ),
        AchievementDef(
          key: 'day_14',
          title: 'Two Weeks',
          description: '14-day clean streak',
          insight:
              'Your impulse control center is measurably stronger.',
          tier: AchievementTier.streak,
          condition: (ctx) => ctx.cleanStreak >= 14,
        ),
        AchievementDef(
          key: 'day_21',
          title: 'Habit Breaker',
          description: '21-day clean streak',
          insight:
              'The old automatic loop is losing its grip.',
          tier: AchievementTier.streak,
          condition: (ctx) => ctx.cleanStreak >= 21,
        ),
        AchievementDef(
          key: 'day_30',
          title: 'One Month',
          description: '30-day clean streak',
          insight: 'This is measurable, real progress.',
          tier: AchievementTier.streak,
          condition: (ctx) => ctx.cleanStreak >= 30,
        ),
        AchievementDef(
          key: 'day_60',
          title: 'Two Months',
          description: '60-day clean streak',
          insight:
              'Clinical studies show 50-60% behavior reduction '
              'at this point.',
          tier: AchievementTier.streak,
          condition: (ctx) => ctx.cleanStreak >= 60,
        ),
        AchievementDef(
          key: 'day_90',
          title: 'Quarter Year',
          description: '90-day clean streak',
          insight:
              'You are in maintenance territory. Relapse probability '
              'is at its lowest.',
          tier: AchievementTier.streak,
          condition: (ctx) => ctx.cleanStreak >= 90,
        ),
        AchievementDef(
          key: 'urge_surfer',
          title: 'Urge Surfer',
          description: 'Successfully rode out 10 urges',
          insight: 'You are learning to let waves pass.',
          tier: AchievementTier.behavioral,
          condition: (ctx) => ctx.urgesResisted >= 10,
        ),
        AchievementDef(
          key: 'night_guardian',
          title: 'Night Guardian',
          description: '7 consecutive nights respecting sleep boundary',
          insight: 'Sleep is your strongest defense.',
          tier: AchievementTier.behavioral,
          condition: (ctx) => ctx.sleepBoundaryStreak >= 7,
        ),
        AchievementDef(
          key: 'self_aware',
          title: 'Self-Aware',
          description: '14 consecutive daily check-ins',
          insight: 'Awareness is the foundation of change.',
          tier: AchievementTier.behavioral,
          condition: (ctx) => ctx.checkinStreak >= 14,
        ),
        AchievementDef(
          key: 'weekend_warrior',
          title: 'Weekend Warrior',
          description: '4 consecutive clean weekends',
          insight:
              'Weekends are where most people fail. Not you.',
          tier: AchievementTier.behavioral,
          condition: (ctx) => ctx.weekendCleanCount >= 4,
        ),
        AchievementDef(
          key: 'task_master',
          title: 'Task Master',
          description: 'Completed 20 diversion tasks',
          insight: 'You have a toolbox that works.',
          tier: AchievementTier.behavioral,
          condition: (ctx) => ctx.rescuesCompleted >= 20,
        ),
      ];
}
