enum QuestionType {
  singleChoice,
  multiChoice,
  scale,
  timeWindow,
  durationBand,
  datePicker,
  infoReward,
  microGame,
  yesNo,
}

extension QuestionTypeJson on QuestionType {
  String get jsonValue => name;
}

QuestionType questionTypeFromJson(String value) {
  switch (value) {
    case 'singleChoice':
      return QuestionType.singleChoice;
    case 'multiChoice':
      return QuestionType.multiChoice;
    case 'scale':
      return QuestionType.scale;
    case 'timeWindow':
      return QuestionType.timeWindow;
    case 'durationBand':
      return QuestionType.durationBand;
    case 'datePicker':
      return QuestionType.datePicker;
    case 'infoReward':
      return QuestionType.infoReward;
    case 'microGame':
      return QuestionType.microGame;
    case 'yesNo':
      return QuestionType.yesNo;
    default:
      throw FormatException('Unknown QuestionType: $value');
  }
}
