/// Deterministic currency display. Do not use AI for this.
abstract final class MoneyFormat {
  static const String defaultCurrencyCode = 'USD';

  static String format(
    double amount, {
    String currencyCode = defaultCurrencyCode,
  }) {
    final symbol = _symbols[currencyCode] ?? '$currencyCode ';
    final sign = amount < 0 ? '-' : '';
    final parts = amount.abs().toStringAsFixed(2).split('.');
    return '$sign$symbol${_groupThousands(parts[0])}.${parts[1]}';
  }

  static String short(
    double amount, {
    String currencyCode = defaultCurrencyCode,
  }) {
    final symbol = _symbols[currencyCode] ?? '$currencyCode ';
    final sign = amount < 0 ? '-' : '';
    return '$sign$symbol${_groupThousands(amount.abs().round().toString())}';
  }

  static ({String whole, String cents}) split(
    double amount, {
    String currencyCode = defaultCurrencyCode,
  }) {
    final formatted = format(amount, currencyCode: currencyCode);
    final dot = formatted.lastIndexOf('.');
    if (dot < 0) {
      return (whole: formatted, cents: '');
    }
    return (
      whole: formatted.substring(0, dot),
      cents: formatted.substring(dot),
    );
  }

  static String _groupThousands(String whole) {
    if (whole.length <= 3) {
      return whole;
    }
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(whole[i]);
    }
    return buffer.toString();
  }

  static const Map<String, String> _symbols = {
    'USD': r'$',
    'CAD': r'C$',
    'AUD': r'A$',
    'GBP': '£',
    'EUR': '€',
    'CHF': 'CHF ',
  };

  static const Map<String, String> _names = {
    'USD': 'US dollar',
    'CAD': 'Canadian dollar',
    'AUD': 'Australian dollar',
    'GBP': 'British pound',
    'EUR': 'Euro',
    'CHF': 'Swiss franc',
  };

  static Iterable<String> get supportedCurrencyCodes => _symbols.keys;

  static String symbolFor(String currencyCode) {
    final symbol = _symbols[currencyCode];
    if (symbol == null) {
      return currencyCode;
    }
    return symbol.trim();
  }

  static String nameFor(String currencyCode) {
    return _names[currencyCode] ?? currencyCode;
  }
}
