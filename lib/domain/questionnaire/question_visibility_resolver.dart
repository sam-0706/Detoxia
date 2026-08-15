import 'models/question_option.dart';
import 'models/questionnaire_question.dart';
import 'models/questionnaire_section.dart';
import 'models/visibility_rule.dart';
import 'detoxia_question_bank.dart';
import 'resolver_context.dart';

/// Determines which sections and questions are visible for a given user context.
///
/// This is the single source of truth for "what does this user see?".
/// UI and the scoring engine must consult this resolver — they must never
/// re-implement the gating logic themselves.
///
/// All methods are pure: no mutation of the bank or the context.
///
/// ## Option-level gates
/// Options may carry their own `visibleIf` rule (or the legacy `ageGate`
/// shape, normalised on parse). [resolveVisibleQuestions] returns questions
/// whose `options` lists are **already filtered**, so any widget rendering a
/// resolved question cannot show an option the user should not see. This is
/// what keeps adult-only goals and triggers away from younger age bands.
class QuestionVisibilityResolver {
  final DetoxiaQuestionBank bank;

  const QuestionVisibilityResolver(this.bank);

  /// Asked of everyone — these shape the whole plan regardless of goals.
  static const Set<String> _routineCoreQuestionIds = {
    'routine_context',
    'routine_wake',
    'routine_sleep_attempt',
    'routine_sleep_latency',
    'routine_free_windows',
    'routine_vulnerable_windows',
  };

  /// Fixed-schedule questions — only meaningful when a daytime structure is
  /// being modelled, so they stay behind the same goal gate as commute.
  static const Set<String> _routineScheduleQuestionIds = {
    'routine_arrival',
    'routine_busy_start',
    'routine_busy_end',
  };

  /// Commute chain. Goal-gated here; *additionally* gated on the user's life
  /// context by `visibleIf` rules in the question bank, so someone who works
  /// from home or has no fixed schedule is never asked how they commute.
  static const Set<String> _routineCommuteQuestionIds = {
    'routine_commute_mode',
    'routine_commute_to',
    'routine_commute_back',
    'routine_commute_phone',
  };

  static const Set<String> _routineScheduleGoals = {
    'scrolling',
    'sexualContent',
    'sexualControl',
    'focus',
    'anxiety',
    'lowMood',
    'energy',
  };

  static const Set<String> _routinePrivacyQuestionIds = {
    'routine_alone_windows',
    'routine_phone_in_bed',
  };

  // ─────────────────────────────────────────────────────────────────────────
  // Core visibility predicate
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns `true` when [rule] allows this [ctx].
  ///
  /// A `null` rule means "always visible". When a rule has multiple fields set,
  /// **all** of them must evaluate to `true` (implicit AND). Explicit `all` /
  /// `any` lists recurse into sub-rules.
  bool isVisible(VisibilityRule? rule, ResolverContext ctx) {
    if (rule == null) return true;

    if (rule.ageBandIn != null && !rule.ageBandIn!.contains(ctx.ageBand.name)) {
      return false;
    }

    if (rule.ageBandNotIn != null &&
        rule.ageBandNotIn!.contains(ctx.ageBand.name)) {
      return false;
    }

    if (rule.genderIn != null && !rule.genderIn!.contains(ctx.gender.name)) {
      return false;
    }

    if (rule.goalSelected != null && !_hasGoal(ctx, rule.goalSelected!)) {
      return false;
    }

    if (rule.answerEquals != null &&
        !_evalAnswerEquals(rule.answerEquals!, ctx)) {
      return false;
    }

    // `answerIn` requires an actual answer — an unanswered parent hides the
    // follow-up. `answerNotIn` is permissive by default and only hides on an
    // explicit match.
    if (rule.answerIn != null && !_evalAnswerIn(rule.answerIn!, ctx)) {
      return false;
    }

    if (rule.answerNotIn != null && _evalAnswerIn(rule.answerNotIn!, ctx)) {
      return false;
    }

    if (rule.all != null && !rule.all!.every((r) => isVisible(r, ctx))) {
      return false;
    }

    if (rule.any != null && !rule.any!.any((r) => isVisible(r, ctx))) {
      return false;
    }

    return true;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Section / question filtering
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns sections visible for [ctx], with each section's `questions` list
  /// already filtered to its own visible questions.
  ///
  /// Sections whose visible question list is empty after filtering are excluded
  /// (this covers computed sections like `sleep_debt` as well as sections whose
  /// gate hides all questions for this persona).
  /// [tier] narrows the result to questions at that tier or sooner. Passing
  /// [QuestionTier.core] yields the onboarding pass; passing null (the
  /// default) yields everything, which is what the "finish your setup" flow
  /// and the settings retake use.
  List<QuestionnaireSection> resolveVisibleSections(
    ResolverContext ctx, {
    QuestionTier? tier,
  }) {
    final result = <QuestionnaireSection>[];

    for (final section in bank.sectionsOrdered()) {
      final shouldUseJsonSectionRule =
          section.sectionId != 'cycle_sensitivity' &&
          section.sectionId != 'menstrual_phase';
      if (shouldUseJsonSectionRule && !isVisible(section.visibleIf, ctx)) {
        continue;
      }
      final sectionHasAnsweredQuestion = section.questions.any(
        (question) => ctx.answers.containsKey(question.questionId),
      );
      final canResurfaceAnsweredSection =
          sectionHasAnsweredQuestion &&
          ((section.sectionId != 'cycle_sensitivity' &&
                  section.sectionId != 'menstrual_phase') ||
              ctx.gender.name == 'female');
      if (!_isSectionGoalVisible(section.sectionId, ctx) &&
          !canResurfaceAnsweredSection) {
        continue;
      }

      final visibleQuestions = resolveVisibleQuestions(section, ctx, tier: tier);
      if (visibleQuestions.isEmpty) continue;

      result.add(
        QuestionnaireSection(
          sectionId: section.sectionId,
          sectionTitle: section.sectionTitle,
          sectionSubtitle: section.sectionSubtitle,
          engineTarget: section.engineTarget,
          order: section.order,
          isCompleted: section.isCompleted,
          completionMessage: section.completionMessage,
          notScored: section.notScored,
          visibleIf: section.visibleIf,
          questions: visibleQuestions,
        ),
      );
    }

    return result;
  }

  /// Returns the visible questions within [section] for [ctx], each with its
  /// `options` already narrowed to the options this user may see.
  ///
  /// A question whose every option is gated away is dropped entirely — an
  /// empty option list would render as an unanswerable dead end.
  List<QuestionnaireQuestion> resolveVisibleQuestions(
    QuestionnaireSection section,
    ResolverContext ctx, {
    QuestionTier? tier,
  }) {
    final result = <QuestionnaireQuestion>[];

    for (final question in section.questions) {
      // Tier filter runs first: a deep question is not "hidden" for this
      // persona, it simply isn't being asked yet.
      if (tier == QuestionTier.core && question.tier != QuestionTier.core) {
        continue;
      }
      if (!isVisible(question.visibleIf, ctx)) continue;
      if (!_isQuestionGoalVisible(
        section.sectionId,
        question.questionId,
        ctx,
      )) {
        continue;
      }

      final options = question.options;
      // No options to gate (prose/info questions, and question types that
      // supply their own control) — nothing to filter, nothing to drop.
      if (options == null || options.isEmpty) {
        result.add(question);
        continue;
      }

      // Only drop when gating removed *every* option, which would otherwise
      // render an unanswerable dead end.
      final visibleOptions = resolveVisibleOptions(question, ctx);
      if (visibleOptions.isEmpty) continue;

      result.add(
        visibleOptions.length == options.length
            ? question
            : question.copyWith(options: visibleOptions),
      );
    }

    return result;
  }

  /// Returns the options of [question] that [ctx] is allowed to see.
  List<QuestionOption> resolveVisibleOptions(
    QuestionnaireQuestion question,
    ResolverContext ctx,
  ) {
    final options = question.options;
    if (options == null) return const [];
    return options
        .where((option) => isVisible(option.visibleIf, ctx))
        .toList(growable: false);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Navigation
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns the first unanswered visible question that is not in an already-
  /// completed section.
  ///
  /// Returns `null` when all visible questions have answers.
  ///
  /// [completedSectionIds] is the set of section IDs the user has already
  /// submitted. [currentQuestionId] is accepted for API symmetry but the
  /// implementation simply finds the first unanswered question regardless of
  /// current position; callers that need "next after current" should pre-fill
  /// [ctx.answers] with the current question's answer first.
  ({String sectionId, String questionId})? resolveNextQuestion({
    required ResolverContext ctx,
    required Iterable<String> completedSectionIds,
    String? currentQuestionId,
  }) {
    final completedSet = completedSectionIds.toSet();

    for (final section in resolveVisibleSections(ctx)) {
      if (completedSet.contains(section.sectionId)) continue;

      for (final question in section.questions) {
        if (!ctx.answers.containsKey(question.questionId)) {
          return (
            sectionId: section.sectionId,
            questionId: question.questionId,
          );
        }
      }
    }

    return null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Internal helpers
  // ─────────────────────────────────────────────────────────────────────────

  bool _evalAnswerEquals(AnswerEqualsClause clause, ResolverContext ctx) {
    if (!ctx.answers.containsKey(clause.questionId)) return false;
    final answer = ctx.answers[clause.questionId];
    if (answer == clause.value) return true;
    if (answer is Map && answer['selectedOptionId'] == clause.value) {
      return true;
    }
    return false;
  }

  /// True when the recorded answer for [clause.questionId] intersects
  /// [clause.values]. Unanswered questions return false; callers decide what
  /// that means for their rule.
  bool _evalAnswerIn(AnswerInClause clause, ResolverContext ctx) {
    final selected = _selectedOptionIds(ctx.answers[clause.questionId]);
    if (selected.isEmpty) return false;
    return selected.any(clause.values.contains);
  }

  /// Normalises the several answer shapes in play: a bare string, a
  /// single-choice `{selectedOptionId: ...}` map, or a multi-choice
  /// `{selectedOptionIds: [...]}` map.
  List<String> _selectedOptionIds(dynamic answer) {
    if (answer == null) return const [];
    if (answer is String) return [answer];
    if (answer is Map) {
      final many = answer['selectedOptionIds'];
      if (many is List) {
        return many.map((value) => '$value').toList(growable: false);
      }
      final one = answer['selectedOptionId'];
      if (one != null) return ['$one'];
    }
    return const [];
  }

  bool _isSectionGoalVisible(String sectionId, ResolverContext ctx) {
    switch (sectionId) {
      case 'scrolling_control':
        return _hasAnyGoal(ctx, const {'scrolling'});
      case 'sexual_content_teen':
        return _hasAnyGoal(ctx, const {'sexualContent'});
      case 'sexual_control_adult':
        return _hasAnyGoal(ctx, const {'sexualControl', 'sexualContent'});
      case 'focus_support':
        return _hasAnyGoal(ctx, const {'focus'});
      case 'anxiety_load':
        return _hasAnyGoal(ctx, const {'anxiety'});
      case 'low_mood_support':
        return _hasAnyGoal(ctx, const {'lowMood'});
      case 'sleep_disruption':
        return _hasAnyGoal(ctx, const {'sleep'});
      case 'physical_activation':
        return _hasAnyGoal(ctx, const {'energy'});
      case 'cycle_sensitivity':
        return ctx.gender.name == 'female' &&
            (_hasAnyGoal(ctx, const {'cycle'}) || _isMenstruationEnabled(ctx));
      case 'menstrual_phase':
        return ctx.gender.name == 'female' &&
            (_hasAnyGoal(ctx, const {'cycle'}) || _isMenstruationEnabled(ctx)) &&
            _isMenstruationEnabled(ctx);
      default:
        return true;
    }
  }

  bool _isQuestionGoalVisible(
    String sectionId,
    String questionId,
    ResolverContext ctx,
  ) {
    if (ctx.answers.containsKey(questionId)) {
      return true;
    }

    if (sectionId == 'routine_map') {
      if (_routineCoreQuestionIds.contains(questionId)) {
        return true;
      }

      if (_routineScheduleQuestionIds.contains(questionId) ||
          _routineCommuteQuestionIds.contains(questionId)) {
        return _hasAnyGoal(ctx, _routineScheduleGoals);
      }

      if (_routinePrivacyQuestionIds.contains(questionId)) {
        return _hasAnyGoal(
          ctx,
          const {'sleep', 'scrolling', 'sexualContent', 'sexualControl'},
        );
      }
    }

    if (sectionId == 'cycle_sensitivity') {
      if (questionId == 'cycle_menstruation_gate') {
        return true;
      }
      return _isMenstruationEnabled(ctx);
    }

    return true;
  }

  bool _isMenstruationEnabled(ResolverContext ctx) {
    final answer = ctx.answers['cycle_menstruation_gate'];
    if (answer == 'yes_or_unsure') return true;
    if (answer is Map && answer['selectedOptionId'] == 'yes_or_unsure') {
      return true;
    }
    return false;
  }

  bool _hasAnyGoal(ResolverContext ctx, Set<String> goalTags) {
    return goalTags.any((goal) => _hasGoal(ctx, goal));
  }

  bool _hasGoal(ResolverContext ctx, String goalTag) {
    final normalized = _normalizeGoal(goalTag);
    return ctx.selectedGoals.any(
      (goal) => _normalizeGoal(goal) == normalized,
    );
  }

  String _normalizeGoal(String goal) {
    switch (goal) {
      case 'goal_scrolling':
      case 'scrolling':
        return 'scrolling';
      case 'goal_sexual_content':
      case 'sexualContent':
        return 'sexualContent';
      case 'goal_porn_masturbation':
      case 'sexualControl':
        return 'sexualControl';
      case 'goal_focus':
      case 'focus':
        return 'focus';
      case 'goal_anxiety':
      case 'anxiety':
        return 'anxiety';
      case 'goal_low_mood':
      case 'lowMood':
        return 'lowMood';
      case 'goal_sleep':
      case 'sleep':
        return 'sleep';
      case 'goal_energy':
      case 'energy':
      case 'physicalActivation':
        return 'energy';
      case 'goal_cycle':
      case 'cycle':
        return 'cycle';
      default:
        return goal;
    }
  }
}
