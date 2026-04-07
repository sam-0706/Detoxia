import 'dart:async';

import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/domain/adhd/dopamine_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DopamineMenuScreen extends ConsumerStatefulWidget {
  const DopamineMenuScreen({super.key});

  @override
  ConsumerState<DopamineMenuScreen> createState() => _DopamineMenuScreenState();
}

class _DopamineMenuScreenState extends ConsumerState<DopamineMenuScreen> {
  int? _selectedMinutes;

  static const _timeFilters = [2, 5, 15, 30];

  List<DopamineActivity> get _filteredActivities {
    if (_selectedMinutes == null) return dopamineActivities;
    return dopamineActivities
        .where((a) => a.durationMinutes == _selectedMinutes)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final activities = _filteredActivities;

    return Scaffold(
      appBar: AppBar(title: const Text('Dopamine Menu')),
      body: Column(
        children: [
          _buildTimeFilters(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: activities.length,
              itemBuilder: (context, index) =>
                  _ActivityCard(activity: activities[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            selected: _selectedMinutes == null,
            onTap: () => setState(() => _selectedMinutes = null),
          ),
          ..._timeFilters.map((min) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _FilterChip(
                  label: '$min min',
                  selected: _selectedMinutes == min,
                  onTap: () => setState(() => _selectedMinutes = min),
                ),
              )),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.accent.withValues(alpha: 0.2)
              : AppTheme.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.accent : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppTheme.accent : Colors.white70,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final DopamineActivity activity;

  const _ActivityCard({required this.activity});

  IconData get _categoryIcon => switch (activity.category) {
        DopamineCategory.quick => Icons.flash_on,
        DopamineCategory.physical => Icons.directions_run,
        DopamineCategory.creative => Icons.palette,
        DopamineCategory.social => Icons.people,
        DopamineCategory.sensory => Icons.touch_app,
      };

  Color get _categoryColor => switch (activity.category) {
        DopamineCategory.quick => AppTheme.warning,
        DopamineCategory.physical => AppTheme.success,
        DopamineCategory.creative => AppTheme.accent,
        DopamineCategory.social => AppTheme.pinkAccent,
        DopamineCategory.sensory => const Color(0xFF26C6DA),
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _categoryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_categoryIcon, color: _categoryColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          activity.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${activity.durationMinutes}m',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.description,
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 13, height: 1.3),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 30,
                    child: ElevatedButton.icon(
                      onPressed: () => _startActivityTimer(context),
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text('Do it now', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _categoryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startActivityTimer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isDismissible: false,
      builder: (_) => _ActivityTimerSheet(activity: activity),
    );
  }
}

class _ActivityTimerSheet extends StatefulWidget {
  final DopamineActivity activity;

  const _ActivityTimerSheet({required this.activity});

  @override
  State<_ActivityTimerSheet> createState() => _ActivityTimerSheetState();
}

class _ActivityTimerSheetState extends State<_ActivityTimerSheet> {
  late int _secondsRemaining;
  Timer? _timer;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.activity.durationMinutes * 60;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining <= 0) {
        _timer?.cancel();
        setState(() => _completed = true);
        return;
      }
      setState(() => _secondsRemaining--);
    });
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.activity.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _completed
                ? 'Done!'
                : '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: _completed ? AppTheme.success : Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.w300,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _completed ? AppTheme.success : Colors.white24,
              ),
              child: Text(_completed ? 'Great job!' : 'Cancel'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
