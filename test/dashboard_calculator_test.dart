import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/core/utils/app_date_format.dart';
import 'package:billkiller_ai/features/dashboard/domain/dashboard_snapshot.dart';
import 'package:billkiller_ai/features/dashboard/domain/day_period.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';

Subscription _item({
  required String id,
  required String name,
  required double amount,
  required DateTime nextBillingDate,
  required SubscriptionCategory category,
  BillingCycle cycle = BillingCycle.monthly,
  SubscriptionStatus status = SubscriptionStatus.active,
}) {
  return Subscription.create(
    id: id,
    name: name,
    merchant: name,
    amount: amount,
    billingCycle: cycle,
    nextBillingDate: nextBillingDate,
    category: category,
    status: status,
  );
}

void main() {
  final netflix = _item(
    id: 'netflix',
    name: 'Netflix',
    amount: 22.99,
    nextBillingDate: DateTime.utc(2026, 9, 3),
    category: SubscriptionCategory.entertainment,
  );
  final adobe = _item(
    id: 'adobe',
    name: 'Adobe',
    amount: 59.99,
    nextBillingDate: DateTime.utc(2026, 9, 7),
    category: SubscriptionCategory.productivity,
  );
  final spotify = _item(
    id: 'spotify',
    name: 'Spotify',
    amount: 120,
    cycle: BillingCycle.yearly,
    nextBillingDate: DateTime.utc(2026, 9, 21),
    category: SubscriptionCategory.entertainment,
  );
  final cancelled = _item(
    id: 'hulu',
    name: 'Hulu',
    amount: 17.99,
    nextBillingDate: DateTime.utc(2026, 9, 1),
    category: SubscriptionCategory.entertainment,
    status: SubscriptionStatus.cancelled,
  );

  test('greeting period follows the hour of day', () {
    expect(
      GreetingPeriodResolver.from(DateTime(2026, 8, 21, 8)),
      GreetingPeriod.morning,
    );
    expect(
      GreetingPeriodResolver.from(DateTime(2026, 8, 21, 14)),
      GreetingPeriod.afternoon,
    );
    expect(
      GreetingPeriodResolver.from(DateTime(2026, 8, 21, 20)),
      GreetingPeriod.evening,
    );
  });

  test('totals include only active subscriptions', () {
    final snapshot = DashboardCalculator.fromSubscriptions([
      netflix,
      adobe,
      spotify,
      cancelled,
    ]);

    expect(snapshot.monthlyTotal, closeTo(22.99 + 59.99 + 10, 0.0001));
    expect(snapshot.annualTotal, closeTo(snapshot.monthlyTotal * 12, 0.0001));
    expect(snapshot.activeCount, 3);
    expect(snapshot.upcoming.map((item) => item.subscriptionId), [
      'netflix',
      'adobe',
      'spotify',
    ]);
  });

  test('category breakdown sorts by monthly spend', () {
    final snapshot = DashboardCalculator.fromSubscriptions([
      netflix,
      adobe,
      spotify,
    ]);

    expect(snapshot.categories, hasLength(2));
    expect(
      snapshot.categories.first.category,
      SubscriptionCategory.productivity,
    );
    expect(snapshot.categories.first.monthlyAmount, closeTo(59.99, 0.0001));
    expect(
      snapshot.categories.last.category,
      SubscriptionCategory.entertainment,
    );
    expect(snapshot.categories.last.monthlyAmount, closeTo(32.99, 0.0001));
  });

  test('upcoming list is capped at three soonest payments', () {
    final extra = _item(
      id: 'icloud',
      name: 'iCloud',
      amount: 2.99,
      nextBillingDate: DateTime.utc(2026, 10, 1),
      category: SubscriptionCategory.cloudStorage,
    );
    final snapshot = DashboardCalculator.fromSubscriptions([
      extra,
      adobe,
      spotify,
      netflix,
    ]);

    expect(snapshot.upcoming.map((item) => item.subscriptionId), [
      'netflix',
      'adobe',
      'spotify',
    ]);
  });

  test('upcoming labels use today, tomorrow, then month-day', () {
    final now = DateTime(2026, 8, 21, 20);
    expect(AppDateFormat.upcomingLabel(DateTime(2026, 8, 21), now), 'Today');
    expect(AppDateFormat.upcomingLabel(DateTime(2026, 8, 22), now), 'Tomorrow');
    expect(AppDateFormat.upcomingLabel(DateTime(2026, 9, 3), now), 'Sep 03');
  });
}
