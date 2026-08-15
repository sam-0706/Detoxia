import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/depression/activity_pool.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivitySchedulerScreen extends ConsumerStatefulWidget {
  const ActivitySchedulerScreen({super.key});

  @override
  ConsumerState<ActivitySchedulerScreen> createState() =>
      _ActivitySchedulerScreenState();
}

class _ActivitySchedulerScreenState
    extends ConsumerState<ActivitySchedulerScreen> {
  ActivityCategory _selectedCategory = ActivityCategory.physicalActivity;
  Set<String> _completedToday = {};

  @override
  void initState() {
    super.initState();
    _loadCompleted();
  }

  Future<void> _loadCompleted() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final activities = await (db.select(db.behavioralActivities)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(todayStart) &
              t.date.isSmallerThanValue(todayEnd)))
        .get();

    if (mounted) {
      setState(() {
        _completedToday = activities.map((a) => a.activityType).toSet();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = activitiesByCategory(_selectedCategory);

    return Scaffold(
      appBar: AppBar(title: const Text('Activity Scheduler')),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: ActivityCategory.values.map((cat) {
                final selected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: selected,
                    label: Text(activityCategoryLabel(cat)),
                    selectedColor: AppTheme.palette(context).accent.withValues(alpha: 0.3),
                    checkmarkColor: AppTheme.palette(context).accent,
                    labelStyle: TextStyle(
                      color: selected ? AppTheme.palette(context).accent : AppTheme.palette(context).textSecondary,
                      fontSize: 13,
                    ),
                    backgroundColor: AppTheme.palette(context).surfaceRaised,
                    side: BorderSide(
                      color: selected
                          ? AppTheme.palette(context).accent.withValues(alpha: 0.5)
                          : AppTheme.palette(context).borderSubtle,
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final activity = filtered[index];
                final done = _completedToday.contains(activity.title);
                return _ActivityCard(
                  activity: activity,
                  completed: done,
                  onSchedule: () => _scheduleActivity(activity),
                  onComplete: () => _showRatingDialog(activity),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _scheduleActivity(ActivationActivity activity) async {
    final db = ref.read(databaseProvider);
    await db.into(db.behavioralActivities).insert(
          BehavioralActivitiesCompanion.insert(
            date: DateTime.now(),
            activityType: activity.title,
            category: activity.category.name,
            pleasureRating: 0,
            masteryRating: 0,
            durationMinutes: activity.durationMinutes,
            wasScheduled: const Value(true),
          ),
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scheduled: ${activity.title}'),
          backgroundColor: AppTheme.palette(context).success,
        ),
      );
      _loadCompleted();
    }
  }

  Future<void> _showRatingDialog(ActivationActivity activity) async {
    var pleasure = 5;
    var mastery = 5;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.palette(context).surface,
          title: Text('Rate this activity',
              style: TextStyle(color: AppTheme.palette(context).textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(activity.title,
                  style: TextStyle(color: AppTheme.palette(context).accent, fontSize: 15)),
              const SizedBox(height: 16),
              Text('Pleasure (how enjoyable was it?)',
                  style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 13)),
              Slider(
                value: pleasure.toDouble(),
                min: 0,
                max: 10,
                divisions: 10,
                label: '$pleasure',
                activeColor: AppTheme.palette(context).accent,
                onChanged: (v) =>
                    setDialogState(() => pleasure = v.round()),
              ),
              const SizedBox(height: 8),
              Text('Mastery (sense of accomplishment)',
                  style: TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 13)),
              Slider(
                value: mastery.toDouble(),
                min: 0,
                max: 10,
                divisions: 10,
                label: '$mastery',
                activeColor: AppTheme.palette(context).success,
                onChanged: (v) =>
                    setDialogState(() => mastery = v.round()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      await db.into(db.behavioralActivities).insert(
            BehavioralActivitiesCompanion.insert(
              date: DateTime.now(),
              activityType: activity.title,
              category: activity.category.name,
              pleasureRating: pleasure,
              masteryRating: mastery,
              durationMinutes: activity.durationMinutes,
            ),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Completed: ${activity.title}'),
            backgroundColor: AppTheme.palette(context).success,
          ),
        );
        _loadCompleted();
      }
    }
  }
}

class _ActivityCard extends StatelessWidget {
  final ActivationActivity activity;
  final bool completed;
  final VoidCallback onSchedule;
  final VoidCallback onComplete;

  const _ActivityCard({
    required this.activity,
    required this.completed,
    required this.onSchedule,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        color: completed
            ? AppTheme.palette(context).success.withValues(alpha: 0.1)
            : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (completed)
                    Icon(Icons.check_circle,
                        color: AppTheme.palette(context).success, size: 20)
                  else
                    Icon(Icons.radio_button_unchecked,
                        color: AppTheme.palette(context).borderStrong, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      activity.title,
                      style: TextStyle(
                        color: completed ? AppTheme.palette(context).success : AppTheme.palette(context).textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.palette(context).borderSubtle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${activity.durationMinutes} min',
                      style:
                           TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                activity.description,
                style:  TextStyle(color: AppTheme.palette(context).textTertiary, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!completed) ...[
                    OutlinedButton(
                      onPressed: onSchedule,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: AppTheme.palette(context).accent.withValues(alpha: 0.5)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                      ),
                      child: const Text('Schedule for today',
                          style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                  ],
                  ElevatedButton(
                    onPressed: onComplete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          completed ? AppTheme.palette(context).borderSubtle : AppTheme.palette(context).success,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                    ),
                    child: Text(
                      completed ? 'Rate again' : 'Done',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
