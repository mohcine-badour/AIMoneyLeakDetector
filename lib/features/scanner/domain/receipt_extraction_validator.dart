import '../../../core/utils/money_format.dart';
import '../../subscriptions/domain/subscription.dart';
import 'receipt_extraction_exception.dart';

class ReceiptExtractionPayload {
  const ReceiptExtractionPayload({
    required this.merchant,
    required this.amount,
    required this.currency,
    required this.billingCycle,
    required this.date,
    required this.confidence,
  });

  final String merchant;
  final double amount;
  final String currency;
  final BillingCycle billingCycle;
  final DateTime date;
  final double confidence;
}

/// Validates structured OCR/AI JSON from the backend. Keep this out of widgets.
abstract final class ReceiptExtractionValidator {
  static const double minConfidence = 0;
  static const double maxConfidence = 1;

  static ReceiptExtractionPayload parse(Map<String, dynamic> json) {
    final merchant = _string(json, 'merchant');

    final amount = _number(json, 'amount');
    if (amount <= 0) {
      throw const ReceiptExtractionException('amount must be greater than 0');
    }

    final currency = _string(json, 'currency').toUpperCase();
    if (!MoneyFormat.supportedCurrencyCodes.contains(currency)) {
      throw ReceiptExtractionException('unsupported currency: $currency');
    }

    final cycleName = _string(json, 'billing_cycle');
    final BillingCycle billingCycle;
    try {
      billingCycle = BillingCycle.values.byName(cycleName);
    } on ArgumentError {
      throw ReceiptExtractionException('unsupported billing cycle: $cycleName');
    }

    final date = _date(_string(json, 'date'));
    final confidence = _number(json, 'confidence');
    if (confidence < minConfidence || confidence > maxConfidence) {
      throw const ReceiptExtractionException('confidence must be between 0 and 1');
    }

    return ReceiptExtractionPayload(
      merchant: merchant.trim(),
      amount: amount,
      currency: currency,
      billingCycle: billingCycle,
      date: date,
      confidence: confidence,
    );
  }

  static String _string(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.trim().isEmpty) {
      throw ReceiptExtractionException('$key is required');
    }
    return value;
  }

  static double _number(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! num) {
      throw ReceiptExtractionException('$key is required');
    }
    return value.toDouble();
  }

  static DateTime _date(String raw) {
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(raw.trim());
    if (match == null) {
      throw ReceiptExtractionException('invalid date: $raw');
    }
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    final date = DateTime.utc(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      throw ReceiptExtractionException('invalid date: $raw');
    }
    return date;
  }
}
