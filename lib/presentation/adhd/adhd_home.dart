import 'dart:convert';

import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/presentation/adhd/dopamine_menu_screen.dart';
import 'package:detoxia/presentation/adhd/focus_timer_screen.dart';
import 'package:detoxia/presentation/adhd/adhd_insights_screen.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdhdHome extends ConsumerStatefulWidget {
  const AdhdHome({super.key});

  @override
  ConsumerState<AdhdHome> createState() => _AdhdHomeState();
}

class _AdhdHomeState extends ConsumerState<AdhdHome> {
  List<String> _top3Tasks = [];
  List<String> _completedTasks = [];
  int _focusSessionsToday = 0;
  int? _planId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final plans = await (db.select(db.adhdDailyPlans)
          ..where((t) => t.date.isBetweenValues(todayStart, todayEnd)))
        .get();

    List<String> tasks = [];
    List<String> completed = [];
    int? planId;

    if (plans.isNotEmpty) {
      final plan = plans.first;
      planId = plan.id;
      tasks = (jsonDecode(plan.top3Tasks) as List).cast<String>();
      completed = (jsonDecode(plan.completedTasks) as List).cast<String>();
    }

    final sessions = await (db.select(db.focusSessions)
          ..where((t) => t.startTime.isBetweenValues(todayStart, todayEnd)))
        .get();

    if (mounted) {
      setState(() {
        _top3Tasks = tasks;
        _completedTasks = completed;
        _focusSessionsToday = sessions.length;
        _planId = planId;
      });
    }
  }

  Future<void> _addTask() async {
    final controller = TextEditingController();
    final task = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.palette(context).surface,
        title:  Text('Add a Task', style: TextStyle(color: AppTheme.palette(context).textPrimary)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style:  TextStyle(color: AppTheme.palette(context).textPrimary),
          decoration: InputDecoration(
            hintText: 'What do you need to do?',
            hintStyle: TextStyle(color: AppTheme.palette(context).textTertiary),
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (task == null || task.trim().isEmpty) return;
    if (_top3Tasks.length >= 3) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Max 3 tasks for today. Finish one first!')),
        );
      }
      return;
    }

    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final newTasks = [..._top3Tasks, task.trim()];

    if (_planId != null) {
      await (db.update(db.adhdDailyPlans)
            ..where((t) => t.id.equals(_planId!)))
          .write(AdhdDailyPlansCompanion(
        top3Tasks: Value(jsonEncode(newTasks)),
      ));
    } else {
      final id = await db.into(db.adhdDailyPlans).insert(
            AdhdDailyPlansCompanion.insert(
              date: todayStart,
              top3Tasks: Value(jsonEncode(newTasks)),
            ),
          );
      _planId = id;
    }

    await _loadData();
  }

  Future<void> _toggleTask(int index) async {
    if (index >= _top3Tasks.length) return;
    final task = _top3Tasks[index];
    final db = ref.read(databaseProvider);

    List<String> newCompleted;
    if (_completedTasks.contains(task)) {
      newCompleted = _completedTasks.where((t) => t != task).toList();
    } else {
      newCompleted = [..._completedTasks, task];
    }

    if (_planId != null) {
      await (db.update(db.adhdDailyPlans)
            ..where((t) => t.id.equals(_planId!)))
          .write(AdhdDailyPlansCompanion(
        completedTasks: Value(jsonEncode(newCompleted)),
      ));
    }

    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADHD Focus Hub'),
        actions: [
          IconButton(
            icon:  Icon(Icons.insights, color: AppTheme.palette(context).textSecondary),
            tooltip: 'Insights',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdhdInsightsScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildFocusCountBanner(),
            const SizedBox(height: 20),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildTop3Section(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: AppTheme.palette(context).accent,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFocusCountBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.palette(context).accent.withValues(alpha: 0.15),
            AppTheme.palette(context).accent.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.palette(context).accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.palette(context).accent.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$_focusSessionsToday',
              style: TextStyle(
                color: AppTheme.palette(context).accent,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Focus Sessions Today',
                  style: TextStyle(
                    color: AppTheme.palette(context).textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _focusSessionsToday == 0
                      ? 'Start your first session!'
                      : 'Keep the momentum going.',
                  style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.timer,
            label: 'Focus Timer',
            color: AppTheme.palette(context).accent,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FocusTimerScreen()),
              );
              _loadData();
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.bolt,
            label: 'Dopamine Menu',
            color: AppTheme.palette(context).warning,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DopamineMenuScreen()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTop3Section() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Today's Top 3", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          'Focus on just these. Everything else can wait.',
          style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 12),
        if (_top3Tasks.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.task_alt, color: AppTheme.palette(context).borderStrong, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      'No tasks yet. Tap + to add up to 3.',
                      style: TextStyle(color: AppTheme.palette(context).textTertiary),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...List.generate(_top3Tasks.length, (i) {
            final task = _top3Tasks[i];
            final done = _completedTasks.contains(task);
            return Card(
              child: ListTile(
                leading: Checkbox(
                  value: done,
                  onChanged: (_) => _toggleTask(i),
                  activeColor: AppTheme.palette(context).success,
                  side:  BorderSide(color: AppTheme.palette(context).textTertiary),
                ),
                title: Text(
                  task,
                  style: TextStyle(
                    color: done ? AppTheme.palette(context).textTertiary : AppTheme.palette(context).textPrimary,
                    decoration: done ? TextDecoration.lineThrough : null,
                    fontSize: 15,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.play_arrow,
                      color: done ? AppTheme.palette(context).borderStrong : AppTheme.palette(context).accent),
                  onPressed: done
                      ? null
                      : () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  FocusTimerScreen(initialTask: task),
                            ),
                          );
                          _loadData();
                        },
                  tooltip: 'Start focus session for this task',
                ),
              ),
            );
          }),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: AppTheme.palette(context).textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
