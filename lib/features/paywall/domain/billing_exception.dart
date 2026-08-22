class BillingException implements Exception {
  const BillingException(
    this.message, {
    this.isCancelled = false,
    this.code,
  });

  final String message;
  final bool isCancelled;
  final String? code;

  @override
  String toString() => 'BillingException: $message';
}

