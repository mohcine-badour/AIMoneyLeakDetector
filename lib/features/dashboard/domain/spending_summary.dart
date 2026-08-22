import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/domain/subscription_cost.dart';

class SpendingSummary {
  const SpendingSummary({
    required this.monthTotal,
    required this.monthDelta,
    required this.yearTotal,
    required this.activeCount,
    required this.highest,
    required this.spark,
    required this.currencyCode,
  });

  final double monthTotal;
  final double monthDelta;
  final double yearTotal;
  final int activeCount;
  final double highest;
  final List<double> spark;
  final String currencyCode;
}

/// Last 6 calendar months from [now], using createdAt as existence.
abstract final class SpendingSummaryCalculator {
  static SpendingSummary fromSubscriptions(
    List<Subscription> subscriptions, {
    required DateTime now,
  }) {
    final active = [
      for (final item in subscriptions)
        if (item.status == SubscriptionStatus.active) item,
    ];
    if (active.isEmpty) {
      return const SpendingSummary(
        monthTotal: 0,
        monthDelta: 0,
        yearTotal: 0,
        activeCount: 0,
        highest: 0,
        spark: [0, 0, 0, 0, 0, 0],
        currencyCode: 'USD',
      );
    }

    var monthly = 0.0;
    var highest = 0.0;
    for (final item in active) {
      final cost = SubscriptionCost.monthlyEquivalent(item);
      monthly += cost;
      if (item.amount > highest) {
        highest = item.amount;
      }
    }

    final spark = [
      for (var i = 5; i >= 0; i--)
        _monthTotal(active: active, now: now, monthsAgo: i),
    ];
    final previous = spark.length > 1 ? spark[spark.length - 2] : 0.0;

    final currencies = {for (final item in active) item.currency};
    return SpendingSummary(
      monthTotal: monthly,
      monthDelta: monthly - previous,
      yearTotal: monthly * 12,
      activeCount: active.length,
      highest: highest,
      spark: spark,
      currencyCode: currencies.length == 1 ? currencies.first : 'USD',
    );
  }

  static double _monthTotal({
    required List<Subscription> active,
    required DateTime now,
    required int monthsAgo,
  }) {
    final month = DateTime(now.year, now.month - monthsAgo + 1, 0);
    var total = 0.0;
    for (final item in active) {
      var created = item.createdAt.toUtc();
      if (created.isAfter(now.toUtc())) {
        created = now.toUtc();
      }
      if (!created.isAfter(month.toUtc())) {
        total += SubscriptionCost.monthlyEquivalent(item);
      }
    }
    return total;
  }
}

class RenewalSplit {
  const RenewalSplit({required this.soon, required this.remaining});

  final List<Subscription> soon;
  final List<Subscription> remaining;
}

abstract final class RenewalWindow {
  static const int days = 7;

  static RenewalSplit split(List<Subscription> subscriptions, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final soon = <Subscription>[];
    final remaining = <Subscription>[];
    for (final item in subscriptions) {
      if (item.status != SubscriptionStatus.active) {
        continue;
      }
      final date = DateTime(
        item.nextBillingDate.year,
        item.nextBillingDate.month,
        item.nextBillingDate.day,
      );
      final diff = date.difference(today).inDays;
      if (diff >= 0 && diff <= days) {
        soon.add(item);
      } else {
        remaining.add(item);
      }
    }
    soon.sort((a, b) => a.nextBillingDate.compareTo(b.nextBillingDate));
    remaining.sort((a, b) => a.nextBillingDate.compareTo(b.nextBillingDate));
    return RenewalSplit(soon: soon, remaining: remaining);
  }
}
