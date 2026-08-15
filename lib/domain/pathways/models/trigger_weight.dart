class TriggerWeight {
  final String triggerId;
  final String label;
  final int strengthRaw;
  final double weight0To10;
  final double reliability;
  final DateTime lastUpdatedAt;

  const TriggerWeight({
    required this.triggerId,
    required this.label,
    required this.strengthRaw,
    required this.weight0To10,
    required this.reliability,
    required this.lastUpdatedAt,
  });

  factory TriggerWeight.fromJson(Map<String, dynamic> json) {
    return TriggerWeight(
      triggerId: json['triggerId'] as String,
      label: json['label'] as String,
      strengthRaw: json['strengthRaw'] as int,
      weight0To10: (json['weight0To10'] as num).toDouble(),
      reliability: (json['reliability'] as num).toDouble(),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'triggerId': triggerId,
      'label': label,
      'strengthRaw': strengthRaw,
      'weight0To10': weight0To10,
      'reliability': reliability,
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }
}
