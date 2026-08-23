/// App-level configuration.
///
/// Keep environment and product flags here. Do not scatter them in widgets.
/// Never store AI API keys here.
abstract final class AppConfig {
  static const String defaultLanguageCode = 'en';
  static const bool analyticsEnabled = true;
  static const bool adsEnabled = false;
  static const bool allowCleartextTraffic = false;
  static const String privacyPolicyUrl = '';
  static const String termsUrl = '';
  static const String supportUrl =
      'https://mohcine-badour.github.io/AIMoneyLeakDetector/support.html';
  static const String manageSubscriptionUrl =
      'https://apps.apple.com/account/subscriptions';
}
