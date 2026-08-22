import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/features/before_subscribe/data/local_subscribe_advice_backend.dart';
import 'package:kichta/features/before_subscribe/data/validated_subscribe_advisor.dart';
import 'package:kichta/features/before_subscribe/domain/subscribe_advice_exception.dart';
import 'package:kichta/features/before_subscribe/domain/subscribe_advice_validator.dart';
import 'package:kichta/features/before_subscribe/domain/subscribe_impact.dart';
import 'package:kichta/features/before_subscribe/domain/subscription_candidate.dart';
import 'package:kichta/features/subscriptions/domain/subscription.dart';

Subscription _sub({
  required String id,
  required String name,
  required double amount,
  required SubscriptionCategory category,
}) {
  return Subscription.create(
    id: id,
    name: name,
    merchant: name,
    amount: amount,
    billingCycle: BillingCycle.monthly,
    nextBillingDate: DateTime.utc(2026, 9, 21),
    category: category,
  );
}

SubscriptionCandidate _candidate({
  String name = 'YouTube Premium',
  double amount = 13.99,
  SubscriptionCategory category = SubscriptionCategory.entertainment,
}) {
  return SubscriptionCandidate(
    name: name,
    merchant: name,
    amount: amount,
    currency: 'USD',
    billingCycle: BillingCycle.monthly,
    nextBillingDate: DateTime.utc(2026, 9, 1),
    category: category,
  );
}

void main() {
  test('category spend and annual impact stay in Dart', () {
    final impact = SubscribeImpactCalculator.from(
      subscriptions: [
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
      ],
      candidate: _candidate(),
    );

    expect(impact.monthlyAmount, closeTo(13.99, 0.0001));
    expect(impact.currentCategoryMonthly, closeTo(40.98, 0.0001));
    expect(impact.afterCategoryMonthly, closeTo(54.97, 0.0001));
    expect(impact.annualImpact, closeTo(167.88, 0.0001));
    expect(impact.wouldOverlap, isTrue);
    expect(impact.wouldDuplicate, isFalse);
    expect(impact.isExpensive, isFalse);
  });

  test(
    'local advice explains overlap without changing money figures',
    () async {
      final impact = SubscribeImpactCalculator.from(
        subscriptions: [
          _sub(
            id: 'netflix',
            name: 'Netflix',
            amount: 22.99,
            category: SubscriptionCategory.entertainment,
          ),
        ],
        candidate: _candidate(),
      );
      final advice = await const ValidatedSubscribeAdvisor(
        LocalSubscribeAdviceBackend(),
      ).advise(impact);

      expect(
        advice.impact.monthlyAmount,
        closeTo(impact.monthlyAmount, 0.0001),
      );
      expect(
        advice.recommendation,
        contains('You already spend \$22.99/month on Entertainment'),
      );
    },
  );

  test('validator rejects advice that would mutate financial data', () {
    final impact = SubscribeImpactCalculator.from(
      subscriptions: const [],
      candidate: _candidate(),
    );
    expect(
      () => SubscribeAdviceValidator.parse(
        json: {
          'monthly_amount': impact.monthlyAmount,
          'current_category_spend': impact.currentCategoryMonthly,
          'after_category_spend': impact.afterCategoryMonthly,
          'annual_impact': impact.annualImpact,
          'currency': impact.currencyCode,
          'mutates_data': true,
          'recommendation': AppStrings.beforeSubscribeClear(
            monthly: r'$13.99',
            annual: r'$167.88',
            category: 'Entertainment',
          ),
        },
        impact: impact,
      ),
      throwsA(isA<SubscribeAdviceException>()),
    );
  });
}
