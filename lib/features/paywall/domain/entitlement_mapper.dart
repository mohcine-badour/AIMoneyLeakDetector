import 'billing_snapshot.dart';
import 'entitlement.dart';
import 'monetization_config.dart';

/// Maps store-validated snapshots into app entitlement. Do not use AI for this.
abstract final class EntitlementMapper {
  static Entitlement fromSnapshot({
    required BillingSnapshot snapshot,
    required MonetizationConfig config,
  }) {
    if (!snapshot.hasEntitlementRecord) {
      return Entitlement.free;
    }

    final plan = config.planForProductId(snapshot.productId);
    if (snapshot.isActive && snapshot.hasBillingIssue) {
      return Entitlement(
        period: EntitlementPeriod.gracePeriod,
        willRenew: snapshot.willRenew,
        isIntroductory: snapshot.isIntroductory,
        expiresAt: snapshot.expiresAt,
        plan: plan,
      );
    }
    if (snapshot.isActive) {
      return Entitlement(
        period: EntitlementPeriod.active,
        willRenew: snapshot.willRenew,
        isIntroductory: snapshot.isIntroductory,
        expiresAt: snapshot.expiresAt,
        plan: plan,
      );
    }
    return Entitlement(
      period: EntitlementPeriod.expired,
      willRenew: false,
      isIntroductory: false,
      expiresAt: snapshot.expiresAt,
      plan: plan,
    );
  }
}
