import 'dart:async';

import '../domain/billing_client.dart';
import '../domain/billing_exception.dart';
import '../domain/entitlement.dart';
import '../domain/paywall_plan.dart';

/// In-memory billing for tests. Production must use RevenueCat.
class FakeBillingClient implements BillingClient {
  FakeBillingClient({
    Entitlement initial = Entitlement.free,
    this.purchaseError,
    this.restoreError,
  }) : _current = initial,
       _restorable = initial.isPro ? initial : null;

  BillingException? purchaseError;
  BillingException? restoreError;
  PaywallPlan? lastPurchased;
  var restoreCount = 0;

  Entitlement _current;
  Entitlement? _restorable;
  final _controller = StreamController<Entitlement>.broadcast();

  @override
  Entitlement get current => _current;

  @override
  Stream<Entitlement> entitlements() async* {
    yield _current;
    yield* _controller.stream;
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<void> purchase(PaywallPlan plan) async {
    lastPurchased = plan;
    final error = purchaseError;
    if (error != null) {
      throw error;
    }
    _emit(
      Entitlement(
        period: EntitlementPeriod.active,
        willRenew: true,
        plan: plan,
      ),
    );
    _restorable = _current;
  }

  @override
  Future<void> restore() async {
    restoreCount += 1;
    final error = restoreError;
    if (error != null) {
      throw error;
    }
    _emit(_restorable ?? Entitlement.free);
  }

  @override
  Future<void> refresh() async {
    _controller.add(_current);
  }

  void seed(Entitlement entitlement) {
    if (entitlement.isPro) {
      _restorable = entitlement;
    }
    _emit(entitlement);
  }

  void _emit(Entitlement entitlement) {
    _current = entitlement;
    _controller.add(entitlement);
  }
}
