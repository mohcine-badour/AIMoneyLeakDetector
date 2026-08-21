import '../../../core/utils/money_format.dart';
import '../../savings/domain/leak_engine.dart';
import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/domain/subscription_cost.dart';
import 'subscription_candidate.dart';

class SubscribeImpact {
  const SubscribeImpact({
    required this.candidate,
    required this.monthlyAmount,
    required this.currentCategoryMonthly,
    required this.afterCategoryMonthly,
    required this.annualImpact,
    required this.currencyCode,
    required this.existingInCategory,
    required this.existingSameMerchant,
  });

  final SubscriptionCandidate candidate;
  final double monthlyAmount;
  final double currentCategoryMonthly;
  final double afterCategoryMonthly;
  final double annualImpact;
  final String currencyCode;
  final int existingInCategory;
  final int existingSameMerchant;

  bool get wouldOverlap => existingInCategory >= 1;

  bool get wouldDuplicate => existingSameMerchant >= 1;

  bool get isExpensive =>
      monthlyAmount >= LeakEngine.expensiveMonthlyThreshold;

  @override
  bool operator ==(Object other) {
    return other is SubscribeImpact &&
        other.candidate == candidate &&
        other.monthlyAmount == monthlyAmount &&
        other.currentCategoryMonthly == currentCategoryMonthly &&
        other.afterCategoryMonthly == afterCategoryMonthly &&
        other.annualImpact == annualImpact &&
        other.currencyCode == currencyCode &&
        other.existingInCategory == existingInCategory &&
        other.existingSameMerchant == existingSameMerchant;
  }

  @override
  int get hashCode => Object.hash(
        candidate,
        monthlyAmount,
        currentCategoryMonthly,
        afterCategoryMonthly,
        annualImpact,
        currencyCode,
        existingInCategory,
        existingSameMerchant,
      );
}

/// Deterministic add-impact math. Do not use AI for this.
abstract final class SubscribeImpactCalculator {
  static SubscribeImpact from({
    required List<Subscription> subscriptions,
    required SubscriptionCandidate candidate,
  }) {
    final monthly = SubscriptionCost.forCycle(
      amount: candidate.amount,
      cycle: candidate.billingCycle,
    );
    final merchantKey = candidate.merchant.trim().toLowerCase();
    var categoryCurrent = 0.0;
    var inCategory = 0;
    var sameMerchant = 0;
    final currencies = <String>{candidate.currency};

    for (final item in subscriptions) {
      if (item.status != SubscriptionStatus.active) {
        continue;
      }
      if (item.category == candidate.category) {
        categoryCurrent += SubscriptionCost.monthlyEquivalent(item);
        inCategory += 1;
        currencies.add(item.currency);
      }
      if (item.merchant.trim().toLowerCase() == merchantKey) {
        sameMerchant += 1;
      }
    }

    return SubscribeImpact(
      candidate: candidate,
      monthlyAmount: monthly,
      currentCategoryMonthly: categoryCurrent,
      afterCategoryMonthly: categoryCurrent + monthly,
      annualImpact: monthly * 12,
      currencyCode: currencies.length == 1
          ? currencies.first
          : MoneyFormat.defaultCurrencyCode,
      existingInCategory: inCategory,
      existingSameMerchant: sameMerchant,
    );
  }
}
