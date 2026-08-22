import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/core/security/in_memory_secure_store.dart';
import 'package:kichta/core/security/secure_store.dart';

void main() {
  test('stores tokens in memory and never accepts financial keys', () async {
    final store = InMemorySecureStore();

    await store.write(key: 'token.session', value: 'abc');
    expect(await store.read('token.session'), 'abc');

    expect(
      () => store.write(key: 'amount', value: '22.99'),
      throwsArgumentError,
    );
    expect(
      () => store.write(key: 'receipt', value: 'raw'),
      throwsArgumentError,
    );
    expect(SecureStorePolicy.isAllowedKey('merchant'), isFalse);

    await store.write(key: SecureStorePolicy.databaseKey, value: 'keep');
    await store.clear();
    expect(await store.read('token.session'), isNull);
    expect(await store.read(SecureStorePolicy.databaseKey), 'keep');
  });
}
