import '../../../core/utils/money_format.dart';
import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/domain/subscription_cost.dart';
import '../../upcoming/domain/upcoming_payment.dart';
import '../../upcoming/domain/upcoming_payments.dart';

class CategorySpend {
  const CategorySpend({
    required this.category,
    required this.monthlyAmount,
  });

  final SubscriptionCategory category;
  final double monthlyAmount;
}

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.monthlyTotal,
    required this.annualTotal,
    required this.currencyCode,
    required this.upcoming,
    required this.categories,
    required this.activeCount,
  });

  final double monthlyTotal;
  final double annualTotal;
  final String currencyCode;
  final List<UpcomingPayment> upcoming;
  final List<CategorySpend> categories;
  final int activeCount;
}

/// Deterministic dashboard totals. Do not use AI for this.
///
/// Only active subscriptions are included. Custom cycles count as monthly.
/// Mixed currencies are displayed as USD.
abstract final class DashboardCalculator {
  static const int upcomingLimit = 3;

  static DashboardSnapshot fromSubscriptions(
    List<Subscription> subscriptions,
  ) {
    final active = [
      for (final item in subscriptions)
        if (item.status == SubscriptionStatus.active) item,
    ];
    if (active.isEmpty) {
      return const DashboardSnapshot(
        monthlyTotal: 0,
        annualTotal: 0,
        currencyCode: MoneyFormat.defaultCurrencyCode,
        upcoming: [],
        categories: [],
        activeCount: 0,
      );
    }

    var monthly = 0.0;
    final byCategory = <SubscriptionCategory, double>{};
    for (final item in active) {
      final cost = SubscriptionCost.monthlyEquivalent(item);
      monthly += cost;
      byCategory[item.category] = (byCategory[item.category] ?? 0) + cost;
    }

    final upcoming = UpcomingPayments.fromSubscriptions(
      active,
      limit: upcomingLimit,
    );

    final categories = [
      for (final entry in byCategory.entries)
        CategorySpend(category: entry.key, monthlyAmount: entry.value),
    ]..sort((left, right) => right.monthlyAmount.compareTo(left.monthlyAmount));

    final currencies = {for (final item in active) item.currency};

    return DashboardSnapshot(
      monthlyTotal: monthly,
      annualTotal: monthly * 12,
      currencyCode: currencies.length == 1
          ? currencies.first
          : MoneyFormat.defaultCurrencyCode,
      upcoming: upcoming,
      categories: categories,
      activeCount: active.length,
    );
  }
}
