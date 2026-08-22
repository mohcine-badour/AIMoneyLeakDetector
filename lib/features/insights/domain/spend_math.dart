import '../../dashboard/domain/spending_summary.dart';
import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/domain/subscription_cost.dart';
import 'insights_timeframe.dart';

class Spark6mo {
  const Spark6mo({required this.values, required this.isEstimated});

  /// Oldest first. Six monthly totals.
  final List<double> values;
  final bool isEstimated;
}

/// Pure spend math. Never call hooks or stores from here.
abstract final class SpendMath {
  static List<Subscription> activeOf(List<Subscription> subscriptions) {
    return [
      for (final item in subscriptions)
        if (item.status == SubscriptionStatus.active) item,
    ];
  }

  static double computeTotalMonthly(List<Subscription> subscriptions) {
    var total = 0.0;
    for (final item in activeOf(subscriptions)) {
      total += SubscriptionCost.monthlyEquivalent(item);
    }
    return total;
  }

  static double computeTotalYearly(List<Subscription> subscriptions) {
    return computeTotalMonthly(subscriptions) * 12;
  }

  /// Last 6 calendar months. Uses createdAt as existence because charge
  /// history is not stored. Marked estimated for that reason.
  static Spark6mo computeSpark6mo(
    List<Subscription> subscriptions, [
    DateTime? now,
  ]) {
    final clock = now ?? DateTime.now();
    final active = activeOf(subscriptions);
    final values = [
      for (var i = 5; i >= 0; i--)
        _monthTotal(active: active, now: clock, monthsAgo: i),
    ];
    return Spark6mo(values: values, isEstimated: true);
  }

  static double computeSpendDelta(double current, double previous) {
    return current - previous;
  }

  static int countRenewalsWithin(
    List<Subscription> subscriptions,
    int days, [
    DateTime? now,
  ]) {
    return RenewalWindow.split(
      subscriptions,
      now ?? DateTime.now(),
    ).soon.length;
  }

  static double periodTotal({
    required List<Subscription> subscriptions,
    required InsightsTimeframe timeframe,
    required DateTime now,
  }) {
    return switch (timeframe) {
      InsightsTimeframe.month => computeTotalMonthly(subscriptions),
      InsightsTimeframe.year => computeTotalYearly(subscriptions),
      InsightsTimeframe.threeMonths || InsightsTimeframe.sixMonths =>
        _sparkWindowTotal(
          computeSpark6mo(subscriptions, now).values,
          timeframe.monthCount,
        ),
    };
  }

  static double amountInWindow({
    required Subscription subscription,
    required InsightsTimeframe timeframe,
    required DateTime now,
  }) {
    final monthly = SubscriptionCost.monthlyEquivalent(subscription);
    if (timeframe == InsightsTimeframe.month) {
      return monthly;
    }
    if (timeframe == InsightsTimeframe.year) {
      return monthly * 12;
    }
    return monthly * monthsExistedInWindow(subscription, timeframe, now);
  }

  static int monthsExistedInWindow(
    Subscription subscription,
    InsightsTimeframe timeframe,
    DateTime now,
  ) {
    final count = timeframe.monthCount;
    var existed = 0;
    for (var i = 0; i < count; i++) {
      if (_existedInMonth(subscription, now, i)) {
        existed++;
      }
    }
    return existed;
  }

  static double _sparkWindowTotal(List<double> values, int months) {
    final start = (values.length - months).clamp(0, values.length);
    var total = 0.0;
    for (var i = start; i < values.length; i++) {
      total += values[i];
    }
    return total;
  }

  static double _monthTotal({
    required List<Subscription> active,
    required DateTime now,
    required int monthsAgo,
  }) {
    var total = 0.0;
    for (final item in active) {
      if (_existedInMonth(item, now, monthsAgo)) {
        total += SubscriptionCost.monthlyEquivalent(item);
      }
    }
    return total;
  }

  static bool _existedInMonth(
    Subscription subscription,
    DateTime now,
    int monthsAgo,
  ) {
    final monthEnd = DateTime(now.year, now.month - monthsAgo + 1, 0);
    var created = subscription.createdAt.toUtc();
    final clock = now.toUtc();
    if (created.isAfter(clock)) {
      created = clock;
    }
    return !created.isAfter(monthEnd.toUtc());
  }
}
