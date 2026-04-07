import 'dart:math';

import 'package:detoxia/core/constants/daily_tasks_pool.dart';

class DailyTaskScheduler {
  static const _universalPrefix = 'uni_';

  /// Selects a diverse set of daily tasks based on active conditions.
  ///
  /// Uses [dayOfYear] as a deterministic seed so the same day always yields
  /// the same selection, while consecutive days rotate categories.
  static List<Map<String, dynamic>> selectTasks({
    required List<String> activeConditions,
    required int dayOfYear,
    int count = 5,
  }) {
    if (activeConditions.isEmpty) return [];

    final rng = Random(dayOfYear * 7919);
    final now = DateTime.now();
    final currentHour = now.hour;

    final universalTasks = dailyTasksPool
        .where((t) => (t['id'] as String).startsWith(_universalPrefix))
        .toList();

    final conditionTasks = <String, List<Map<String, dynamic>>>{};
    for (final condition in activeConditions) {
      conditionTasks[condition] = dailyTasksPool
          .where((t) =>
              t['conditionType'] == condition &&
              !(t['id'] as String).startsWith(_universalPrefix))
          .toList();
    }

    final previousDayCategories = _categoriesForDay(dayOfYear - 1, activeConditions);

    final selected = <Map<String, dynamic>>[];
    final usedIds = <String>{};
    final usedCategories = <String>{};

    final challengeSlot = rng.nextInt(count);

    for (var i = 0; i < count; i++) {
      final targetDifficulty =
          i == challengeSlot ? 'challenge' : (rng.nextBool() ? 'easy' : 'easy');

      final conditionIndex = i % activeConditions.length;
      final condition = activeConditions[conditionIndex];

      final useUniversal = i == count - 1 && universalTasks.isNotEmpty;
      final pool = useUniversal ? universalTasks : (conditionTasks[condition] ?? []);

      final candidates = pool.where((t) {
        final id = t['id'] as String;
        final cat = t['category'] as String;
        final diff = t['difficulty'] as String;
        final tod = t['timeOfDay'] as String;

        if (usedIds.contains(id)) return false;
        if (usedCategories.contains(cat)) return false;
        if (previousDayCategories.contains(cat) && pool.length > 10) return false;
        if (diff != targetDifficulty && targetDifficulty == 'challenge') return false;

        if (currentHour < 12 && tod == 'evening') return false;
        if (currentHour >= 18 && tod == 'morning') return false;

        return true;
      }).toList();

      final fallbackCandidates = pool.where((t) {
        final id = t['id'] as String;
        final cat = t['category'] as String;
        if (usedIds.contains(id)) return false;
        if (usedCategories.contains(cat)) return false;
        return true;
      }).toList();

      final source = candidates.isNotEmpty ? candidates : fallbackCandidates;
      if (source.isEmpty) continue;

      final pick = source[rng.nextInt(source.length)];
      selected.add(pick);
      usedIds.add(pick['id'] as String);
      usedCategories.add(pick['category'] as String);
    }

    selected.shuffle(rng);
    return selected;
  }

  /// Returns tasks filtered by condition type, limited to [count].
  static List<Map<String, dynamic>> getTasksForCondition(
    String conditionType,
    int count,
  ) {
    final filtered = dailyTasksPool
        .where((t) => t['conditionType'] == conditionType)
        .toList();
    if (filtered.length <= count) return filtered;
    return filtered.sublist(0, count);
  }

  /// Derives a set of category strings for a given day, used to avoid
  /// repeating categories on consecutive days.
  static Set<String> _categoriesForDay(int dayOfYear, List<String> conditions) {
    final rng = Random(dayOfYear * 7919);
    final categories = <String>{};
    for (var i = 0; i < 5; i++) {
      final condition = conditions[i % conditions.length];
      final pool = dailyTasksPool
          .where((t) => t['conditionType'] == condition)
          .toList();
      if (pool.isNotEmpty) {
        final pick = pool[rng.nextInt(pool.length)];
        categories.add(pick['category'] as String);
      }
    }
    return categories;
  }
}
