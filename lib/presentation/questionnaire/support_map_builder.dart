import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/learning/models/intervention_preferences.dart';
import 'package:detoxia/domain/learning/models/learning_state.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/pathways/models/trigger_weight.dart';
import 'package:detoxia/domain/questionnaire/detoxia_question_bank.dart';
import 'package:detoxia/domain/questionnaire/models/question_option.dart';
import 'package:detoxia/domain/questionnaire/question_visibility_resolver.dart';
import 'package:detoxia/domain/questionnaire/resolver_context.dart';
import 'package:detoxia/domain/routine/models/menstrual_profile.dart';
import 'package:detoxia/domain/routine/models/routine_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/detoxia_scoring_engine.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';

class SupportMapBuilder {
  final DetoxiaQuestionBank bank;
  final QuestionVisibilityResolver resolver;

  const SupportMapBuilder({required this.bank, required this.resolver});

  SupportProfile build({
    required RegistrationProfile registration,
    required Map<String, dynamic> answers,
    required DateTime now,
  }) {
    final ageBand = _ageBandFromString(registration.ageBand);
    final gender = _genderFromString(registration.gender);
    final selectedGoals = _selectedOptionIds('goal_q1', answers);
    final context = ResolverContext(
      ageBand: ageBand,
      gender: gender,
      selectedGoals: selectedGoals,
      answers: answers,
    );
    final visibleSectionIds = resolver
        .resolveVisibleSections(context)
        .map((s) => s.sectionId)
        .toSet();

    final routineProfile = _buildRoutineProfile(answers);
    final sleepDisruption = _scoreSleepDisruption(answers);
    final sleepProfile = _buildSleepProfile(
      answers: answers,
      ageBand: ageBand,
      sleepDisruptionScore: sleepDisruption.visibleScore,
    );
    final cycleScore = _scoreCycleSensitivity(answers);
    final menstrualProfile = _buildMenstrualProfile(
      answers: answers,
      now: now,
      enabled: visibleSectionIds.contains('menstrual_phase'),
      cycleSensitivityScore: cycleScore.visibleScore,
    );
    final triggerWeights = _buildTriggerWeights(answers, now);
    final routineRisk = _routineRiskScore(routineProfile);
    final domainScores = _buildDomainScores(
      answers: answers,
      visibleSectionIds: visibleSectionIds,
      sleepDisruption: sleepDisruption,
      cycleSensitivity: cycleScore,
    );
    final pathwayScores = _buildPathwayScores(
      domainScores: domainScores,
      routineRisk: routineRisk,
      triggerWeights: triggerWeights,
    );

    return SupportProfile(
      registrationProfileId: registration.id,
      selectedGoals: selectedGoals,
      domainScores: domainScores,
      routineProfile: routineProfile,
      sleepProfile: sleepProfile,
      menstrualProfile: menstrualProfile,
      triggerWeights: triggerWeights,
      pathwayScores: pathwayScores,
      interventionPreferences: _buildInterventionPreferences(answers),
      learningState: LearningState(
        recoveryMomentum: 5.0,
        predictionAccuracy: 5.0,
        falseAlarmRate: 0.0,
        triggerReliabilityMap: const {},
        interventionRewardsMap: const {},
        lastUpdatedAt: now,
      ),
      createdAt: now,
      updatedAt: now,
    );
  }

  List<DomainScore> _buildDomainScores({
    required Map<String, dynamic> answers,
    required Set<String> visibleSectionIds,
    required DomainScore sleepDisruption,
    required DomainScore cycleSensitivity,
  }) {
    return [
      _withEnabled(
        DetoxiaScoringEngine.scoreScrollingControl(
          _numericAnswers([
            'scroll_q1',
            'scroll_q2',
            'scroll_q3',
            'scroll_q4',
            'scroll_q5',
          ], answers),
        ),
        visibleSectionIds.contains('scrolling_control'),
      ),
      _withEnabled(
        DetoxiaScoringEngine.scoreSexualContentControl(
          _numericAnswers([
            'sxteen_q1',
            'sxteen_q2',
            'sxteen_q3',
            'sxteen_q4',
            'sxteen_q5',
          ], answers),
        ),
        visibleSectionIds.contains('sexual_content_teen'),
      ),
      _withEnabled(
        DetoxiaScoringEngine.scoreSexualControlRecovery(
          _numericAnswers([
            'sxadult_q1',
            'sxadult_q2',
            'sxadult_q3',
            'sxadult_q4',
            'sxadult_q5',
          ], answers),
        ),
        visibleSectionIds.contains('sexual_control_adult'),
      ),
      _withEnabled(
        DetoxiaScoringEngine.scoreFocusSupport(
          _numericAnswers([
            'focus_q1',
            'focus_q2',
            'focus_q3',
            'focus_q4',
            'focus_q5',
            'focus_q6',
          ], answers),
        ),
        visibleSectionIds.contains('focus_support'),
      ),
      _withEnabled(
        DetoxiaScoringEngine.scoreAnxietyLoad(
          _numericAnswers(['anx_q1', 'anx_q2', 'anx_q3', 'anx_q4'], answers),
        ),
        visibleSectionIds.contains('anxiety_load'),
      ),
      _withEnabled(
        DetoxiaScoringEngine.scoreLowMoodSupport(
          _numericAnswers([
            'mood_q1',
            'mood_q2',
            'mood_q3',
            'mood_q4',
          ], answers),
        ),
        visibleSectionIds.contains('low_mood_support'),
      ),
      _withEnabled(
        sleepDisruption,
        visibleSectionIds.contains('sleep_disruption'),
      ),
      _withEnabled(
        DetoxiaScoringEngine.scorePhysicalActivation(
          _numericAnswers(['phys_q1', 'phys_q2', 'phys_q3'], answers),
        ),
        visibleSectionIds.contains('physical_activation'),
      ),
      _withEnabled(
        cycleSensitivity,
        visibleSectionIds.contains('cycle_sensitivity'),
      ),
    ];
  }

  DomainScore _scoreSleepDisruption(Map<String, dynamic> answers) {
    return DetoxiaScoringEngine.scoreSleepDisruption(
      _numericAnswers([
        'sleep_q1',
        'sleep_q2',
        'sleep_q3',
        'sleep_q4',
        'sleep_q5',
      ], answers),
    );
  }

  DomainScore _scoreCycleSensitivity(Map<String, dynamic> answers) {
    return DetoxiaScoringEngine.scoreCycleSensitivity(
      _numericAnswers([
        'cycle_q1',
        'cycle_q2',
        'cycle_q3',
        'cycle_q4',
        'cycle_q5',
        'cycle_q6',
        'cycle_q7',
      ], answers),
    );
  }

  DomainScore _withEnabled(DomainScore score, bool enabled) {
    return DomainScore(
      id: score.id,
      label: score.label,
      rawScore: score.rawScore,
      maxRawScore: score.maxRawScore,
      visibleScore: score.visibleScore,
      band: score.band,
      enabled: enabled,
      confidence: enabled ? score.confidence : 0.0,
      explanation: score.explanation,
    );
  }

  RoutineProfile _buildRoutineProfile(Map<String, dynamic> answers) {
    return RoutineProfile(
      wakeWindow:
          _optionLabel('routine_wake', answers) ?? 'Flexible / changes daily',
      sleepAttemptWindow:
          _optionLabel('routine_sleep_attempt', answers) ??
          'Flexible / changes daily',
      sleepLatencyRange:
          _optionLabel('routine_sleep_latency', answers) ?? 'Highly variable',
      schoolWorkArrivalWindow: _optionLabel('routine_arrival', answers),
      busyStartWindow: _optionLabel('routine_busy_start', answers),
      busyEndWindow: _optionLabel('routine_busy_end', answers),
      commuteToDuration: _durationMinutes('routine_commute_to', answers),
      commuteBackDuration: _durationMinutes('routine_commute_back', answers),
      commuteMode: _optionLabel('routine_commute_mode', answers),
      commutePhoneUseScore: _numericValue('routine_commute_phone', answers),
      freeWindows: _selectedLabels('routine_free_windows', answers),
      aloneWindows: _selectedLabels('routine_alone_windows', answers),
      phoneInBedScore: _numericValue('routine_phone_in_bed', answers),
      vulnerableWindows: _selectedLabels('routine_vulnerable_windows', answers),
    );
  }

  SleepProfile _buildSleepProfile({
    required Map<String, dynamic> answers,
    required RegistrationAgeBand ageBand,
    required double sleepDisruptionScore,
  }) {
    return DetoxiaScoringEngine.computeSleepProfile(
      wakeWindow:
          _optionLabel('routine_wake', answers) ?? 'Flexible / changes daily',
      sleepAttemptWindow:
          _optionLabel('routine_sleep_attempt', answers) ??
          'Flexible / changes daily',
      sleepLatencyRange:
          _optionLabel('routine_sleep_latency', answers) ?? 'Highly variable',
      wakeMidpointMinutes: _midpointMinutes(
        'routine_wake',
        answers,
        fallback: 480,
      ),
      sleepAttemptMidpointMinutes: _midpointMinutes(
        'routine_sleep_attempt',
        answers,
        fallback: 1380,
      ),
      latencyMidpointMinutes: _durationMinutes(
        'routine_sleep_latency',
        answers,
        fallback: 60,
      ),
      sleepDisruptionScore: sleepDisruptionScore,
      ageBand: ageBand,
    );
  }

  MenstrualProfile? _buildMenstrualProfile({
    required Map<String, dynamic> answers,
    required DateTime now,
    required bool enabled,
    required double cycleSensitivityScore,
  }) {
    if (!enabled) return null;
    return DetoxiaScoringEngine.computeMenstrualPhase(
      enabled: true,
      today: now,
      lastPeriodStart: _dateAnswer('mens_last_period_start', answers),
      averageCycleLength: _numericValue(
        'mens_avg_cycle_length',
        answers,
        fallback: 28,
      ),
      averageBleedingLength: _numericValue(
        'mens_avg_bleeding_length',
        answers,
        fallback: 5,
      ),
      regularity: _regularity(answers),
      cycleSensitivityScore: cycleSensitivityScore,
    );
  }

  List<TriggerWeight> _buildTriggerWeights(
    Map<String, dynamic> answers,
    DateTime now,
  ) {
    final selected = _selectedOptionIds('trig_select', answers);
    final weights = selected.map((id) {
      final strength = _numericValue('trig_strength_$id', answers, fallback: 2);
      return TriggerWeight(
        triggerId: id,
        label: _optionLabelById('trig_select', id) ?? _fallbackLabel(id),
        strengthRaw: strength,
        weight0To10: (strength / 3.0 * 10.0).clamp(0.0, 10.0),
        reliability: 0.6,
        lastUpdatedAt: now,
      );
    }).toList()..sort((a, b) => b.weight0To10.compareTo(a.weight0To10));
    return weights;
  }

  List<PathwayScore> _buildPathwayScores({
    required List<DomainScore> domainScores,
    required double routineRisk,
    required List<TriggerWeight> triggerWeights,
  }) {
    final enabledScores = domainScores.where((score) => score.enabled).toList();
    final topTrigger = triggerWeights.isEmpty
        ? 0.0
        : triggerWeights.first.weight0To10;
    final modifier = enabledScores
        .where(
          (s) => s.id != 'scrollingControl' && s.id != 'sexualControlRecovery',
        )
        .fold<double>(
          0.0,
          (max, score) => score.visibleScore > max ? score.visibleScore : max,
        );

    return enabledScores.map((score) {
      return DetoxiaScoringEngine.computePathwayScore(
        pathwayId: '${score.id}Pathway',
        label: '${score.label} pathway',
        mainProblemScore: score.visibleScore,
        modifierScore: modifier,
        routineRisk: routineRisk,
        triggerWeight: topTrigger,
        explanation:
            '${score.label} combined with routine and trigger signals.',
      );
    }).toList()..sort((a, b) => b.score0To10.compareTo(a.score0To10));
  }

  InterventionPreferences _buildInterventionPreferences(
    Map<String, dynamic> answers,
  ) {
    final selected = _selectedOptionIds('intv_select', answers).toSet();
    final directness = _selectedOptionId('intv_directness', answers);
    return InterventionPreferences(
      physicalReset: selected.contains('intv_physical'),
      breathingGrounding: selected.contains('intv_breathing'),
      appFrictionDelay: selected.contains('intv_friction'),
      journalingThoughtDump: selected.contains('intv_journaling'),
      focusSprint: selected.contains('intv_focus'),
      sleepShutdown: selected.contains('intv_sleep_shutdown'),
      spiritualValuesReset: selected.contains('intv_spiritual'),
      lowPressureTask: selected.contains('intv_low_pressure'),
      directnessLevel: switch (directness) {
        'dir_gentle' => 'gentle',
        'dir_strong' => 'strong',
        _ => 'balanced',
      },
    );
  }

  double _routineRiskScore(RoutineProfile routine) {
    final free = routine.freeWindows.isEmpty ? 0.0 : 1.0;
    final alone = routine.aloneWindows.isEmpty ? 0.0 : 1.0;
    final vulnerableText = routine.vulnerableWindows.join(' ').toLowerCase();
    final freeText = routine.freeWindows.join(' ').toLowerCase();
    final lateNight =
        vulnerableText.contains('late night') ||
        freeText.contains('late night');
    final commuteIdle =
        ((routine.commuteToDuration ?? 0) +
                (routine.commuteBackDuration ?? 0)) >
            0 &&
        routine.commutePhoneUseScore > 0;
    final transitionStress =
        vulnerableText.contains('after school') ||
        vulnerableText.contains('commute');

    return DetoxiaScoringEngine.computeRoutineRisk(
      freeTime: free,
      aloneTime: alone,
      lateNight: lateNight ? 1.0 : 0.0,
      phoneAccess:
          ((routine.phoneInBedScore + routine.commutePhoneUseScore) / 6.0)
              .clamp(0.0, 1.0),
      commuteIdle: commuteIdle ? 1.0 : 0.0,
      transitionStress: transitionStress ? 1.0 : 0.0,
      pastRiskWindow: routine.vulnerableWindows.isEmpty ? 0.0 : 1.0,
    );
  }

  List<int> _numericAnswers(
    List<String> questionIds,
    Map<String, dynamic> answers,
  ) {
    return questionIds.map((id) => _numericValue(id, answers)).toList();
  }

  int _numericValue(
    String questionId,
    Map<String, dynamic> answers, {
    int fallback = 0,
  }) {
    final answer = answers[questionId];
    if (answer is Map) {
      final explicit = answer['numericValue'];
      if (explicit is num) return explicit.toInt();
      final option = _selectedOption(questionId, answer);
      final numeric = option?.numericValue;
      if (numeric != null) return numeric.toInt();
    }
    if (answer is num) return answer.toInt();
    return fallback;
  }

  int _midpointMinutes(
    String questionId,
    Map<String, dynamic> answers, {
    required int fallback,
  }) {
    final answer = answers[questionId];
    if (answer is Map && answer['midpointMinutes'] is int) {
      return answer['midpointMinutes'] as int;
    }
    return _selectedOption(questionId, answer)?.midpointMinutes ?? fallback;
  }

  int _durationMinutes(
    String questionId,
    Map<String, dynamic> answers, {
    int fallback = 0,
  }) {
    final answer = answers[questionId];
    if (answer is Map && answer['midpointDurationMinutes'] is int) {
      return answer['midpointDurationMinutes'] as int;
    }
    return _selectedOption(questionId, answer)?.midpointDurationMinutes ??
        fallback;
  }

  String? _optionLabel(String questionId, Map<String, dynamic> answers) {
    final option = _selectedOption(questionId, answers[questionId]);
    return option?.label;
  }

  String? _optionLabelById(String questionId, String optionId) {
    final question = bank.questionById(questionId);
    return question?.options
        ?.where((option) => option.optionId == optionId)
        .map((option) => option.label)
        .firstOrNull;
  }

  List<String> _selectedLabels(
    String questionId,
    Map<String, dynamic> answers,
  ) {
    return _selectedOptionIds(questionId, answers)
        .map((id) => _optionLabelById(questionId, id) ?? _fallbackLabel(id))
        .toList();
  }

  List<String> _selectedOptionIds(
    String questionId,
    Map<String, dynamic> answers,
  ) {
    final answer = answers[questionId];
    if (answer is Map) {
      final ids = answer['selectedOptionIds'];
      if (ids is List) return ids.map((id) => id.toString()).toList();
      final id = answer['selectedOptionId'];
      if (id != null) return [id.toString()];
    }
    if (answer is List) return answer.map((id) => id.toString()).toList();
    return const [];
  }

  String? _selectedOptionId(String questionId, Map<String, dynamic> answers) {
    final ids = _selectedOptionIds(questionId, answers);
    return ids.isEmpty ? null : ids.first;
  }

  QuestionOption? _selectedOption(String questionId, dynamic answer) {
    if (answer is! Map) return null;
    final optionId = answer['selectedOptionId'];
    if (optionId == null) return null;
    final question = bank.questionById(questionId);
    return question?.options
        ?.where((option) => option.optionId == optionId)
        .firstOrNull;
  }

  DateTime? _dateAnswer(String questionId, Map<String, dynamic> answers) {
    final answer = answers[questionId];
    final value = answer is Map ? answer['date'] : answer;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  String _regularity(Map<String, dynamic> answers) {
    return switch (_selectedOptionId('mens_regularity', answers)) {
      'reg_regular' => 'regular',
      'reg_slightly' => 'slightly',
      'reg_very' => 'very',
      'reg_unsure' => 'unsure',
      _ => 'unsure',
    };
  }

  String _fallbackLabel(String id) {
    return id.replaceAll(RegExp(r'^(trig_|intv_|p_)'), '').replaceAll('_', ' ');
  }

  RegistrationAgeBand _ageBandFromString(String value) {
    return RegistrationAgeBand.values.firstWhere(
      (ageBand) => ageBand.name == value,
      orElse: () => RegistrationAgeBand.adult18Plus,
    );
  }

  RegistrationGender _genderFromString(String value) {
    return RegistrationGender.values.firstWhere(
      (gender) => gender.name == value,
      orElse: () => RegistrationGender.preferNotToSay,
    );
  }
}
