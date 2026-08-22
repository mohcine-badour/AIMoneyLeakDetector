import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/features/dashboard/domain/home_insight.dart';
import 'package:billkiller_ai/features/dashboard/domain/spending_summary.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';

Subscription _item({
  required String id,
  required String name,
  required double amount,
  required DateTime nextBillingDate,
  required SubscriptionCategory category,
}) {
  return Subscription.create(
    id: id,
    name: name,
    merchant: name,
    amount: amount,
    billingCycle: BillingCycle.monthly,
    nextBillingDate: nextBillingDate,
    category: category,
  );
}

void main() {
  final now = DateTime.utc(2026, 8, 21, 20);
  final netflix = _item(
    id: 'netflix',
    name: 'Netflix',
    amount: 22.99,
    nextBillingDate: DateTime.utc(2026, 8, 22),
    category: SubscriptionCategory.entertainment,
  );
  final adobe = _item(
    id: 'adobe',
    name: 'Adobe',
    amount: 59.99,
    nextBillingDate: DateTime.utc(2026, 9, 7),
    category: SubscriptionCategory.productivity,
  );
  final hulu = _item(
    id: 'hulu',
    name: 'Hulu',
    amount: 17.99,
    nextBillingDate: DateTime.utc(2026, 9, 10),
    category: SubscriptionCategory.entertainment,
  );

  test('returns null when there is no unused, hike, or overlap signal', () {
    expect(
      HomeInsightResolver.fromSubscriptions([netflix, adobe], now: now),
      isNull,
    );
  });

  test('unused wins over overlap when last opened is older than 30 days', () {
    final insight = HomeInsightResolver.fromSubscriptions(
      [netflix, hulu],
      now: now,
      lastOpenedById: {netflix.id: now.subtract(const Duration(days: 42))},
    );

    expect(insight, isA<UnusedInsight>());
    final unused = insight! as UnusedInsight;
    expect(unused.subscription.id, netflix.id);
    expect(unused.daysUnused, 42);
    expect(unused.monthlySavings, 22.99);
  });

  test('overlap uses the cheapest monthly amount as potential savings', () {
    final insight = HomeInsightResolver.fromSubscriptions(
      [netflix, hulu],
      now: now,
    );

    expect(insight, isA<OverlapInsight>());
    final overlap = insight! as OverlapInsight;
    expect(overlap.subscriptions.length, 2);
    expect(overlap.potentialSavings, 17.99);
  });

  test('renewal window splits the next 7 days from the rest', () {
    final split = RenewalWindow.split([netflix, adobe], now);
    expect(split.soon.map((item) => item.id), ['netflix']);
    expect(split.remaining.map((item) => item.id), ['adobe']);
  });
}
