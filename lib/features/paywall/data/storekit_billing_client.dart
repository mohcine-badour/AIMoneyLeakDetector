import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../core/constants/app_strings.dart';
import '../domain/billing_client.dart';
import '../domain/billing_exception.dart';
import '../domain/entitlement.dart';
import '../domain/entitlement_mapper.dart';
import '../domain/monetization_config.dart';
import '../domain/paywall_plan.dart';
import '../domain/storekit_entitlement.dart';

/// App Store billing through StoreKit. Entitlement comes from Apple's
/// purchase stream, not a local flag.
class StoreKitBillingClient implements BillingClient {
  StoreKitBillingClient({
    required MonetizationConfig config,
    InAppPurchase? store,
  }) : _config = config,
       _storeOverride = store;

  final MonetizationConfig _config;
  final InAppPurchase? _storeOverride;
  InAppPurchase get _store => _storeOverride ?? InAppPurchase.instance;
  final _controller = StreamController<Entitlement>.broadcast();
  final _owned = <String>{};

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  Completer<void>? _pending;
  Entitlement _current = Entitlement.free;
  var _initialized = false;
  var _available = false;

  @override
  Entitlement get current => _current;

  @override
  Stream<Entitlement> entitlements() async* {
    yield _current;
    yield* _controller.stream;
  }

  @override
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    try {
      _available = await _store.isAvailable();
    } catch (_) {
      _available = false;
    }
    if (_available) {
      _subscription = _store.purchaseStream.listen(
        _onPurchases,
        onError: _onStreamError,
      );
    }
    _initialized = true;
    if (_available) {
      try {
        await _store.restorePurchases();
      } catch (_) {}
    }
  }

  @override
  Future<void> purchase(PaywallPlan plan) async {
    await _ensureInitialized();
    if (!_available) {
      throw const BillingException(AppStrings.billingNotConfigured);
    }
    final productId = _config.productIdFor(plan);
    try {
      final response = await _store.queryProductDetails({productId});
      if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
        throw const BillingException(AppStrings.purchaseFailed);
      }
      final pending = Completer<void>();
      _pending = pending;
      final submitted = await _store.buyNonConsumable(
        purchaseParam: PurchaseParam(
          productDetails: response.productDetails.first,
        ),
      );
      if (!submitted) {
        _pending = null;
        throw const BillingException(AppStrings.purchaseFailed);
      }
      await pending.future;
    } on BillingException {
      rethrow;
    } catch (_) {
      _pending = null;
      throw const BillingException(AppStrings.purchaseFailed);
    }
  }

  @override
  Future<void> restore() async {
    await _ensureInitialized();
    if (!_available) {
      throw const BillingException(AppStrings.billingNotConfigured);
    }
    await _store.restorePurchases();
  }

  @override
  Future<void> refresh() async {
    await restore();
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }

  void _onPurchases(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _owned.add(purchase.productID);
          _finish(purchase);
          _succeedPending();
        case PurchaseStatus.canceled:
          _finish(purchase);
          _failPending(const BillingException('', isCancelled: true));
        case PurchaseStatus.error:
          _finish(purchase);
          _failPending(
            BillingException(
              purchase.error?.message ?? AppStrings.purchaseFailed,
              code: purchase.error?.code,
            ),
          );
        case PurchaseStatus.pending:
          break;
      }
    }
    _emit(_mapOwned());
  }

  void _onStreamError(Object error) {
    _failPending(
      BillingException(
        error.toString().trim().isEmpty
            ? AppStrings.purchaseFailed
            : error.toString(),
      ),
    );
  }

  Entitlement _mapOwned() {
    return EntitlementMapper.fromSnapshot(
      snapshot: StoreKitEntitlement.snapshotFromProductIds(
        productIds: _owned,
        config: _config,
      ),
      config: _config,
    );
  }

  void _emit(Entitlement entitlement) {
    _current = entitlement;
    _controller.add(entitlement);
  }

  void _succeedPending() {
    final pending = _pending;
    if (pending == null || pending.isCompleted) {
      return;
    }
    _pending = null;
    pending.complete();
  }

  void _failPending(BillingException error) {
    final pending = _pending;
    if (pending == null || pending.isCompleted) {
      return;
    }
    _pending = null;
    pending.completeError(error);
  }

  Future<void> _finish(PurchaseDetails purchase) async {
    if (purchase.pendingCompletePurchase) {
      await _store.completePurchase(purchase);
    }
  }
}
