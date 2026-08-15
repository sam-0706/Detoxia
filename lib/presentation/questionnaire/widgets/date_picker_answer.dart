import 'package:flutter/material.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';

/// Wraps [showDatePicker] for date-picker questions.
class DatePickerAnswer extends StatefulWidget {
  final QuestionnaireQuestion question;
  final void Function(Map<String, dynamic>) onAnswer;

  const DatePickerAnswer({
    super.key,
    required this.question,
    required this.onAnswer,
  });

  @override
  State<DatePickerAnswer> createState() => _DatePickerAnswerState();
}

class _DatePickerAnswerState extends State<DatePickerAnswer> {
  DateTime? _picked;

  Future<void> _open() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: _picked ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppTheme.palette(context).accent,
            surface: AppTheme.palette(context).surface,
          ),
        ),
        child: child!,
      ),
    );
    if (result != null) {
      setState(() => _picked = result);
      widget.onAnswer({'date': result.toIso8601String()});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_picked != null) ...[
          Text(
            '${_picked!.day}/${_picked!.month}/${_picked!.year}',
            style: TextStyle(
              color: AppTheme.palette(context).textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _open,
            icon: const Icon(Icons.calendar_today_outlined, size: 18),
            label: Text(_picked == null ? 'Select date' : 'Change date'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.palette(context).textPrimary,
              side: BorderSide(color: AppTheme.palette(context).accent),
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
