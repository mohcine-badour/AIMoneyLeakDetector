import '../../../core/brand/brand_registry.dart';
import '../../../core/utils/money_format.dart';
import '../../subscriptions/domain/subscription.dart';
import 'receipt_extraction_exception.dart';

/// Turns OCR text into the receipt JSON contract. Keep this deterministic.
abstract final class ReceiptTextParser {
  static const _noise = {
    'receipt',
    'invoice',
    'statement',
    'subscription',
    'billing',
    'total',
    'subtotal',
    'amount',
    'tax',
    'vat',
    'paid',
    'payment',
    'thanks',
    'thank you',
    'date',
    'visa',
    'mastercard',
    'debit',
    'credit',
  };

  static const _monthNames = <String, int>{
    'jan': 1,
    'january': 1,
    'feb': 2,
    'february': 2,
    'mar': 3,
    'march': 3,
    'apr': 4,
    'april': 4,
    'may': 5,
    'jun': 6,
    'june': 6,
    'jul': 7,
    'july': 7,
    'aug': 8,
    'august': 8,
    'sep': 9,
    'sept': 9,
    'september': 9,
    'oct': 10,
    'october': 10,
    'nov': 11,
    'november': 11,
    'dec': 12,
    'december': 12,
  };

  static Map<String, dynamic> parse(String text, {DateTime? now}) {
    final cleaned = text.replaceAll('\r', '\n').trim();
    if (cleaned.isEmpty) {
      throw const ReceiptExtractionException('no text found');
    }

    final clock = now ?? DateTime.now().toUtc();
    final merchant = _merchant(cleaned);
    final money = _money(cleaned);
    final date = _date(cleaned) ?? DateTime.utc(clock.year, clock.month, clock.day);
    final billing = _billing(cleaned);
    var confidence = 0.35;
    if (BrandRegistry.getBrand(
          BrandRegistry.slugFor(name: merchant, merchant: merchant),
        ) !=
        null) {
      confidence += 0.25;
    } else {
      confidence += 0.1;
    }
    if (money != null) {
      confidence += 0.25;
    }
    if (_date(cleaned) != null) {
      confidence += 0.1;
    }
    if (billing.explicit) {
      confidence += 0.1;
    }
    if (money == null) {
      throw const ReceiptExtractionException('amount is required');
    }

    return {
      'merchant': merchant,
      'amount': money.amount,
      'currency': money.currency,
      'billing_cycle': billing.cycle.name,
      'date': _iso(date),
      'confidence': double.parse(confidence.clamp(0.0, 1.0).toStringAsFixed(2)),
    };
  }

  static String _merchant(String text) {
    final brands = BrandRegistry.bySlug.values.toList()
      ..sort((a, b) => b.displayName.length.compareTo(a.displayName.length));
    final lower = text.toLowerCase();
    for (final brand in brands) {
      if (_containsPhrase(lower, brand.displayName.toLowerCase()) ||
          _containsPhrase(lower, brand.slug)) {
        return brand.displayName;
      }
    }

    for (final raw in text.split(RegExp(r'\n+'))) {
      final line = raw.trim();
      if (line.length < 2 || line.length > 48) {
        continue;
      }
      final normalized = line.toLowerCase();
      if (_noise.contains(normalized)) {
        continue;
      }
      if (RegExp(r'^[\d\s.,€$£/-]+$').hasMatch(line)) {
        continue;
      }
      if (_date(line) != null) {
        continue;
      }
      return line;
    }
    throw const ReceiptExtractionException('merchant is required');
  }

  static ({double amount, String currency})? _money(String text) {
    final preferred = <({double amount, String currency, int score})>[];
    final lines = text.split(RegExp(r'\n+'));
    for (final line in lines) {
      final currency = _currencyIn(line);
      for (final match in RegExp(
        r'(?<![A-Z0-9])(\d{1,4}(?:[.,]\d{2}))(?!\d)',
      ).allMatches(line)) {
        final amount = _toAmount(match.group(1)!);
        if (amount == null || amount < 0.5 || amount > 9999) {
          continue;
        }
        var score = 1;
        final lower = line.toLowerCase();
        if (lower.contains('total') ||
            lower.contains('charged') ||
            lower.contains('billed') ||
            lower.contains('amount') ||
            lower.contains('price') ||
            lower.contains('due')) {
          score += 3;
        }
        if (currency != MoneyFormat.defaultCurrencyCode ||
            line.contains(r'$') ||
            line.contains('€') ||
            line.contains('£')) {
          score += 1;
        }
        preferred.add((amount: amount, currency: currency, score: score));
      }
    }
    if (preferred.isEmpty) {
      return null;
    }
    preferred.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      if (byScore != 0) {
        return byScore;
      }
      return b.amount.compareTo(a.amount);
    });
    return (amount: preferred.first.amount, currency: preferred.first.currency);
  }

  static String _currencyIn(String line) {
    final upper = line.toUpperCase();
    for (final code in MoneyFormat.supportedCurrencyCodes) {
      if (upper.contains(code)) {
        return code;
      }
    }
    if (line.contains('€')) {
      return 'EUR';
    }
    if (line.contains('£')) {
      return 'GBP';
    }
    if (line.contains(r'C$')) {
      return 'CAD';
    }
    if (line.contains(r'A$')) {
      return 'AUD';
    }
    return MoneyFormat.defaultCurrencyCode;
  }

  static double? _toAmount(String raw) {
    final normalized = raw.replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  static DateTime? _date(String text) {
    final iso = RegExp(r'\b(\d{4})-(\d{2})-(\d{2})\b').firstMatch(text);
    if (iso != null) {
      return _validDate(
        int.parse(iso.group(1)!),
        int.parse(iso.group(2)!),
        int.parse(iso.group(3)!),
      );
    }

    final named = RegExp(
      r'\b([A-Za-z]{3,9})\s+(\d{1,2}),?\s+(\d{4})\b',
    ).firstMatch(text);
    if (named != null) {
      final month = _monthNames[named.group(1)!.toLowerCase()];
      if (month != null) {
        return _validDate(
          int.parse(named.group(3)!),
          month,
          int.parse(named.group(2)!),
        );
      }
    }

    final namedLeading = RegExp(
      r'\b(\d{1,2})\s+([A-Za-z]{3,9})\s+(\d{4})\b',
    ).firstMatch(text);
    if (namedLeading != null) {
      final month = _monthNames[namedLeading.group(2)!.toLowerCase()];
      if (month != null) {
        return _validDate(
          int.parse(namedLeading.group(3)!),
          month,
          int.parse(namedLeading.group(1)!),
        );
      }
    }

    final numeric = RegExp(r'\b(\d{1,2})[/-](\d{1,2})[/-](\d{4})\b').firstMatch(
      text,
    );
    if (numeric != null) {
      final first = int.parse(numeric.group(1)!);
      final second = int.parse(numeric.group(2)!);
      final year = int.parse(numeric.group(3)!);
      if (first > 12) {
        return _validDate(year, second, first);
      }
      return _validDate(year, first, second);
    }
    return null;
  }

  static DateTime? _validDate(int year, int month, int day) {
    if (year < 2018 || year > 2100) {
      return null;
    }
    final date = DateTime.utc(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }

  static ({BillingCycle cycle, bool explicit}) _billing(String text) {
    final lower = text.toLowerCase();
    if (RegExp(r'\b(year|yearly|annual|annually|/yr|/year)\b').hasMatch(lower)) {
      return (cycle: BillingCycle.yearly, explicit: true);
    }
    if (RegExp(r'\b(week|weekly|/wk|/week)\b').hasMatch(lower)) {
      return (cycle: BillingCycle.weekly, explicit: true);
    }
    if (RegExp(r'\b(quarter|quarterly)\b').hasMatch(lower)) {
      return (cycle: BillingCycle.quarterly, explicit: true);
    }
    if (RegExp(r'\b(month|monthly|/mo|/month)\b').hasMatch(lower)) {
      return (cycle: BillingCycle.monthly, explicit: true);
    }
    return (cycle: BillingCycle.monthly, explicit: false);
  }

  static bool _containsPhrase(String haystack, String needle) {
    if (needle.isEmpty) {
      return false;
    }
    final escaped = RegExp.escape(needle);
    return RegExp(
      '(^|[^a-z0-9])$escaped([^a-z0-9]|\$)',
      caseSensitive: false,
    ).hasMatch(haystack);
  }

  static String _iso(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
