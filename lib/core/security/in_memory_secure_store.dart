import 'secure_store.dart';

/// Process-memory store used until a Keychain adapter is wired for API tokens.
class InMemorySecureStore implements SecureStore {
  final Map<String, String> _values = {};

  @override
  Future<void> write({required String key, required String value}) async {
    SecureStorePolicy.assertAllowedKey(key);
    _values[key] = value;
  }

  @override
  Future<String?> read(String key) async {
    SecureStorePolicy.assertAllowedKey(key);
    return _values[key];
  }

  @override
  Future<void> delete(String key) async {
    SecureStorePolicy.assertAllowedKey(key);
    _values.remove(key);
  }

  @override
  Future<void> clear() async {
    _values.clear();
  }
}
