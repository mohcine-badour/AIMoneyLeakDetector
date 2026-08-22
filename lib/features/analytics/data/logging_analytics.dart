import 'package:flutter/foundation.dart';

import '../domain/analytics.dart';
import '../domain/analytics_event.dart';

/// Debug stand-in. A later adapter can wrap a product analytics SDK here.
class LoggingAnalytics implements Analytics {
  const LoggingAnalytics();

  @override
  Future<void> track(
    AnalyticsEvent event, {
    Map<String, Object>? properties,
  }) async {
    debugPrint('analytics ${event.name}');
  }
}
