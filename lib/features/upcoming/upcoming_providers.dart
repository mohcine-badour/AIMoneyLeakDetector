import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../subscriptions/subscriptions_providers.dart';
import 'domain/upcoming_payment.dart';
import 'domain/upcoming_payments.dart';

final upcomingPaymentsProvider = Provider<AsyncValue<List<UpcomingPayment>>>((
  ref,
) {
  return ref.watch(subscriptionsProvider).whenData((items) {
    return UpcomingPayments.fromSubscriptions(items);
  });
});
