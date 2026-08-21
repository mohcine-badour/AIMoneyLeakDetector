class MoneyAnalysisException implements Exception {
  const MoneyAnalysisException(this.message);

  final String message;

  @override
  String toString() => 'MoneyAnalysisException: $message';
}
