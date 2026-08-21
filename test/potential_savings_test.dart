import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/features/savings/domain/potential_savings.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';

Subscription _sub({
  required String id,
  required String name,
  required double amount,
  required SubscriptionCategory category,
  String? merchant,
  SubscriptionStatus status = SubscriptionStatus.active,
}) {
  return Subscription.create(
    id: id,
    name: name,
    merchant: merchant ?? name,
    amount: amount,
    billingCycle: BillingCycle.monthly,
    nextBillingDate: DateTime.utc(2026, 9, 21),
    category: category,
    status: status,
  );
}

void main() {
  test('overlapping extras keep the highest item in the category', () {
    final savings = PotentialSavingsCalculator.fromSubscriptions([
      _sub(
        id: 'netflix',
        name: 'Netflix',
        amount: 22.99,
        category: SubscriptionCategory.entertainment,
      ),
      _sub(
        id: 'hulu',
        name: 'Hulu',
        amount: 17.99,
        category: SubscriptionCategory.entertainment,
      ),
      _sub(
        id: 'adobe',
        name: 'Adobe',
        amount: 59.99,
        category: SubscriptionCategory.productivity,
      ),
    ]);

    expect(savings, closeTo(17.99, 0.0001));
  });

  test('duplicate merchants are not also counted as category overlap', () {
    final savings = PotentialSavingsCalculator.fromSubscriptions([
      _sub(
        id: 'a',
        name: 'Netflix',
        merchant: 'Netflix',
        amount: 22.99,
        category: SubscriptionCategory.entertainment,
      ),
      _sub(
        id: 'b',
        name: 'Netflix Extra',
        merchant: 'Netflix',
        amount: 6.99,
        category: SubscriptionCategory.entertainment,
      ),
    ]);

    expect(savings, closeTo(6.99, 0.0001));
  });

  test('cancelled subscriptions are ignored', () {
    final savings = PotentialSavingsCalculator.fromSubscriptions([
      _sub(
        id: 'netflix',
        name: 'Netflix',
        amount: 22.99,
        category: SubscriptionCategory.entertainment,
      ),
      _sub(
        id: 'hulu',
        name: 'Hulu',
        amount: 17.99,
        category: SubscriptionCategory.entertainment,
        status: SubscriptionStatus.cancelled,
      ),
    ]);

    expect(savings, 0);
  });
}
