enum InterventionFeedback { helped, somewhat, ignored, didNotHelp, slippedAfterTask }

extension InterventionFeedbackReward on InterventionFeedback {
  double get reward {
    switch (this) {
      case InterventionFeedback.helped:
        return 1.0;
      case InterventionFeedback.somewhat:
        return 0.5;
      case InterventionFeedback.ignored:
        return 0.0;
      case InterventionFeedback.didNotHelp:
        return -0.5;
      case InterventionFeedback.slippedAfterTask:
        return -1.0;
    }
  }
}

InterventionFeedback interventionFeedbackFromJson(String value) {
  switch (value) {
    case 'helped':
      return InterventionFeedback.helped;
    case 'somewhat':
      return InterventionFeedback.somewhat;
    case 'ignored':
      return InterventionFeedback.ignored;
    case 'didNotHelp':
      return InterventionFeedback.didNotHelp;
    case 'slippedAfterTask':
      return InterventionFeedback.slippedAfterTask;
    default:
      throw FormatException('Unknown InterventionFeedback: $value');
  }
}
