import 'entitlement.dart';
import 'paywall_plan.dart';

/// App Store / Play billing. Implementations must not treat a local flag as truth.
abstract class BillingClient {
  Entitlement get current;

  Stream<Entitlement> entitlements();

  Future<void> initialize();

  Future<void> purchase(PaywallPlan plan);

  Future<void> restore();

  Future<void> refresh();
}
