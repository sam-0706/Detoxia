import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/domain/tasks/task_utility_score.dart';

enum HomeEventLanguage {
  roughWindow,
  missedFocusBlock,
  sleepDisruption,
  scrollingLoop,
  setback,
}

class GreetingState {
  final String title;
  final String dateLabel;

  const GreetingState({required this.title, required this.dateLabel});
}

class DailyCheckinState {
  final bool isDoneToday;
  final String ctaLabel;
  final String statusLabel;

  const DailyCheckinState({
    required this.isDoneToday,
    required this.ctaLabel,
    required this.statusLabel,
  });
}

class TodayInsightState {
  final String title;
  final String body;
  final bool isLocked;

  const TodayInsightState({
    required this.title,
    required this.body,
    required this.isLocked,
  });
}

class HomeDriverInsight {
  final String label;
  final List<String> affectedDomains;
  final double confidence0To1;
  final String suggestedAction;

  const HomeDriverInsight({
    required this.label,
    required this.affectedDomains,
    required this.confidence0To1,
    required this.suggestedAction,
  });
}

class HomeTaskInsight {
  final String id;
  final String title;
  final int durationMinutes;
  final String whyChosen;
  final List<String> steps;
  final String targetDriver;
  final List<String> domainTags;
  final String feedbackPrompt;
  final List<String> feedbackButtons;

  const HomeTaskInsight({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.whyChosen,
    required this.steps,
    required this.targetDriver,
    required this.domainTags,
    required this.feedbackPrompt,
    required this.feedbackButtons,
  });
}

class SupportMapPreviewState {
  final List<DomainScore> topDomains;
  final bool isLocked;

  const SupportMapPreviewState({required this.topDomains, required this.isLocked});
}

class RecoveryMomentumState {
  final double score0To10;
  final String explanation;
  final bool isExpandable;
  final bool isLocked;

  const RecoveryMomentumState({
    required this.score0To10,
    required this.explanation,
    required this.isExpandable,
    required this.isLocked,
  });
}

class RiskWindowState {
  final String summary;
  final String legend;
  final String nextWindowLabel;
  final List<String> drivers;
  final bool isLocked;

  const RiskWindowState({
    required this.summary,
    required this.legend,
    required this.nextWindowLabel,
    required this.drivers,
    required this.isLocked,
  });
}

class ResetCtaState {
  final String label;
  final HomeEventLanguage language;

  const ResetCtaState({required this.label, required this.language});
}

class HomeInsightViewModel {
  final GreetingState greeting;
  final DailyCheckinState dailyCheckin;
  final TodayInsightState todayInsight;
  final List<HomeDriverInsight> topDrivers;
  final List<HomeTaskInsight> todayTasks;
  final SupportMapPreviewState supportMapPreview;
  final RecoveryMomentumState recoveryMomentum;
  final RiskWindowState riskWindow;
  final ResetCtaState primaryResetCta;

  const HomeInsightViewModel({
    required this.greeting,
    required this.dailyCheckin,
    required this.todayInsight,
    required this.topDrivers,
    required this.todayTasks,
    required this.supportMapPreview,
    required this.recoveryMomentum,
    required this.riskWindow,
    required this.primaryResetCta,
  });
}

class HomeInsightViewModelBuilder {
  const HomeInsightViewModelBuilder();

  HomeInsightViewModel build({
    required DateTime now,
    required String? displayName,
    required bool checkedInToday,
    SupportProfile? supportProfile,
    List<Map<String, dynamic>> dailyCheckins = const [],
    List<TaskUtility> rankedTasks = const [],
  }) {
    final goals = supportProfile?.selectedGoals ?? const <String>[];
    final language = _languageForGoals(goals);
    final greeting = GreetingState(
      title: '${_greetingPrefix(now)}${_nameSuffix(displayName)}',
      dateLabel: '${_weekdayName(now.weekday)}, ${now.day}/${now.month}/${now.year}',
    );

    final dailyCheckin = DailyCheckinState(
      isDoneToday: checkedInToday,
      ctaLabel: checkedInToday ? 'Daily check-in complete' : 'Daily check-in',
      statusLabel: checkedInToday
          ? 'You are checked in for today.'
          : 'A quick check-in improves today\'s plan.',
    );

    final hasSignal = supportProfile != null;
    final todayInsight = hasSignal
        ? TodayInsightState(
            title: 'Today\'s Insight',
            body: _buildInsightBody(supportProfile, language),
            isLocked: false,
          )
        : const TodayInsightState(
            title: 'Today\'s Insight',
            body:
                'Detoxia is still learning your pattern. Complete check-ins and tasks to unlock personalized insights.',
            isLocked: true,
          );

    final topDrivers = hasSignal ? _buildTopDrivers(supportProfile) : const <HomeDriverInsight>[];
    final todayTasks = _buildTasks(rankedTasks, language);
    final supportMapPreview = SupportMapPreviewState(
      topDomains: _topDomains(supportProfile),
      isLocked: supportProfile == null,
    );

    final recoveryMomentum = hasSignal
        ? RecoveryMomentumState(
            score0To10: supportProfile.learningState.recoveryMomentum,
            explanation:
                'Momentum adjusts from your recent outcomes, check-ins, and completed support actions.',
            isExpandable: true,
            isLocked: false,
          )
        : const RecoveryMomentumState(
            score0To10: 0,
            explanation: 'Complete more check-ins to unlock momentum trends.',
            isExpandable: false,
            isLocked: true,
          );

    final riskWindow = _buildRiskWindow(
      supportProfile: supportProfile,
      dailyCheckins: dailyCheckins,
      language: language,
    );

    return HomeInsightViewModel(
      greeting: greeting,
      dailyCheckin: dailyCheckin,
      todayInsight: todayInsight,
      topDrivers: topDrivers,
      todayTasks: todayTasks,
      supportMapPreview: supportMapPreview,
      recoveryMomentum: recoveryMomentum,
      riskWindow: riskWindow,
      primaryResetCta: ResetCtaState(
        label: _resetCtaForLanguage(language),
        language: language,
      ),
    );
  }

  RiskWindowState _buildRiskWindow({
    required SupportProfile? supportProfile,
    required List<Map<String, dynamic>> dailyCheckins,
    required HomeEventLanguage language,
  }) {
    if (supportProfile == null || dailyCheckins.length < 3) {
      return const RiskWindowState(
        summary: 'Learning your support windows',
        legend: 'Low / Moderate / Elevated',
        nextWindowLabel: 'Need more local check-ins',
        drivers: <String>[],
        isLocked: true,
      );
    }

    final drivers = supportProfile.triggerWeights
        .where((trigger) => trigger.weight0To10 >= 6)
        .take(3)
        .map((trigger) => trigger.label)
        .toList(growable: false);
    final avgStress = dailyCheckins
            .map((row) => (row['stress'] as num?)?.toDouble() ?? 0)
            .fold<double>(0, (sum, value) => sum + value) /
        dailyCheckins.length;
    final riskBand = avgStress >= 7
        ? 'Higher'
        : avgStress >= 4
            ? 'Moderate'
            : 'Lower';
    final vulnerableWindows = supportProfile.routineProfile.vulnerableWindows;
    final nextWindow = vulnerableWindows.isNotEmpty
        ? vulnerableWindows.first
        : 'next vulnerable window';
    return RiskWindowState(
      summary:
          '$riskBand chance of ${_nounForLanguage(language)} in your $nextWindow window.',
      legend: 'Low / Moderate / Elevated',
      nextWindowLabel: 'Next elevated window: $nextWindow',
      drivers: drivers,
      isLocked: false,
    );
  }

  List<HomeTaskInsight> _buildTasks(
    List<TaskUtility> rankedTasks,
    HomeEventLanguage language,
  ) {
    return rankedTasks.take(4).map((utility) {
      final task = utility.task;
      return HomeTaskInsight(
        id: task['id'] as String? ?? 'task',
        title: task['title'] as String? ?? 'Support action',
        durationMinutes: task['durationMinutes'] as int? ?? 10,
        whyChosen: utility.whyChosen,
        steps: utility.steps,
        targetDriver: utility.targetDriver,
        domainTags: utility.domainTags,
        feedbackPrompt: 'Did this help right now?',
        feedbackButtons: utility.feedbackButtons,
      );
    }).toList(growable: false);
  }

  List<HomeDriverInsight> _buildTopDrivers(SupportProfile profile) {
    final sorted = profile.triggerWeights
        .where((trigger) => trigger.weight0To10 > 0)
        .toList()
      ..sort((a, b) => b.weight0To10.compareTo(a.weight0To10));
    return sorted.take(3).map((trigger) {
        return HomeDriverInsight(
          label: trigger.label,
          affectedDomains: profile.domainScores
              .where((domain) => domain.enabled)
              .take(2)
              .map((domain) => domain.label)
              .toList(growable: false),
          confidence0To1: trigger.reliability.clamp(0, 1).toDouble(),
          suggestedAction: 'Use one short reset before the next risky window.',
        );
      }).toList(growable: false);
  }

  List<DomainScore> _topDomains(SupportProfile? profile) {
    if (profile == null) return const <DomainScore>[];
    final enabled = profile.domainScores.where((score) => score.enabled).toList()
      ..sort((a, b) => b.visibleScore.compareTo(a.visibleScore));
    return enabled.take(3).toList(growable: false);
  }

  String _buildInsightBody(SupportProfile profile, HomeEventLanguage language) {
    final topDomains = _topDomains(profile);
    final DomainScore? topDomain = topDomains.isEmpty ? null : topDomains.first;
    if (topDomain == null) {
      return 'Detoxia is gathering enough local data to personalize this section.';
    }
    return 'Your strongest current support signal is ${topDomain.label.toLowerCase()} (${topDomain.visibleScore.toStringAsFixed(1)}/10). '
        'A short ${_resetNounForLanguage(language)} plan can reduce tonight\'s friction.';
  }

  HomeEventLanguage _languageForGoals(List<String> goals) {
    bool has(String value) => goals.any((goal) => goal.contains(value));
    if (has('anxiety')) return HomeEventLanguage.roughWindow;
    if (has('focus')) return HomeEventLanguage.missedFocusBlock;
    if (has('sleep')) return HomeEventLanguage.sleepDisruption;
    if (has('scrolling')) return HomeEventLanguage.scrollingLoop;
    return HomeEventLanguage.setback;
  }

  String _resetCtaForLanguage(HomeEventLanguage language) {
    switch (language) {
      case HomeEventLanguage.roughWindow:
        return 'Help me through this rough window';
      case HomeEventLanguage.missedFocusBlock:
        return 'Reset missed focus block';
      case HomeEventLanguage.sleepDisruption:
        return 'Reset sleep disruption';
      case HomeEventLanguage.scrollingLoop:
        return 'Break scrolling loop';
      case HomeEventLanguage.setback:
        return 'Help me reset';
    }
  }

  String _nounForLanguage(HomeEventLanguage language) {
    switch (language) {
      case HomeEventLanguage.roughWindow:
        return 'rough windows';
      case HomeEventLanguage.missedFocusBlock:
        return 'missed focus blocks';
      case HomeEventLanguage.sleepDisruption:
        return 'sleep disruption';
      case HomeEventLanguage.scrollingLoop:
        return 'scrolling loops';
      case HomeEventLanguage.setback:
        return 'reset moments';
    }
  }

  String _resetNounForLanguage(HomeEventLanguage language) {
    switch (language) {
      case HomeEventLanguage.roughWindow:
        return 'calming';
      case HomeEventLanguage.missedFocusBlock:
        return 'focus';
      case HomeEventLanguage.sleepDisruption:
        return 'sleep';
      case HomeEventLanguage.scrollingLoop:
        return 'loop-break';
      case HomeEventLanguage.setback:
        return 'recovery';
    }
  }

  String _greetingPrefix(DateTime now) {
    if (now.hour < 12) return 'Good morning';
    if (now.hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _nameSuffix(String? displayName) {
    if (displayName == null || displayName.trim().isEmpty) return '';
    return ', ${displayName.trim()}';
  }

  String _weekdayName(int weekday) {
    const names = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return names[(weekday - 1).clamp(0, 6)];
  }
}
