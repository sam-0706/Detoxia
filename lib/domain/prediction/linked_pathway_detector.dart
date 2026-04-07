class LinkedPathwayDetector {
  int scrollingPrecededSlips = 0;
  int totalSlips = 0;

  bool get isActive =>
      totalSlips >= 3 && scrollingPrecededSlips / totalSlips > 0.4;

  double get linkageRate =>
      totalSlips > 0 ? scrollingPrecededSlips / totalSlips : 0.0;

  void recordSlip({required bool precededByScrolling}) {
    totalSlips++;
    if (precededByScrolling) scrollingPrecededSlips++;
  }

  String? get insight {
    if (totalSlips < 3) return null;
    final pct = (linkageRate * 100).round();
    return '$pct% of your lapses were preceded by scrolling.';
  }

  String? get interventionSuggestion {
    if (!isActive) return null;
    return 'Your scrolling often leads to a lapse. '
        'Try putting your phone away when you notice the urge to scroll.';
  }
}
