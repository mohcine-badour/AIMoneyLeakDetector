enum InsightsTimeframe { month, threeMonths, sixMonths, year }

abstract final class InsightsTimeframeLabels {
  static const Map<InsightsTimeframe, String> values = {
    InsightsTimeframe.month: 'This month',
    InsightsTimeframe.threeMonths: 'Last 3 months',
    InsightsTimeframe.sixMonths: 'Last 6 months',
    InsightsTimeframe.year: 'This year',
  };

  static String of(InsightsTimeframe timeframe) => values[timeframe]!;
}

extension InsightsTimeframeX on InsightsTimeframe {
  String get label => InsightsTimeframeLabels.of(this);

  String get amountSuffix => switch (this) {
    InsightsTimeframe.month => '/month',
    InsightsTimeframe.threeMonths => '/3 mo',
    InsightsTimeframe.sixMonths => '/6 mo',
    InsightsTimeframe.year => '/year',
  };

  int get monthCount => switch (this) {
    InsightsTimeframe.month => 1,
    InsightsTimeframe.threeMonths => 3,
    InsightsTimeframe.sixMonths => 6,
    InsightsTimeframe.year => 12,
  };
}
