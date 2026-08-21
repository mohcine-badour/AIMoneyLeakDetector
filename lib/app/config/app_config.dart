/// App-level configuration.
///
/// Keep environment and product flags here. Do not scatter them in widgets.
/// Never store AI API keys here.
abstract final class AppConfig {
  static const String defaultLanguageCode = 'en';
  static const bool analyticsEnabled = false;
  static const bool monetizationEnabled = false;
}
