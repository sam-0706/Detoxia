import 'package:detoxia/core/constants/enums.dart';

class TriggerPosteriorEntry {
  final TriggerType trigger;
  int urgeCount;
  int slipCount;
  int resistCount;

  TriggerPosteriorEntry({
    required this.trigger,
    this.urgeCount = 0,
    this.slipCount = 0,
    this.resistCount = 0,
  });

  double get pSlipGivenTrigger =>
      (slipCount + 1) / (urgeCount + 2);

  void recordUrge({required bool slipped}) {
    urgeCount++;
    if (slipped) {
      slipCount++;
    } else {
      resistCount++;
    }
  }
}

class TriggerModel {
  final Map<TriggerType, TriggerPosteriorEntry> _posteriors = {};

  TriggerModel();

  void initializeFromProfile(List<TriggerType> triggers) {
    for (final t in TriggerType.values) {
      _posteriors[t] = TriggerPosteriorEntry(trigger: t);
    }
  }

  void recordEvent(TriggerType trigger, {required bool slipped}) {
    _posteriors.putIfAbsent(
      trigger,
      () => TriggerPosteriorEntry(trigger: trigger),
    );
    _posteriors[trigger]!.recordUrge(slipped: slipped);
  }

  double probabilityForTrigger(TriggerType trigger) =>
      _posteriors[trigger]?.pSlipGivenTrigger ?? 0.5;

  List<MapEntry<TriggerType, double>> get rankedTriggers {
    final entries = _posteriors.entries
        .where((e) => e.value.urgeCount > 0)
        .map((e) => MapEntry(e.key, e.value.pSlipGivenTrigger))
        .toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    for (final entry in _posteriors.entries) {
      map[entry.key.name] = {
        'urgeCount': entry.value.urgeCount,
        'slipCount': entry.value.slipCount,
        'resistCount': entry.value.resistCount,
      };
    }
    return map;
  }
}
