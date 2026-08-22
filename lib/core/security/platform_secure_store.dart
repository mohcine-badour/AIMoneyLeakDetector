import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_store.dart';

/// Keychain on iOS and EncryptedSharedPreferences on Android.
class PlatformSecureStore implements SecureStore {
  PlatformSecureStore([FlutterSecureStorage? storage])
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  final FlutterSecureStorage _storage;

  @override
  Future<void> write({required String key, required String value}) async {
    SecureStorePolicy.assertAllowedKey(key);
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read(String key) async {
    SecureStorePolicy.assertAllowedKey(key);
    return _storage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    SecureStorePolicy.assertAllowedKey(key);
    await _storage.delete(key: key);
  }

  @override
  Future<void> clear() async {
    final values = await _storage.readAll();
    for (final key in values.keys) {
      if (SecureStorePolicy.shouldClear(key)) {
        await _storage.delete(key: key);
      }
    }
  }
}
