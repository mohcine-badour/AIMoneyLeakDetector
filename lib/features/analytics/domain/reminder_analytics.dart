import 'analytics.dart';
import 'analytics_event.dart';

/// Maps local reminder payloads to analytics without financial fields.
abstract final class ReminderAnalytics {
  static void onPayload(String? payload, Analytics analytics) {
    if (payload == null || !payload.startsWith('trialEnding:')) {
      return;
    }
    analytics.track(
      AnalyticsEvent.trialReminderTriggered,
      properties: const {'kind': 'trial_ending'},
    );
  }
}
