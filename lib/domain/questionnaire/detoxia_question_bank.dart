import 'models/questionnaire_question.dart';
import 'models/questionnaire_section.dart';
import 'question_bank_loader.dart';

class DetoxiaQuestionBank {
  final List<QuestionnaireSection> sections;
  final String version;

  const DetoxiaQuestionBank({required this.sections, required this.version});

  static Future<DetoxiaQuestionBank> loadFromAssets({
    QuestionBankLoader? loader,
  }) async {
    final resolvedLoader = loader ?? const AssetQuestionBankLoader();
    final sections = await resolvedLoader.load();
    return DetoxiaQuestionBank(sections: sections, version: '1.0.0');
  }

  QuestionnaireSection? sectionById(String id) {
    for (final section in sections) {
      if (section.sectionId == id) {
        return section;
      }
    }
    return null;
  }

  QuestionnaireQuestion? questionById(String id) {
    for (final section in sections) {
      for (final question in section.questions) {
        if (question.questionId == id) {
          return question;
        }
      }
    }
    return null;
  }

  List<QuestionnaireSection> sectionsOrdered() {
    final ordered = List<QuestionnaireSection>.from(sections);
    ordered.sort((a, b) => a.order.compareTo(b.order));
    return ordered;
  }
}
