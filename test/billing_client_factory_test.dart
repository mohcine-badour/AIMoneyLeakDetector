import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/features/paywall/data/billing_client_factory.dart';
import 'package:kichta/features/paywall/data/revenuecat_billing_client.dart';
import 'package:kichta/features/paywall/data/unconfigured_billing_client.dart';
import 'package:kichta/features/paywall/domain/monetization_config.dart';

void main() {
  test('skips RevenueCat until a public SDK key is configured', () {
    final client = BillingClientFactory.create(const MonetizationConfig());
    expect(client, isA<UnconfiguredBillingClient>());
  });

  test('uses RevenueCat when a public Apple SDK key is present', () {
    final client = BillingClientFactory.create(
      const MonetizationConfig(revenueCatAppleApiKey: 'appl_public_test_key'),
    );
    expect(client, isA<RevenueCatBillingClient>());
  });
}
