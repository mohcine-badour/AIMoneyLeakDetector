import 'money_analysis_exception.dart';
import 'money_leak_report.dart';

/// Validates structured AI analysis JSON. Money figures must match local facts.
abstract final class MoneyAnalysisValidator {
  static const double moneyEpsilon = 0.0001;

  static List<String> parse({
    required Map<String, dynamic> json,
    required MoneyAnalysisFacts facts,
  }) {
    _requireMatchingNumber(json, 'monthly_spend', facts.monthlySpend);
    _requireMatchingNumber(json, 'potential_savings', facts.potentialSavings);

    final currency = json['currency'];
    if (currency is! String || currency != facts.currencyCode) {
      throw const MoneyAnalysisException('currency does not match local facts');
    }

    final mutates = json['mutates_data'];
    if (mutates == true) {
      throw const MoneyAnalysisException('analysis must not mutate financial data');
    }

    final mutations = json['mutations'];
    if (mutations is List && mutations.isNotEmpty) {
      throw const MoneyAnalysisException('analysis must not mutate financial data');
    }

    final explanations = json['explanations'];
    if (explanations is! List) {
      throw const MoneyAnalysisException('explanations are required');
    }
    if (explanations.length != facts.recommendations.length) {
      throw const MoneyAnalysisException('explanation count does not match');
    }

    final parsed = <String>[];
    for (final item in explanations) {
      if (item is! String || item.trim().isEmpty) {
        throw const MoneyAnalysisException('each explanation is required');
      }
      parsed.add(item.trim());
    }
    return parsed;
  }

  static void _requireMatchingNumber(
    Map<String, dynamic> json,
    String key,
    double expected,
  ) {
    final value = json[key];
    if (value is! num) {
      throw MoneyAnalysisException('$key is required');
    }
    if ((value.toDouble() - expected).abs() > moneyEpsilon) {
      throw MoneyAnalysisException('$key does not match local facts');
    }
  }
}
