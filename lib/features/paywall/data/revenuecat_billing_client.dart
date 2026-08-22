import 'dart:async';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/constants/app_strings.dart';
import '../domain/billing_client.dart';
import '../domain/billing_exception.dart';
import '../domain/billing_snapshot.dart';
import '../domain/entitlement.dart';
import '../domain/entitlement_mapper.dart';
import '../domain/monetization_config.dart';
import '../domain/paywall_plan.dart';

/// RevenueCat adapter. Receipts are validated on RevenueCat's servers.
class RevenueCatBillingClient implements BillingClient {
  RevenueCatBillingClient({required this._config});

  final MonetizationConfig _config;
  final _controller = StreamController<Entitlement>.broadcast();
  Entitlement _current = Entitlement.free;
  var _initialized = false;

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
    if (!_config.isStoreBillingConfigured) {
      throw const BillingException(AppStrings.billingNotConfigured);
    }
    await Purchases.configure(
      PurchasesConfiguration(_config.revenueCatAppleApiKey),
    );
    Purchases.addCustomerInfoUpdateListener(_onCustomerInfo);
    _initialized = true;
    await refresh();
  }

  @override
  Future<void> purchase(PaywallPlan plan) async {
    await _ensureInitialized();
    final productId = _config.productIdFor(plan);
    try {
      final products = await Purchases.getProducts([productId]);
      if (products.isEmpty) {
        throw const BillingException(AppStrings.purchaseFailed);
      }
      final info = await Purchases.purchaseStoreProduct(products.first);
      _emit(_map(info));
    } on BillingException {
      rethrow;
    } on PlatformException catch (error) {
      throw _wrap(error, AppStrings.purchaseFailed);
    }
  }

  @override
  Future<void> restore() async {
    await _ensureInitialized();
    try {
      final info = await Purchases.restorePurchases();
      _emit(_map(info));
    } on PlatformException catch (error) {
      throw _wrap(error, AppStrings.restoreFailed);
    }
  }

  @override
  Future<void> refresh() async {
    await _ensureInitialized();
    try {
      final info = await Purchases.getCustomerInfo();
      _emit(_map(info));
    } on PlatformException catch (error) {
      throw _wrap(error, AppStrings.restoreFailed);
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }

  void _onCustomerInfo(CustomerInfo info) {
    _emit(_map(info));
  }

  Entitlement _map(CustomerInfo info) {
    return EntitlementMapper.fromSnapshot(
      snapshot: snapshotFromCustomerInfo(info, _config.proEntitlementId),
      config: _config,
    );
  }

  void _emit(Entitlement entitlement) {
    _current = entitlement;
    _controller.add(entitlement);
  }

  static BillingSnapshot snapshotFromCustomerInfo(
    CustomerInfo info,
    String entitlementId,
  ) {
    final record = info.entitlements.all[entitlementId];
    if (record == null) {
      return const BillingSnapshot();
    }
    return BillingSnapshot(
      hasEntitlementRecord: true,
      isActive: record.isActive,
      willRenew: record.willRenew,
      hasBillingIssue: record.billingIssueDetectedAt != null,
      isIntroductory:
          record.periodType == PeriodType.intro ||
          record.periodType == PeriodType.trial,
      expiresAt: record.expirationDate == null
          ? null
          : DateTime.tryParse(record.expirationDate!),
      productId: record.productIdentifier,
    );
  }

  static BillingException _wrap(PlatformException error, String fallback) {
    final code = PurchasesErrorHelper.getErrorCode(error);
    if (code == PurchasesErrorCode.purchaseCancelledError) {
      return BillingException(fallback, isCancelled: true);
    }
    final message = error.message?.trim();
    return BillingException(
      message == null || message.isEmpty ? fallback : message,
    );
  }
}
