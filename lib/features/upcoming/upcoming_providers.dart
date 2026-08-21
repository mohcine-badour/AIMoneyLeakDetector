import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../subscriptions/subscriptions_providers.dart';
import 'domain/payment_reminder_scheduler.dart';
import 'domain/upcoming_payment.dart';
import 'domain/upcoming_payments.dart';

final paymentReminderSchedulerProvider = Provider<PaymentReminderScheduler>((
  ref,
) {
  return const NoOpPaymentReminderScheduler();
});

final upcomingPaymentsProvider = Provider<AsyncValue<List<UpcomingPayment>>>((
  ref,
) {
  return ref.watch(subscriptionsProvider).whenData((items) {
    return UpcomingPayments.fromSubscriptions(items);
  });
});

final upcomingReminderSyncProvider = Provider<void>((ref) {
  ref.listen(upcomingPaymentsProvider, (previous, next) {
    next.whenData(
      (payments) =>
          ref.read(paymentReminderSchedulerProvider).syncUpcoming(payments),
    );
  }, fireImmediately: true);
});
