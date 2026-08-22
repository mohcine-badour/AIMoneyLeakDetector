/// Product events. Names stay stable; do not attach financial documents.
enum AnalyticsEvent {
  appOpened('app_opened'),
  welcomeView('welcome_view'),
  getStartedPress('get_started_press'),
  anonymousSignInSuccess('anonymous_signin_success'),
  anonymousSignInError('anonymous_signin_error'),
  signInPress('sign_in_press'),
  termsPress('terms_press'),
  privacyPress('privacy_press'),
  featuredBrandTap('featured_brand_tap'),
  onboardingStarted('onboarding_started'),
  onboardingCompleted('onboarding_completed'),
  subscriptionCreated('subscription_created'),
  subscriptionDeleted('subscription_deleted'),
  subscriptionUpdated('subscription_updated'),
  receiptScanStarted('receipt_scan_started'),
  receiptScanCompleted('receipt_scan_completed'),
  aiAnalysisStarted('ai_analysis_started'),
  aiAnalysisCompleted('ai_analysis_completed'),
  trialCreated('trial_created'),
  trialReminderTriggered('trial_reminder_triggered'),
  paywallViewed('paywall_viewed'),
  paywallDismissed('paywall_dismissed'),
  paywallPlanToggled('paywall_plan_toggled'),
  paywallTermsOpened('paywall_terms_opened'),
  paywallPrivacyOpened('paywall_privacy_opened'),
  purchaseStarted('purchase_started'),
  purchaseCompleted('purchase_completed'),
  purchaseRestored('purchase_restored'),
  cancellationGuideOpened('cancellation_guide_opened');

  const AnalyticsEvent(this.name);

  final String name;
}
