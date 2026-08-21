import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';
import 'package:billkiller_ai/features/upcoming/domain/upcoming_payments.dart';
import 'package:billkiller_ai/features/upcoming/domain/payment_reminder_scheduler.dart';

Subscription _item({
  required String id,
  required String name,
  required double amount,
  required DateTime nextBillingDate,
  SubscriptionStatus status = SubscriptionStatus.active,
}) {
  return Subscription.create(
    id: id,
    name: name,
    merchant: name,
    amount: amount,
    billingCycle: BillingCycle.monthly,
    nextBillingDate: nextBillingDate,
    category: SubscriptionCategory.entertainment,
    status: status,
  );
}

void main() {
  final netflix = _item(
    id: 'netflix',
    name: 'Netflix',
    amount: 22.99,
    nextBillingDate: DateTime.utc(2026, 9, 3),
  );
  final adobe = _item(
    id: 'adobe',
    name: 'Adobe',
    amount: 59.99,
    nextBillingDate: DateTime.utc(2026, 9, 7),
  );
  final spotify = _item(
    id: 'spotify',
    name: 'Spotify',
    amount: 11.99,
    nextBillingDate: DateTime.utc(2026, 9, 21),
  );
  final cancelled = _item(
    id: 'hulu',
    name: 'Hulu',
    amount: 17.99,
    nextBillingDate: DateTime.utc(2026, 9, 1),
    status: SubscriptionStatus.cancelled,
  );

  test('sorts active payments by billing date and skips cancelled', () {
    final result = UpcomingPayments.fromSubscriptions([
      spotify,
      cancelled,
      adobe,
      netflix,
    ]);

    expect(result.map((item) => item.subscriptionId), [
      'netflix',
      'adobe',
      'spotify',
    ]);
  });

  test('can cap the list for dashboard previews', () {
    final result = UpcomingPayments.fromSubscriptions(
      [spotify, adobe, netflix],
      limit: 2,
    );

    expect(result.map((item) => item.subscriptionId), ['netflix', 'adobe']);
  });

  test('reminder offsets cover 3 days, 24 hours, and 2 hours', () {
    expect(PaymentReminderOffsets.beforeCharge, [
      PaymentReminderOffsets.threeDays,
      PaymentReminderOffsets.twentyFourHours,
      PaymentReminderOffsets.twoHours,
    ]);
  });
}
