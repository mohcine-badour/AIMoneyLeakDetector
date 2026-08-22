/// Keychain-ready token storage. Never use SharedPreferences for secrets.
abstract class SecureStore {
  Future<void> write({required String key, required String value});

  Future<String?> read(String key);

  Future<void> delete(String key);

  Future<void> clear();
}

/// Only session/token keys may be stored. Never receipts or money figures.
abstract final class SecureStorePolicy {
  static const String tokenPrefix = 'token.';
  static const String sessionPrefix = 'session.';

  static bool isAllowedKey(String key) {
    return key.startsWith(tokenPrefix) || key.startsWith(sessionPrefix);
  }

  static void assertAllowedKey(String key) {
    if (!isAllowedKey(key)) {
      throw ArgumentError.value(
        key,
        'key',
        'Secure storage is only for tokens and session identifiers.',
      );
    }
  }
}
