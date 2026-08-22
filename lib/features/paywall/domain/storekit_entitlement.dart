import 'billing_snapshot.dart';
import 'monetization_config.dart';
import 'paywall_plan.dart';

/// Maps StoreKit product IDs into a billing snapshot. Do not persist isPro.
abstract final class StoreKitEntitlement {
  static BillingSnapshot snapshotFromProductIds({
    required Iterable<String> productIds,
    required MonetizationConfig config,
  }) {
    String? yearly;
    String? monthly;
    for (final id in productIds) {
      switch (config.planForProductId(id)) {
        case PaywallPlan.yearly:
          yearly = id;
        case PaywallPlan.monthly:
          monthly = id;
        case null:
          break;
      }
    }
    final productId = yearly ?? monthly;
    if (productId == null) {
      return const BillingSnapshot();
    }
    return BillingSnapshot(
      hasEntitlementRecord: true,
      isActive: true,
      willRenew: true,
      productId: productId,
    );
  }
}
