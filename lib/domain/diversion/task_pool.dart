import 'package:detoxia/core/constants/enums.dart';

class DiversionTask {
  final String name;
  final TaskCategory category;
  final int minDurationSeconds;
  final int maxDurationSeconds;
  final List<String> suitableLocations;
  final List<int> suitableIntensities;
  final bool availableAtNight;
  int timesUsed;
  int timesSucceeded;

  DiversionTask({
    required this.name,
    required this.category,
    required this.minDurationSeconds,
    required this.maxDurationSeconds,
    this.suitableLocations = const ['any'],
    this.suitableIntensities = const [1, 2, 3],
    this.availableAtNight = true,
    this.timesUsed = 0,
    this.timesSucceeded = 0,
  });

  double get effectivenessRate =>
      timesUsed > 0 ? timesSucceeded / timesUsed : 0.5;
}

class TaskPool {
  static List<DiversionTask> getDefaultTasks() => [
        // Physical
        DiversionTask(
          name: '20 push-ups',
          category: TaskCategory.physical,
          minDurationSeconds: 60,
          maxDurationSeconds: 180,
          availableAtNight: false,
          suitableIntensities: [2, 3],
        ),
        DiversionTask(
          name: 'Cold water on face',
          category: TaskCategory.physical,
          minDurationSeconds: 30,
          maxDurationSeconds: 120,
          suitableIntensities: [2, 3],
        ),
        DiversionTask(
          name: 'Brisk 5-minute walk',
          category: TaskCategory.physical,
          minDurationSeconds: 300,
          maxDurationSeconds: 600,
          availableAtNight: false,
          suitableIntensities: [1, 2, 3],
        ),
        DiversionTask(
          name: '10 jumping jacks',
          category: TaskCategory.physical,
          minDurationSeconds: 30,
          maxDurationSeconds: 120,
          availableAtNight: false,
          suitableIntensities: [2, 3],
        ),
        DiversionTask(
          name: 'Cold shower',
          category: TaskCategory.physical,
          minDurationSeconds: 120,
          maxDurationSeconds: 300,
          suitableIntensities: [3],
        ),
        DiversionTask(
          name: 'Stretch routine',
          category: TaskCategory.physical,
          minDurationSeconds: 180,
          maxDurationSeconds: 600,
          suitableIntensities: [1, 2],
        ),

        // Breathing / Mindfulness
        DiversionTask(
          name: 'Box breathing (4-4-4-4)',
          category: TaskCategory.breathing,
          minDurationSeconds: 120,
          maxDurationSeconds: 300,
          suitableIntensities: [1, 2, 3],
        ),
        DiversionTask(
          name: 'Body scan',
          category: TaskCategory.breathing,
          minDurationSeconds: 180,
          maxDurationSeconds: 600,
          suitableIntensities: [1, 2],
        ),
        DiversionTask(
          name: 'Urge surfing (ride the wave)',
          category: TaskCategory.breathing,
          minDurationSeconds: 120,
          maxDurationSeconds: 600,
          suitableIntensities: [2, 3],
        ),
        DiversionTask(
          name: '5-4-3-2-1 grounding',
          category: TaskCategory.breathing,
          minDurationSeconds: 60,
          maxDurationSeconds: 300,
          suitableIntensities: [1, 2, 3],
        ),

        // Cognitive
        DiversionTask(
          name: 'Write 3 things you are grateful for',
          category: TaskCategory.cognitive,
          minDurationSeconds: 120,
          maxDurationSeconds: 300,
          suitableIntensities: [1, 2],
        ),
        DiversionTask(
          name: 'Journal: what am I actually feeling?',
          category: TaskCategory.cognitive,
          minDurationSeconds: 180,
          maxDurationSeconds: 600,
          suitableIntensities: [1, 2],
        ),
        DiversionTask(
          name: 'Call or text someone',
          category: TaskCategory.social,
          minDurationSeconds: 60,
          maxDurationSeconds: 900,
          suitableIntensities: [1, 2, 3],
        ),
        DiversionTask(
          name: 'Read 2 pages of a book',
          category: TaskCategory.cognitive,
          minDurationSeconds: 180,
          maxDurationSeconds: 600,
          suitableIntensities: [1],
        ),

        // Environmental
        DiversionTask(
          name: 'Leave the room',
          category: TaskCategory.environmental,
          minDurationSeconds: 30,
          maxDurationSeconds: 120,
          suitableIntensities: [2, 3],
        ),
        DiversionTask(
          name: 'Put phone in another room',
          category: TaskCategory.environmental,
          minDurationSeconds: 10,
          maxDurationSeconds: 60,
          suitableIntensities: [2, 3],
        ),
        DiversionTask(
          name: 'Go outside',
          category: TaskCategory.environmental,
          minDurationSeconds: 60,
          maxDurationSeconds: 600,
          availableAtNight: false,
          suitableIntensities: [2, 3],
        ),

        // Productive
        DiversionTask(
          name: 'Clean something for 10 minutes',
          category: TaskCategory.productive,
          minDurationSeconds: 600,
          maxDurationSeconds: 900,
          suitableIntensities: [1, 2],
        ),
        DiversionTask(
          name: 'Cook a quick snack',
          category: TaskCategory.productive,
          minDurationSeconds: 300,
          maxDurationSeconds: 900,
          suitableIntensities: [1, 2],
        ),

        // Values
        DiversionTask(
          name: 'Re-read your "why I want to change"',
          category: TaskCategory.valuesAnchor,
          minDurationSeconds: 60,
          maxDurationSeconds: 180,
          suitableIntensities: [1, 2, 3],
        ),
        DiversionTask(
          name: 'Visualize your future self at week 12',
          category: TaskCategory.valuesAnchor,
          minDurationSeconds: 60,
          maxDurationSeconds: 300,
          suitableIntensities: [1, 2],
        ),
      ];
}
