import 'analytics_event.dart';

class AnalyticsRecord {
  const AnalyticsRecord(this.event, [this.properties]);

  final AnalyticsEvent event;
  final Map<String, Object>? properties;
}

/// Product analytics port. Never send receipts or money figures.
abstract class Analytics {
  Future<void> track(AnalyticsEvent event, {Map<String, Object>? properties});
}
