import '../domain/billing_client.dart';
import '../domain/monetization_config.dart';
import 'revenuecat_billing_client.dart';
import 'unconfigured_billing_client.dart';

/// Chooses RevenueCat when a public SDK key is present.
///
/// Direct StoreKit would require a custom receipt-validation backend. RevenueCat
/// validates with Apple and tracks restore, expiration, cancellation, grace
/// period, and introductory offers.
abstract final class BillingClientFactory {
  static BillingClient create(MonetizationConfig config) {
    if (config.isStoreBillingConfigured) {
      return RevenueCatBillingClient(config: config);
    }
    return const UnconfiguredBillingClient();
  }
}
