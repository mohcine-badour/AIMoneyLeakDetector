import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/features/analytics/data/recording_analytics.dart';
import 'package:billkiller_ai/features/analytics/domain/analytics_event.dart';
import 'package:billkiller_ai/features/analytics/domain/reminder_analytics.dart';

void main() {
  test('trial payload records a reminder event without financial fields', () {
    final analytics = RecordingAnalytics();

    ReminderAnalytics.onPayload('trialEnding:chatgpt', analytics);

    expect(analytics.has(AnalyticsEvent.trialReminderTriggered), isTrue);
    expect(analytics.propertiesFor(AnalyticsEvent.trialReminderTriggered), {
      'kind': 'trial_ending',
    });
  });

  test('renewal payloads are ignored', () {
    final analytics = RecordingAnalytics();

    ReminderAnalytics.onPayload('renewal:netflix', analytics);

    expect(analytics.has(AnalyticsEvent.trialReminderTriggered), isFalse);
  });
}
