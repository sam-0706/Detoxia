import 'dart:math' as math;

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FocusTimerScreen extends ConsumerStatefulWidget {
  final String? initialTask;

  const FocusTimerScreen({super.key, this.initialTask});

  @override
  ConsumerState<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends ConsumerState<FocusTimerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late TextEditingController _taskController;

  FocusSessionType _sessionType = FocusSessionType.pomodoro25;
  int _distractionCount = 0;
  bool _isRunning = false;
  bool _isComplete = false;
  double _focusRating = 5;
  DateTime? _sessionStartTime;

  static const _durations = {
    FocusSessionType.micro5: Duration(minutes: 5),
    FocusSessionType.short15: Duration(minutes: 15),
    FocusSessionType.pomodoro25: Duration(minutes: 25),
    FocusSessionType.deep50: Duration(minutes: 50),
  };

  static const _labels = {
    FocusSessionType.micro5: '5 min',
    FocusSessionType.short15: '15 min',
    FocusSessionType.pomodoro25: '25 min',
    FocusSessionType.deep50: '50 min',
  };

  static const _subtitles = {
    FocusSessionType.micro5: 'Micro',
    FocusSessionType.short15: 'Short',
    FocusSessionType.pomodoro25: 'Pomodoro',
    FocusSessionType.deep50: 'Deep',
  };

  Duration get _totalDuration => _durations[_sessionType]!;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.initialTask ?? '');
    _controller = AnimationController(
      vsync: this,
      duration: _totalDuration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _isComplete = true);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _taskController.dispose();
    super.dispose();
  }

  void _selectSession(FocusSessionType type) {
    if (_isRunning) return;
    setState(() {
      _sessionType = type;
      _isComplete = false;
      _distractionCount = 0;
      _controller.duration = _totalDuration;
      _controller.reset();
    });
  }

  void _start() {
    setState(() {
      _isRunning = true;
      _isComplete = false;
      _sessionStartTime = DateTime.now();
    });
    _controller.forward(from: _controller.value);
  }

  void _pause() {
    _controller.stop();
    setState(() => _isRunning = false);
  }

  void _reset() {
    _controller.reset();
    setState(() {
      _isRunning = false;
      _isComplete = false;
      _distractionCount = 0;
      _sessionStartTime = null;
    });
  }

  void _addDistraction() {
    setState(() => _distractionCount++);
  }

  Future<void> _saveSession() async {
    final db = ref.read(databaseProvider);
    final taskText = _taskController.text.trim().isEmpty
        ? 'Untitled session'
        : _taskController.text.trim();

    await db.into(db.focusSessions).insert(
          FocusSessionsCompanion.insert(
            startTime: _sessionStartTime ?? DateTime.now(),
            endTime: Value(DateTime.now()),
            taskDescription: taskText,
            focusRating: Value(_focusRating.round()),
            distractions: Value(_distractionCount),
            technique: _sessionType.name,
          ),
        );

    if (mounted) {
      _showBreakReminder();
    }
  }

  void _showBreakReminder() {
    final breakMinutes = _sessionType == FocusSessionType.deep50 ? 15 : 5;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.palette(context).surface,
        title: Text('Session Saved!',
            style: TextStyle(color: AppTheme.palette(context).textPrimary)),
        content: Text(
          'Great work! Take a $breakMinutes-minute break before your next session.',
          style:  TextStyle(color: AppTheme.palette(context).textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _reset();
            },
            child: const Text('Another Session'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Timer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTaskField(),
          const SizedBox(height: 20),
          _buildSessionSelector(),
          const SizedBox(height: 32),
          _buildTimer(),
          const SizedBox(height: 24),
          _buildDistractionCounter(),
          const SizedBox(height: 24),
          _buildControls(),
          if (_isComplete) ...[
            const SizedBox(height: 32),
            _buildRatingSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskField() {
    return TextField(
      controller: _taskController,
      style:  TextStyle(color: AppTheme.palette(context).textPrimary, fontSize: 16),
      decoration: InputDecoration(
        hintText: 'What are you focusing on?',
        hintStyle:  TextStyle(color: AppTheme.palette(context).textTertiary),
        prefixIcon: Icon(Icons.edit, color: AppTheme.palette(context).accent, size: 20),
      ),
    );
  }

  Widget _buildSessionSelector() {
    return Row(
      children: FocusSessionType.values.map((type) {
        final selected = type == _sessionType;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              onTap: () => _selectSession(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected
                      ? AppTheme.palette(context).accent.withValues(alpha: 0.2)
                      : AppTheme.palette(context).surfaceRaised,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? AppTheme.palette(context).accent
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _labels[type]!,
                      style: TextStyle(
                        color: selected ? AppTheme.palette(context).accent : AppTheme.palette(context).textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _subtitles[type]!,
                      style: TextStyle(
                        color: selected
                            ? AppTheme.palette(context).accent.withValues(alpha: 0.7)
                            : AppTheme.palette(context).textTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimer() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final elapsed = _controller.value * _totalDuration.inSeconds;
        final remaining = _totalDuration.inSeconds - elapsed.round();
        final minutes = remaining ~/ 60;
        final seconds = remaining % 60;

        return Center(
          child: SizedBox(
            width: 240,
            height: 240,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(240, 240),
                  painter: _TimerPainter(
                    progress: _controller.value,
                    color: _isComplete ? AppTheme.palette(context).success : AppTheme.palette(context).accent,
                    backgroundColor: AppTheme.palette(context).surfaceRaised,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: AppTheme.palette(context).textPrimary,
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    if (_isComplete)
                      Text(
                        'Complete!',
                        style: TextStyle(
                          color: AppTheme.palette(context).success,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDistractionCounter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Distractions:',
            style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 14)),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _distractionCount > 0
                ? AppTheme.palette(context).warning.withValues(alpha: 0.15)
                : AppTheme.palette(context).surfaceRaised,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$_distractionCount',
            style: TextStyle(
              color: _distractionCount > 0 ? AppTheme.palette(context).warning : AppTheme.palette(context).textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: _isRunning ? _addDistraction : null,
          icon: Icon(Icons.add_circle_outline,
              color: _isRunning ? AppTheme.palette(context).warning : AppTheme.palette(context).borderStrong),
          tooltip: 'Got distracted',
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!_isComplete) ...[
          _ControlButton(
            icon: Icons.refresh,
            label: 'Reset',
            color: AppTheme.palette(context).textTertiary,
            onTap: _reset,
          ),
          const SizedBox(width: 24),
          _ControlButton(
            icon: _isRunning ? Icons.pause : Icons.play_arrow,
            label: _isRunning ? 'Pause' : 'Start',
            color: AppTheme.palette(context).accent,
            large: true,
            onTap: _isRunning ? _pause : _start,
          ),
        ],
      ],
    );
  }

  Widget _buildRatingSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'How was your focus?',
              style: TextStyle(
                color: AppTheme.palette(context).textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_focusRating.round()}/10',
              style: TextStyle(
                color: AppTheme.palette(context).accent,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              value: _focusRating,
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: AppTheme.palette(context).accent,
              inactiveColor: AppTheme.palette(context).surfaceRaised,
              onChanged: (v) => setState(() => _focusRating = v),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Scattered', style: TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 12)),
                Text('Locked in', style: TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSession,
                child: const Text('Save Session'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool large;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    this.large = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = large ? 64.0 : 48.0;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color.withValues(alpha: large ? 0.2 : 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: large ? 2 : 1),
            ),
            child: Icon(icon, color: color, size: large ? 32 : 22),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}

class _TimerPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _TimerPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 6.0;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
