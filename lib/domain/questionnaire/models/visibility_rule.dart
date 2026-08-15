class AnswerEqualsClause {
  final String questionId;
  final dynamic value;

  const AnswerEqualsClause({required this.questionId, required this.value});

  factory AnswerEqualsClause.fromJson(Map<String, dynamic> json) {
    return AnswerEqualsClause(
      questionId: json['questionId'] as String? ?? '',
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'questionId': questionId, 'value': value};
  }
}

/// Membership test against a previous answer.
///
/// Used by both `answerIn` (visible when the answer *is* one of [values]) and
/// `answerNotIn` (visible when it is not). The two differ in how they treat an
/// unanswered question — see [VisibilityRule].
class AnswerInClause {
  final String questionId;
  final List<String> values;

  const AnswerInClause({required this.questionId, required this.values});

  factory AnswerInClause.fromJson(Map<String, dynamic> json) {
    final rawValues = json['values'];
    return AnswerInClause(
      questionId: json['questionId'] as String? ?? '',
      values: rawValues is List
          ? rawValues.map((value) => '$value').toList(growable: false)
          : const <String>[],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'questionId': questionId, 'values': values};
  }
}

class VisibilityRule {
  final List<VisibilityRule>? all;
  final List<VisibilityRule>? any;
  final List<String>? ageBandIn;
  final List<String>? ageBandNotIn;
  final List<String>? genderIn;
  final String? goalSelected;
  final AnswerEqualsClause? answerEquals;

  /// Visible only when [answerIn.questionId] has been answered **and** the
  /// selection is one of the listed option ids. An unanswered question fails
  /// this rule, which makes it the safe choice for follow-up questions that
  /// must not appear before their parent is answered.
  final AnswerInClause? answerIn;

  /// Visible unless the selection is one of the listed option ids. An
  /// unanswered question *passes* this rule, so use it for questions that
  /// should show by default and only disappear on specific answers.
  final AnswerInClause? answerNotIn;

  const VisibilityRule({
    this.all,
    this.any,
    this.ageBandIn,
    this.ageBandNotIn,
    this.genderIn,
    this.goalSelected,
    this.answerEquals,
    this.answerIn,
    this.answerNotIn,
  });

  factory VisibilityRule.fromJson(Map<String, dynamic> json) {
    return VisibilityRule(
      all: _readRuleList(json['all']),
      any: _readRuleList(json['any']),
      ageBandIn: _readStringList(json['ageBandIn']),
      ageBandNotIn: _readStringList(json['ageBandNotIn']),
      genderIn: _readStringList(json['genderIn']),
      goalSelected: json['goalSelected'] as String?,
      answerEquals: _readAnswerEquals(json['answerEquals']),
      answerIn: _readAnswerIn(json['answerIn']),
      answerNotIn: _readAnswerIn(json['answerNotIn']),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (all != null) {
      json['all'] = all!.map((rule) => rule.toJson()).toList();
    }
    if (any != null) {
      json['any'] = any!.map((rule) => rule.toJson()).toList();
    }
    if (ageBandIn != null) {
      json['ageBandIn'] = ageBandIn;
    }
    if (ageBandNotIn != null) {
      json['ageBandNotIn'] = ageBandNotIn;
    }
    if (genderIn != null) {
      json['genderIn'] = genderIn;
    }
    if (goalSelected != null) {
      json['goalSelected'] = goalSelected;
    }
    if (answerEquals != null) {
      json['answerEquals'] = answerEquals!.toJson();
    }
    if (answerIn != null) {
      json['answerIn'] = answerIn!.toJson();
    }
    if (answerNotIn != null) {
      json['answerNotIn'] = answerNotIn!.toJson();
    }

    return json;
  }

  static AnswerEqualsClause? _readAnswerEquals(dynamic value) {
    if (value is Map<String, dynamic>) {
      return AnswerEqualsClause.fromJson(value);
    }
    if (value is Map) {
      return AnswerEqualsClause.fromJson(Map<String, dynamic>.from(value));
    }
    return null;
  }

  static AnswerInClause? _readAnswerIn(dynamic value) {
    if (value is Map<String, dynamic>) {
      return AnswerInClause.fromJson(value);
    }
    if (value is Map) {
      return AnswerInClause.fromJson(Map<String, dynamic>.from(value));
    }
    return null;
  }

  static List<VisibilityRule>? _readRuleList(dynamic value) {
    if (value is! List) {
      return null;
    }

    return value
        .map(
          (item) => item is Map<String, dynamic>
              ? VisibilityRule.fromJson(item)
              : VisibilityRule.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  static List<String>? _readStringList(dynamic value) {
    if (value is! List) {
      return null;
    }

    return value.map((item) => item as String).toList();
  }
}
