import '../domain/analytics.dart';
import '../domain/analytics_event.dart';

/// In-memory analytics for tests.
class RecordingAnalytics implements Analytics {
  final List<AnalyticsRecord> records = [];

  @override
  Future<void> track(
    AnalyticsEvent event, {
    Map<String, Object>? properties,
  }) async {
    records.add(AnalyticsRecord(event, properties));
  }

  bool has(AnalyticsEvent event) {
    return records.any((record) => record.event == event);
  }

  Map<String, Object>? propertiesFor(AnalyticsEvent event) {
    for (final record in records.reversed) {
      if (record.event == event) {
        return record.properties;
      }
    }
    return null;
  }
}
