import 'questionnaire_question.dart';
import 'visibility_rule.dart';

class QuestionnaireSection {
  final String sectionId;
  final String sectionTitle;
  final String? sectionSubtitle;
  final String engineTarget;
  final int order;
  final bool isCompleted;
  final String? completionMessage;
  final bool notScored;
  final VisibilityRule? visibleIf;
  final List<QuestionnaireQuestion> questions;

  const QuestionnaireSection({
    required this.sectionId,
    required this.sectionTitle,
    this.sectionSubtitle,
    required this.engineTarget,
    required this.order,
    this.isCompleted = false,
    this.completionMessage,
    this.notScored = false,
    this.visibleIf,
    this.questions = const [],
  });

  factory QuestionnaireSection.fromJson(Map<String, dynamic> json) {
    return QuestionnaireSection(
      sectionId: json['sectionId'] as String? ?? '',
      sectionTitle: json['sectionTitle'] as String? ?? '',
      sectionSubtitle: json['sectionSubtitle'] as String?,
      engineTarget: json['engineTarget'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completionMessage: json['completionMessage'] as String?,
      notScored: json['notScored'] as bool? ?? false,
      visibleIf: json['visibleIf'] is Map<String, dynamic>
          ? VisibilityRule.fromJson(json['visibleIf'] as Map<String, dynamic>)
          : json['visibleIf'] is Map
          ? VisibilityRule.fromJson(
              Map<String, dynamic>.from(json['visibleIf'] as Map),
            )
          : null,
      questions: _readQuestions(json['questions']),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'sectionId': sectionId,
      'sectionTitle': sectionTitle,
      'engineTarget': engineTarget,
      'order': order,
    };

    if (sectionSubtitle != null) {
      json['sectionSubtitle'] = sectionSubtitle;
    }
    if (isCompleted) {
      json['isCompleted'] = isCompleted;
    }
    if (completionMessage != null) {
      json['completionMessage'] = completionMessage;
    }
    if (notScored) {
      json['notScored'] = notScored;
    }
    if (visibleIf != null) {
      json['visibleIf'] = visibleIf!.toJson();
    }
    json['questions'] = questions.map((question) => question.toJson()).toList();

    return json;
  }

  static List<QuestionnaireQuestion> _readQuestions(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .map(
          (item) => item is Map<String, dynamic>
              ? QuestionnaireQuestion.fromJson(item)
              : QuestionnaireQuestion.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
        )
        .toList();
  }
}
