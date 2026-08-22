import '../../../core/brand/brand_registry.dart';
import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/domain/subscription_brand.dart';
import '../../subscriptions/domain/subscription_cost.dart';
import 'insight_item.dart';
import 'spend_math.dart';

/// Builds current, priority-sorted insights. Not filtered by timeframe.
abstract final class InsightListResolver {
  static const int unusedDays = 30;
  static const double unusedMinMonthly = 5;
  static const double overlapMinMonthly = 10;
  static const double yearlyMinAmount = 100;
  static const int yearlyRenewalDays = 14;
  static const int maxShown = 3;

  static const typicalMonthlyCategories = {
    BrandCategory.entertainment,
    BrandCategory.music,
    BrandCategory.storage,
    BrandCategory.ai,
    BrandCategory.productivity,
  };

  static List<InsightItem> resolve(
    List<Subscription> subscriptions, {
    required DateTime now,
    Set<String> dismissedIds = const {},
    Map<String, DateTime> lastOpenedById = const {},
    Map<String, double> previousAmountById = const {},
  }) {
    final active = SpendMath.activeOf(subscriptions);
    final perSub = <String, InsightItem>{};

    void consider(InsightItem item) {
      final existing = perSub[item.featured.id];
      if (existing == null || item.priority < existing.priority) {
        perSub[item.featured.id] = item;
      }
    }

    for (final item in _unused(active, now, lastOpenedById)) {
      consider(item);
    }
    for (final item in _priceHikes(active, previousAmountById)) {
      consider(item);
    }
    for (final item in _yearlyRenewals(active, now)) {
      consider(item);
    }
    for (final item in _wrongCycles(active)) {
      consider(item);
    }

    final subLevel = perSub.values.toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
    final covered = {for (final item in subLevel) item.featured.id};

    final overlaps = [
      for (final item in _overlaps(active))
        if (item.involvedIds.where((id) => !covered.contains(id)).length >= 2)
          item,
    ];

    final all = [...subLevel, ...overlaps]
      ..sort((a, b) {
        final byPriority = a.priority.compareTo(b.priority);
        if (byPriority != 0) {
          return byPriority;
        }
        return a.id.compareTo(b.id);
      });

    return [
      for (final item in all)
        if (!dismissedIds.contains(item.id)) item,
    ].take(maxShown).toList();
  }

  static List<InsightItem> _unused(
    List<Subscription> active,
    DateTime now,
    Map<String, DateTime> lastOpenedById,
  ) {
    final items = <InsightItem>[];
    for (final item in active) {
      final opened = lastOpenedById[item.id];
      if (opened == null) {
        continue;
      }
      final days = now.difference(opened).inDays;
      final monthly = SubscriptionCost.monthlyEquivalent(item);
      if (days >= unusedDays && monthly >= unusedMinMonthly) {
        items.add(
          InsightItem(
            id: 'unused:${item.id}',
            kind: InsightKind.unused,
            featured: item,
            daysUnused: days,
            monthlySavings: monthly,
          ),
        );
      }
    }
    items.sort(
      (a, b) => (b.monthlySavings ?? 0).compareTo(a.monthlySavings ?? 0),
    );
    return items;
  }

  static List<InsightItem> _priceHikes(
    List<Subscription> active,
    Map<String, double> previousAmountById,
  ) {
    final items = <InsightItem>[];
    for (final item in active) {
      final previous = previousAmountById[item.id];
      if (previous == null || previous <= 0) {
        continue;
      }
      final delta = item.amount - previous;
      if (delta / previous > 0.10) {
        items.add(
          InsightItem(
            id: 'price_hike:${item.id}',
            kind: InsightKind.priceHike,
            featured: item,
            delta: delta,
          ),
        );
      }
    }
    return items;
  }

  static List<InsightItem> _overlaps(List<Subscription> active) {
    final byCategory = <BrandCategory, List<Subscription>>{};
    for (final item in active) {
      final monthly = SubscriptionCost.monthlyEquivalent(item);
      if (monthly < overlapMinMonthly) {
        continue;
      }
      final category = SubscriptionBrand.categoryFor(item);
      byCategory.putIfAbsent(category, () => []).add(item);
    }

    final items = <InsightItem>[];
    for (final entry in byCategory.entries) {
      if (entry.value.length < 2) {
        continue;
      }
      final ranked = [...entry.value]
        ..sort(
          (a, b) => SubscriptionCost.monthlyEquivalent(
            b,
          ).compareTo(SubscriptionCost.monthlyEquivalent(a)),
        );
      final amounts = [
        for (final item in ranked) SubscriptionCost.monthlyEquivalent(item),
      ]..sort();
      items.add(
        InsightItem(
          id: 'overlap:${entry.key.name}',
          kind: InsightKind.overlap,
          featured: ranked.first,
          subscriptions: ranked,
          category: entry.key,
          potentialSavings: amounts.first,
        ),
      );
    }
    return items;
  }

  static List<InsightItem> _yearlyRenewals(
    List<Subscription> active,
    DateTime now,
  ) {
    final today = DateTime(now.year, now.month, now.day);
    final items = <InsightItem>[];
    for (final item in active) {
      if (item.billingCycle != BillingCycle.yearly) {
        continue;
      }
      if (item.amount < yearlyMinAmount) {
        continue;
      }
      final date = DateTime(
        item.nextBillingDate.year,
        item.nextBillingDate.month,
        item.nextBillingDate.day,
      );
      final days = date.difference(today).inDays;
      if (days >= 0 && days <= yearlyRenewalDays) {
        items.add(
          InsightItem(
            id: 'yearly_renewal:${item.id}',
            kind: InsightKind.yearlyRenewal,
            featured: item,
            daysUntil: days,
            renewalAmount: item.amount,
          ),
        );
      }
    }
    return items;
  }

  static List<InsightItem> _wrongCycles(List<Subscription> active) {
    final items = <InsightItem>[];
    for (final item in active) {
      if (item.billingCycle != BillingCycle.weekly) {
        continue;
      }
      final category = SubscriptionBrand.categoryFor(item);
      if (!typicalMonthlyCategories.contains(category)) {
        continue;
      }
      items.add(
        InsightItem(
          id: 'wrong_cycle:${item.id}',
          kind: InsightKind.wrongCycle,
          featured: item,
          category: category,
        ),
      );
    }
    return items;
  }
}
