import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/core/security/document_store.dart';

void main() {
  test('receipt bytes stay ephemeral and are discarded', () async {
    final store = EphemeralDocumentStore();
    expect(store.persistsDocuments, isFalse);
    expect(DocumentRetentionPolicy.persistReceiptImages, isFalse);
    expect(DocumentRetentionPolicy.discardImageAfterExtraction, isTrue);

    await store.hold(Uint8List.fromList([1, 2, 3]));
    expect(store.currentBytes, isNotNull);

    await store.discard();
    expect(store.currentBytes, isNull);
  });
}
