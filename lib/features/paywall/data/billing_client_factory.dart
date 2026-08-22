import 'package:flutter/foundation.dart';

import '../domain/billing_client.dart';
import '../domain/monetization_config.dart';
import 'revenuecat_billing_client.dart';
import 'storekit_billing_client.dart';
import 'unconfigured_billing_client.dart';

/// Chooses RevenueCat when a public SDK key is present.
///
/// On iOS without that key, StoreKit still runs (simulator StoreKit config or
/// App Store products). Direct StoreKit trusts Apple's purchase stream on
/// device. RevenueCat adds server-side receipt validation when configured.
abstract final class BillingClientFactory {
  static BillingClient create(
    MonetizationConfig config, {
    TargetPlatform? platform,
    bool isWeb = kIsWeb,
  }) {
    if (config.isStoreBillingConfigured) {
      return RevenueCatBillingClient(config: config);
    }
    if (!isWeb && (platform ?? defaultTargetPlatform) == TargetPlatform.iOS) {
      return StoreKitBillingClient(config: config);
    }
    return const UnconfiguredBillingClient();
  }
}
