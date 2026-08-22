import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/features/analytics/data/disabled_analytics.dart';
import 'package:kichta/features/analytics/data/recording_analytics.dart';
import 'package:kichta/features/analytics/domain/analytics_event.dart';
import 'package:kichta/features/analytics/domain/analytics_sanitizer.dart';

void main() {
  test('keeps only non-financial allowlisted properties', () {
    final cleaned = AnalyticsSanitizer.sanitize({
      'plan': 'yearly',
      'source': 'scan',
      'success': true,
      'kind': 'trial_ending',
      'amount': 22.99,
      'merchant': 'Netflix',
      'name': 'Netflix',
      'currency': 'USD',
      'image': [1, 2, 3],
      'receipt': 'raw text',
      'spend': 40.98,
    });

    expect(cleaned, {
      'plan': 'yearly',
      'source': 'scan',
      'success': true,
      'kind': 'trial_ending',
    });
  });

  test('drops numbers even if the key looks allowed', () {
    expect(AnalyticsSanitizer.sanitize({'plan': 39.99, 'success': 1}), isNull);
  });

  test('sanitizing analytics never forwards blocked fields', () async {
    final recording = RecordingAnalytics();
    final analytics = SanitizingAnalytics(recording);

    await analytics.track(
      AnalyticsEvent.subscriptionCreated,
      properties: {'source': 'manual', 'amount': 22.99, 'merchant': 'Netflix'},
    );

    expect(recording.propertiesFor(AnalyticsEvent.subscriptionCreated), {
      'source': 'manual',
    });
  });
}
