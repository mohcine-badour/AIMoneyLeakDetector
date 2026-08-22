import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/core/brand/brand_registry.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription_cost.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription_list_filter.dart';

Subscription _item({
  required String id,
  required String name,
  required double amount,
  required BillingCycle cycle,
  required DateTime nextBillingDate,
  required SubscriptionCategory category,
  String merchant = '',
}) {
  return Subscription.create(
    id: id,
    name: name,
    merchant: merchant.isEmpty ? name : merchant,
    amount: amount,
    billingCycle: cycle,
    nextBillingDate: nextBillingDate,
    category: category,
  );
}

void main() {
  final netflix = _item(
    id: 'netflix',
    name: 'Netflix',
    amount: 22.99,
    cycle: BillingCycle.monthly,
    nextBillingDate: DateTime.utc(2026, 9, 3),
    category: SubscriptionCategory.entertainment,
  );
  final adobe = _item(
    id: 'adobe',
    name: 'Adobe',
    amount: 59.99,
    cycle: BillingCycle.monthly,
    nextBillingDate: DateTime.utc(2026, 9, 7),
    category: SubscriptionCategory.productivity,
  );
  final spotify = _item(
    id: 'spotify',
    name: 'Spotify',
    merchant: 'Spotify AB',
    amount: 120,
    cycle: BillingCycle.yearly,
    nextBillingDate: DateTime.utc(2026, 9, 21),
    category: SubscriptionCategory.entertainment,
  );

  test('monthly equivalent is deterministic', () {
    expect(
      SubscriptionCost.forCycle(amount: 22.99, cycle: BillingCycle.monthly),
      22.99,
    );
    expect(
      SubscriptionCost.forCycle(amount: 120, cycle: BillingCycle.yearly),
      10,
    );
    expect(
      SubscriptionCost.forCycle(amount: 30, cycle: BillingCycle.quarterly),
      10,
    );
    expect(
      SubscriptionCost.forCycle(amount: 5, cycle: BillingCycle.weekly),
      closeTo(5 * 52 / 12, 0.0001),
    );
  });

  test('annual equivalent is monthly times 12', () {
    expect(
      SubscriptionCost.annualEquivalent(netflix),
      closeTo(22.99 * 12, 0.0001),
    );
    expect(SubscriptionCost.annualEquivalent(spotify), 120);
    expect(
      SubscriptionCost.annualEquivalent(
        _item(
          id: 'weekly',
          name: 'Gym',
          amount: 5,
          cycle: BillingCycle.weekly,
          nextBillingDate: DateTime.utc(2026, 9, 1),
          category: SubscriptionCategory.fitness,
        ),
      ),
      closeTo(5 * 52, 0.0001),
    );
  });

  test('search matches name or merchant', () {
    final byMerchant = SubscriptionListFilter.apply([
      netflix,
      adobe,
      spotify,
    ], const SubscriptionListQuery(search: 'spotify'));
    expect(byMerchant.map((item) => item.id), ['spotify']);

    final byPartialName = SubscriptionListFilter.apply([
      netflix,
      adobe,
      spotify,
    ], const SubscriptionListQuery(search: 'ado'));
    expect(byPartialName.map((item) => item.id), ['adobe']);
  });

  test('category filter keeps matching subscriptions', () {
    final result = SubscriptionListFilter.apply(
      [netflix, adobe, spotify],
      const SubscriptionListQuery(category: BrandCategory.entertainment),
    );

    expect(result.map((item) => item.id), ['netflix']);
  });

  test('sorts by next billing date then monthly cost', () {
    final byDate = SubscriptionListFilter.apply([
      adobe,
      spotify,
      netflix,
    ], const SubscriptionListQuery());
    expect(byDate.map((item) => item.id), ['netflix', 'adobe', 'spotify']);

    final byCost = SubscriptionListFilter.apply([
      adobe,
      spotify,
      netflix,
    ], const SubscriptionListQuery(sort: SubscriptionSort.highestCost));
    expect(byCost.map((item) => item.id), ['adobe', 'netflix', 'spotify']);
  });

  test('hides inactive subscriptions until asked', () {
    final paused = netflix.copyWith(status: SubscriptionStatus.paused);
    final hidden = SubscriptionListFilter.apply([
      paused,
      adobe,
    ], const SubscriptionListQuery());
    expect(hidden.map((item) => item.id), ['adobe']);

    final shown = SubscriptionListFilter.apply([
      paused,
      adobe,
    ], const SubscriptionListQuery(showInactive: true));
    expect(shown.map((item) => item.id), ['netflix', 'adobe']);
  });

  test('brand registry category wins over stored software', () {
    final misfiled = netflix.copyWith(category: SubscriptionCategory.software);
    expect(
      SubscriptionListFilter.categoryCounts([misfiled])['entertainment'],
      1,
    );
    expect(SubscriptionListFilter.categoryCounts([misfiled])['other'], isNull);
  });
}
