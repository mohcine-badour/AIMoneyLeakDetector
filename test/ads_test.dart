import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/core/database/app_database.dart';
import 'package:kichta/features/ads/data/local_ad_service.dart';
import 'package:kichta/features/ads/domain/ad_config.dart';
import 'package:kichta/features/paywall/domain/entitlement.dart';
import 'package:kichta/features/trials/data/drift_trial_repository.dart';
import 'package:kichta/features/trials/domain/trial.dart';

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

  testWidgets('free users do not see a labeled trials banner', (tester) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester, location: AppRoutes.trials);

    expect(find.byKey(const Key('ad-banner-trials')), findsNothing);
    expect(find.text(AppStrings.adLabel), findsNothing);
    expect(find.text(AppStrings.adRemoveHint), findsNothing);
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

  testWidgets('free users see a trials banner when a trial exists', (
    tester,
  ) async {
    _largeScreen(tester);
    await pumpKichtaApp(
      tester,
      location: AppRoutes.trials,
      now: DateTime.utc(2026, 8, 21),
      adConfig: const AdConfig(enabled: true),
      adService: const LocalAdService(),
      seed: (AppDatabase database) {
        return DriftTrialRepository(database).save(
          Trial.create(
            id: 'chatgpt',
            subscriptionName: 'ChatGPT',
            amountAfterTrial: 20,
            trialEndDate: DateTime.utc(2026, 8, 26),
          ),
        );
      },
    );

    expect(find.byKey(const Key('ad-banner-trials')), findsOneWidget);
    expect(find.text(AppStrings.adLabel), findsOneWidget);
    expect(find.text(AppStrings.adRemoveHint), findsOneWidget);
  });

  testWidgets('empty trials list does not show a banner', (tester) async {
    _largeScreen(tester);
    await pumpKichtaApp(
      tester,
      location: AppRoutes.trials,
      adConfig: const AdConfig(enabled: true),
      adService: const LocalAdService(),
    );

    expect(find.byKey(const Key('ad-banner-trials')), findsNothing);
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

}
