import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/core/database/app_database.dart';
import 'package:kichta/features/paywall/data/fake_billing_client.dart';
import 'package:kichta/features/paywall/data/unconfigured_billing_client.dart';
import 'package:kichta/features/paywall/domain/billing_exception.dart';
import 'package:kichta/features/paywall/domain/entitlement.dart';
import 'package:kichta/features/paywall/domain/monetization_config.dart';
import 'package:kichta/features/paywall/domain/paywall_features.dart';
import 'package:kichta/features/paywall/domain/paywall_plan.dart';
import 'package:kichta/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:kichta/features/subscriptions/domain/subscription.dart';

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
    await pumpKichtaApp(tester, location: AppRoutes.paywall);

    expect(find.text(AppStrings.paywallTitle), findsNothing);
    expect(find.text(AppStrings.paywallHeadline), findsOneWidget);
    expect(find.text(AppStrings.paywallSubheadline), findsOneWidget);
    expect(find.text(AppStrings.paywallUnlock), findsNothing);
    expect(find.text(AppStrings.introOfferAvailable), findsNothing);
    for (final feature in PaywallFeatures.all) {
      expect(find.text(feature.title), findsOneWidget);
      expect(find.text(feature.description), findsOneWidget);
    }
    expect(find.text(r'$19.99'), findsWidgets);
    expect(find.text(r'$2.99'), findsOneWidget);
    expect(find.text(r'$0.99'), findsOneWidget);
    expect(find.text('SAVE 44%'), findsOneWidget);
    expect(
      find.text(AppStrings.continueWithPrice(r'$19.99', '/year')),
      findsOneWidget,
    );
    expect(find.text(AppStrings.unlockPro), findsNothing);
    expect(find.text(AppStrings.restorePurchases), findsOneWidget);
    expect(find.text(AppStrings.cancelAnytime), findsOneWidget);
    expect(find.text(AppStrings.paywallAutoRenewLegal), findsOneWidget);
    expect(find.text(AppStrings.perkNoAds), findsNothing);
  });

  testWidgets('paywall Terms opens Terms of Use, not Privacy Policy', (
    tester,
  ) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester, location: AppRoutes.paywall);

    await tester.ensureVisible(find.byKey(const Key('paywall-terms')));
    await tester.tap(find.byKey(const Key('paywall-terms')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.termsOfUseTitle), findsWidgets);
    expect(find.text(AppStrings.paywallHeadline), findsNothing);
  });

  testWidgets('unlock purchases the selected plan and grants Pro', (
    tester,
  ) async {
    _largeScreen(tester);
    final billing = FakeBillingClient();
    await pumpKichtaApp(
      tester,
      location: AppRoutes.paywall,
      billingClient: billing,
    );

    await tester.tap(find.byKey(const Key('paywall-plan-monthly')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('unlock-pro')));
    await tester.pumpAndSettle();

    expect(billing.lastPurchased, PaywallPlan.monthly);
    expect(billing.current.isPro, isTrue);
    expect(find.byKey(const Key('unlock-pro')), findsNothing);
  });

  testWidgets('restore grants Pro when the store account has a subscription', (
    tester,
  ) async {
    _largeScreen(tester);
    final billing = FakeBillingClient()..seed(Entitlement.pro);
    billing.seed(Entitlement.free);
    await pumpKichtaApp(
      tester,
      location: AppRoutes.paywall,
      billingClient: billing,
    );

    expect(find.byKey(const Key('unlock-pro')), findsOneWidget);

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
    await pumpKichtaApp(tester, location: AppRoutes.paywall);

    await tester.ensureVisible(find.text(AppStrings.restorePurchases));
    await tester.tap(find.text(AppStrings.restorePurchases));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.restoreNone), findsOneWidget);
    expect(find.byKey(const Key('unlock-pro')), findsOneWidget);
  });

  testWidgets('cancelled purchases stay on the paywall without an error', (
    tester,
  ) async {
    _largeScreen(tester);
    final billing = FakeBillingClient(
      purchaseError: const BillingException('cancelled', isCancelled: true),
    );
    await pumpKichtaApp(
      tester,
      location: AppRoutes.paywall,
      billingClient: billing,
    );

    await tester.tap(find.byKey(const Key('unlock-pro')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.paywallHeadline), findsOneWidget);
    expect(find.text('cancelled'), findsNothing);
    expect(find.text(AppStrings.purchaseFailedTitle), findsNothing);
    expect(billing.current.isPro, isFalse);
  });

  testWidgets('unconfigured billing does not invent Pro access', (
    tester,
  ) async {
    _largeScreen(tester);
    await pumpKichtaApp(
      tester,
      location: AppRoutes.paywall,
      billingClient: const UnconfiguredBillingClient(),
    );

    await tester.tap(find.byKey(const Key('unlock-pro')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.billingNotConfigured), findsOneWidget);
    expect(find.byKey(const Key('unlock-pro')), findsOneWidget);
  });

  testWidgets('free subscription limit opens the paywall', (tester) async {
    await pumpKichtaApp(
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
    await pumpKichtaApp(
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

  testWidgets('selecting monthly updates the CTA amount', (tester) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester, location: AppRoutes.paywall);

    await tester.tap(find.byKey(const Key('paywall-plan-monthly')));
    await tester.pumpAndSettle();

    expect(
      find.text(AppStrings.continueWithPrice(r'$2.99', '/month')),
      findsOneWidget,
    );
  });

  testWidgets('selecting weekly updates the CTA amount', (tester) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester, location: AppRoutes.paywall);

    await tester.tap(find.byKey(const Key('paywall-plan-weekly')));
    await tester.pumpAndSettle();

    expect(
      find.text(AppStrings.continueWithPrice(r'$0.99', '/week')),
      findsOneWidget,
    );
  });
}
