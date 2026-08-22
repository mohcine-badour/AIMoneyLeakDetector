/// Client-side secret rules. AI and OCR keys stay on the server.
abstract final class ClientSecretPolicy {
  static const Set<String> forbiddenNames = {
    'OPENAI_API_KEY',
    'ANTHROPIC_API_KEY',
    'AI_SECRET',
    'OCR_API_KEY',
    'REVENUECAT_SECRET',
    'STRIPE_SECRET',
  };

  /// Public identifiers that may be supplied with dart-define.
  static const Set<String> allowedDartDefines = {
    'REVENUECAT_APPLE_API_KEY',
    'ADMOB_BANNER_UNIT_ID',
  };

  static bool isForbiddenName(String name) {
    final upper = name.toUpperCase();
    for (final forbidden in forbiddenNames) {
      if (upper.contains(forbidden)) {
        return true;
      }
    }
    return false;
  }

  static bool isAllowedDartDefine(String name) {
    return allowedDartDefines.contains(name);
  }
}
