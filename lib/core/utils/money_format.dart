/// Deterministic currency display. Do not use AI for this.
abstract final class MoneyFormat {
  static const String defaultCurrencyCode = 'USD';

  static String format(
    double amount, {
    String currencyCode = defaultCurrencyCode,
  }) {
    final symbol = _symbols[currencyCode] ?? '$currencyCode ';
    final sign = amount < 0 ? '-' : '';
    return '$sign$symbol${amount.abs().toStringAsFixed(2)}';
  }

  static const Map<String, String> _symbols = {
    'USD': r'$',
    'CAD': r'C$',
    'AUD': r'A$',
    'GBP': '£',
    'EUR': '€',
    'CHF': 'CHF ',
  };

  static Iterable<String> get supportedCurrencyCodes => _symbols.keys;
}
