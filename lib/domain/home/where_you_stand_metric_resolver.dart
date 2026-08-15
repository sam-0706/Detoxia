import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';

class WhereYouStandMetric {
  final String id;
  final String label;
  final double value0To10;
  final String explanation;
  final bool isLocked;

  const WhereYouStandMetric({
    required this.id,
    required this.label,
    required this.value0To10,
    required this.explanation,
    required this.isLocked,
  });
}

class WhereYouStandMetricResult {
  final List<WhereYouStandMetric> metrics;
  final bool isLocked;
  final String? lockedReason;

  const WhereYouStandMetricResult({
    required this.metrics,
    required this.isLocked,
    required this.lockedReason,
  });
}

class WhereYouStandMetricResolver {
  const WhereYouStandMetricResolver();

  WhereYouStandMetricResult resolve({
    required SupportProfile? supportProfile,
    required List<Map<String, dynamic>> recentCheckins,
  }) {
    if (supportProfile == null) {
      return const WhereYouStandMetricResult(
        metrics: [],
        isLocked: true,
        lockedReason: 'Complete your support map to unlock dynamic metrics.',
      );
    }

    final goalFamilies = _goalFamilies(supportProfile.selectedGoals);
    final templates = _templatesForGoals(goalFamilies);
    final hasEnoughSignal = recentCheckins.length >= 3;

    final metrics = templates
        .map(
          (template) => WhereYouStandMetric(
            id: template.id,
            label: template.label,
            value0To10: hasEnoughSignal
                ? _valueForTemplate(template.id, supportProfile, recentCheckins)
                : 0,
            explanation: hasEnoughSignal
                ? template.explanation
                : 'More local check-ins are needed to unlock this metric.',
            isLocked: !hasEnoughSignal,
          ),
        )
        .toList(growable: false);

    return WhereYouStandMetricResult(
      metrics: metrics,
      isLocked: !hasEnoughSignal,
      lockedReason: hasEnoughSignal
          ? null
          : 'Keep checking in daily to unlock reliable metric trends.',
    );
  }

  Set<String> _goalFamilies(List<String> goals) {
    final normalized = goals
        .map((goal) => goal.toLowerCase().replaceAll('_', ''))
        .toSet();
    final families = <String>{};
    for (final goal in normalized) {
      if (goal.contains('sexual') || goal.contains('porn')) {
        families.add('sexual');
      }
      if (goal.contains('anxiety')) families.add('anxiety');
      if (goal.contains('focus') || goal.contains('adhd')) families.add('focus');
      if (goal.contains('sleep')) families.add('sleep');
      if (goal.contains('lowmood') || goal.contains('mood')) families.add('lowMood');
      if (goal.contains('scroll')) families.add('scrolling');
    }
    if (families.isEmpty) {
      families.add('general');
    }
    return families;
  }

  List<_MetricTemplate> _templatesForGoals(Set<String> goals) {
    final families = <List<_MetricTemplate>>[
      if (goals.contains('sexual')) _sexualMetrics,
      if (goals.contains('anxiety')) _anxietyMetrics,
      if (goals.contains('focus')) _focusMetrics,
      if (goals.contains('sleep')) _sleepMetrics,
      if (goals.contains('lowMood')) _lowMoodMetrics,
      if (goals.contains('scrolling')) _scrollingMetrics,
      if (goals.contains('general')) _generalMetrics,
    ];

    final deduped = <String, _MetricTemplate>{};
    for (var depth = 0; depth < 5; depth++) {
      for (final family in families) {
        if (depth >= family.length) continue;
        final metric = family[depth];
        deduped.putIfAbsent(metric.id, () => metric);
        if (deduped.length >= 5) {
          return deduped.values.toList(growable: false);
        }
      }
    }
    return deduped.values.toList(growable: false);
  }

  double _valueForTemplate(
    String metricId,
    SupportProfile profile,
    List<Map<String, dynamic>> checkins,
  ) {
    double score(String id) => _score(profile.domainScores, id);
    final momentum = profile.learningState.recoveryMomentum.clamp(0.0, 10.0);
    final avgStress = _avg(checkins, 'stress');
    final avgMood = _avg(checkins, 'mood');
    final avgSleep = _avg(checkins, 'sleepQuality');
    final confidence = _avg(checkins, 'confidenceTomorrow');

    return switch (metricId) {
      'self_control' => score('sexualControlRecovery'),
      'urge_resilience' => (10 - avgStress).clamp(0, 10),
      'trigger_exposure' => score('scrollingControl'),
      'recovery_momentum' => momentum,
      'confidence' => confidence.clamp(0, 10),
      'anxiety_load' => score('anxietyLoad'),
      'calm_recovery' => (avgMood + (10 - avgStress)) / 2,
      'worry_control' => (10 - avgStress).clamp(0, 10),
      'sleep_protection' => score('sleepDisruption'),
      'focus_control' => score('focusSupport'),
      'task_initiation' => ((score('focusSupport') + confidence) / 2).clamp(0, 10),
      'restlessness' => avgStress.clamp(0, 10),
      'routine_stability' => ((avgSleep + score('sleepDisruption')) / 2).clamp(0, 10),
      'momentum' => momentum,
      'sleep_stability' => score('sleepDisruption'),
      'sleep_debt' => score('sleepDisruption'),
      'sleep_consistency' => avgSleep.clamp(0, 10),
      'energy_recovery' => avgMood.clamp(0, 10),
      'night_risk' => avgStress.clamp(0, 10),
      'mood_stability' => score('lowMoodSupport'),
      'activation' => ((avgMood + confidence) / 2).clamp(0, 10),
      'energy' => avgMood.clamp(0, 10),
      'avoidance_risk' => avgStress.clamp(0, 10),
      'scrolling_control' => score('scrollingControl'),
      'loop_resistance' => (10 - avgStress).clamp(0, 10),
      _ => momentum,
    };
  }

  double _score(List<DomainScore> scores, String id) {
    for (final score in scores) {
      if (score.id == id && score.enabled) return score.visibleScore.clamp(0, 10);
    }
    return 0;
  }

  double _avg(List<Map<String, dynamic>> rows, String key) {
    if (rows.isEmpty) return 0;
    final values = rows
        .map((row) => (row[key] as num?)?.toDouble())
        .whereType<double>()
        .toList();
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }
}

class _MetricTemplate {
  final String id;
  final String label;
  final String explanation;

  const _MetricTemplate(this.id, this.label, this.explanation);
}

const _sexualMetrics = <_MetricTemplate>[
  _MetricTemplate('self_control', 'Awareness', 'How early you notice a support moment starting.'),
  _MetricTemplate('urge_resilience', 'Reset Speed', 'How quickly you return to a helpful next step.'),
  _MetricTemplate('trigger_exposure', 'Trigger Clarity', 'How clear your repeated patterns are becoming.'),
  _MetricTemplate('recovery_momentum', 'Recovery Momentum', 'Your current recovery direction from local outcomes.'),
  _MetricTemplate('confidence', 'Confidence', 'How confident you feel about tomorrow.'),
];

const _anxietyMetrics = <_MetricTemplate>[
  _MetricTemplate('anxiety_load', 'Calm Recovery', 'How often your body and attention return toward calm.'),
  _MetricTemplate('calm_recovery', 'Calm Recovery', 'How quickly you return to calm after spikes.'),
  _MetricTemplate('worry_control', 'Pattern Clarity', 'How well Detoxia can understand what tends to happen before a support moment.'),
  _MetricTemplate('sleep_protection', 'Sleep Protection', 'How well sleep patterns are shielding your calm.'),
  _MetricTemplate('confidence', 'Confidence', 'How confident you feel about tomorrow.'),
];

const _focusMetrics = <_MetricTemplate>[
  _MetricTemplate('focus_control', 'Focus Flow', 'How often you can return to the next small task.'),
  _MetricTemplate('task_initiation', 'Task Momentum', 'How often you can begin again without forcing the whole day.'),
  _MetricTemplate('restlessness', 'Rest Energy', 'How supported your body feels during focus and rest moments.'),
  _MetricTemplate('routine_stability', 'Routine Strength', 'How steadily your daily structure holds.'),
  _MetricTemplate('momentum', 'Momentum', 'Current forward momentum from recent outcomes.'),
];

const _sleepMetrics = <_MetricTemplate>[
  _MetricTemplate('sleep_stability', 'Sleep Rhythm', 'How steady your sleep timing is right now.'),
  _MetricTemplate('sleep_debt', 'Sleep Recovery', 'How well your recent sleep is supporting the next day.'),
  _MetricTemplate('sleep_consistency', 'Sleep Consistency', 'How consistent your recent sleep quality has been.'),
  _MetricTemplate('energy_recovery', 'Energy Recovery', 'How well sleep is restoring daytime energy.'),
  _MetricTemplate('night_risk', 'Evening Support', 'How protected your evening routine is becoming.'),
];

const _lowMoodMetrics = <_MetricTemplate>[
  _MetricTemplate('mood_stability', 'Mood Balance', 'How steady your mood has been recently.'),
  _MetricTemplate('activation', 'Activation', 'How often you take meaningful small actions.'),
  _MetricTemplate('energy', 'Energy', 'Your current usable energy level.'),
  _MetricTemplate('avoidance_risk', 'Protection Gap', 'Where a little more support may help next.'),
  _MetricTemplate('momentum', 'Momentum', 'Current momentum from recent outcomes.'),
];

const _scrollingMetrics = <_MetricTemplate>[
  _MetricTemplate('scrolling_control', 'Scroll Awareness', 'How well you notice looping patterns.'),
  _MetricTemplate('loop_resistance', 'Loop Pause', 'How often you can pause before the loop deepens.'),
  _MetricTemplate('trigger_exposure', 'Trigger Clarity', 'How clear your repeated patterns are becoming.'),
  _MetricTemplate('recovery_momentum', 'Recovery Momentum', 'Current direction of your awareness trend.'),
  _MetricTemplate('confidence', 'Confidence', 'How confident you feel about tomorrow.'),
];

const _generalMetrics = <_MetricTemplate>[
  _MetricTemplate('confidence', 'Confidence', 'How confident you feel about tomorrow.'),
  _MetricTemplate('recovery_momentum', 'Recovery Momentum', 'Current trend from local outcomes.'),
  _MetricTemplate('routine_stability', 'Routine Strength', 'How steadily your daily structure holds.'),
  _MetricTemplate('sleep_consistency', 'Sleep Consistency', 'How consistent your recent sleep quality has been.'),
  _MetricTemplate('calm_recovery', 'Calm Recovery', 'How quickly you return to baseline after stress.'),
];
