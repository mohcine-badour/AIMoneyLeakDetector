import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/features/analytics/data/analytics_factory.dart';
import 'package:kichta/features/analytics/data/disabled_analytics.dart';
import 'package:kichta/features/analytics/domain/analytics_event.dart';

void main() {
  test('event names match the product analytics catalog', () {
    expect(AnalyticsEvent.appOpened.name, 'app_opened');
    expect(AnalyticsEvent.welcomeView.name, 'welcome_view');
    expect(AnalyticsEvent.getStartedPress.name, 'get_started_press');
    expect(
      AnalyticsEvent.anonymousSignInSuccess.name,
      'anonymous_signin_success',
    );
    expect(AnalyticsEvent.anonymousSignInError.name, 'anonymous_signin_error');
    expect(AnalyticsEvent.signInPress.name, 'sign_in_press');
    expect(AnalyticsEvent.termsPress.name, 'terms_press');
    expect(AnalyticsEvent.privacyPress.name, 'privacy_press');
    expect(AnalyticsEvent.featuredBrandTap.name, 'featured_brand_tap');
    expect(AnalyticsEvent.onboardingStarted.name, 'onboarding_started');
    expect(AnalyticsEvent.onboardingPageView.name, 'onboarding_page_view');
    expect(AnalyticsEvent.onboardingAdvance.name, 'onboarding_advance');
    expect(AnalyticsEvent.onboardingBack.name, 'onboarding_back');
    expect(AnalyticsEvent.onboardingJump.name, 'onboarding_jump');
    expect(AnalyticsEvent.onboardingSkipPress.name, 'onboarding_skip_press');
    expect(AnalyticsEvent.onboardingCompleted.name, 'onboarding_completed');
    expect(AnalyticsEvent.onboardingExampleTap.name, 'onboarding_example_tap');
    expect(
      AnalyticsEvent.onboardingTrialExampleTap.name,
      'onboarding_trial_example_tap',
    );
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
    expect(AnalyticsEvent.paywallDismissed.name, 'paywall_dismissed');
    expect(AnalyticsEvent.paywallPlanToggled.name, 'paywall_plan_toggled');
    expect(AnalyticsEvent.paywallTermsOpened.name, 'paywall_terms_opened');
    expect(AnalyticsEvent.paywallPrivacyOpened.name, 'paywall_privacy_opened');
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
