import 'subscription.dart';
import 'subscription_cost.dart';

enum SubscriptionSort { nextBillingDate, monthlyCost }

class SubscriptionListQuery {
  const SubscriptionListQuery({
    this.search = '',
    this.category,
    this.sort = SubscriptionSort.nextBillingDate,
  });

  final String search;
  final SubscriptionCategory? category;
  final SubscriptionSort sort;
}

abstract final class SubscriptionListFilter {
  static List<Subscription> apply(
    List<Subscription> subscriptions,
    SubscriptionListQuery query,
  ) {
    Iterable<Subscription> result = subscriptions;

    final search = query.search.trim().toLowerCase();
    if (search.isNotEmpty) {
      result = result.where((item) {
        return item.name.toLowerCase().contains(search) ||
            item.merchant.toLowerCase().contains(search);
      });
    }

    if (query.category != null) {
      result = result.where((item) => item.category == query.category);
    }

    final list = result.toList();
    list.sort((left, right) {
      switch (query.sort) {
        case SubscriptionSort.nextBillingDate:
          return left.nextBillingDate.compareTo(right.nextBillingDate);
        case SubscriptionSort.monthlyCost:
          return SubscriptionCost.monthlyEquivalent(right).compareTo(
            SubscriptionCost.monthlyEquivalent(left),
          );
      }
    });
    return list;
  }
}
