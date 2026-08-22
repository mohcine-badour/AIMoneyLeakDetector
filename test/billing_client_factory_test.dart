import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/features/paywall/data/billing_client_factory.dart';
import 'package:kichta/features/paywall/data/revenuecat_billing_client.dart';
import 'package:kichta/features/paywall/data/storekit_billing_client.dart';
import 'package:kichta/features/paywall/data/unconfigured_billing_client.dart';
import 'package:kichta/features/paywall/domain/entitlement.dart';
import 'package:kichta/features/paywall/domain/entitlement_mapper.dart';
import 'package:kichta/features/paywall/domain/monetization_config.dart';
import 'package:kichta/features/paywall/domain/paywall_plan.dart';
import 'package:kichta/features/paywall/domain/storekit_entitlement.dart';

void main() {
  test('skips RevenueCat until a public SDK key is configured', () {
    final client = BillingClientFactory.create(
      const MonetizationConfig(),
      platform: TargetPlatform.android,
    );
    expect(client, isA<UnconfiguredBillingClient>());
  });

  test('uses StoreKit on iOS when RevenueCat is not configured', () {
    final client = BillingClientFactory.create(
      const MonetizationConfig(),
      platform: TargetPlatform.iOS,
    );
    expect(client, isA<StoreKitBillingClient>());
  });

  test('uses RevenueCat when a public Apple SDK key is present', () {
    final client = BillingClientFactory.create(
      const MonetizationConfig(revenueCatAppleApiKey: 'appl_public_test_key'),
    );
    expect(client, isA<RevenueCatBillingClient>());
  });

  test('StoreKit product IDs map to Pro without a local isPro flag', () {
    const config = MonetizationConfig();
    final snapshot = StoreKitEntitlement.snapshotFromProductIds(
      productIds: {config.yearlyProductId},
      config: config,
    );
    final entitlement = EntitlementMapper.fromSnapshot(
      snapshot: snapshot,
      config: config,
    );
    expect(entitlement.isPro, isTrue);
    expect(entitlement.plan, PaywallPlan.yearly);
    expect(entitlement.period, EntitlementPeriod.active);
  });

  test('unknown StoreKit product IDs stay free', () {
    const config = MonetizationConfig();
    final snapshot = StoreKitEntitlement.snapshotFromProductIds(
      productIds: {'something_else'},
      config: config,
    );
    expect(snapshot.hasEntitlementRecord, isFalse);
    expect(
      EntitlementMapper.fromSnapshot(snapshot: snapshot, config: config).isPro,
      isFalse,
    );
  });
}
