import 'visibility_rule.dart';

class QuestionOption {
  final String optionId;
  final String label;
  final num? numericValue;
  final int? midpointMinutes;
  final int? midpointDurationMinutes;
  final String? tag;

  /// Gate for this single option.
  ///
  /// Evaluated by `QuestionVisibilityResolver.resolveVisibleOptions`, which
  /// every answer widget goes through — an option that fails this rule is
  /// never rendered and can never be selected. The legacy
  /// `"ageGate": {"include": [...]}` JSON shape is normalised into an
  /// [VisibilityRule.ageBandIn] rule on parse.
  final VisibilityRule? visibleIf;

  const QuestionOption({
    required this.optionId,
    required this.label,
    this.numericValue,
    this.midpointMinutes,
    this.midpointDurationMinutes,
    this.tag,
    this.visibleIf,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      optionId: json['optionId'] as String? ?? '',
      label: json['label'] as String? ?? '',
      numericValue: json['numericValue'] as num?,
      midpointMinutes: json['midpointMinutes'] as int?,
      midpointDurationMinutes: json['midpointDurationMinutes'] as int?,
      tag: json['tag'] as String?,
      visibleIf: _readVisibility(json),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'optionId': optionId, 'label': label};

    if (numericValue != null) {
      json['numericValue'] = numericValue;
    }
    if (midpointMinutes != null) {
      json['midpointMinutes'] = midpointMinutes;
    }
    if (midpointDurationMinutes != null) {
      json['midpointDurationMinutes'] = midpointDurationMinutes;
    }
    if (tag != null) {
      json['tag'] = tag;
    }
    if (visibleIf != null) {
      json['visibleIf'] = visibleIf!.toJson();
    }

    return json;
  }

  static VisibilityRule? _readVisibility(Map<String, dynamic> json) {
    final explicit = json['visibleIf'];
    if (explicit is Map) {
      return VisibilityRule.fromJson(
        explicit is Map<String, dynamic>
            ? explicit
            : Map<String, dynamic>.from(explicit),
      );
    }

    // Legacy shape: {"ageGate": {"include": ["teen16To17", "adult18Plus"]}}
    final ageGate = json['ageGate'];
    if (ageGate is Map) {
      final include = ageGate['include'];
      if (include is List) {
        return VisibilityRule(
          ageBandIn: include.map((value) => '$value').toList(growable: false),
        );
      }
    }

    return null;
  }
}
