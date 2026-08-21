import '../../../core/utils/id_generator.dart';
import '../../../core/utils/money_format.dart';

enum BillingCycle { weekly, monthly, quarterly, yearly, custom }

enum SubscriptionCategory {
  entertainment,
  productivity,
  cloudStorage,
  fitness,
  education,
  software,
  news,
  gaming,
  finance,
  other,
}

enum SubscriptionStatus { active, paused, cancelled }

enum SubscriptionSource { manual, scan, import }

class Subscription {
  const Subscription({
    required this.id,
    required this.name,
    required this.merchant,
    required this.amount,
    required this.currency,
    required this.billingCycle,
    required this.nextBillingDate,
    required this.category,
    required this.status,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subscription.create({
    required String name,
    required String merchant,
    required double amount,
    required BillingCycle billingCycle,
    required DateTime nextBillingDate,
    required SubscriptionCategory category,
    String? id,
    String currency = MoneyFormat.defaultCurrencyCode,
    SubscriptionStatus status = SubscriptionStatus.active,
    SubscriptionSource source = SubscriptionSource.manual,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final now = DateTime.now().toUtc();
    return Subscription(
      id: id ?? IdGenerator.next(),
      name: name,
      merchant: merchant,
      amount: amount,
      currency: currency,
      billingCycle: billingCycle,
      nextBillingDate: nextBillingDate,
      category: category,
      status: status,
      source: source,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
    );
  }

  final String id;
  final String name;
  final String merchant;
  final double amount;
  final String currency;
  final BillingCycle billingCycle;
  final DateTime nextBillingDate;
  final SubscriptionCategory category;
  final SubscriptionStatus status;
  final SubscriptionSource source;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subscription copyWith({
    String? name,
    String? merchant,
    double? amount,
    String? currency,
    BillingCycle? billingCycle,
    DateTime? nextBillingDate,
    SubscriptionCategory? category,
    SubscriptionStatus? status,
    SubscriptionSource? source,
    DateTime? updatedAt,
  }) {
    return Subscription(
      id: id,
      name: name ?? this.name,
      merchant: merchant ?? this.merchant,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      category: category ?? this.category,
      status: status ?? this.status,
      source: source ?? this.source,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
