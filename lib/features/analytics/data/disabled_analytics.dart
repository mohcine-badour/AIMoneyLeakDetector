import '../domain/analytics.dart';
import '../domain/analytics_event.dart';
import '../domain/analytics_sanitizer.dart';

class DisabledAnalytics implements Analytics {
  const DisabledAnalytics();

  @override
  Future<void> track(
    AnalyticsEvent event, {
    Map<String, Object>? properties,
  }) async {}
}

class SanitizingAnalytics implements Analytics {
  const SanitizingAnalytics(this._inner);

  final Analytics _inner;

  @override
  Future<void> track(AnalyticsEvent event, {Map<String, Object>? properties}) {
    return _inner.track(
      event,
      properties: AnalyticsSanitizer.sanitize(properties),
    );
  }
}
