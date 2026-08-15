import 'package:detoxia/core/motion/app_motion.dart';
import 'package:detoxia/domain/questionnaire/models/question_option.dart';
import 'package:flutter/material.dart';

import 'answer_option_tile.dart';

/// Shared single-select list used by the scale, single-choice, time-window and
/// duration-band question types — they differ only in which extra fields ride
/// along in the answer payload.
///
/// Selecting an option paints it immediately and advances a beat later, so the
/// choice is visibly acknowledged instead of the screen changing under the
/// user's finger.
class SingleSelectAnswer extends StatefulWidget {
  final List<QuestionOption> options;
  final void Function(Map<String, dynamic>) onAnswer;

  /// Builds the persisted payload for a chosen option.
  final Map<String, dynamic> Function(QuestionOption option, int index)
  payloadBuilder;

  /// Previously chosen option id, so returning to a question shows the answer
  /// already on record rather than a blank slate.
  final String? initialOptionId;

  /// Renders the leading indicator as an intensity ramp (Likert scales).
  final bool showIntensity;

  const SingleSelectAnswer({
    super.key,
    required this.options,
    required this.onAnswer,
    required this.payloadBuilder,
    this.initialOptionId,
    this.showIntensity = false,
  });

  @override
  State<SingleSelectAnswer> createState() => _SingleSelectAnswerState();
}

class _SingleSelectAnswerState extends State<SingleSelectAnswer> {
  String? _selected;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialOptionId;
  }

  Future<void> _choose(QuestionOption option, int index) async {
    if (_locked) return;
    setState(() {
      _selected = option.optionId;
      _locked = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 170));
    if (!mounted) return;
    widget.onAnswer(widget.payloadBuilder(option, index));
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.options;
    if (options.isEmpty) return const SizedBox.shrink();

    final lastIndex = options.length - 1;

    return Column(
      children: [
        for (int i = 0; i < options.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == lastIndex ? 0 : 10),
            // Options cascade in rather than appearing as a wall of choices,
            // which makes a fresh card read as one step instead of a list.
            child: FadeSlideIn(
              index: i,
              offset: 12,
              child: AnswerOptionTile(
                label: options[i].label,
                selected: _selected == options[i].optionId,
                intensity: widget.showIntensity && lastIndex > 0
                    ? i / lastIndex
                    : null,
                onTap: () => _choose(options[i], i),
              ),
            ),
          ),
      ],
    );
  }
}
