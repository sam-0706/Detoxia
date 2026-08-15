import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:flutter/material.dart';

/// Two side-by-side buttons for yes/no questions.
///
/// These are the safety-gate questions, so neither answer is styled as the
/// "right" one — a highlighted Yes would nudge, and a highlighted No would
/// discourage disclosure.
class YesNoAnswer extends StatefulWidget {
  final QuestionnaireQuestion question;
  final void Function(Map<String, dynamic>) onAnswer;
  final String? initialOptionId;

  const YesNoAnswer({
    super.key,
    required this.question,
    required this.onAnswer,
    this.initialOptionId,
  });

  @override
  State<YesNoAnswer> createState() => _YesNoAnswerState();
}

class _YesNoAnswerState extends State<YesNoAnswer> {
  String? _selected;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialOptionId;
  }

  Future<void> _choose(String optionId) async {
    if (_locked) return;
    setState(() {
      _selected = optionId;
      _locked = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 170));
    if (!mounted) return;
    widget.onAnswer({'selectedOptionId': optionId});
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.question.options;

    final yesOptionId =
        options != null && options.isNotEmpty ? options[0].optionId : 'yes';
    final noOptionId =
        options != null && options.length > 1 ? options[1].optionId : 'no';
    final yesLabel =
        options != null && options.isNotEmpty ? options[0].label : 'Yes';
    final noLabel =
        options != null && options.length > 1 ? options[1].label : 'No';

    return Row(
      children: [
        Expanded(
          child: _Choice(
            label: yesLabel,
            selected: _selected == yesOptionId,
            onTap: () => _choose(yesOptionId),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Choice(
            label: noLabel,
            selected: _selected == noOptionId,
            onTap: () => _choose(noOptionId),
          ),
        ),
      ],
    );
  }
}

class _Choice extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Choice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppTheme.palette(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? p.accentSoft : p.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? p.accent : p.borderSubtle,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? p.textPrimary : p.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
