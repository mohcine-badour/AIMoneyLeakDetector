import 'subscription.dart';

/// Deterministic cost conversions. Do not use AI for this.
///
/// Custom cycles are treated as monthly.
abstract final class SubscriptionCost {
  static double monthlyEquivalent(Subscription subscription) {
    return forCycle(
      amount: subscription.amount,
      cycle: subscription.billingCycle,
    );
  }

  static double annualEquivalent(Subscription subscription) {
    return monthlyEquivalent(subscription) * 12;
  }

  static double forCycle({
    required double amount,
    required BillingCycle cycle,
  }) {
    return switch (cycle) {
      BillingCycle.weekly => amount * 52 / 12,
      BillingCycle.monthly => amount,
      BillingCycle.quarterly => amount / 3,
      BillingCycle.yearly => amount / 12,
      BillingCycle.custom => amount,
    };
  }
}
