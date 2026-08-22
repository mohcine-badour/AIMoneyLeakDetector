import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/domain/subscription_cost.dart';

sealed class HomeInsight {
  const HomeInsight();
}

class UnusedInsight extends HomeInsight {
  const UnusedInsight({
    required this.subscription,
    required this.daysUnused,
    required this.monthlySavings,
  });

  final Subscription subscription;
  final int daysUnused;
  final double monthlySavings;
}

class PriceHikeInsight extends HomeInsight {
  const PriceHikeInsight({required this.subscription, required this.delta});

  final Subscription subscription;
  final double delta;
}

class OverlapInsight extends HomeInsight {
  const OverlapInsight({
    required this.category,
    required this.subscriptions,
    required this.potentialSavings,
  });

  final SubscriptionCategory category;
  final List<Subscription> subscriptions;
  final double potentialSavings;
}

/// Priority: unused > price hike > overlap. Returns null if nothing qualifies.
abstract final class HomeInsightResolver {
  static const int unusedDays = 30;
  static const double unusedMinMonthly = 5;
  static const double overlapMinMonthly = 10;

  static HomeInsight? fromSubscriptions(
    List<Subscription> subscriptions, {
    required DateTime now,
    Map<String, DateTime> lastOpenedById = const {},
    Map<String, double> previousAmountById = const {},
  }) {
    final active = [
      for (final item in subscriptions)
        if (item.status == SubscriptionStatus.active) item,
    ];
    final unused = _unused(active, now, lastOpenedById);
    if (unused != null) {
      return unused;
    }
    final hike = _priceHike(active, previousAmountById);
    if (hike != null) {
      return hike;
    }
    return _overlap(active);
  }

  static UnusedInsight? _unused(
    List<Subscription> active,
    DateTime now,
    Map<String, DateTime> lastOpenedById,
  ) {
    UnusedInsight? best;
    for (final item in active) {
      final opened = lastOpenedById[item.id];
      if (opened == null) {
        continue;
      }
      final days = now.difference(opened).inDays;
      final monthly = SubscriptionCost.monthlyEquivalent(item);
      if (days > unusedDays && monthly >= unusedMinMonthly) {
        if (best == null || monthly > best.monthlySavings) {
          best = UnusedInsight(
            subscription: item,
            daysUnused: days,
            monthlySavings: monthly,
          );
        }
      }
    }
    return best;
  }

  static PriceHikeInsight? _priceHike(
    List<Subscription> active,
    Map<String, double> previousAmountById,
  ) {
    for (final item in active) {
      final previous = previousAmountById[item.id];
      if (previous == null || previous <= 0) {
        continue;
      }
      final delta = item.amount - previous;
      if (delta / previous > 0.10) {
        return PriceHikeInsight(subscription: item, delta: delta);
      }
    }
    return null;
  }

  static OverlapInsight? _overlap(List<Subscription> active) {
    final byCategory = <SubscriptionCategory, List<Subscription>>{};
    for (final item in active) {
      final monthly = SubscriptionCost.monthlyEquivalent(item);
      if (monthly < overlapMinMonthly) {
        continue;
      }
      byCategory.putIfAbsent(item.category, () => []).add(item);
    }
    for (final entry in byCategory.entries) {
      if (entry.value.length < 2) {
        continue;
      }
      final amounts = [
        for (final item in entry.value)
          SubscriptionCost.monthlyEquivalent(item),
      ]..sort();
      return OverlapInsight(
        category: entry.key,
        subscriptions: entry.value,
        potentialSavings: amounts.first,
      );
    }
    return null;
  }
}
