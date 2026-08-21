class ReceiptExtractionException implements Exception {
  const ReceiptExtractionException(this.message);

  final String message;

  @override
  String toString() => 'ReceiptExtractionException: $message';
}
