import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';

class WeeklyReviewMetric {
  final String label;
  final String value;
  final String helper;

  const WeeklyReviewMetric({
    required this.label,
    required this.value,
    required this.helper,
  });
}

class WeeklyReviewDayBar {
  final String dayLabel;
  final double value0To10;

  const WeeklyReviewDayBar({
    required this.dayLabel,
    required this.value0To10,
  });
}

class AdaptiveWeeklyReview {
  final bool isLocked;
  final String title;
  final String subtitle;
  final String impactTitle;
  final String impactBody;
  final List<WeeklyReviewMetric> metrics;
  final List<WeeklyReviewDayBar> trendBars;
  final String topDriverText;
  final String bestProtectedText;
  final String triggerChainText;
  final String supportWindowsText;
  final String bestResetText;
  final String patternText;
  final String experimentText;

  const AdaptiveWeeklyReview({
    required this.isLocked,
    required this.title,
    required this.subtitle,
    required this.impactTitle,
    required this.impactBody,
    required this.metrics,
    required this.trendBars,
    required this.topDriverText,
    this.bestProtectedText = '',
    this.triggerChainText = '',
    this.supportWindowsText = '',
    this.bestResetText = '',
    this.patternText = '',
    this.experimentText = '',
  });
}

class AdaptiveWeeklyReviewResolver {
  const AdaptiveWeeklyReviewResolver();

  AdaptiveWeeklyReview resolve({
    required SupportProfile? supportProfile,
    required List<Map<String, dynamic>> checkins,
    required int urgesLast7Days,
    required int slipsLast7Days,
    required int completedTasksLast7Days,
  }) {
    if (supportProfile == null || checkins.length < 4) {
      return const AdaptiveWeeklyReview(
        isLocked: true,
        title: 'Your Weekly Reflection',
        subtitle: 'A calm look at what protected you and what needs support.',
        impactTitle: 'Weekly reflection',
        impactBody:
            'Complete at least 4 check-ins this week to unlock your reflection.',
        metrics: <WeeklyReviewMetric>[],
        trendBars: <WeeklyReviewDayBar>[],
        topDriverText: 'Not enough local data yet.',
      );
    }

    final families = _goalFamilies(supportProfile.selectedGoals);
    final primary = families.isEmpty ? 'general' : families.first;
    final avgStress = _avg(checkins, 'stress');
    final avgMood = _avg(checkins, 'mood');
    final avgSleep = _avg(checkins, 'sleepQuality');
    final avgConfidence = _avg(checkins, 'confidenceTomorrow');
    final roughWindows = checkins.where((row) => _num(row['stress']) >= 7).length;
    final lowEnergyDays = checkins.where((row) => _num(row['mood']) <= 4).length;
    final sleepDisruptions = checkins.where((row) => _num(row['sleepQuality']) <= 4).length;
    final hadUrges = checkins.where((row) => row['hadUrge'] == true).length;
    final slippedDays = checkins.where((row) => row['slipped'] == true).length;
    final resisted = (urgesLast7Days - slipsLast7Days).clamp(0, urgesLast7Days);

    final metrics = switch (primary) {
      'anxiety' => <WeeklyReviewMetric>[
          WeeklyReviewMetric(
            label: 'Calm recovery',
            value: avgStress.toStringAsFixed(1),
            helper: '/10 from local check-ins',
          ),
          WeeklyReviewMetric(
            label: 'Support windows',
            value: '$roughWindows',
            helper: 'Windows needing support this week',
          ),
          WeeklyReviewMetric(
            label: 'Reset actions',
            value: '$completedTasksLast7Days',
            helper: 'Completed support actions',
          ),
        ],
      'focus' => <WeeklyReviewMetric>[
          WeeklyReviewMetric(
            label: 'Focus blocks',
            value: '$completedTasksLast7Days',
            helper: 'Completed tasks this week',
          ),
          WeeklyReviewMetric(
            label: 'Task momentum',
            value: _percent(checkins.length - lowEnergyDays, checkins.length),
            helper: 'Days with enough energy to start',
          ),
          WeeklyReviewMetric(
            label: 'Task-start support',
            value: '$roughWindows',
            helper: 'Moments needing a small push',
          ),
        ],
      'sleep' => <WeeklyReviewMetric>[
          WeeklyReviewMetric(
            label: 'Sleep rhythm',
            value: avgSleep.toStringAsFixed(1),
            helper: '/10 average sleep quality',
          ),
          WeeklyReviewMetric(
            label: 'Sleep interruptions',
            value: '$sleepDisruptions',
            helper: 'Check-ins with poor sleep',
          ),
          WeeklyReviewMetric(
            label: 'Evening support',
            value: avgStress.toStringAsFixed(1),
            helper: 'Late-window support signal',
          ),
        ],
      'scrolling' => <WeeklyReviewMetric>[
          WeeklyReviewMetric(
            label: 'Scroll moments',
            value: '$hadUrges',
            helper: 'Urge-like loop episodes',
          ),
          WeeklyReviewMetric(
            label: 'Loops paused',
            value: '$resisted',
            helper: 'Protected moments this week',
          ),
          WeeklyReviewMetric(
            label: 'Support windows',
            value: '$roughWindows',
            helper: 'Windows needing extra support',
          ),
        ],
      'sexual' => <WeeklyReviewMetric>[
          WeeklyReviewMetric(
            label: 'Urge signals',
            value: '$urgesLast7Days',
            helper: 'Logged urges this week',
          ),
          WeeklyReviewMetric(
            label: 'Urges moved through',
            value: '$resisted',
            helper: 'Protected moments',
          ),
          WeeklyReviewMetric(
            label: 'Reset moments',
            value: '$slipsLast7Days',
            helper: 'Moments to learn from',
          ),
        ],
      'lowMood' => <WeeklyReviewMetric>[
          WeeklyReviewMetric(
            label: 'Actions taken',
            value: '$completedTasksLast7Days',
            helper: 'Completed support actions',
          ),
          WeeklyReviewMetric(
            label: 'Low-energy days',
            value: '$lowEnergyDays',
            helper: 'Days needing lighter support',
          ),
          WeeklyReviewMetric(
            label: 'Protection gap',
            value: '$slippedDays',
            helper: 'Days where momentum dipped',
          ),
        ],
      _ => <WeeklyReviewMetric>[
          WeeklyReviewMetric(
            label: 'Check-ins',
            value: '${checkins.length}',
            helper: 'Weekly local check-ins',
          ),
          WeeklyReviewMetric(
            label: 'Support tasks',
            value: '$completedTasksLast7Days',
            helper: 'Completed this week',
          ),
          WeeklyReviewMetric(
            label: 'Recovery momentum',
            value: supportProfile.learningState.recoveryMomentum.toStringAsFixed(1),
            helper: '/10',
          ),
        ],
    };

    final impactTitle = switch (primary) {
      'anxiety' => 'How your support windows evolved',
      'focus' => 'How your focus evolved this week',
      'sleep' => 'How your sleep rhythm evolved',
      'scrolling' => 'How your scroll patterns evolved',
      'sexual' => 'How your protected moments evolved',
      'lowMood' => 'How your energy evolved this week',
      _ => 'How your momentum evolved',
    };

    final impactBody = 'From your local check-ins this week.';

    final trendBars = _bars(checkins, primary);
    final topDriver = _topDriver(supportProfile);

    // Derived fields for the new reflection sections
    final bestProtected = _bestProtectedSignal(
      completedTasksLast7Days, slipsLast7Days, checkins.length, supportProfile);
    final triggerChain = _triggerChainText(supportProfile);
    final supportWindows = _supportWindowsText(supportProfile, roughWindows, primary);
    final bestReset = _bestResetText(supportProfile);
    final pattern = _patternText(supportProfile, primary);
    final experiment = _experimentText(primary);

    return AdaptiveWeeklyReview(
      isLocked: false,
      title: 'Your Weekly Reflection',
      subtitle: 'A calm look at what protected you and what needs support.',
      impactTitle: impactTitle,
      impactBody: impactBody,
      metrics: metrics,
      trendBars: trendBars,
      topDriverText: topDriver,
      bestProtectedText: bestProtected,
      triggerChainText: triggerChain,
      supportWindowsText: supportWindows,
      bestResetText: bestReset,
      patternText: pattern,
      experimentText: experiment,
    );
  }

  // ── New reflection helpers ───────────────────────────────────────────

  String _bestProtectedSignal(int tasks, int slips, int checkinCount,
      SupportProfile profile) {
    if (tasks >= 3) {
      return 'You completed $tasks support actions this week. '
          'Those small choices added up.';
    }
    if (checkinCount >= 5) {
      return 'Checking in $checkinCount times this week kept your pattern visible.';
    }
    if (profile.learningState.recoveryMomentum >= 6) {
      return 'Your recovery momentum is holding steady. '
          'Consistency is quietly building.';
    }
    return 'A clearer signal will appear after a few more check-ins and resets.';
  }

  String _triggerChainText(SupportProfile profile) {
    if (profile.triggerWeights.isEmpty) {
      return 'A clearer pattern will appear after a few more check-ins and resets.';
    }
    final sorted = [...profile.triggerWeights]
      ..sort((a, b) => b.weight0To10.compareTo(a.weight0To10));
    final labels = sorted.take(3).map((t) => t.label.toLowerCase()).toList();
    return labels.join(' → ');
  }

  String _supportWindowsText(SupportProfile profile, int roughWindows,
      String family) {
    final windows = profile.routineProfile.vulnerableWindows;
    if (windows.isEmpty && roughWindows == 0) {
      return 'Your support windows will become clearer with more local data.';
    }
    if (windows.isNotEmpty) {
      return '${windows.join(', ')}${roughWindows > 0 ? ' — $roughWindows moments needed support' : ''}.';
    }
    return '$roughWindows moments needed extra support this week.';
  }

  String _bestResetText(SupportProfile profile) {
    final rewards = profile.learningState.interventionRewardsMap;
    if (rewards.isEmpty) {
      return 'Your best working reset will appear after you complete a few more protected moments.';
    }
    final entries = rewards.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final best = entries.first;
    if (best.value <= 0) {
      return 'Keep trying different resets. One will click.';
    }
    return 'Your top reset is helping. Small actions are building your pattern.';
  }

  String _patternText(SupportProfile profile, String family) {
    final triggers = profile.triggerWeights;
    final windows = profile.routineProfile.vulnerableWindows;
    final sleepDebt = profile.sleepProfile.dailySleepDebtHours;

    if (triggers.isEmpty && windows.isEmpty) {
      return 'Your patterns will become clearer as you check in more consistently.';
    }

    TriggerWeight? topTrigger;
    if (triggers.isNotEmpty) {
      final sorted = [...triggers]..sort((a, b) => b.weight0To10.compareTo(a.weight0To10));
      topTrigger = sorted.first;
    }
    final triggerLabel = topTrigger?.label.toLowerCase() ?? '';

    if (sleepDebt >= 2 && triggerLabel.isNotEmpty) {
      return '$triggerLabel after low sleep seems worth protecting.';
    }
    if (windows.isNotEmpty && triggerLabel.isNotEmpty) {
      return '$triggerLabel during ${windows.first.toLowerCase()} windows is worth watching.';
    }
    if (triggerLabel.isNotEmpty) {
      return '$triggerLabel appears to be your strongest signal right now.';
    }
    return 'Your data is building. Keep checking in.';
  }

  String _experimentText(String family) {
    return switch (family) {
      'anxiety' => 'Try a 60-second breathing reset before your next stressful window.',
      'focus' => 'Try starting just one small task before checking your phone.',
      'sleep' => 'Try putting your phone away 30 minutes before bed twice this week.',
      'scrolling' => 'Try a 5-minute phone-away reset when you first notice the loop.',
      'sexual' => 'Try one grounding exercise when you feel the first urge signal.',
      'lowMood' => 'Try one tiny action — even 2 minutes counts.',
      _ => 'Try completing one small reset each day this week.',
    };
  }

  // ── Existing helpers (unchanged) ─────────────────────────────────────

  List<String> _goalFamilies(List<String> goals) {
    final normalized = goals.map((goal) => goal.toLowerCase().replaceAll('_', '')).toList();
    final families = <String>[];
    bool add(String key) {
      if (families.contains(key)) return false;
      families.add(key);
      return true;
    }

    for (final goal in normalized) {
      if (goal.contains('anxiety')) add('anxiety');
      if (goal.contains('focus') || goal.contains('adhd')) add('focus');
      if (goal.contains('sleep')) add('sleep');
      if (goal.contains('scroll')) add('scrolling');
      if (goal.contains('sexual') || goal.contains('porn')) add('sexual');
      if (goal.contains('lowmood') || goal.contains('mood')) add('lowMood');
    }
    return families;
  }

  List<WeeklyReviewDayBar> _bars(List<Map<String, dynamic>> checkins, String family) {
    final ordered = List<Map<String, dynamic>>.from(checkins)
      ..sort((a, b) => (_asDate(a['date']) ?? DateTime(1970))
          .compareTo(_asDate(b['date']) ?? DateTime(1970)));
    final last7 = ordered.length <= 7 ? ordered : ordered.sublist(ordered.length - 7);

    return last7.map((row) {
      final day = _asDate(row['date']);
      final label = day == null ? '-' : _shortDay(day.weekday);
      final value = (switch (family) {
        'anxiety' => _num(row['stress']).clamp(0, 10),
        'focus' => (10 - _num(row['stress'])).clamp(0, 10),
        'sleep' => _num(row['sleepQuality']).clamp(0, 10),
        'scrolling' => (row['hadUrge'] == true ? 7.0 : 3.0),
        'sexual' => (row['slipped'] == true ? 8.0 : 3.0),
        'lowMood' => _num(row['mood']).clamp(0, 10),
        _ => _num(row['confidenceTomorrow']).clamp(0, 10),
      })
          .toDouble();
      return WeeklyReviewDayBar(dayLabel: label, value0To10: value);
    }).toList(growable: false);
  }

  String _topDriver(SupportProfile profile) {
    if (profile.triggerWeights.isEmpty) return 'No driver signal yet.';
    final sorted = [...profile.triggerWeights]
      ..sort((a, b) => b.weight0To10.compareTo(a.weight0To10));
    final top = sorted.first;
    return '${top.label} appears to be your strongest driver this week.';
  }

  String _percent(int numerator, int denominator) {
    if (denominator <= 0) return '0%';
    final pct = (numerator / denominator * 100).round();
    return '$pct%';
  }

  double _avg(List<Map<String, dynamic>> rows, String key) {
    if (rows.isEmpty) return 0;
    final values = rows.map((row) => _num(row[key])).toList(growable: false);
    return values.reduce((a, b) => a + b) / values.length;
  }

  double _num(dynamic value) {
    if (value is num) return value.toDouble();
    return 0;
  }

  DateTime? _asDate(dynamic value) {
    if (value is DateTime) return value;
    return null;
  }

  String _shortDay(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(weekday - 1).clamp(0, 6)];
  }
}
