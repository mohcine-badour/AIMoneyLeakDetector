import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/features/ads/domain/ad_config.dart';
import 'package:kichta/features/paywall/domain/entitlement.dart';

import 'helpers/pump_app.dart';

void _largeScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('home does not show an inline ad banner', (tester) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester, location: AppRoutes.dashboard);

    expect(find.byKey(const Key('ad-banner-dashboard')), findsNothing);
    expect(find.text(AppStrings.adLabel), findsNothing);
  });

  testWidgets('subscriptions list does not show an inline ad', (tester) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester, location: AppRoutes.subscriptions);

    expect(find.byKey(const Key('ad-banner-subscriptions')), findsNothing);
    expect(find.text(AppStrings.adLabel), findsNothing);
  });

  testWidgets('free users see a labeled trials banner', (tester) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester, location: AppRoutes.trials);

    expect(find.byKey(const Key('ad-banner-trials')), findsOneWidget);
    expect(find.text(AppStrings.adLabel), findsOneWidget);
    expect(find.text(AppStrings.adRemoveHint), findsOneWidget);
  });

  testWidgets('pro users do not see ads', (tester) async {
    await pumpKichtaApp(
      tester,
      location: AppRoutes.trials,
      entitlement: Entitlement.pro,
    );

    expect(find.byKey(const Key('ad-banner-trials')), findsNothing);
    expect(find.text(AppStrings.adLabel), findsNothing);
  });

  testWidgets('paywall does not show ads during billing', (tester) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester, location: AppRoutes.paywall);

    expect(find.text(AppStrings.paywallHeadline), findsOneWidget);
    expect(find.text(AppStrings.adLabel), findsNothing);
  });

  testWidgets('add subscription does not show ads', (tester) async {
    await pumpKichtaApp(tester, location: AppRoutes.addSubscription);

    expect(find.text(AppStrings.addSubscriptionTitle), findsOneWidget);
    expect(find.text(AppStrings.adLabel), findsNothing);
  });

  testWidgets('disabled ads config hides banners', (tester) async {
    await pumpKichtaApp(
      tester,
      location: AppRoutes.trials,
      adConfig: const AdConfig(enabled: false),
    );

    expect(find.byKey(const Key('ad-banner-trials')), findsNothing);
  });

  testWidgets('tapping a banner opens the paywall', (tester) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester, location: AppRoutes.trials);
    await tester.tap(find.byKey(const Key('ad-banner-trials')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.paywallHeadline), findsOneWidget);
  });
}
