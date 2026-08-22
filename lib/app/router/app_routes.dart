/// Named route paths used by go_router.
abstract final class AppRoutes {
  static const String launch = '/';
  static const String onboarding = '/onboarding';
  static const String dashboard = '/dashboard';
  static const String subscriptions = '/subscriptions';
  static const String addSubscription = '/subscriptions/add';
  static const String scanReceipt = '/subscriptions/scan';
  static const String beforeYouSubscribe = '/subscriptions/evaluate';
  static const String subscriptionDetail = '/subscriptions/:id';
  static const String editSubscription = '/subscriptions/:id/edit';
  static const String cancellationGuide = '/subscriptions/:id/cancel';
  static const String upcoming = '/upcoming';
  static const String trials = '/trials';
  static const String addTrial = '/trials/add';
  static const String trialDetail = '/trials/:id';
  static const String savings = '/savings';
  static const String settings = '/settings';
  static const String privacyPolicy = '/settings/privacy';
  static const String paywall = '/paywall';

  static String subscriptionDetailLocation(String id) => '/subscriptions/$id';

  static String editSubscriptionLocation(String id) =>
      '/subscriptions/$id/edit';

  static String cancellationGuideLocation(String id) =>
      '/subscriptions/$id/cancel';

  static String trialDetailLocation(String id) => '/trials/$id';
}
