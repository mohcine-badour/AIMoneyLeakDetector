import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'document_store.dart';
import 'platform_secure_store.dart';
import 'secure_store.dart';

final secureStoreProvider = Provider<SecureStore>((ref) {
  return PlatformSecureStore();
});

final documentStoreProvider = Provider<DocumentStore>((ref) {
  return EphemeralDocumentStore();
});
