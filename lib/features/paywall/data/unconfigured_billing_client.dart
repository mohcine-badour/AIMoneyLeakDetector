import '../../../core/constants/app_strings.dart';
import '../domain/billing_client.dart';
import '../domain/billing_exception.dart';
import '../domain/entitlement.dart';
import '../domain/paywall_plan.dart';

/// Used when no RevenueCat public SDK key is configured.
///
/// Never grants Pro. The client is not allowed to invent entitlement.
class UnconfiguredBillingClient implements BillingClient {
  const UnconfiguredBillingClient();

  @override
  Entitlement get current => Entitlement.free;

  @override
  Stream<Entitlement> entitlements() =>
      Stream<Entitlement>.value(Entitlement.free);

  @override
  Future<void> initialize() async {}

  @override
  Future<void> purchase(PaywallPlan plan) async {
    throw const BillingException(AppStrings.billingNotConfigured);
  }

  @override
  Future<void> restore() async {
    throw const BillingException(AppStrings.billingNotConfigured);
  }

  @override
  Future<void> refresh() async {}
}
