import 'task_tag.dart';

class TaskTagMapper {
  const TaskTagMapper();

  /// Maps the existing task pool's stable `conditionType`, `category`, and
  /// `id` prefixes into support-map task tags.
  ///
  /// The daily task pool remains the source of task copy and metadata. This
  /// mapper is intentionally conservative: unknown tasks return an empty list
  /// so they can still be selected as low-utility fallbacks without inventing a
  /// domain relationship.
  List<TaskTag> tagsForTask(Map<String, dynamic> task) {
    final id = (task['id'] as String? ?? '').toLowerCase();
    final conditionType = (task['conditionType'] as String? ?? '')
        .toLowerCase();
    final category = (task['category'] as String? ?? '').toLowerCase();
    final tags = <TaskTag>{};

    switch (conditionType) {
      case 'detoxrecovery':
        tags
          ..add(TaskTag.scrolling)
          ..add(TaskTag.sexualControl);
      case 'anxiety':
        tags.add(TaskTag.anxiety);
      case 'depression':
        tags.add(TaskTag.lowMood);
      case 'adhd':
        tags.add(TaskTag.focus);
      case 'periodtracking':
        tags.add(TaskTag.cycle);
      case 'moodtracking':
        tags.add(TaskTag.lowMood);
    }

    switch (category) {
      case 'breathingexercise':
      case 'groundingexercise':
      case 'mindfulness':
        tags
          ..add(TaskTag.anxiety)
          ..add(TaskTag.breathingReset);
      case 'physicaltask':
      case 'dopamineboost':
        tags
          ..add(TaskTag.physicalReset)
          ..add(TaskTag.physicalActivation);
      case 'focustask':
        tags
          ..add(TaskTag.focus)
          ..add(TaskTag.focusSprint);
      case 'journalingtask':
        tags.add(TaskTag.journaling);
      case 'organizationaltask':
        tags.add(TaskTag.appFriction);
      case 'selfcaretask':
      case 'creativetask':
      case 'socialtask':
        tags.add(TaskTag.lowPressure);
      case 'cognitivetask':
        tags.add(TaskTag.focus);
    }

    if (id.contains('sleep') ||
        id.contains('bed') ||
        id.contains('wind_down') ||
        id.contains('wind')) {
      tags
        ..add(TaskTag.sleep)
        ..add(TaskTag.sleepShutdown);
    }
    if (id.contains('debt')) {
      tags.add(TaskTag.sleepDebt);
    }
    if (id.contains('evening') ||
        id.contains('night') ||
        id.contains('phone_out') ||
        id.contains('digital_sunset') ||
        id.contains('screen_sunset')) {
      tags.add(TaskTag.lateNightRisk);
    }
    if (id.contains('scroll') ||
        id.contains('screen') ||
        id.contains('digital') ||
        id.contains('phone')) {
      tags.add(TaskTag.scrolling);
    }
    if (id.contains('porn') ||
        id.contains('sexual') ||
        id.contains('urge') ||
        id.contains('craving')) {
      tags.add(TaskTag.sexualControl);
    }
    if (id.contains('trigger') || id.contains('stress')) {
      tags.add(TaskTag.postWorkStress);
    }
    if (id.contains('commute')) {
      tags.add(TaskTag.commuteScrolling);
    }
    if (id.contains('values') ||
        id.contains('commitment') ||
        id.contains('identity')) {
      tags.add(TaskTag.spiritual);
    }

    return tags.toList(growable: false);
  }
}
