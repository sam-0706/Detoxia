import 'package:detoxia/core/constants/daily_tasks_pool.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';
import 'package:detoxia/domain/tasks/task_tag.dart';
import 'package:detoxia/domain/tasks/task_tag_mapper.dart';
import 'package:detoxia/domain/tasks/task_utility_score.dart';

class UnifiedTaskEngine {
  final TaskTagMapper mapper;

  const UnifiedTaskEngine({this.mapper = const TaskTagMapper()});

  /// Selects daily tasks from the existing pool using support-map signals.
  ///
  /// Weight choices:
  /// - Domain score is the main driver because visible 0-10 domain scores are
  ///   the clearest current support need.
  /// - Pathway score is secondary and additive, so compound pathways can lift
  ///   otherwise useful tasks without swamping direct domain fit.
  /// - Intervention reward is a small learned adjustment from feedback.
  /// - Burden penalty scales by duration so long tasks do not dominate.
  /// - Notification fatigue is 0 in v1 until notification history exists.
  List<TaskUtility> selectTasks({
    required SupportProfile profile,
    required DateTime now,
    int count = 4,
  }) {
    if (count <= 0) return const [];

    final dayOfYear = now.difference(DateTime(now.year)).inDays + 1;
    final medianScore = _medianEnabledScore(profile.domainScores);
    final scored = <TaskUtility>[];

    for (final task in dailyTasksPool) {
      final tags = mapper.tagsForTask(task);
      if (!_passesInterventionPreferences(tags, profile)) continue;
      if (_shouldExcludeForGoals(tags, profile.selectedGoals)) continue;

      final domainUtility = _domainUtility(tags, profile);
      final pathwayUtility = _pathwayUtility(tags, profile);
      final reward = _interventionReward(task, tags, profile);
      final burdenPenalty = _burdenPenalty(task);
      const notificationFatigue = 0.0;
      final compoundBonus = _compoundBonus(tags, profile, medianScore);
      final goalBonus = _goalBonus(tags, profile.selectedGoals);
      final timeBonus = _timeOfDayBonus(task, now);
      final rotationBonus = _rotationBonus(task, dayOfYear);

      final utility =
          domainUtility +
          pathwayUtility +
          reward +
          compoundBonus +
          goalBonus +
          timeBonus +
          rotationBonus -
          burdenPenalty -
          notificationFatigue;

      final topDomain = _topDomainForTask(tags, profile);
      final topPathway = _topPathwayForTask(tags, profile);
      final targetDriver = _targetDriverForTask(tags, profile);
      final whyChosen = _whyChosen(
        topDomainLabel: topDomain?.label,
        topPathwayLabel: topPathway,
        targetDriver: targetDriver,
      );

      scored.add(
        TaskUtility(
          task: task,
          utility: utility,
          tags: tags,
          reason: _reason(
            domainUtility: domainUtility,
            pathwayUtility: pathwayUtility,
            reward: reward,
            compoundBonus: compoundBonus,
            goalBonus: goalBonus,
          ),
          whyChosen: whyChosen,
          steps: _stepsForTask(task),
          targetDriver: targetDriver,
          domainTags: tags.map((tag) => _tagLabel(tag)).toList(growable: false),
          feedbackButtons: const [
            'Helped',
            'Somewhat helped',
            'Did not help',
          ],
        ),
      );
    }

    scored.sort((a, b) {
      final byUtility = b.utility.compareTo(a.utility);
      if (byUtility != 0) return byUtility;
      return _taskId(a.task).compareTo(_taskId(b.task));
    });

    return _dedupeRepetitiveTags(scored).take(count).toList(growable: false);
  }

  double _domainUtility(List<TaskTag> tags, SupportProfile profile) {
    var utility = 0.0;
    for (final score in profile.domainScores.where((score) => score.enabled)) {
      final fit = _domainFit(tags, score.id);
      utility += score.visibleScore * fit;
    }
    return utility;
  }

  double _pathwayUtility(List<TaskTag> tags, SupportProfile profile) {
    var utility = 0.0;
    for (final pathway in profile.pathwayScores.where((p) => p.enabled)) {
      utility += pathway.score0To10 * _pathwayFit(tags, pathway.pathwayId);
      utility += pathway.score0To10 * _pathwayFit(tags, pathway.label);
    }
    return utility * 0.5;
  }

  double _goalBonus(List<TaskTag> tags, List<String> selectedGoals) {
    if (selectedGoals.isEmpty) return 0.0;

    final normalized = selectedGoals.map(_normalizeGoal).toSet();
    final matches = <String>{
      if (_hasAny(tags, const {
        TaskTag.scrolling,
        TaskTag.commuteScrolling,
      }))
        'scrolling',
      if (tags.contains(TaskTag.sexualControl)) 'sexualcontrol',
      if (tags.contains(TaskTag.anxiety)) 'anxiety',
      if (tags.contains(TaskTag.focus) || tags.contains(TaskTag.focusSprint))
        'focus',
      if (tags.contains(TaskTag.lowMood)) 'lowmood',
      if (_hasAny(tags, const {
        TaskTag.sleep,
        TaskTag.sleepDebt,
        TaskTag.sleepShutdown,
        TaskTag.lateNightRisk,
      }))
        'sleep',
      if (tags.contains(TaskTag.cycle)) 'cycle',
    };

    final selectedMatches = matches.where(normalized.contains).length;
    final selectedMisses = matches.length - selectedMatches;
    final noMatchPenalty = selectedMatches == 0 ? 1.0 : 0.0;
    return (selectedMatches * 0.8) - (selectedMisses * 0.35) - noMatchPenalty;
  }

  bool _shouldExcludeForGoals(List<TaskTag> tags, List<String> selectedGoals) {
    if (selectedGoals.isEmpty) return false;
    final normalized = selectedGoals.map(_normalizeGoal).toSet();
    final allowsSexual = normalized.contains('sexualcontrol');
    if (!allowsSexual && tags.contains(TaskTag.sexualControl)) {
      return true;
    }
    return false;
  }

  double _domainFit(List<TaskTag> tags, String domainId) {
    final domain = domainId.toLowerCase();
    if (domain == 'scrollingcontrol') {
      return _hasAny(tags, const {
            TaskTag.scrolling,
            TaskTag.commuteScrolling,
            TaskTag.appFriction,
          })
          ? 1.0
          : _hasAny(tags, const {TaskTag.journaling, TaskTag.lowPressure})
          ? 0.3
          : 0.0;
    }
    if (domain == 'sexualcontentcontrol' || domain == 'sexualcontrolrecovery') {
      return _hasAny(tags, const {
            TaskTag.sexualControl,
            TaskTag.lateNightRisk,
            TaskTag.appFriction,
          })
          ? 1.0
          : _hasAny(tags, const {TaskTag.scrolling, TaskTag.spiritual})
          ? 0.3
          : 0.0;
    }
    if (domain == 'anxietyload') {
      return _hasAny(tags, const {
            TaskTag.anxiety,
            TaskTag.breathingReset,
            TaskTag.postWorkStress,
          })
          ? 1.0
          : _hasAny(tags, const {TaskTag.physicalReset, TaskTag.journaling})
          ? 0.3
          : 0.0;
    }
    if (domain == 'lowmoodsupport') {
      return _hasAny(tags, const {TaskTag.lowMood, TaskTag.lowPressure})
          ? 1.0
          : _hasAny(tags, const {TaskTag.physicalReset, TaskTag.journaling})
          ? 0.3
          : 0.0;
    }
    if (domain == 'focussupport') {
      return _hasAny(tags, const {TaskTag.focus, TaskTag.focusSprint})
          ? 1.0
          : _hasAny(tags, const {TaskTag.appFriction, TaskTag.lowPressure})
          ? 0.3
          : 0.0;
    }
    if (domain == 'sleepdisruption') {
      return _hasAny(tags, const {
            TaskTag.sleep,
            TaskTag.sleepDebt,
            TaskTag.sleepShutdown,
            TaskTag.lateNightRisk,
          })
          ? 1.0
          : _hasAny(tags, const {TaskTag.breathingReset, TaskTag.lowPressure})
          ? 0.3
          : 0.0;
    }
    if (domain == 'physicalactivation') {
      return _hasAny(tags, const {
            TaskTag.physicalActivation,
            TaskTag.physicalReset,
          })
          ? 1.0
          : 0.0;
    }
    if (domain == 'cyclesensitivity') {
      return tags.contains(TaskTag.cycle) ? 1.0 : 0.0;
    }
    return 0.0;
  }

  double _pathwayFit(List<TaskTag> tags, String value) {
    final normalized = value.toLowerCase();
    var fit = 0.0;
    if (normalized.contains('scroll')) {
      fit = tags.contains(TaskTag.scrolling) ? 1.0 : fit;
    }
    if (normalized.contains('sexual') || normalized.contains('porn')) {
      fit = tags.contains(TaskTag.sexualControl) ? 1.0 : fit;
    }
    if (normalized.contains('anx')) {
      fit = tags.contains(TaskTag.anxiety) ? 1.0 : fit;
    }
    if (normalized.contains('sleep') || normalized.contains('late')) {
      fit = tags.contains(TaskTag.sleep) || tags.contains(TaskTag.lateNightRisk)
          ? 1.0
          : fit;
    }
    if (normalized.contains('focus')) {
      fit = tags.contains(TaskTag.focus) ? 1.0 : fit;
    }
    return fit;
  }

  double _interventionReward(
    Map<String, dynamic> task,
    List<TaskTag> tags,
    SupportProfile profile,
  ) {
    final rewards = profile.learningState.interventionRewardsMap;
    final rewardKeys = <String>[
      _taskId(task),
      task['category'] as String? ?? '',
      ...tags.map((tag) => tag.name),
    ];
    return rewardKeys.fold<double>(0.0, (best, key) {
      final reward = rewards[key] ?? 0.0;
      return reward > best ? reward : best;
    });
  }

  double _burdenPenalty(Map<String, dynamic> task) {
    final duration = (task['durationMinutes'] as num?)?.toDouble() ?? 10.0;
    return 0.5 * duration / 30.0;
  }

  double _compoundBonus(
    List<TaskTag> tags,
    SupportProfile profile,
    double medianScore,
  ) {
    final highFits = profile.domainScores.where((score) {
      return score.enabled &&
          score.visibleScore >= medianScore &&
          _domainFit(tags, score.id) >= 1.0;
    }).length;
    return highFits >= 2 ? 1.0 : 0.0;
  }

  double _timeOfDayBonus(Map<String, dynamic> task, DateTime now) {
    final timeOfDay = task['timeOfDay'] as String? ?? 'anytime';
    if (timeOfDay == 'anytime') return 0.1;
    final hour = now.hour;
    final current = hour < 12
        ? 'morning'
        : hour < 17
        ? 'afternoon'
        : 'evening';
    return timeOfDay == current ? 0.4 : -0.3;
  }

  double _rotationBonus(Map<String, dynamic> task, int dayOfYear) {
    final id = _taskId(task);
    var hash = dayOfYear * 31;
    for (final codeUnit in id.codeUnits) {
      hash = (hash * 33 + codeUnit) & 0x7fffffff;
    }
    return (hash % 997) / 997.0 * 0.2;
  }

  List<TaskUtility> _dedupeRepetitiveTags(List<TaskUtility> scored) {
    final selected = <TaskUtility>[];
    var breathingCount = 0;
    for (final utility in scored) {
      if (utility.tags.contains(TaskTag.breathingReset)) {
        if (breathingCount >= 1) continue;
        breathingCount++;
      }
      selected.add(utility);
    }
    return selected;
  }

  bool _passesInterventionPreferences(
    List<TaskTag> tags,
    SupportProfile profile,
  ) {
    final prefs = profile.interventionPreferences;
    final hasAnyPreference =
        prefs.physicalReset ||
        prefs.breathingGrounding ||
        prefs.appFrictionDelay ||
        prefs.journalingThoughtDump ||
        prefs.focusSprint ||
        prefs.sleepShutdown ||
        prefs.spiritualValuesReset ||
        prefs.lowPressureTask;
    if (!hasAnyPreference) return true;

    if (!prefs.physicalReset && tags.contains(TaskTag.physicalReset)) {
      return false;
    }
    if (!prefs.breathingGrounding && tags.contains(TaskTag.breathingReset)) {
      return false;
    }
    if (!prefs.appFrictionDelay && tags.contains(TaskTag.appFriction)) {
      return false;
    }
    if (!prefs.journalingThoughtDump && tags.contains(TaskTag.journaling)) {
      return false;
    }
    if (!prefs.focusSprint && tags.contains(TaskTag.focusSprint)) {
      return false;
    }
    if (!prefs.sleepShutdown && tags.contains(TaskTag.sleepShutdown)) {
      return false;
    }
    if (!prefs.spiritualValuesReset && tags.contains(TaskTag.spiritual)) {
      return false;
    }
    if (!prefs.lowPressureTask && tags.contains(TaskTag.lowPressure)) {
      return false;
    }
    return true;
  }

  double _medianEnabledScore(List<DomainScore> scores) {
    final enabledScores =
        scores
            .where((score) => score.enabled)
            .map((score) => score.visibleScore)
            .toList()
          ..sort();
    if (enabledScores.isEmpty) return 0.0;
    return enabledScores[enabledScores.length ~/ 2];
  }

  String _reason({
    required double domainUtility,
    required double pathwayUtility,
    required double reward,
    required double compoundBonus,
    required double goalBonus,
  }) {
    return 'domain=${domainUtility.toStringAsFixed(2)}, '
        'pathway=${pathwayUtility.toStringAsFixed(2)}, '
        'reward=${reward.toStringAsFixed(2)}, '
        'compound=${compoundBonus.toStringAsFixed(2)}, '
        'goals=${goalBonus.toStringAsFixed(2)}';
  }

  DomainScore? _topDomainForTask(List<TaskTag> tags, SupportProfile profile) {
    DomainScore? best;
    var bestFit = 0.0;
    for (final score in profile.domainScores.where((score) => score.enabled)) {
      final fit = _domainFit(tags, score.id) * score.visibleScore;
      if (fit > bestFit) {
        bestFit = fit;
        best = score;
      }
    }
    return best;
  }

  String? _topPathwayForTask(List<TaskTag> tags, SupportProfile profile) {
    String? best;
    var bestFit = 0.0;
    for (final pathway in profile.pathwayScores.where((p) => p.enabled)) {
      final fit =
          _pathwayFit(tags, pathway.pathwayId) * pathway.score0To10 +
          _pathwayFit(tags, pathway.label) * pathway.score0To10;
      if (fit > bestFit) {
        bestFit = fit;
        best = pathway.label;
      }
    }
    return best;
  }

  String _targetDriverForTask(List<TaskTag> tags, SupportProfile profile) {
    final ordered = profile.triggerWeights.toList()
      ..sort((a, b) => b.weight0To10.compareTo(a.weight0To10));
    if (ordered.isNotEmpty) {
      return ordered.first.label;
    }

    if (tags.contains(TaskTag.lateNightRisk)) return 'Late-night pattern';
    if (tags.contains(TaskTag.postWorkStress)) return 'Post-work stress';
    if (tags.contains(TaskTag.commuteScrolling)) return 'Commute scrolling';
    return 'Current support driver';
  }

  String _whyChosen({
    required String? topDomainLabel,
    required String? topPathwayLabel,
    required String targetDriver,
  }) {
    final domainText = topDomainLabel == null
        ? 'today\'s support map signals'
        : '${topDomainLabel.toLowerCase()} support';
    final pathwayText = (topPathwayLabel == null || topPathwayLabel.isEmpty)
        ? ''
        : ' Pathway signal: $topPathwayLabel.';
    return 'Chosen for $domainText. Target driver: $targetDriver.$pathwayText';
  }

  List<String> _stepsForTask(Map<String, dynamic> task) {
    final description =
        (task['description'] as String? ?? 'Follow this short support action.')
            .trim();
    final firstSentence = description.split('.').first.trim();
    final leadStep = firstSentence.isEmpty ? description : '$firstSentence.';
    final duration = (task['durationMinutes'] as int?) ?? 10;
    return <String>[
      leadStep,
      'Stay with this for about $duration minutes.',
      'Mark feedback after finishing so Detoxia can adapt tomorrow.',
    ];
  }

  String _tagLabel(TaskTag tag) {
    return switch (tag) {
      TaskTag.scrolling => 'Scrolling',
      TaskTag.sexualControl => 'Sexual control',
      TaskTag.anxiety => 'Anxiety',
      TaskTag.lowMood => 'Low mood',
      TaskTag.focus => 'Focus',
      TaskTag.sleep => 'Sleep',
      TaskTag.sleepDebt => 'Sleep debt',
      TaskTag.physicalActivation => 'Physical activation',
      TaskTag.cycle => 'Cycle',
      TaskTag.postWorkStress => 'Stress',
      TaskTag.commuteScrolling => 'Commute',
      TaskTag.lateNightRisk => 'Late night',
      TaskTag.breathingReset => 'Breathing',
      TaskTag.physicalReset => 'Physical reset',
      TaskTag.focusSprint => 'Focus sprint',
      TaskTag.appFriction => 'App friction',
      TaskTag.journaling => 'Journaling',
      TaskTag.lowPressure => 'Low pressure',
      TaskTag.spiritual => 'Values',
      TaskTag.sleepShutdown => 'Sleep shutdown',
    };
  }

  String _normalizeGoal(String goal) {
    final normalized = goal.toLowerCase().replaceAll('_', '');
    return normalized
        .replaceAll('goal', '')
        .replaceAll('content', '')
        .replaceAll('recovery', '')
        .replaceAll('tracking', '');
  }

  String _taskId(Map<String, dynamic> task) => task['id'] as String? ?? '';

  bool _hasAny(List<TaskTag> tags, Set<TaskTag> wanted) {
    return tags.any(wanted.contains);
  }
}
