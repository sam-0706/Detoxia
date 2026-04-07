import 'dart:math';

import 'package:detoxia/domain/diversion/task_pool.dart';

class TaskSelector {
  final List<DiversionTask> _tasks;
  String? _lastUsedTask;

  TaskSelector(this._tasks);

  List<DiversionTask> recommend({
    required int urgeIntensity,
    required int hourOfDay,
    required String? location,
    int count = 3,
  }) {
    final intensityLevel = urgeIntensity <= 3
        ? 1
        : urgeIntensity <= 6
            ? 2
            : 3;
    final isNight = hourOfDay >= 22 || hourOfDay < 6;

    final scored = <_ScoredTask>[];
    for (final task in _tasks) {
      if (isNight && !task.availableAtNight) continue;
      if (!task.suitableIntensities.contains(intensityLevel)) continue;

      final score = _scoreTask(task, intensityLevel);
      scored.add(_ScoredTask(task: task, score: score));
    }

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.take(count).map((s) => s.task).toList();
  }

  double _scoreTask(DiversionTask task, int intensityLevel) {
    final effectiveness = task.timesUsed >= 3
        ? task.effectivenessRate
        : 0.5;
    final recencyPenalty =
        task.name == _lastUsedTask ? -0.15 : 0.0;
    final varietyBonus = task.timesUsed == 0 ? 0.1 : 0.0;

    final intensityMatch = task.suitableIntensities
            .contains(intensityLevel)
        ? 0.2
        : 0.0;

    return 0.35 * effectiveness +
        0.25 * intensityMatch +
        0.20 * 0.5 +
        0.10 * recencyPenalty +
        0.10 * varietyBonus;
  }

  void recordUsage(String taskName, {required bool succeeded}) {
    _lastUsedTask = taskName;
    final task = _tasks.firstWhere(
      (t) => t.name == taskName,
      orElse: () => _tasks.first,
    );
    task.timesUsed++;
    if (succeeded) task.timesSucceeded++;
  }

  List<MapEntry<String, double>> get effectivenessRanking {
    final ranked = _tasks
        .where((t) => t.timesUsed >= 3)
        .map((t) => MapEntry(t.name, t.effectivenessRate))
        .toList();
    ranked.sort((a, b) => b.value.compareTo(a.value));
    return ranked.take(min(5, ranked.length)).toList();
  }
}

class _ScoredTask {
  final DiversionTask task;
  final double score;
  const _ScoredTask({required this.task, required this.score});
}
