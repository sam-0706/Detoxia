import 'dart:math' as math;

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/domain/pathways/models/pathway_score.dart';
import 'package:detoxia/domain/routine/models/menstrual_phase.dart';
import 'package:detoxia/domain/routine/models/menstrual_profile.dart';
import 'package:detoxia/domain/routine/models/sleep_profile.dart';
import 'package:detoxia/domain/scoring/models/domain_score.dart';

import 'score_band.dart';
import 'time_window_utils.dart';

/// Stateless scoring engine for the Detoxia questionnaire.
///
/// Every method is `static` and deterministic. There is no I/O, no Flutter,
/// no database access. Inputs are primitive types (or read-only domain
/// models); outputs are immutable score objects.
///
/// All formulas mirror `DETOXIA_V1_TASK_LIST.md` Task 1.3 exactly.
class DetoxiaScoringEngine {
  DetoxiaScoringEngine._();

  // ───────────────────────────────────────────────────────────────────────────
  // Core helpers
  // ───────────────────────────────────────────────────────────────────────────

  /// Normalizes `raw` to a 0–10 score.
  ///
  /// Returns `0.0` when `max <= 0`. Otherwise computes `raw / max * 10` and
  /// clamps to `[0.0, 10.0]`.
  static double normalizeScore(double raw, double max) {
    if (max <= 0) return 0.0;
    final result = raw / max * 10.0;
    return result.clamp(0.0, 10.0);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Per-domain scoring
  // ───────────────────────────────────────────────────────────────────────────

  /// Scrolling Control: 5 items × 0–3, max raw 15.
  ///
  /// Throws [ArgumentError] if the list does not contain exactly 5 entries.
  /// Individual values are clamped into `[0, 3]`.
  static DomainScore scoreScrollingControl(List<int> answers) {
    _expectLength(answers, 5, 'scoreScrollingControl');
    final raw = _sumClamped(answers, 0, 3).toDouble();
    const max = 15.0;
    final visible = normalizeScore(raw, max);
    return DomainScore(
      id: 'scrollingControl',
      label: 'Scrolling Control',
      rawScore: raw,
      maxRawScore: max,
      visibleScore: visible,
      band: scoreBand(visible),
      enabled: true,
      confidence: 1.0,
      explanation:
          'Scrolling control derived from 5 self-report items (0–3 each).',
    );
  }

  /// Sexual Content Control (16–17): 5 items × 0–3, max raw 15.
  static DomainScore scoreSexualContentControl(List<int> answers) {
    _expectLength(answers, 5, 'scoreSexualContentControl');
    final raw = _sumClamped(answers, 0, 3).toDouble();
    const max = 15.0;
    final visible = normalizeScore(raw, max);
    return DomainScore(
      id: 'sexualContentControl',
      label: 'Sexual Content Control',
      rawScore: raw,
      maxRawScore: max,
      visibleScore: visible,
      band: scoreBand(visible),
      enabled: true,
      confidence: 1.0,
      explanation:
          'Sexual content control derived from 5 self-report items (0–3 each).',
    );
  }

  /// Sexual Control Recovery (18+): 5 items × 0–3, max raw 15.
  static DomainScore scoreSexualControlRecovery(List<int> answers) {
    _expectLength(answers, 5, 'scoreSexualControlRecovery');
    final raw = _sumClamped(answers, 0, 3).toDouble();
    const max = 15.0;
    final visible = normalizeScore(raw, max);
    return DomainScore(
      id: 'sexualControlRecovery',
      label: 'Sexual Control Recovery',
      rawScore: raw,
      maxRawScore: max,
      visibleScore: visible,
      band: scoreBand(visible),
      enabled: true,
      confidence: 1.0,
      explanation:
          'Sexual control recovery derived from 5 self-report items (0–3 each).',
    );
  }

  /// Focus Support: 6 items × 0–4, max raw 24.
  static DomainScore scoreFocusSupport(List<int> answers) {
    _expectLength(answers, 6, 'scoreFocusSupport');
    final raw = _sumClamped(answers, 0, 4).toDouble();
    const max = 24.0;
    final visible = normalizeScore(raw, max);
    return DomainScore(
      id: 'focusSupport',
      label: 'Focus Support',
      rawScore: raw,
      maxRawScore: max,
      visibleScore: visible,
      band: scoreBand(visible),
      enabled: true,
      confidence: 1.0,
      explanation:
          'Focus support derived from 6 self-report items (0–4 each).',
    );
  }

  /// Anxiety Load: 4 items × 0–3, max raw 12.
  static DomainScore scoreAnxietyLoad(List<int> answers) {
    _expectLength(answers, 4, 'scoreAnxietyLoad');
    final raw = _sumClamped(answers, 0, 3).toDouble();
    const max = 12.0;
    final visible = normalizeScore(raw, max);
    return DomainScore(
      id: 'anxietyLoad',
      label: 'Anxiety Load',
      rawScore: raw,
      maxRawScore: max,
      visibleScore: visible,
      band: scoreBand(visible),
      enabled: true,
      confidence: 1.0,
      explanation:
          'Anxiety load derived from 4 GAD-style items (0–3 each).',
    );
  }

  /// Low Mood Support: 4 items × 0–3, max raw 12.
  static DomainScore scoreLowMoodSupport(List<int> answers) {
    _expectLength(answers, 4, 'scoreLowMoodSupport');
    final raw = _sumClamped(answers, 0, 3).toDouble();
    const max = 12.0;
    final visible = normalizeScore(raw, max);
    return DomainScore(
      id: 'lowMoodSupport',
      label: 'Low Mood Support',
      rawScore: raw,
      maxRawScore: max,
      visibleScore: visible,
      band: scoreBand(visible),
      enabled: true,
      confidence: 1.0,
      explanation:
          'Low mood support derived from 4 PHQ-style items (0–3 each).',
    );
  }

  /// Sleep Disruption: 5 items × 0–3, max raw 15.
  static DomainScore scoreSleepDisruption(List<int> answers) {
    _expectLength(answers, 5, 'scoreSleepDisruption');
    final raw = _sumClamped(answers, 0, 3).toDouble();
    const max = 15.0;
    final visible = normalizeScore(raw, max);
    return DomainScore(
      id: 'sleepDisruption',
      label: 'Sleep Disruption',
      rawScore: raw,
      maxRawScore: max,
      visibleScore: visible,
      band: scoreBand(visible),
      enabled: true,
      confidence: 1.0,
      explanation:
          'Sleep disruption derived from 5 self-report items (0–3 each).',
    );
  }

  /// Physical Activation (inverted): 3 items, q1∈[0,3], q2∈[0,4], q3∈[0,3].
  ///
  /// Max raw activity = 10. The visible score is INVERTED:
  /// `score = (1 - raw / 10) × 10` so a sedentary person scores HIGH (more
  /// support need) and a very active person scores LOW.
  static DomainScore scorePhysicalActivation(List<int> answers) {
    _expectLength(answers, 3, 'scorePhysicalActivation');
    final q1 = answers[0].clamp(0, 3);
    final q2 = answers[1].clamp(0, 4);
    final q3 = answers[2].clamp(0, 3);
    final raw = (q1 + q2 + q3).toDouble();
    const max = 10.0;
    final inverted = (1.0 - raw / max) * 10.0;
    final visible = inverted.clamp(0.0, 10.0);
    return DomainScore(
      id: 'physicalActivation',
      label: 'Physical Activation',
      rawScore: raw,
      maxRawScore: max,
      visibleScore: visible,
      band: scoreBand(visible),
      enabled: true,
      confidence: 1.0,
      explanation:
          'Physical activation derived from 3 items (max 10), inverted so '
          'low movement means high support need.',
    );
  }

  /// Cycle Sensitivity: 7 items × 0–3, max raw 21.
  static DomainScore scoreCycleSensitivity(List<int> answers) {
    _expectLength(answers, 7, 'scoreCycleSensitivity');
    final raw = _sumClamped(answers, 0, 3).toDouble();
    const max = 21.0;
    final visible = normalizeScore(raw, max);
    return DomainScore(
      id: 'cycleSensitivity',
      label: 'Cycle Sensitivity',
      rawScore: raw,
      maxRawScore: max,
      visibleScore: visible,
      band: scoreBand(visible),
      enabled: true,
      confidence: 1.0,
      explanation:
          'Cycle sensitivity derived from 7 PMS/PMDD-style items (0–3 each).',
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Sleep profile
  // ───────────────────────────────────────────────────────────────────────────

  /// Computes a [SleepProfile] from routine + disruption inputs.
  ///
  /// `*MidpointMinutes` are minutes-since-midnight from the routine window
  /// the user picked. Latency midpoint is the latency band midpoint (minutes).
  ///
  /// Formula:
  ///   estimatedSleepStartMinutes  = (sleepAttempt + latency) % 1440
  ///   estimatedSleepDurationHours = wake − estimatedSleepStart, across midnight
  ///   targetSleepHours            = 8.0 (18+) | 9.0 (under 18)
  ///   dailySleepDebtHours         = max(0, target − duration)
  ///   estimatedSevenDaySleepDebt  = dailySleepDebt × 7
  ///   sleepDebtScore              = min(10, 7dayDebt / 14 × 10)
  ///   sleepRiskScore              = 0.60 × disruption + 0.40 × debtScore
  ///   confidence                  : "flexible" 0.3, narrow 1.0, else 0.6
  static SleepProfile computeSleepProfile({
    required String wakeWindow,
    required String sleepAttemptWindow,
    required String sleepLatencyRange,
    required int wakeMidpointMinutes,
    required int sleepAttemptMidpointMinutes,
    required int latencyMidpointMinutes,
    required double sleepDisruptionScore,
    required RegistrationAgeBand ageBand,
  }) {
    final estimatedSleepStartMinutes =
        (sleepAttemptMidpointMinutes + latencyMidpointMinutes) % 1440;

    final estimatedSleepDurationHours = minutesBetweenAcrossMidnight(
      estimatedSleepStartMinutes,
      wakeMidpointMinutes,
    );

    final targetSleepHours =
        ageBand == RegistrationAgeBand.adult18Plus ? 8.0 : 9.0;

    final dailySleepDebtHours = math.max(
      0.0,
      targetSleepHours - estimatedSleepDurationHours,
    );

    final estimatedSevenDaySleepDebtHours = dailySleepDebtHours * 7.0;

    final sleepDebtScore = math.min(
      10.0,
      estimatedSevenDaySleepDebtHours / 14.0 * 10.0,
    );

    final sleepRiskScore =
        0.60 * sleepDisruptionScore + 0.40 * sleepDebtScore;

    final confidence = _confidenceFromWindowString(sleepAttemptWindow);

    return SleepProfile(
      sleepAttemptWindow: sleepAttemptWindow,
      wakeWindow: wakeWindow,
      sleepLatencyRange: sleepLatencyRange,
      estimatedSleepStartMinutes: estimatedSleepStartMinutes,
      estimatedWakeTimeMinutes: wakeMidpointMinutes,
      estimatedSleepDurationHours: estimatedSleepDurationHours,
      targetSleepHours: targetSleepHours,
      dailySleepDebtHours: dailySleepDebtHours,
      estimatedSevenDaySleepDebtHours: estimatedSevenDaySleepDebtHours,
      sleepDebtScore: sleepDebtScore,
      sleepDisruptionScore: sleepDisruptionScore,
      sleepRiskScore: clamp10(sleepRiskScore),
      confidence: confidence,
    );
  }

  /// Confidence heuristic for a sleep-attempt window string:
  /// - contains "flexible" → 0.3
  /// - contains "–" or "-" with two clock times → 0.6 (typical 1-hour band)
  /// - contains "before" or "after" (open-ended) → 0.6
  /// - exact single time / single-hour window keywords → 1.0
  ///
  /// We deliberately default to 0.6 because most JSON windows are 1-hour
  /// bands. "Flexible" answers carry the lowest confidence.
  static double _confidenceFromWindowString(String window) {
    final lower = window.toLowerCase();
    if (lower.contains('flexible')) return 0.3;
    if (lower.contains('exact')) return 1.0;
    return 0.6;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Menstrual phase
  // ───────────────────────────────────────────────────────────────────────────

  /// Computes a [MenstrualProfile] for a given day.
  ///
  /// If `enabled` is false OR `lastPeriodStart` is null, returns a disabled
  /// profile with `currentPhase = unknown` and only the `cycleSensitivityScore`
  /// carried through.
  ///
  /// Phase rules (with `ovDay = averageCycleLength − 14`):
  ///   - day ≤ averageBleedingLength            → menstruation
  ///   - day <  ovDay − 1                       → follicular
  ///   - ovDay − 1 ≤ day ≤ ovDay + 1            → ovulation
  ///   - otherwise                              → luteal
  ///
  /// `nextPeriodEstimate` is the smallest `lastPeriodStart + n × cycleLength`
  /// that is strictly after `today` (so re-running on a later day still gives
  /// a future date).
  ///
  /// Confidence from regularity string:
  ///   - regular   → 1.0
  ///   - slightly  → 0.7
  ///   - very      → 0.4
  ///   - unsure    → 0.3
  ///   - anything else → 0.3
  static MenstrualProfile computeMenstrualPhase({
    required bool enabled,
    required DateTime today,
    required DateTime? lastPeriodStart,
    required int averageCycleLength,
    required int averageBleedingLength,
    required String regularity,
    required double cycleSensitivityScore,
  }) {
    if (!enabled || lastPeriodStart == null) {
      return MenstrualProfile(
        enabled: false,
        currentPhase: MenstrualPhase.unknown,
        confidence: 0.0,
        cycleSensitivityScore: cycleSensitivityScore,
      );
    }

    final daysSinceLastPeriod = today.difference(lastPeriodStart).inDays;
    final positiveDays = daysSinceLastPeriod < 0 ? 0 : daysSinceLastPeriod;
    final currentCycleDay = (positiveDays % averageCycleLength) + 1;

    final estimatedOvulationDay = averageCycleLength - 14;

    var nextPeriodEstimate =
        lastPeriodStart.add(Duration(days: averageCycleLength));
    while (!nextPeriodEstimate.isAfter(today)) {
      nextPeriodEstimate =
          nextPeriodEstimate.add(Duration(days: averageCycleLength));
    }

    final MenstrualPhase phase;
    if (currentCycleDay <= averageBleedingLength) {
      phase = MenstrualPhase.menstruation;
    } else if (currentCycleDay < estimatedOvulationDay - 1) {
      phase = MenstrualPhase.follicular;
    } else if (currentCycleDay >= estimatedOvulationDay - 1 &&
        currentCycleDay <= estimatedOvulationDay + 1) {
      phase = MenstrualPhase.ovulation;
    } else {
      phase = MenstrualPhase.luteal;
    }

    return MenstrualProfile(
      enabled: true,
      lastPeriodStartDate: lastPeriodStart,
      averageCycleLength: averageCycleLength,
      averageBleedingLength: averageBleedingLength,
      regularity: regularity,
      currentCycleDay: currentCycleDay,
      currentPhase: phase,
      nextPeriodEstimate: nextPeriodEstimate,
      confidence: _regularityToConfidence(regularity),
      cycleSensitivityScore: cycleSensitivityScore,
    );
  }

  static double _regularityToConfidence(String regularity) {
    switch (regularity.toLowerCase()) {
      case 'regular':
        return 1.0;
      case 'slightly':
        return 0.7;
      case 'very':
        return 0.4;
      case 'unsure':
        return 0.3;
      default:
        return 0.3;
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Routine risk
  // ───────────────────────────────────────────────────────────────────────────

  /// Computes a 0–10 routine risk score for a given time window.
  ///
  /// Each input is a `[0, 1]` indicator:
  ///   - freeTime         : how free the user is in this window
  ///   - aloneTime        : how alone / private the user is
  ///   - lateNight        : how late-night-ish the window is
  ///   - phoneAccess      : phone-in-hand availability
  ///   - commuteIdle      : commuting + idle scrolling
  ///   - transitionStress : entering/leaving school/work
  ///   - pastRiskWindow   : user-flagged "vulnerable" window
  ///
  /// Formula (weights sum to 1.0):
  ///   risk01 = 0.20*free + 0.20*alone + 0.15*lateNight + 0.15*phone +
  ///            0.10*commute + 0.10*transition + 0.10*pastRisk
  ///   returned 0–10 = clamp(risk01 × 10).
  static double computeRoutineRisk({
    required double freeTime,
    required double aloneTime,
    required double lateNight,
    required double phoneAccess,
    required double commuteIdle,
    required double transitionStress,
    required double pastRiskWindow,
  }) {
    final risk01 = 0.20 * clamp01(freeTime) +
        0.20 * clamp01(aloneTime) +
        0.15 * clamp01(lateNight) +
        0.15 * clamp01(phoneAccess) +
        0.10 * clamp01(commuteIdle) +
        0.10 * clamp01(transitionStress) +
        0.10 * clamp01(pastRiskWindow);
    return clamp10(clamp01(risk01) * 10.0);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Pathway score
  // ───────────────────────────────────────────────────────────────────────────

  /// Computes a [PathwayScore] from its four 0–10 inputs.
  ///
  /// Formula (weights sum to 1.0):
  ///   score = 0.45*main + 0.20*modifier + 0.20*routine + 0.15*trigger
  /// Clamped to `[0, 10]`.
  static PathwayScore computePathwayScore({
    required String pathwayId,
    required String label,
    required double mainProblemScore,
    required double modifierScore,
    required double routineRisk,
    required double triggerWeight,
    required String explanation,
  }) {
    final score = 0.45 * mainProblemScore +
        0.20 * modifierScore +
        0.20 * routineRisk +
        0.15 * triggerWeight;
    return PathwayScore(
      pathwayId: pathwayId,
      label: label,
      mainProblemScore: mainProblemScore,
      modifierScore: modifierScore,
      routineRisk: routineRisk,
      triggerWeight: triggerWeight,
      score0To10: clamp10(score),
      enabled: true,
      explanation: explanation,
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Internal helpers
  // ───────────────────────────────────────────────────────────────────────────

  static void _expectLength(List<int> answers, int expected, String fn) {
    if (answers.length != expected) {
      throw ArgumentError.value(
        answers.length,
        'answers.length',
        '$fn expected $expected answers',
      );
    }
  }

  static int _sumClamped(List<int> answers, int lo, int hi) {
    var sum = 0;
    for (final v in answers) {
      sum += v.clamp(lo, hi);
    }
    return sum;
  }
}
