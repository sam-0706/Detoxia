import 'question_option.dart';
import 'question_type.dart';
import 'visibility_rule.dart';

class AgeGate {
  final List<String>? include;
  final List<String>? exclude;

  const AgeGate({this.include, this.exclude});

  factory AgeGate.fromJson(Map<String, dynamic> json) {
    return AgeGate(
      include: _readStringList(json['include']),
      exclude: _readStringList(json['exclude']),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (include != null) {
      json['include'] = include;
    }
    if (exclude != null) {
      json['exclude'] = exclude;
    }
    return json;
  }

  static List<String>? _readStringList(dynamic value) {
    if (value is! List) {
      return null;
    }
    return value.map((item) => item as String).toList();
  }
}

class GenderGate {
  final List<String>? include;

  const GenderGate({this.include});

  factory GenderGate.fromJson(Map<String, dynamic> json) {
    return GenderGate(include: AgeGate._readStringList(json['include']));
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (include != null) {
      json['include'] = include;
    }
    return json;
  }
}

/// How soon a question needs answering.
///
/// The full bank is far more than anyone will sit through in one go, so
/// onboarding asks only what the app cannot function without and the rest is
/// finished later from the home screen, a few at a time.
enum QuestionTier {
  /// Asked during onboarding — the app can't personalise anything without it.
  core,

  /// Deferred. Sharpens the model but isn't needed to produce a first plan.
  deep,
}

QuestionTier questionTierFromJson(String? value) =>
    value == 'core' ? QuestionTier.core : QuestionTier.deep;

class QuestionnaireQuestion {
  final String questionId;
  final String sectionId;
  final QuestionType questionType;
  final String text;
  final String? helperText;
  final bool required;
  final String? scoreDomain;
  final int? scaleMin;
  final int? scaleMax;
  final List<QuestionOption>? options;
  final VisibilityRule? visibleIf;
  final bool safetyGate;
  final bool notScored;
  final AgeGate? ageGate;
  final GenderGate? genderGate;

  /// Whether this is asked during onboarding or deferred — see
  /// [QuestionTier]. Defaults to [QuestionTier.deep] so a question is
  /// only ever pulled into onboarding by explicitly opting in.
  final QuestionTier tier;

  const QuestionnaireQuestion({
    required this.questionId,
    this.sectionId = '',
    required this.questionType,
    required this.text,
    this.helperText,
    this.required = true,
    this.scoreDomain,
    this.scaleMin,
    this.scaleMax,
    this.options,
    this.visibleIf,
    this.safetyGate = false,
    this.notScored = false,
    this.ageGate,
    this.genderGate,
    this.tier = QuestionTier.deep,
  });

  QuestionnaireQuestion copyWith({
    String? sectionId,
    List<QuestionOption>? options,
    String? text,
    String? helperText,
  }) {
    return QuestionnaireQuestion(
      questionId: questionId,
      sectionId: sectionId ?? this.sectionId,
      questionType: questionType,
      text: text ?? this.text,
      helperText: helperText ?? this.helperText,
      required: required,
      scoreDomain: scoreDomain,
      scaleMin: scaleMin,
      scaleMax: scaleMax,
      options: options ?? this.options,
      visibleIf: visibleIf,
      safetyGate: safetyGate,
      notScored: notScored,
      ageGate: ageGate,
      genderGate: genderGate,
      tier: tier,
    );
  }

  factory QuestionnaireQuestion.fromJson(Map<String, dynamic> json) {
    return QuestionnaireQuestion(
      questionId: json['questionId'] as String? ?? '',
      sectionId: json['sectionId'] as String? ?? '',
      questionType: questionTypeFromJson(json['questionType'] as String? ?? ''),
      text: json['text'] as String? ?? '',
      helperText: json['helperText'] as String?,
      required: json['required'] as bool? ?? true,
      scoreDomain: json['scoreDomain'] as String?,
      scaleMin: json['scaleMin'] as int?,
      scaleMax: json['scaleMax'] as int?,
      options: _readOptions(json['options']),
      visibleIf: json['visibleIf'] is Map<String, dynamic>
          ? VisibilityRule.fromJson(json['visibleIf'] as Map<String, dynamic>)
          : json['visibleIf'] is Map
          ? VisibilityRule.fromJson(
              Map<String, dynamic>.from(json['visibleIf'] as Map),
            )
          : null,
      safetyGate: json['safetyGate'] as bool? ?? false,
      notScored: json['notScored'] as bool? ?? false,
      ageGate: json['ageGate'] is Map<String, dynamic>
          ? AgeGate.fromJson(json['ageGate'] as Map<String, dynamic>)
          : json['ageGate'] is Map
          ? AgeGate.fromJson(Map<String, dynamic>.from(json['ageGate'] as Map))
          : null,
      genderGate: json['genderGate'] is Map<String, dynamic>
          ? GenderGate.fromJson(json['genderGate'] as Map<String, dynamic>)
          : json['genderGate'] is Map
          ? GenderGate.fromJson(
              Map<String, dynamic>.from(json['genderGate'] as Map),
            )
          : null,
      tier: questionTierFromJson(json['tier'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'questionId': questionId,
      'questionType': questionType.jsonValue,
      'text': text,
    };

    if (sectionId.isNotEmpty) {
      json['sectionId'] = sectionId;
    }
    if (helperText != null) {
      json['helperText'] = helperText;
    }
    if (!required) {
      json['required'] = required;
    }
    if (scoreDomain != null) {
      json['scoreDomain'] = scoreDomain;
    }
    if (scaleMin != null) {
      json['scaleMin'] = scaleMin;
    }
    if (scaleMax != null) {
      json['scaleMax'] = scaleMax;
    }
    if (options != null) {
      json['options'] = options!.map((option) => option.toJson()).toList();
    }
    if (visibleIf != null) {
      json['visibleIf'] = visibleIf!.toJson();
    }
    if (safetyGate) {
      json['safetyGate'] = safetyGate;
    }
    if (notScored) {
      json['notScored'] = notScored;
    }
    if (ageGate != null) {
      json['ageGate'] = ageGate!.toJson();
    }
    if (genderGate != null) {
      json['genderGate'] = genderGate!.toJson();
    }
    if (tier == QuestionTier.core) {
      json['tier'] = 'core';
    }

    return json;
  }

  static List<QuestionOption>? _readOptions(dynamic value) {
    if (value is! List) {
      return null;
    }

    return value
        .map(
          (item) => item is Map<String, dynamic>
              ? QuestionOption.fromJson(item)
              : QuestionOption.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }
}
