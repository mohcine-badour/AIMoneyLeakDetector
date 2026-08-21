class SubscribeAdviceException implements Exception {
  const SubscribeAdviceException(this.message);

  final String message;

  @override
  String toString() => 'SubscribeAdviceException: $message';
}
