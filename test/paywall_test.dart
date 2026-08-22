import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/app/router/app_routes.dart';
import 'package:billkiller_ai/core/constants/app_strings.dart';
import 'package:billkiller_ai/core/database/app_database.dart';
import 'package:billkiller_ai/features/paywall/data/fake_billing_client.dart';
import 'package:billkiller_ai/features/paywall/data/unconfigured_billing_client.dart';
import 'package:billkiller_ai/features/paywall/domain/billing_exception.dart';
import 'package:billkiller_ai/features/paywall/domain/entitlement.dart';
import 'package:billkiller_ai/features/paywall/domain/monetization_config.dart';
import 'package:billkiller_ai/features/paywall/domain/paywall_plan.dart';
import 'package:billkiller_ai/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';

import 'helpers/pump_app.dart';

Future<void> _saveNetflix(AppDatabase database) {
  return DriftSubscriptionRepository(database).save(
    Subscription.create(
      id: 'netflix',
      name: 'Netflix',
      merchant: 'Netflix',
      amount: 22.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.utc(2026, 9, 3),
      category: SubscriptionCategory.entertainment,
    ),
  );
}

void _largeScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('paywall shows conversion copy and configurable prices', (
    tester,
  ) async {
    _largeScreen(tester);
    await pumpBillKillerApp(tester, location: AppRoutes.paywall);

    expect(find.text(AppStrings.paywallHeadline), findsOneWidget);
    expect(find.text(AppStrings.paywallUnlock), findsOneWidget);
    expect(find.text(AppStrings.perkUnlimitedSubscriptions), findsOneWidget);
    expect(find.text(AppStrings.perkAiMoneyAnalysis), findsOneWidget);
    expect(find.text(AppStrings.perkReceiptScanner), findsOneWidget);
    expect(find.text(AppStrings.perkTrialProtection), findsOneWidget);
    expect(find.text(AppStrings.perkAdvancedSavings), findsOneWidget);
    expect(find.text(AppStrings.perkPriceMonitoring), findsOneWidget);
    expect(find.text(AppStrings.perkNoAds), findsOneWidget);
    expect(find.text(r'$5.99/month'), findsOneWidget);
    expect(find.text(r'$39.99/year'), findsOneWidget);
    expect(find.text(AppStrings.introOfferAvailable), findsOneWidget);
    expect(find.text(AppStrings.unlockPro), findsOneWidget);
    expect(find.text(AppStrings.restorePurchases), findsOneWidget);
  });

  testWidgets('unlock purchases the selected plan and grants Pro', (
    tester,
  ) async {
    _largeScreen(tester);
    final billing = FakeBillingClient();
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.paywall,
      billingClient: billing,
    );

    await tester.tap(find.byKey(const Key('paywall-plan-monthly')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.unlockPro));
    await tester.pumpAndSettle();

    expect(billing.lastPurchased, PaywallPlan.monthly);
    expect(billing.current.isPro, isTrue);
    expect(find.text(AppStrings.unlockPro), findsNothing);
  });

  testWidgets('restore grants Pro when the store account has a subscription', (
    tester,
  ) async {
    _largeScreen(tester);
    final billing = FakeBillingClient()..seed(Entitlement.pro);
    billing.seed(Entitlement.free);
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.paywall,
      billingClient: billing,
    );

    expect(find.text(AppStrings.unlockPro), findsOneWidget);

    await tester.ensureVisible(find.text(AppStrings.restorePurchases));
    await tester.tap(find.text(AppStrings.restorePurchases));
    await tester.pumpAndSettle();

    expect(billing.restoreCount, 1);
    expect(billing.current.isPro, isTrue);
  });

  testWidgets('restore without a store subscription stays free', (
    tester,
  ) async {
    _largeScreen(tester);
    await pumpBillKillerApp(tester, location: AppRoutes.paywall);

    await tester.ensureVisible(find.text(AppStrings.restorePurchases));
    await tester.tap(find.text(AppStrings.restorePurchases));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.restoreNone), findsOneWidget);
    expect(find.text(AppStrings.unlockPro), findsOneWidget);
  });

  testWidgets('cancelled purchases stay on the paywall without an error', (
    tester,
  ) async {
    _largeScreen(tester);
    final billing = FakeBillingClient(
      purchaseError: const BillingException('cancelled', isCancelled: true),
    );
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.paywall,
      billingClient: billing,
    );

    await tester.tap(find.text(AppStrings.unlockPro));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.paywallHeadline), findsOneWidget);
    expect(find.text('cancelled'), findsNothing);
    expect(billing.current.isPro, isFalse);
  });

  testWidgets('unconfigured billing does not invent Pro access', (
    tester,
  ) async {
    _largeScreen(tester);
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.paywall,
      billingClient: const UnconfiguredBillingClient(),
    );

    await tester.tap(find.text(AppStrings.unlockPro));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.billingNotConfigured), findsOneWidget);
    expect(find.text(AppStrings.unlockPro), findsOneWidget);
  });

  testWidgets('free subscription limit opens the paywall', (tester) async {
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.subscriptions,
      seed: _saveNetflix,
      monetizationConfig: const MonetizationConfig(freeSubscriptionLimit: 1),
    );

    await tester.tap(find.byTooltip(AppStrings.addSubscriptionTitle));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.paywallHeadline), findsOneWidget);
    expect(find.text(AppStrings.addSubscriptionTitle), findsNothing);
  });

  testWidgets('pro users can still add past the free limit', (tester) async {
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.subscriptions,
      seed: _saveNetflix,
      entitlement: Entitlement.pro,
      monetizationConfig: const MonetizationConfig(freeSubscriptionLimit: 1),
    );

    await tester.tap(find.byTooltip(AppStrings.addSubscriptionTitle));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.addSubscriptionTitle), findsOneWidget);
    expect(find.text(AppStrings.paywallHeadline), findsNothing);
  });
}
