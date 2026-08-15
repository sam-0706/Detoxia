enum Outcome { resisted, slipped, noUrge, falseAlarm }

extension OutcomeValue on Outcome {
  double get value {
    switch (this) {
      case Outcome.resisted:
        return 1.0;
      case Outcome.slipped:
        return -1.0;
      case Outcome.noUrge:
        return 0.3;
      case Outcome.falseAlarm:
        return 0.0;
    }
  }
}

Outcome outcomeFromJson(String value) {
  switch (value) {
    case 'resisted':
      return Outcome.resisted;
    case 'slipped':
      return Outcome.slipped;
    case 'noUrge':
      return Outcome.noUrge;
    case 'falseAlarm':
      return Outcome.falseAlarm;
    default:
      throw FormatException('Unknown Outcome: $value');
  }
}
