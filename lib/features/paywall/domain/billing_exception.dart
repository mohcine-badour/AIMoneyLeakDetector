class BillingException implements Exception {
  const BillingException(this.message, {this.isCancelled = false});

  final String message;
  final bool isCancelled;

  @override
  String toString() => 'BillingException: $message';
}
