import 'dart:math' as math;

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/period/cycle_calculator.dart';
import 'package:detoxia/domain/period/phase_engine.dart';
import 'package:detoxia/presentation/period/cycle_calendar_screen.dart';
import 'package:detoxia/presentation/period/period_insights_screen.dart';
import 'package:detoxia/presentation/period/period_log_screen.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeriodHome extends ConsumerStatefulWidget {
  const PeriodHome({super.key});

  @override
  ConsumerState<PeriodHome> createState() => _PeriodHomeState();
}

class _PeriodHomeState extends ConsumerState<PeriodHome> {
  int _cycleDay = 1;
  double _avgLength = 28.0;
  CyclePhase _phase = CyclePhase.menstrual;
  int _daysUntilNext = 0;
  DateTime? _lastPeriodStart;
  bool _hasData = false;

  static const _phaseColors = {
    CyclePhase.menstrual: Color(0xFFEF5350),
    CyclePhase.follicular: Color(0xFFFF8A80),
    CyclePhase.ovulation: Color(0xFFCE93D8),
    CyclePhase.luteal: Color(0xFF64B5F6),
  };

  static const _phaseNames = {
    CyclePhase.menstrual: 'Menstrual Phase',
    CyclePhase.follicular: 'Follicular Phase',
    CyclePhase.ovulation: 'Ovulation Phase',
    CyclePhase.luteal: 'Luteal Phase',
  };

  static const _phaseDescriptions = {
    CyclePhase.menstrual: 'Your body is shedding. Rest, nourish, and be gentle with yourself.',
    CyclePhase.follicular: 'Energy is rising! Great time for new projects and exploration.',
    CyclePhase.ovulation: 'Peak energy and confidence. You\'re at your most expressive.',
    CyclePhase.luteal: 'Winding down. Focus on wrapping up tasks and self-care.',
  };

  @override
  void initState() {
    super.initState();
    _loadCycleData();
  }

  Future<void> _loadCycleData() async {
    final db = ref.read(databaseProvider);

    final entries = await (db.select(db.cycleEntries)
          ..where((t) => t.flowIntensity.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();

    if (entries.isEmpty) {
      if (mounted) setState(() => _hasData = false);
      return;
    }

    final periodStarts = _extractPeriodStarts(entries);
    final avgLen = CycleCalculator.averageCycleLength(periodStarts);
    final lastStart = periodStarts.isNotEmpty ? periodStarts.last : entries.first.date;
    final cycleDay = CycleCalculator.currentCycleDay(lastStart);
    final phase = CycleCalculator.currentPhase(cycleDay, avgLen);
    final nextPeriod = CycleCalculator.predictNextPeriod(lastStart, avgLen);
    final daysUntil = nextPeriod.difference(DateTime.now()).inDays;

    if (mounted) {
      setState(() {
        _hasData = true;
        _avgLength = avgLen;
        _cycleDay = cycleDay;
        _phase = phase;
        _daysUntilNext = daysUntil.clamp(0, 99);
        _lastPeriodStart = lastStart;
      });
    }
  }

  List<DateTime> _extractPeriodStarts(List<CycleEntry> entries) {
    final sorted = [...entries]..sort((a, b) => a.date.compareTo(b.date));
    final starts = <DateTime>[];
    DateTime? prevDate;
    for (final e in sorted) {
      if (e.flowIntensity == null || e.flowIntensity == 0) continue;
      if (prevDate == null || e.date.difference(prevDate).inDays > 5) {
        starts.add(e.date);
      }
      prevDate = e.date;
    }
    return starts;
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Period Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Cycle Calendar',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CycleCalendarScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.insights),
            tooltip: 'Insights',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PeriodInsightsScreen())),
          ),
        ],
      ),
      body: _hasData
          ? ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                _buildCycleRing(tt),
                const SizedBox(height: 24),
                _buildPhaseCard(tt),
                const SizedBox(height: 16),
                _buildCountdown(tt),
                const SizedBox(height: 16),
                _buildTodayTip(tt),
              ],
            )
          : _buildEmptyState(tt),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.pinkAccent,
        icon: const Icon(Icons.add),
        label: const Text('Log Today'),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PeriodLogScreen()),
          );
          _loadCycleData();
        },
      ),
    );
  }

  Widget _buildEmptyState(TextTheme tt) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌸', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text('Start tracking your cycle', style: tt.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Log your first period day to see predictions,\nphase info, and personalized tips.',
              style: tt.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleRing(TextTheme tt) {
    final color = _phaseColors[_phase]!;
    return Center(
      child: SizedBox(
        width: 220,
        height: 220,
        child: CustomPaint(
          painter: _CycleRingPainter(
            cycleDay: _cycleDay,
            avgLength: _avgLength,
            phaseColors: _phaseColors,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Day',
                  style: tt.bodyMedium?.copyWith(color: Colors.white54),
                ),
                Text(
                  '$_cycleDay',
                  style: tt.headlineLarge?.copyWith(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  'of ~${_avgLength.round()}',
                  style: tt.bodyMedium?.copyWith(color: Colors.white38),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseCard(TextTheme tt) {
    final color = _phaseColors[_phase]!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: .3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _phaseNames[_phase]!,
            style: tt.titleLarge?.copyWith(color: color),
          ),
          const SizedBox(height: 6),
          Text(
            _phaseDescriptions[_phase]!,
            style: tt.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildCountdown(TextTheme tt) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.pinkAccent.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('🩸', style: TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _daysUntilNext <= 0
                        ? 'Period may have started'
                        : 'Period in $_daysUntilNext day${_daysUntilNext == 1 ? '' : 's'}',
                    style: tt.titleLarge,
                  ),
                  if (_lastPeriodStart != null)
                    Text(
                      'Last period: ${_formatDate(_lastPeriodStart!)}',
                      style: tt.bodyMedium,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayTip(TextTheme tt) {
    final rec = PhaseEngine.recommendations(_phase);
    final tips = [rec.exercise, rec.nutrition, rec.selfCare, rec.social];
    final tip = tips[DateTime.now().day % tips.length];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text("Today's Tip", style: tt.titleLarge),
              ],
            ),
            const SizedBox(height: 10),
            Text(tip, style: tt.bodyLarge),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month]} ${d.day}';
  }
}

class _CycleRingPainter extends CustomPainter {
  final int cycleDay;
  final double avgLength;
  final Map<CyclePhase, Color> phaseColors;

  _CycleRingPainter({
    required this.cycleDay,
    required this.avgLength,
    required this.phaseColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 10.0;
    const startAngle = -math.pi / 2;

    final total = avgLength.round();
    final menstrualEnd = 5 / total;
    final follicularEnd = (avgLength * 0.5).round() / total;
    final ovulationEnd = ((avgLength * 0.5).round() + 3) / total;

    final segments = [
      (menstrualEnd, phaseColors[CyclePhase.menstrual]!),
      (follicularEnd - menstrualEnd, phaseColors[CyclePhase.follicular]!),
      (ovulationEnd - follicularEnd, phaseColors[CyclePhase.ovulation]!),
      (1.0 - ovulationEnd, phaseColors[CyclePhase.luteal]!),
    ];

    var sweep = 0.0;
    for (final (frac, color) in segments) {
      final paint = Paint()
        ..color = color.withValues(alpha: .35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + sweep * 2 * math.pi,
        frac * 2 * math.pi,
        false,
        paint,
      );
      sweep += frac;
    }

    // Progress arc
    final progress = (cycleDay - 1) / total;
    final progressPaint = Paint()
      ..color = phaseColors[CycleCalculator.currentPhase(cycleDay, avgLength)]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      progress.clamp(0.0, 1.0) * 2 * math.pi,
      false,
      progressPaint,
    );

    // Current position dot
    final dotAngle = startAngle + progress.clamp(0.0, 1.0) * 2 * math.pi;
    final dotCenter = Offset(
      center.dx + radius * math.cos(dotAngle),
      center.dy + radius * math.sin(dotAngle),
    );
    canvas.drawCircle(
      dotCenter,
      7,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _CycleRingPainter old) =>
      old.cycleDay != cycleDay || old.avgLength != avgLength;
}
