import 'dart:math';

import 'package:detoxia/domain/prediction/projection_engine.dart';
import 'package:detoxia/domain/scoring/models/support_profile.dart';

class RecoveryJourneyPoint {
  final int week;
  final double projectedEventsPerWeek;

  const RecoveryJourneyPoint({
    required this.week,
    required this.projectedEventsPerWeek,
  });
}

class RecoveryJourneyProjection {
  final bool isLocked;
  final String title;
  final String summary;
  final String caption;
  final String? lockedReason;
  final List<String> directionItems;
  final List<RecoveryJourneyPoint> points;
  final int completedTasks;
  final int checkinCount;

  const RecoveryJourneyProjection({
    required this.isLocked,
    required this.title,
    required this.summary,
    required this.caption,
    required this.lockedReason,
    required this.directionItems,
    required this.points,
    this.completedTasks = 0,
    this.checkinCount = 0,
  });
}

class RecoveryJourneyProjectionResolver {
  const RecoveryJourneyProjectionResolver();

  RecoveryJourneyProjection resolve({
    required SupportProfile? supportProfile,
    required List<Map<String, dynamic>> checkins,
    required int slipsLast28Days,
    required int completedTasksLast14Days,
  }) {
    if (supportProfile == null || checkins.length < 7) {
      return RecoveryJourneyProjection(
        isLocked: true,
        title: 'Your Recovery Path',
        summary: 'A calm look at your direction, not a prediction.',
        caption: 'Local data only. This is direction, not prediction.',
        lockedReason:
            'Your path will become clearer after a few more check-ins and protected moments.',
        directionItems: const <String>[],
        points: const <RecoveryJourneyPoint>[],
      );
    }

    final slipsFromCheckins = checkins.where((row) => row['slipped'] == true).length;
    final fallbackSlips = max(1, slipsFromCheckins);
    final slips28 = max(slipsLast28Days, fallbackSlips);
    final baselinePerWeek = max(0.5, slips28 / 4.0);

    final momentum0To1 = (supportProfile.learningState.recoveryMomentum / 10.0).clamp(0.05, 1.0);
    final checkinRate = (checkins.length / 14.0).clamp(0.2, 1.0);
    final taskRate = (completedTasksLast14Days / 14.0).clamp(0.0, 1.0);
    final regulationCapacity = ((momentum0To1 * 0.6) + (checkinRate * 0.4)).clamp(0.1, 1.0);
    final habitStrength = max(0.2, 1.0 - (taskRate * 0.4) + ((1.0 - momentum0To1) * 0.4));

    final engine = ProjectionEngine(
      baselineSlipsPerWeek: baselinePerWeek,
      habitStrength: habitStrength,
      regulationCapacity: regulationCapacity,
      adherenceFactor: ((checkinRate * 0.6) + (taskRate * 0.4)).clamp(0.2, 1.0),
    );
    engine.updateAdherence(
      checkinRate: checkinRate,
      rescueUsageRate: taskRate,
      boundaryCompliance: momentum0To1,
    );

    final points = engine
        .projectionCurve(weeks: 12)
        .entries
        .map(
          (entry) => RecoveryJourneyPoint(
            week: entry.key,
            projectedEventsPerWeek: entry.value.clamp(0, baselinePerWeek),
          ),
        )
        .toList(growable: false);

    // Build qualitative direction items (no week-by-week numbers)
    final directionItems = _buildDirectionItems(
      momentum: supportProfile.learningState.recoveryMomentum,
      checkinCount: checkins.length,
      completedTasks: completedTasksLast14Days,
      baselineTrend: _trendDirection(points),
    );

    return RecoveryJourneyProjection(
      isLocked: false,
      title: 'Your Recovery Path',
      summary: 'A calm look at your direction, not a prediction.',
      caption: 'Local data only. This is direction, not prediction.',
      lockedReason: null,
      directionItems: directionItems,
      points: points,
      completedTasks: completedTasksLast14Days,
      checkinCount: checkins.length,
    );
  }

  List<String> _buildDirectionItems({
    required double momentum,
    required int checkinCount,
    required int completedTasks,
    required String baselineTrend,
  }) {
    final items = <String>[];

    if (momentum >= 6.5) {
      items.add('Your recovery momentum is trending up.');
    } else if (momentum >= 5) {
      items.add('Your recovery momentum is holding steady.');
    }

    if (checkinCount >= 10) {
      items.add('Your support windows are becoming clearer.');
    } else if (checkinCount >= 7) {
      items.add('You are building earlier awareness.');
    }

    if (completedTasks >= 5) {
      items.add('Your reset speed is improving.');
      items.add('You are learning which resets fit.');
    } else {
      items.add('Each small reset is building your pattern.');
    }

    if (baselineTrend == 'improving') {
      items.add('Your direction is improving steadily.');
    } else if (baselineTrend == 'steady') {
      items.add('Your path is holding steady — consistency matters.');
    }

    if (items.isEmpty) {
      items.add('Your path will become clearer with a few more protected moments.');
    }

    return items;
  }

  String _trendDirection(List<RecoveryJourneyPoint> points) {
    if (points.length < 4) return 'early';
    final first = points.first.projectedEventsPerWeek;
    final last = points.last.projectedEventsPerWeek;
    if (last < first * 0.7) return 'improving';
    if (last <= first * 0.95) return 'steady';
    return 'early';
  }
}
