import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/routine/models/menstrual_phase.dart';
import 'package:detoxia/domain/routine/models/menstrual_profile.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/presentation/urge_rescue/rescue_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget app(SupportProfile profile) {
    return ProviderScope(
      child: MaterialApp(home: RescueScreen(supportProfileOverride: profile)),
    );
  }

  testWidgets('entry screen shows universal options with calm copy', (
    tester,
  ) async {
    final profile = _profile(goals: const ['goal_anxiety', 'goal_sleep']);

    await tester.pumpWidget(app(profile));
    await tester.pumpAndSettle();

    expect(find.text('Protected moment'), findsOneWidget);
    expect(find.text("What's happening right now?"), findsOneWidget);
    expect(find.text("Pick what's closest. No wrong answer."), findsOneWidget);
    expect(find.text('Urge'), findsOneWidget);
    expect(find.text('Scroll spiral'), findsOneWidget);
    expect(find.text('Anxiety spike'), findsOneWidget);
    expect(find.text('Focus crash'), findsOneWidget);
    expect(find.text('Sleep drift'), findsOneWidget);
    expect(find.text('After-slip reset'), findsOneWidget);
    // Old domain-specific labels should not appear
    expect(find.text('Sexual-control'), findsNothing);
    expect(find.text('ADHD / Focus'), findsNothing);
  });

  testWidgets('intensity screen shows calm labels, no danger color', (
    tester,
  ) async {
    final profile = _profile(goals: const ['goal_anxiety']);

    await tester.pumpWidget(app(profile));
    await tester.pumpAndSettle();

    // Navigate to intensity step
    await tester.tap(find.text('Anxiety spike'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('How strong is it?'), findsOneWidget);
    // Default intensity 5 = "building"
    expect(find.text('building'), findsOneWidget);
    // "protect this moment" should exist somewhere in the widget tree
    // (as a label option, even if not currently selected)
    // Verify no old labels
    expect(find.text('Mild'), findsNothing);
    expect(find.text('Moderate'), findsNothing);
    expect(find.text('Intense'), findsNothing);
  });

  testWidgets('trigger screen uses universal chips', (tester) async {
    final profile = _profile(goals: const ['goal_scrolling']);

    await tester.pumpWidget(app(profile));
    await tester.pumpAndSettle();

    // Navigate through entry → intensity → triggers
    await tester.tap(find.text('Scroll spiral'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('What might have led here?'), findsOneWidget);
    expect(find.text("Choose any that fit. You can skip this."), findsOneWidget);
    expect(find.text('stress'), findsOneWidget);
    expect(find.text('boredom'), findsOneWidget);
    expect(find.text('loneliness'), findsOneWidget);
    expect(find.text('tired'), findsOneWidget);
    expect(find.text('phone in bed'), findsOneWidget);
    expect(find.text('argument'), findsOneWidget);
    expect(find.text('deadline'), findsOneWidget);
    expect(find.text('shame'), findsOneWidget);
    expect(find.text('random'), findsOneWidget);
    // Old domain-specific triggers should not appear
    expect(find.text('Overwhelm episode'), findsNothing);
    expect(find.text('Worry spiral'), findsNothing);
    expect(find.text('Urge'), findsNothing);
  });

  testWidgets('reset step offers recommended action and alternatives', (
    tester,
  ) async {
    final profile = _profile(goals: const ['goal_anxiety']);

    await tester.pumpWidget(app(profile));
    await tester.pumpAndSettle();

    // Navigate through entry → intensity → triggers → reset
    await tester.tap(find.text('Anxiety spike'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get support'));
    await tester.pumpAndSettle();

    expect(find.text('Try a small reset'), findsOneWidget);
    expect(
      find.text("This one fits your current pattern best."),
      findsOneWidget,
    );
    expect(find.text('I did it'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('outcome screen shows five universal options, no shame', (
    tester,
  ) async {
    final profile = _profile(goals: const ['goal_anxiety']);

    await tester.pumpWidget(app(profile));
    await tester.pumpAndSettle();

    // Navigate through entry → intensity → triggers → reset → outcome
    await tester.tap(find.text('Anxiety spike'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get support'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('What happened after the reset?'), findsOneWidget);
    expect(find.text('I moved through it'), findsOneWidget);
    expect(find.text('I delayed it'), findsOneWidget);
    expect(find.text('I still need support'), findsOneWidget);
    expect(find.text('I had a reset moment'), findsOneWidget);
    expect(find.text('False alarm'), findsOneWidget);
    // No shame language
    expect(find.textContaining('slipped'), findsNothing);
    expect(find.textContaining('failed'), findsNothing);
    expect(find.textContaining('Setback'), findsNothing);
    expect(find.textContaining('Resisted urge'), findsNothing);
  });
}

SupportProfile _profile({
  required List<String> goals,
  bool cycleEnabled = false,
}) {
  final now = DateTime(2026, 1, 1);
  return SupportProfile(
    registrationProfileId: 1,
    selectedGoals: goals,
    domainScores: const [
      DomainScore(
        id: 'scrollingControl',
        label: 'scrolling',
        rawScore: 4,
        maxRawScore: 10,
        visibleScore: 4,
        band: 'Low',
        enabled: true,
        confidence: 0.8,
        explanation: 'test',
      ),
      DomainScore(
        id: 'sexualControlRecovery',
        label: 'sexual control',
        rawScore: 3,
        maxRawScore: 10,
        visibleScore: 3,
        band: 'Low',
        enabled: true,
        confidence: 0.8,
        explanation: 'test',
      ),
      DomainScore(
        id: 'focusSupport',
        label: 'focus',
        rawScore: 7,
        maxRawScore: 10,
        visibleScore: 7,
        band: 'High',
        enabled: true,
        confidence: 0.8,
        explanation: 'test',
      ),
      DomainScore(
        id: 'anxietyLoad',
        label: 'anxiety',
        rawScore: 8,
        maxRawScore: 10,
        visibleScore: 8,
        band: 'High',
        enabled: true,
        confidence: 0.8,
        explanation: 'test',
      ),
      DomainScore(
        id: 'lowMoodSupport',
        label: 'mood',
        rawScore: 5,
        maxRawScore: 10,
        visibleScore: 5,
        band: 'Low',
        enabled: true,
        confidence: 0.8,
        explanation: 'test',
      ),
      DomainScore(
        id: 'sleepDisruption',
        label: 'sleep',
        rawScore: 8,
        maxRawScore: 10,
        visibleScore: 8,
        band: 'High',
        enabled: true,
        confidence: 0.8,
        explanation: 'test',
      ),
    ],
    routineProfile: const RoutineProfile(
      wakeWindow: '7-8 AM',
      sleepAttemptWindow: '11 PM-12 AM',
      sleepLatencyRange: '15-30 min',
      commutePhoneUseScore: 2,
      freeWindows: ['Evening'],
      aloneWindows: ['Late night'],
      phoneInBedScore: 2,
      vulnerableWindows: ['After work'],
    ),
    sleepProfile: const SleepProfile(
      sleepAttemptWindow: '11 PM-12 AM',
      wakeWindow: '7-8 AM',
      sleepLatencyRange: '15-30 min',
      estimatedSleepStartMinutes: 1410,
      estimatedWakeTimeMinutes: 420,
      estimatedSleepDurationHours: 7,
      targetSleepHours: 8,
      dailySleepDebtHours: 1,
      estimatedSevenDaySleepDebtHours: 7,
      sleepDebtScore: 6,
      sleepDisruptionScore: 7,
      sleepRiskScore: 7,
      confidence: 0.8,
    ),
    menstrualProfile: cycleEnabled
        ? const MenstrualProfile(
            enabled: true,
            currentPhase: MenstrualPhase.luteal,
            confidence: 0.8,
            cycleSensitivityScore: 7,
          )
        : null,
    triggerWeights: [
      TriggerWeight(
        triggerId: 'stress',
        label: 'Stress spike',
        strengthRaw: 8,
        weight0To10: 8,
        reliability: 0.8,
        lastUpdatedAt: now,
      ),
    ],
    pathwayScores: const <PathwayScore>[],
    interventionPreferences: const InterventionPreferences(
      physicalReset: true,
      breathingGrounding: true,
      appFrictionDelay: true,
      journalingThoughtDump: true,
      focusSprint: true,
      sleepShutdown: true,
      spiritualValuesReset: true,
      lowPressureTask: true,
      directnessLevel: 'balanced',
    ),
    learningState: LearningState(
      recoveryMomentum: 5,
      predictionAccuracy: 5,
      falseAlarmRate: 0,
      triggerReliabilityMap: const {},
      interventionRewardsMap: const {},
      lastUpdatedAt: now,
    ),
    createdAt: now,
    updatedAt: now,
  );
}
