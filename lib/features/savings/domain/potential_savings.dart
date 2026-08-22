import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/domain/subscription_cost.dart';

/// Deterministic overlap/duplicate extras. Do not use AI for this.
///
/// For duplicate merchants and overlapping categories, the kept item is the
/// highest monthly equivalent. The rest is reviewable extra, not a guarantee.
abstract final class PotentialSavingsCalculator {
  static double fromSubscriptions(List<Subscription> subscriptions) {
    final active = [
      for (final item in subscriptions)
        if (item.status == SubscriptionStatus.active) item,
    ];
    return fromActive(active);
  }

  static double fromActive(List<Subscription> active) {
    final counted = <String>{};
    var savings = 0.0;

    final byMerchant = <String, List<Subscription>>{};
    for (final item in active) {
      final key = item.merchant.trim().toLowerCase();
      byMerchant.putIfAbsent(key, () => []).add(item);
    }
    for (final group in byMerchant.values) {
      if (group.length < 2) {
        continue;
      }
      savings += _extra(group);
      counted.addAll(group.map((item) => item.id));
    }

    final byCategory = <SubscriptionCategory, List<Subscription>>{};
    for (final item in active) {
      if (counted.contains(item.id)) {
        continue;
      }
      byCategory.putIfAbsent(item.category, () => []).add(item);
    }
    for (final group in byCategory.values) {
      if (group.length < 2) {
        continue;
      }
      savings += _extra(group);
    }

    return savings;
  }

  static double _extra(List<Subscription> group) {
    final amounts = [
      for (final item in group) SubscriptionCost.monthlyEquivalent(item),
    ];
    final total = amounts.fold<double>(0, (sum, amount) => sum + amount);
    final highest = amounts.reduce(
      (left, right) => left > right ? left : right,
    );
    return total - highest;
  }
}
