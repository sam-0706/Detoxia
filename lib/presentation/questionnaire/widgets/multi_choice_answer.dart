import 'package:detoxia/core/motion/app_motion.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:flutter/material.dart';

import 'answer_option_tile.dart';

/// Toggleable option list with an explicit Continue.
///
/// The button reflects how many things are picked and stays reachable, since
/// several of these lists run past a screen height.
class MultiChoiceAnswer extends StatefulWidget {
  final QuestionnaireQuestion question;
  final void Function(Map<String, dynamic>) onAnswer;
  final List<String> initialOptionIds;

  const MultiChoiceAnswer({
    super.key,
    required this.question,
    required this.onAnswer,
    this.initialOptionIds = const [],
  });

  @override
  State<MultiChoiceAnswer> createState() => _MultiChoiceAnswerState();
}

class _MultiChoiceAnswerState extends State<MultiChoiceAnswer> {
  late final Set<String> _selected = {...widget.initialOptionIds};

  void _toggle(String optionId) {
    setState(() {
      if (!_selected.remove(optionId)) _selected.add(optionId);
    });
  }

  void _submit() {
    if (_selected.isEmpty) return;
    widget.onAnswer({'selectedOptionIds': _selected.toList()});
  }

  @override
  Widget build(BuildContext context) {
    final p = AppTheme.palette(context);
    final options = widget.question.options;
    if (options == null || options.isEmpty) {
      return const SizedBox.shrink();
    }

    final count = _selected.length;

    return Column(
      children: [
        for (final (i, option) in options.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FadeSlideIn(
              index: i,
              offset: 12,
              child: AnswerOptionTile(
                label: option.label,
                selected: _selected.contains(option.optionId),
                multiSelect: true,
                onTap: () => _toggle(option.optionId),
              ),
            ),
          ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: count == 0 ? null : _submit,
            child: PulseOnChange(
              trigger: count,
              child: Text(
                count == 0
                    ? 'Pick at least one'
                    : 'Continue with $count selected',
              ),
            ),
          ),
        ),
        if (count == 0) ...[
          const SizedBox(height: 10),
          Text(
            'You can choose more than one.',
            style: TextStyle(color: p.textTertiary, fontSize: 13),
          ),
        ],
      ],
    );
  }
}
