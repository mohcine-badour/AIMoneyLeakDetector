import '../../subscriptions/domain/subscription.dart';
import 'upcoming_payment.dart';

/// Sorted upcoming charges. Do not use AI for this.
abstract final class UpcomingPayments {
  static List<UpcomingPayment> fromSubscriptions(
    List<Subscription> subscriptions, {
    int? limit,
  }) {
    final items = [
      for (final subscription in subscriptions)
        if (subscription.status == SubscriptionStatus.active)
          UpcomingPayment(
            subscriptionId: subscription.id,
            name: subscription.name,
            amount: subscription.amount,
            currencyCode: subscription.currency,
            billingDate: subscription.nextBillingDate,
          ),
    ]..sort((left, right) => left.billingDate.compareTo(right.billingDate));

    if (limit == null) {
      return items;
    }
    return items.take(limit).toList();
  }
}
