import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/core/utils/money_format.dart';
import 'package:billkiller_ai/features/subscriptions/domain/cost_per_use.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription_usage.dart';

void main() {
  final netflix = Subscription.create(
    id: 'netflix',
    name: 'Netflix',
    merchant: 'Netflix',
    amount: 22.99,
    billingCycle: BillingCycle.monthly,
    nextBillingDate: DateTime.utc(2026, 9, 21),
    category: SubscriptionCategory.entertainment,
  );

  test('cost per use is monthly equivalent divided by uses', () {
    final snapshot = CostPerUse.from(
      subscription: netflix,
      usage: SubscriptionUsage.create(subscriptionId: 'netflix', useCount: 8),
    );

    expect(snapshot.monthlyAmount, closeTo(22.99, 0.0001));
    expect(snapshot.uses, 8);
    expect(snapshot.costPerUse, closeTo(22.99 / 8, 0.0001));
    expect(MoneyFormat.format(snapshot.costPerUse!), r'$2.87');
  });

  test('cost per use is missing when uses are not recorded or zero', () {
    expect(CostPerUse.from(subscription: netflix).costPerUse, isNull);
    expect(
      CostPerUse.from(
        subscription: netflix,
        usage: SubscriptionUsage.create(subscriptionId: 'netflix', useCount: 0),
      ).costPerUse,
      isNull,
    );
  });

  test('yearly subscriptions use the monthly equivalent', () {
    final snapshot = CostPerUse.fromMonthly(monthlyAmount: 10, uses: 5);

    expect(snapshot.costPerUse, closeTo(2, 0.0001));
  });
}
