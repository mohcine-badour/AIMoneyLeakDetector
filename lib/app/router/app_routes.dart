/// Named route paths used by go_router.
abstract final class AppRoutes {
  static const String launch = '/';
  static const String onboarding = '/onboarding';
  static const String dashboard = '/dashboard';
  static const String subscriptions = '/subscriptions';
  static const String addSubscription = '/subscriptions/add';
  static const String subscriptionDetail = '/subscriptions/:id';
  static const String trials = '/trials';
  static const String savings = '/savings';
  static const String settings = '/settings';
  static const String paywall = '/paywall';

  static String subscriptionDetailLocation(String id) =>
      '/subscriptions/$id';
}
