import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/features/analytics/data/analytics_factory.dart';
import 'package:billkiller_ai/features/analytics/data/disabled_analytics.dart';
import 'package:billkiller_ai/features/analytics/domain/analytics_event.dart';

void main() {
  test('event names match the product analytics catalog', () {
    expect(AnalyticsEvent.appOpened.name, 'app_opened');
    expect(AnalyticsEvent.onboardingStarted.name, 'onboarding_started');
    expect(AnalyticsEvent.onboardingCompleted.name, 'onboarding_completed');
    expect(AnalyticsEvent.subscriptionCreated.name, 'subscription_created');
    expect(AnalyticsEvent.subscriptionDeleted.name, 'subscription_deleted');
    expect(AnalyticsEvent.subscriptionUpdated.name, 'subscription_updated');
    expect(AnalyticsEvent.receiptScanStarted.name, 'receipt_scan_started');
    expect(AnalyticsEvent.receiptScanCompleted.name, 'receipt_scan_completed');
    expect(AnalyticsEvent.aiAnalysisStarted.name, 'ai_analysis_started');
    expect(AnalyticsEvent.aiAnalysisCompleted.name, 'ai_analysis_completed');
    expect(AnalyticsEvent.trialCreated.name, 'trial_created');
    expect(
      AnalyticsEvent.trialReminderTriggered.name,
      'trial_reminder_triggered',
    );
    expect(AnalyticsEvent.paywallViewed.name, 'paywall_viewed');
    expect(AnalyticsEvent.purchaseStarted.name, 'purchase_started');
    expect(AnalyticsEvent.purchaseCompleted.name, 'purchase_completed');
    expect(AnalyticsEvent.purchaseRestored.name, 'purchase_restored');
    expect(
      AnalyticsEvent.cancellationGuideOpened.name,
      'cancellation_guide_opened',
    );
  });

  test('disabled factory never records', () {
    expect(AnalyticsFactory.create(enabled: false), isA<DisabledAnalytics>());
  });

  test('enabled factory sanitizes before logging', () {
    expect(AnalyticsFactory.create(enabled: true), isA<SanitizingAnalytics>());
  });
}
