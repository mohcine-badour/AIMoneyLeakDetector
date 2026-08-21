import 'subscribe_advice_exception.dart';
import 'subscribe_impact.dart';

/// Validates structured before-you-subscribe JSON. Money must match local facts.
abstract final class SubscribeAdviceValidator {
  static const double moneyEpsilon = 0.0001;

  static String parse({
    required Map<String, dynamic> json,
    required SubscribeImpact impact,
  }) {
    _requireMatchingNumber(json, 'monthly_amount', impact.monthlyAmount);
    _requireMatchingNumber(
      json,
      'current_category_spend',
      impact.currentCategoryMonthly,
    );
    _requireMatchingNumber(
      json,
      'after_category_spend',
      impact.afterCategoryMonthly,
    );
    _requireMatchingNumber(json, 'annual_impact', impact.annualImpact);

    final currency = json['currency'];
    if (currency is! String || currency != impact.currencyCode) {
      throw const SubscribeAdviceException('currency does not match local facts');
    }

    if (json['mutates_data'] == true) {
      throw const SubscribeAdviceException(
        'advice must not mutate financial data',
      );
    }
    final mutations = json['mutations'];
    if (mutations is List && mutations.isNotEmpty) {
      throw const SubscribeAdviceException(
        'advice must not mutate financial data',
      );
    }

    final recommendation = json['recommendation'];
    if (recommendation is! String || recommendation.trim().isEmpty) {
      throw const SubscribeAdviceException('recommendation is required');
    }
    return recommendation.trim();
  }

  static void _requireMatchingNumber(
    Map<String, dynamic> json,
    String key,
    double expected,
  ) {
    final value = json[key];
    if (value is! num) {
      throw SubscribeAdviceException('$key is required');
    }
    if ((value.toDouble() - expected).abs() > moneyEpsilon) {
      throw SubscribeAdviceException('$key does not match local facts');
    }
  }
}
