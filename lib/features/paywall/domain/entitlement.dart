import 'paywall_plan.dart';

/// Subscription period for the Pro entitlement.
///
/// Cancellation while the period is still paid is [active] with
/// [Entitlement.willRenew] false. The client is not the source of truth;
/// this value is mapped from store-validated billing data.
enum EntitlementPeriod { none, active, gracePeriod, expired }

/// Store-validated Pro access. Do not persist a local "isPro" flag as truth.
class Entitlement {
  const Entitlement({
    this.period = EntitlementPeriod.none,
    this.willRenew = false,
    this.isIntroductory = false,
    this.expiresAt,
    this.plan,
  });

  final EntitlementPeriod period;
  final bool willRenew;
  final bool isIntroductory;
  final DateTime? expiresAt;
  final PaywallPlan? plan;

  bool get isPro =>
      period == EntitlementPeriod.active ||
      period == EntitlementPeriod.gracePeriod;

  static const Entitlement free = Entitlement();
  static const Entitlement pro = Entitlement(
    period: EntitlementPeriod.active,
    willRenew: true,
  );
}
