import 'dart:convert';

import 'package:flutter/services.dart';

import 'models/questionnaire_question.dart';
import 'models/questionnaire_section.dart';

abstract class QuestionBankLoader {
  Future<List<QuestionnaireSection>> load();
}

class AssetQuestionBankLoader implements QuestionBankLoader {
  final String assetPath;

  const AssetQuestionBankLoader({
    this.assetPath = 'assets/questionnaire/detoxia_questionnaire_v1.json',
  });

  @override
  Future<List<QuestionnaireSection>> load() async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Questionnaire JSON root must be an object.');
    }
    return parseSections(decoded);
  }
}

List<QuestionnaireSection> parseSections(Map<String, dynamic> json) {
  _requireType<String>(json, 'version');
  final sectionsJson = _requireType<List<dynamic>>(json, 'sections');

  final sections = sectionsJson.map((sectionJson) {
    if (sectionJson is! Map<String, dynamic>) {
      throw const FormatException(
        'Each questionnaire section must be an object.',
      );
    }

    _validateSection(sectionJson);
    final section = QuestionnaireSection.fromJson(sectionJson);
    final questions = section.questions
        .map((question) => _withSectionId(question, section.sectionId))
        .toList(growable: false);

    return QuestionnaireSection(
      sectionId: section.sectionId,
      sectionTitle: section.sectionTitle,
      sectionSubtitle: section.sectionSubtitle,
      engineTarget: section.engineTarget,
      order: section.order,
      isCompleted: section.isCompleted,
      completionMessage: section.completionMessage,
      notScored: section.notScored,
      visibleIf: section.visibleIf,
      questions: questions,
    );
  }).toList();

  sections.sort((a, b) => a.order.compareTo(b.order));
  return sections;
}

String parseQuestionnaireVersion(Map<String, dynamic> json) {
  return _requireType<String>(json, 'version');
}

QuestionnaireQuestion _withSectionId(
  QuestionnaireQuestion question,
  String sectionId,
) {
  final json = question.toJson();
  json['sectionId'] = sectionId;
  return QuestionnaireQuestion.fromJson(json);
}

void _validateSection(Map<String, dynamic> json) {
  final sectionId = _requireType<String>(json, 'sectionId');
  if (sectionId.isEmpty) {
    throw const FormatException('Section field "sectionId" must not be empty.');
  }
  _requireType<String>(json, 'sectionTitle');
  _requireType<String>(json, 'engineTarget');
  _requireType<int>(json, 'order');

  final questions = json['questions'];
  if (questions != null && questions is! List<dynamic>) {
    throw FormatException(
      'Section "$sectionId" field "questions" must be a list when present.',
    );
  }

  if (questions is List<dynamic>) {
    for (final questionJson in questions) {
      if (questionJson is! Map<String, dynamic>) {
        throw FormatException(
          'Section "$sectionId" contains a question that is not an object.',
        );
      }
      _validateQuestion(questionJson, sectionId);
    }
  }
}

void _validateQuestion(Map<String, dynamic> json, String sectionId) {
  final questionId = _requireType<String>(json, 'questionId');
  if (questionId.isEmpty) {
    throw FormatException(
      'Question in section "$sectionId" has an empty "questionId".',
    );
  }
  _requireType<String>(json, 'questionType');
  _requireType<String>(json, 'text');

  final options = json['options'];
  if (options != null && options is! List<dynamic>) {
    throw FormatException(
      'Question "$questionId" field "options" must be a list when present.',
    );
  }

  if (options is List<dynamic>) {
    for (final optionJson in options) {
      if (optionJson is! Map<String, dynamic>) {
        throw FormatException(
          'Question "$questionId" contains an option that is not an object.',
        );
      }
      _validateOption(optionJson, questionId);
    }
  }
}

void _validateOption(Map<String, dynamic> json, String questionId) {
  final optionId = _requireType<String>(json, 'optionId');
  if (optionId.isEmpty) {
    throw FormatException(
      'Option in question "$questionId" has an empty "optionId".',
    );
  }
  _requireType<String>(json, 'label');
}

T _requireType<T>(Map<String, dynamic> json, String fieldName) {
  if (!json.containsKey(fieldName)) {
    throw FormatException('Missing required field "$fieldName".');
  }

  final value = json[fieldName];
  if (value is! T) {
    throw FormatException('Field "$fieldName" must be a $T.');
  }

  return value;
}
