import 'package:detoxia/core/constants/enums.dart';

/// Input snapshot used by [QuestionVisibilityResolver].
///
/// All fields are immutable. The resolver never mutates this object.
class ResolverContext {
  /// The user's age band from their registration profile.
  final RegistrationAgeBand ageBand;

  /// The user's gender from their registration profile.
  final RegistrationGender gender;

  /// Goal option IDs the user selected on the goal-selection question.
  /// Common values are option IDs like `goal_sleep` and `goal_anxiety`.
  final List<String> selectedGoals;

  /// Raw answers keyed by `questionId`.
  ///
  /// Values can be:
  /// - A plain scalar (String, bool, num) for single-choice / yesNo answers.
  /// - A `Map<String, dynamic>` with a `selectedOptionId` key for single-choice
  ///   answers stored as option objects.
  /// - A `List` for multi-choice answers.
  final Map<String, dynamic> answers;

  const ResolverContext({
    required this.ageBand,
    required this.gender,
    required this.selectedGoals,
    required this.answers,
  });
}
