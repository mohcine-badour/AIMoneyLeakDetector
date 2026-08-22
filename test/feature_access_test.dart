import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/features/paywall/domain/entitlement.dart';
import 'package:kichta/features/paywall/domain/feature_access.dart';
import 'package:kichta/features/paywall/domain/monetization_config.dart';

void main() {
  const config = MonetizationConfig(
    freeSubscriptionLimit: 2,
    freeTrialLimit: 1,
  );

  test('free users can add subscriptions under the configured limit', () {
    final access = FeatureAccess(
      entitlement: Entitlement.free,
      config: config,
      subscriptionCount: 1,
      trialCount: 0,
    );

    expect(access.canAddSubscription, isTrue);
    expect(access.canAddTrial, isTrue);
    expect(access.canUseScanner, isFalse);
    expect(access.canUseAiAnalysis, isFalse);
  });

  test('free users are gated at the configured subscription limit', () {
    final access = FeatureAccess(
      entitlement: Entitlement.free,
      config: config,
      subscriptionCount: 2,
      trialCount: 1,
    );

    expect(access.canAddSubscription, isFalse);
    expect(access.canAddTrial, isFalse);
  });

  test('pro users are not limited', () {
    final access = FeatureAccess(
      entitlement: Entitlement.pro,
      config: config,
      subscriptionCount: 40,
      trialCount: 12,
    );

    expect(access.canAddSubscription, isTrue);
    expect(access.canAddTrial, isTrue);
    expect(access.canUseScanner, isTrue);
    expect(access.canUseAiAnalysis, isTrue);
  });

  test('prices and product IDs live in config, not widgets', () {
    expect(MonetizationConfig.defaults.monthlyPrice, 5.99);
    expect(MonetizationConfig.defaults.yearlyPrice, 39.99);
    expect(MonetizationConfig.defaults.monthlyPriceLabel, r'$5.99/month');
    expect(MonetizationConfig.defaults.yearlyPriceLabel, r'$39.99/year');
    expect(
      MonetizationConfig.defaults.monthlyProductId,
      'billkiller_pro_monthly',
    );
    expect(
      MonetizationConfig.defaults.yearlyProductId,
      'billkiller_pro_yearly',
    );
    expect(MonetizationConfig.defaults.proEntitlementId, 'pro');
  });
}
