import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/core/database/database_encryption.dart';
import 'package:kichta/core/security/in_memory_secure_store.dart';
import 'package:kichta/core/security/secure_store.dart';

void main() {
  test('creates a Keychain key once and reuses it', () async {
    final store = InMemorySecureStore();
    final first = await DatabaseEncryption.ensureKey(store);
    final second = await DatabaseEncryption.ensureKey(store);

    expect(first, isNotEmpty);
    expect(second, first);
    expect(await store.read(SecureStorePolicy.databaseKey), first);
  });

  test('escapes quotes so PRAGMA key cannot break out of the SQL string', () {
    expect(DatabaseEncryption.escapeSqlString("a'b"), "a''b");
  });
}
