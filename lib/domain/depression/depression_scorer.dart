/// PHQ-9-inspired self-assessment for mood tracking (NOT a diagnostic tool).
class DepressionScorer {
  static const questions = <String>[
    'Little interest or pleasure in doing things',
    'Feeling down, depressed, or hopeless',
    'Trouble falling or staying asleep, or sleeping too much',
    'Feeling tired or having little energy',
    'Poor appetite or overeating',
    'Feeling bad about yourself — or that you\'re a failure',
    'Trouble concentrating on things like reading or watching TV',
    'Moving or speaking noticeably slowly, or being fidgety/restless',
    'Thoughts that you would be better off dead, or of hurting yourself',
  ];

  static const answerOptions = <String>[
    'Not at all',
    'Several days',
    'More than half the days',
    'Nearly every day',
  ];

  /// Each answer is 0-3. Returns total score from 0 to 27.
  static int computeScore(List<int> answers) {
    assert(answers.length == 9);
    return answers.fold(0, (sum, a) => sum + a.clamp(0, 3));
  }

  static String severityLabel(int score) {
    if (score <= 4) return 'Minimal';
    if (score <= 9) return 'Mild';
    if (score <= 14) return 'Moderate';
    if (score <= 19) return 'Moderately severe';
    return 'Severe';
  }

  /// Needs at least 2 weekly scores to determine a trend.
  static String trendDirection(List<int> weeklyScores) {
    if (weeklyScores.length < 2) return 'stable';

    final recent = weeklyScores.length >= 3
        ? weeklyScores.sublist(weeklyScores.length - 3)
        : weeklyScores;

    var improving = 0;
    var worsening = 0;
    for (var i = 1; i < recent.length; i++) {
      final diff = recent[i] - recent[i - 1];
      if (diff < -2) {
        improving++;
      } else if (diff > 2) {
        worsening++;
      }
    }

    if (improving > worsening) return 'improving';
    if (worsening > improving) return 'worsening';
    return 'stable';
  }
}
