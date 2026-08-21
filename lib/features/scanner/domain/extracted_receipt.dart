import '../../subscriptions/domain/subscription.dart';
import 'receipt_category_mapper.dart';
import 'receipt_extraction_validator.dart';

class ExtractedReceipt {
  const ExtractedReceipt({
    required this.merchant,
    required this.amount,
    required this.currency,
    required this.date,
    required this.billingCycle,
    required this.category,
    required this.confidence,
  });

  factory ExtractedReceipt.fromPayload(ReceiptExtractionPayload payload) {
    return ExtractedReceipt(
      merchant: payload.merchant,
      amount: payload.amount,
      currency: payload.currency,
      date: payload.date,
      billingCycle: payload.billingCycle,
      category: ReceiptCategoryMapper.fromMerchant(payload.merchant),
      confidence: payload.confidence,
    );
  }

  /// Deterministic sample used by tests and the local backend contract.
  factory ExtractedReceipt.mock() {
    return ExtractedReceipt.fromPayload(
      ReceiptExtractionValidator.parse(const {
        'merchant': 'Netflix',
        'amount': 22.99,
        'currency': 'USD',
        'billing_cycle': 'monthly',
        'date': '2026-08-21',
        'confidence': 0.96,
      }),
    );
  }

  final String merchant;
  final double amount;
  final String currency;
  final DateTime date;
  final BillingCycle billingCycle;
  final SubscriptionCategory category;
  final double confidence;

  String get confidencePercent => '${(confidence * 100).round()}%';
}
