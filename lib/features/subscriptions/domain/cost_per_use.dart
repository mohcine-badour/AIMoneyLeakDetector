import 'subscription.dart';
import 'subscription_cost.dart';
import 'subscription_usage.dart';

class CostPerUseSnapshot {
  const CostPerUseSnapshot({
    required this.monthlyAmount,
    required this.uses,
    required this.costPerUse,
  });

  /// Null when usage has not been recorded.
  final int? uses;
  final double monthlyAmount;

  /// Null when uses is missing or zero. Do not divide by zero.
  final double? costPerUse;
}

/// Deterministic cost per use. Do not use AI for this.
///
/// Cost per use = monthly equivalent / declared uses.
abstract final class CostPerUse {
  static CostPerUseSnapshot from({
    required Subscription subscription,
    SubscriptionUsage? usage,
  }) {
    return fromMonthly(
      monthlyAmount: SubscriptionCost.monthlyEquivalent(subscription),
      uses: usage?.useCount,
    );
  }

  static CostPerUseSnapshot fromMonthly({
    required double monthlyAmount,
    int? uses,
  }) {
    if (uses == null || uses <= 0) {
      return CostPerUseSnapshot(
        monthlyAmount: monthlyAmount,
        uses: uses,
        costPerUse: null,
      );
    }
    return CostPerUseSnapshot(
      monthlyAmount: monthlyAmount,
      uses: uses,
      costPerUse: monthlyAmount / uses,
    );
  }
}
