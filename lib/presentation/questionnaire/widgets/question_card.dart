import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/questionnaire/models/question_type.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:flutter/material.dart';

import 'date_picker_answer.dart';
import 'duration_band_answer.dart';
import 'multi_choice_answer.dart';
import 'scale_answer.dart';
import 'single_choice_answer.dart';
import 'time_window_answer.dart';
import 'yes_no_answer.dart';

/// A single-question card: where you are, what's being asked, and the answer
/// control for it.
///
/// [initialAnswer] is the answer already on record for this question, so
/// stepping back shows what was chosen instead of a blank card.
class QuestionCard extends StatelessWidget {
  final QuestionnaireQuestion question;
  final String sectionTitle;

  /// Why this section exists. Shown once, on the section's first question —
  /// without it a section like the safety check-in reads as a non-sequitur.
  final String? sectionSubtitle;
  final bool showPrivacyNote;
  final void Function(Map<String, dynamic>) onAnswer;
  final VoidCallback? onBack;
  final Map<String, dynamic>? initialAnswer;

  /// 1-based position of this question inside its section.
  final int? positionInSection;
  final int? countInSection;

  const QuestionCard({
    super.key,
    required this.question,
    required this.sectionTitle,
    this.sectionSubtitle,
    this.showPrivacyNote = false,
    required this.onAnswer,
    this.onBack,
    this.initialAnswer,
    this.positionInSection,
    this.countInSection,
  });

  String? get _initialOptionId {
    final value = initialAnswer?['selectedOptionId'];
    return value is String ? value : null;
  }

  List<String> get _initialOptionIds {
    final value = initialAnswer?['selectedOptionIds'];
    if (value is List) {
      return value.map((item) => '$item').toList(growable: false);
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final p = AppTheme.palette(context);
    final showPosition = positionInSection != null && countInSection != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Where am I ──
        Row(
          children: [
            Flexible(
              child: Text(
                sectionTitle,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: p.accentBright,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.9,
                ),
              ),
            ),
            if (showPosition) ...[
              const SizedBox(width: 8),
              Text(
                '$positionInSection of $countInSection',
                style: TextStyle(color: p.textTertiary, fontSize: 12.5),
              ),
            ],
          ],
        ),
        const SizedBox(height: 14),

        // ── The question ──
        Text(
          question.text,
          style: TextStyle(
            color: p.textPrimary,
            fontSize: 23,
            height: 1.32,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),

        if (question.helperText != null) ...[
          const SizedBox(height: 10),
          Text(
            question.helperText!,
            style: TextStyle(
              color: p.textTertiary,
              fontSize: 14.5,
              height: 1.45,
            ),
          ),
        ],

        // Section framing, on the section's opening question only.
        if (positionInSection == 1 &&
            sectionSubtitle != null &&
            sectionSubtitle!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: p.borderSubtle),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 15,
                  color: p.calm,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    sectionSubtitle!,
                    style: TextStyle(
                      color: p.textTertiary,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        if (showPrivacyNote) ...[
          const SizedBox(height: 16),
          _PrivacyNote(palette: p),
        ],

        const SizedBox(height: 26),

        _buildAnswerWidget(),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAnswerWidget() {
    switch (question.questionType) {
      case QuestionType.scale:
        return ScaleAnswer(
          question: question,
          onAnswer: onAnswer,
          initialOptionId: _initialOptionId,
        );
      case QuestionType.singleChoice:
        return SingleChoiceAnswer(
          question: question,
          onAnswer: onAnswer,
          initialOptionId: _initialOptionId,
        );
      case QuestionType.multiChoice:
        return MultiChoiceAnswer(
          question: question,
          onAnswer: onAnswer,
          initialOptionIds: _initialOptionIds,
        );
      case QuestionType.timeWindow:
        return TimeWindowAnswer(
          question: question,
          onAnswer: onAnswer,
          initialOptionId: _initialOptionId,
        );
      case QuestionType.durationBand:
        return DurationBandAnswer(
          question: question,
          onAnswer: onAnswer,
          initialOptionId: _initialOptionId,
        );
      case QuestionType.yesNo:
        return YesNoAnswer(
          question: question,
          onAnswer: onAnswer,
          initialOptionId: _initialOptionId,
        );
      case QuestionType.datePicker:
        return DatePickerAnswer(question: question, onAnswer: onAnswer);
      case QuestionType.infoReward:
      case QuestionType.microGame:
        // Handled at screen level or skipped; show a Continue button.
        return _InfoContinue(onAnswer: onAnswer);
    }
  }
}

class _PrivacyNote extends StatelessWidget {
  final AppPalette palette;

  const _PrivacyNote({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.borderSubtle),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline_rounded, size: 15, color: palette.calm),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Sensitive answers stay on this device.',
              style: TextStyle(color: palette.textTertiary, fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fallback for infoReward / microGame types: a plain continue button.
class _InfoContinue extends StatelessWidget {
  final void Function(Map<String, dynamic>) onAnswer;

  const _InfoContinue({required this.onAnswer});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onAnswer({'acknowledged': true}),
        child: const Text('Continue'),
      ),
    );
  }
}
