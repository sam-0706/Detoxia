import 'task_tag.dart';

class TaskUtility {
  final Map<String, dynamic> task;
  final double utility;
  final List<TaskTag> tags;
  final String reason;
  final String whyChosen;
  final List<String> steps;
  final String targetDriver;
  final List<String> domainTags;
  final List<String> feedbackButtons;

  const TaskUtility({
    required this.task,
    required this.utility,
    required this.tags,
    required this.reason,
    required this.whyChosen,
    required this.steps,
    required this.targetDriver,
    required this.domainTags,
    required this.feedbackButtons,
  });
}
