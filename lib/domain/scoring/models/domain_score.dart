class DomainScore {
  final String id;
  final String label;
  final double rawScore;
  final double maxRawScore;
  final double visibleScore;
  final String band;
  final bool enabled;
  final double confidence;
  final String explanation;

  static const List<String> bands = ['Low', 'Mild', 'Moderate', 'High'];

  const DomainScore({
    required this.id,
    required this.label,
    required this.rawScore,
    required this.maxRawScore,
    required this.visibleScore,
    required this.band,
    required this.enabled,
    required this.confidence,
    required this.explanation,
  });

  factory DomainScore.fromJson(Map<String, dynamic> json) {
    return DomainScore(
      id: json['id'] as String,
      label: json['label'] as String,
      rawScore: (json['rawScore'] as num).toDouble(),
      maxRawScore: (json['maxRawScore'] as num).toDouble(),
      visibleScore: (json['visibleScore'] as num).toDouble(),
      band: json['band'] as String,
      enabled: json['enabled'] as bool,
      confidence: (json['confidence'] as num).toDouble(),
      explanation: json['explanation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'label': label,
      'rawScore': rawScore,
      'maxRawScore': maxRawScore,
      'visibleScore': visibleScore,
      'band': band,
      'enabled': enabled,
      'confidence': confidence,
      'explanation': explanation,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DomainScore &&
        other.id == id &&
        other.label == label &&
        other.rawScore == rawScore &&
        other.maxRawScore == maxRawScore &&
        other.visibleScore == visibleScore &&
        other.band == band &&
        other.enabled == enabled &&
        other.confidence == confidence &&
        other.explanation == explanation;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      label,
      rawScore,
      maxRawScore,
      visibleScore,
      band,
      enabled,
      confidence,
      explanation,
    );
  }
}
