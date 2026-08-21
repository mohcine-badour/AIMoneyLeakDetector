import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/app/router/app_routes.dart';
import 'package:billkiller_ai/core/constants/app_strings.dart';

import 'helpers/pump_app.dart';

void main() {
  testWidgets('Get Started opens onboarding and back returns home', (
    tester,
  ) async {
    await pumpBillKillerApp(tester);

    await tester.tap(find.text(AppStrings.getStarted));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.onboardingHeadline), findsOneWidget);
    expect(find.text(AppStrings.onboardingFindOut), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.getStarted), findsOneWidget);
  });

  testWidgets('placeholder routes render their titles', (tester) async {
    const routes = <String, String>{
      AppRoutes.dashboard: AppStrings.yourSubscriptions,
      AppRoutes.upcoming: AppStrings.upcomingPayments,
      AppRoutes.subscriptions: AppStrings.subscriptionsTitle,
      AppRoutes.addSubscription: AppStrings.addSubscriptionTitle,
      AppRoutes.scanReceipt: AppStrings.scanReceiptTitle,
      AppRoutes.trials: AppStrings.trialsTitle,
      AppRoutes.addTrial: AppStrings.addTrialTitle,
      AppRoutes.savings: AppStrings.savingsTitle,
      AppRoutes.settings: AppStrings.settingsTitle,
      AppRoutes.paywall: AppStrings.paywallTitle,
    };

    for (final entry in routes.entries) {
      await pumpBillKillerApp(tester, location: entry.key);
      expect(find.text(entry.value), findsWidgets);
    }
  });

  testWidgets('missing subscription shows not found', (tester) async {
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.subscriptionDetailLocation('netflix'),
    );

    expect(find.text(AppStrings.subscriptionNotFound), findsOneWidget);
    expect(find.text(AppStrings.backToList), findsOneWidget);
  });

  testWidgets('unknown route shows not found and can return home', (
    tester,
  ) async {
    await pumpBillKillerApp(tester, location: '/this-route-does-not-exist');

    expect(find.text(AppStrings.notFoundTitle), findsOneWidget);
    expect(find.text('/this-route-does-not-exist'), findsOneWidget);

    await tester.tap(find.text(AppStrings.goHome));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.getStarted), findsOneWidget);
  });
}
