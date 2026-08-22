import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'document_store.dart';
import 'in_memory_secure_store.dart';
import 'secure_store.dart';

final secureStoreProvider = Provider<SecureStore>((ref) {
  return InMemorySecureStore();
});

final documentStoreProvider = Provider<DocumentStore>((ref) {
  return EphemeralDocumentStore();
});
