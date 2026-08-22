import '../../../core/brand/brand_registry.dart';
import 'subscription.dart';
import 'subscription_brand.dart';
import 'subscription_cost.dart';

enum SubscriptionSort {
  nextPayment,
  highestCost,
  alphabetical,
  recentlyAdded,
}

enum SubscriptionViewMode { list, grid }

class SubscriptionListQuery {
  const SubscriptionListQuery({
    this.search = '',
    this.category,
    this.sort = SubscriptionSort.nextPayment,
    this.viewMode = SubscriptionViewMode.list,
    this.showInactive = false,
  });

  final String search;
  final BrandCategory? category;
  final SubscriptionSort sort;
  final SubscriptionViewMode viewMode;
  final bool showInactive;

  bool get hasActiveFilters =>
      category != null ||
      sort != SubscriptionSort.nextPayment ||
      showInactive;

  SubscriptionListQuery copyWith({
    String? search,
    BrandCategory? category,
    bool clearCategory = false,
    SubscriptionSort? sort,
    SubscriptionViewMode? viewMode,
    bool? showInactive,
  }) {
    return SubscriptionListQuery(
      search: search ?? this.search,
      category: clearCategory ? null : (category ?? this.category),
      sort: sort ?? this.sort,
      viewMode: viewMode ?? this.viewMode,
      showInactive: showInactive ?? this.showInactive,
    );
  }
}

class SubscriptionListTotals {
  const SubscriptionListTotals({
    required this.monthly,
    required this.yearly,
    required this.count,
  });

  final double monthly;
  final double yearly;
  final int count;

  static SubscriptionListTotals from(List<Subscription> subscriptions) {
    var monthly = 0.0;
    for (final item in subscriptions) {
      monthly += SubscriptionCost.monthlyEquivalent(item);
    }
    return SubscriptionListTotals(
      monthly: monthly,
      yearly: monthly * 12,
      count: subscriptions.length,
    );
  }
}

abstract final class SubscriptionListFilter {
  static List<Subscription> apply(
    List<Subscription> subscriptions,
    SubscriptionListQuery query,
  ) {
    Iterable<Subscription> result = subscriptions;

    if (!query.showInactive) {
      result = result.where(
        (item) => item.status == SubscriptionStatus.active,
      );
    }

    final search = query.search.trim().toLowerCase();
    if (search.isNotEmpty) {
      result = result.where((item) {
        final brand = SubscriptionBrand.brandFor(item);
        final name = (item.name).toLowerCase();
        final merchant = item.merchant.toLowerCase();
        final display = (brand?.displayName ?? '').toLowerCase();
        return name.contains(search) ||
            merchant.contains(search) ||
            display.contains(search);
      });
    }

    if (query.category != null) {
      result = result.where(
        (item) => SubscriptionBrand.categoryFor(item) == query.category,
      );
    }

    final list = result.toList();
    list.sort((left, right) {
      switch (query.sort) {
        case SubscriptionSort.nextPayment:
          return left.nextBillingDate.compareTo(right.nextBillingDate);
        case SubscriptionSort.highestCost:
          return SubscriptionCost.monthlyEquivalent(
            right,
          ).compareTo(SubscriptionCost.monthlyEquivalent(left));
        case SubscriptionSort.alphabetical:
          return left.name.toLowerCase().compareTo(right.name.toLowerCase());
        case SubscriptionSort.recentlyAdded:
          return right.createdAt.compareTo(left.createdAt);
      }
    });
    return list;
  }

  static Map<String, int> categoryCounts(List<Subscription> subscriptions) {
    final counts = <String, int>{
      'all': subscriptions
          .where((item) => item.status == SubscriptionStatus.active)
          .length,
    };
    for (final item in subscriptions) {
      if (item.status != SubscriptionStatus.active) {
        continue;
      }
      final key = SubscriptionBrand.categoryFor(item).name;
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts;
  }
}
