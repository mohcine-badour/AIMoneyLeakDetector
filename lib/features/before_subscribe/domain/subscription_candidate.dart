import '../../subscriptions/domain/subscription.dart';

class SubscriptionCandidate {
  const SubscriptionCandidate({
    required this.name,
    required this.merchant,
    required this.amount,
    required this.currency,
    required this.billingCycle,
    required this.nextBillingDate,
    required this.category,
    this.source = SubscriptionSource.manual,
  });

  final String name;
  final String merchant;
  final double amount;
  final String currency;
  final BillingCycle billingCycle;
  final DateTime nextBillingDate;
  final SubscriptionCategory category;
  final SubscriptionSource source;

  Subscription toSubscription() {
    return Subscription.create(
      name: name,
      merchant: merchant,
      amount: amount,
      currency: currency,
      billingCycle: billingCycle,
      nextBillingDate: nextBillingDate,
      category: category,
      source: source,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SubscriptionCandidate &&
        other.name == name &&
        other.merchant == merchant &&
        other.amount == amount &&
        other.currency == currency &&
        other.billingCycle == billingCycle &&
        other.nextBillingDate == nextBillingDate &&
        other.category == category &&
        other.source == source;
  }

  @override
  int get hashCode => Object.hash(
    name,
    merchant,
    amount,
    currency,
    billingCycle,
    nextBillingDate,
    category,
    source,
  );
}
