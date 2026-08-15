enum MenstrualPhase { menstruation, follicular, ovulation, luteal, unknown }

MenstrualPhase menstrualPhaseFromJson(String value) {
  switch (value) {
    case 'menstruation':
      return MenstrualPhase.menstruation;
    case 'follicular':
      return MenstrualPhase.follicular;
    case 'ovulation':
      return MenstrualPhase.ovulation;
    case 'luteal':
      return MenstrualPhase.luteal;
    case 'unknown':
      return MenstrualPhase.unknown;
    default:
      throw FormatException('Unknown MenstrualPhase: $value');
  }
}
