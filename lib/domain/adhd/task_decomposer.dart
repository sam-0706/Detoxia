class TaskDecomposer {
  static const decompositionPrompts = <String>[
    'What is the very first physical action you need to take?',
    'What materials or tools do you need to start?',
    'What is the smallest piece you can finish in 5 minutes?',
    'Can you break that step into something even smaller?',
    'What does "done" look like for this one micro-step?',
    'Where exactly will you do this?',
    'What might distract you, and how will you block it?',
    'What is the next visible output after the first step?',
    'Is there a part you already know how to do? Start there.',
    'What would you tell a friend to do first if they had this task?',
  ];

  /// Generates generic micro-step prompts for breaking down [bigTask].
  /// Returns a list of actionable question-prompts the user can answer
  /// to turn one overwhelming task into small, concrete steps.
  List<String> decompose(String bigTask) {
    final trimmed = bigTask.trim();
    if (trimmed.isEmpty) return [];

    return [
      'For "$trimmed": What is the very first physical action?',
      'What do you need in front of you to start "$trimmed"?',
      'What is the smallest piece of "$trimmed" you can do in 5 minutes?',
      'After that 5-minute piece, what naturally comes next?',
      'What does "halfway done" look like for "$trimmed"?',
      'Is there a part of "$trimmed" you can delegate or skip entirely?',
      'What is the final step that marks "$trimmed" as complete?',
    ];
  }

  /// Rough time estimate: ~8 minutes per micro-step for ADHD-friendly pacing
  /// (includes buffer for context switching and re-engagement).
  int suggestTimeEstimate(int microStepCount) {
    if (microStepCount <= 0) return 0;
    const minutesPerStep = 8;
    const contextSwitchBuffer = 3;
    return (microStepCount * minutesPerStep) +
        ((microStepCount - 1) * contextSwitchBuffer);
  }
}
