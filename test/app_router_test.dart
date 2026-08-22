import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';

import 'helpers/pump_app.dart';

void _largeScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('Get Started opens onboarding and back returns home', (
    tester,
  ) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester);

    await tester.tap(find.text(AppStrings.getStarted));
    await tester.pumpAndSettle();

    expect(find.text('THE GAP'), findsOneWidget);
    expect(find.text('See mine'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.getStarted), findsOneWidget);
  });

  testWidgets('placeholder routes render their titles', (tester) async {
    const routes = <String, String>{
      AppRoutes.dashboard: AppStrings.noRenewalsThisWeek,
      AppRoutes.upcoming: AppStrings.upcomingPayments,
      AppRoutes.subscriptions: AppStrings.subscriptionsTitle,
      AppRoutes.addSubscription: AppStrings.addSubscriptionTitle,
      AppRoutes.trials: AppStrings.trialsTitle,
      AppRoutes.addTrial: AppStrings.addTrialTitle,
      AppRoutes.savings: AppStrings.insightsTitle,
      AppRoutes.settings: AppStrings.settingsTitle,
      AppRoutes.paywall: AppStrings.paywallHeadline,
    };

    for (final entry in routes.entries) {
      await pumpKichtaApp(tester, location: entry.key);
      expect(find.text(entry.value), findsWidgets);
    }
  });

  testWidgets('missing subscription shows not found', (tester) async {
    await pumpKichtaApp(
      tester,
      location: AppRoutes.subscriptionDetailLocation('netflix'),
    );

    expect(find.text(AppStrings.subscriptionNotFound), findsOneWidget);
    expect(find.text(AppStrings.backToList), findsOneWidget);
  });

  testWidgets('receipt scan is not a shipped route', (tester) async {
    await pumpKichtaApp(tester, location: AppRoutes.scanReceipt);

    expect(find.text(AppStrings.scanReceiptTitle), findsNothing);
    expect(find.text(AppStrings.subscriptionNotFound), findsOneWidget);
  });

  testWidgets('unknown route shows not found and can return home', (
    tester,
  ) async {
    await pumpKichtaApp(tester, location: '/this-route-does-not-exist');

    expect(find.text(AppStrings.notFoundTitle), findsOneWidget);
    expect(find.text('/this-route-does-not-exist'), findsOneWidget);

    await tester.tap(find.text(AppStrings.goHome));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.getStarted), findsOneWidget);
  });
}
