import 'dart:typed_data';

/// Receipt documents stay in memory and are never written to the app database.
abstract final class DocumentRetentionPolicy {
  static const bool persistReceiptImages = false;
  static const bool persistRawDocuments = false;
  static const bool discardImageAfterExtraction = true;
}

/// Holds a document only for the current session. Does not write files.
abstract class DocumentStore {
  Uint8List? get currentBytes;

  bool get persistsDocuments;

  Future<void> hold(Uint8List bytes);

  Future<void> discard();
}

class EphemeralDocumentStore implements DocumentStore {
  Uint8List? _currentBytes;

  @override
  Uint8List? get currentBytes => _currentBytes;

  @override
  bool get persistsDocuments => false;

  @override
  Future<void> hold(Uint8List bytes) async {
    _currentBytes = bytes;
  }

  @override
  Future<void> discard() async {
    _currentBytes = null;
  }
}
