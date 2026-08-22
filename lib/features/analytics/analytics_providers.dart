import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/analytics_factory.dart';
import 'domain/analytics.dart';
import 'domain/analytics_event.dart';

final analyticsProvider = Provider<Analytics>((ref) {
  return AnalyticsFactory.create();
});

final analyticsSessionProvider = Provider<void>((ref) {
  ref.read(analyticsProvider).track(AnalyticsEvent.appOpened);
});

final analyticsScreenViewProvider = Provider.family<void, AnalyticsEvent>((
  ref,
  event,
) {
  ref.read(analyticsProvider).track(event);
}, isAutoDispose: true);
